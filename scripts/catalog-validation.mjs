import { createHash } from 'node:crypto';

const SLUG = /^[a-z0-9]+(?:-[a-z0-9]+)*$/;
const LIFECYCLE = new Set(['active', 'discontinued', 'unknown']);
const SOURCE_TYPES = new Set(['manufacturer', 'supplier', 'policy', 'license', 'other']);

function isObject(value) {
  return value !== null && typeof value === 'object' && !Array.isArray(value);
}

function clean(value) {
  return typeof value === 'string' ? value.trim() : '';
}

function canonical(value) {
  if (Array.isArray(value)) return value.map(canonical);
  if (isObject(value)) {
    return Object.fromEntries(Object.keys(value).sort().map((key) => [key, canonical(value[key])]));
  }
  return value;
}

function digest(value) {
  return createHash('sha256').update(JSON.stringify(canonical(value))).digest('hex');
}

function validHttps(value) {
  try {
    return new URL(value).protocol === 'https:';
  } catch {
    return false;
  }
}

function validTimestamp(value) {
  return typeof value === 'string' && !Number.isNaN(Date.parse(value));
}

function validateRecord(record) {
  const errors = [];
  const quarantine = [];
  if (!isObject(record)) {
    return { status: 'rejected', errors: ['Record must be a JSON object'], quarantine: [] };
  }

  const manufacturer = clean(record.manufacturer_slug).toLowerCase();
  const model = clean(record.model_number);
  const name = clean(record.name);
  const lifecycle = clean(record.lifecycle_status).toLowerCase();
  const source = isObject(record.source) ? record.source : {};

  if (!SLUG.test(manufacturer) || !['allen-heath', 'yamaha', 'shure'].includes(manufacturer)) {
    errors.push('manufacturer_slug must be allen-heath, yamaha, or shure');
  }
  if (!name) errors.push('name is required');
  if (!model) errors.push('model_number is required');
  if (!LIFECYCLE.has(lifecycle)) errors.push('lifecycle_status must be active, discontinued, or unknown');
  if (record.product_url && !validHttps(record.product_url)) errors.push('product_url must be an HTTPS URL');
  if (!Array.isArray(record.categories) || record.categories.length === 0 ||
      record.categories.some((item) => !clean(item))) {
    errors.push('at least one non-empty category is required');
  }

  if (!validHttps(source.url)) quarantine.push('Official/source URL is missing or invalid');
  if (!SOURCE_TYPES.has(clean(source.type))) quarantine.push('Source type is missing or invalid');
  if (!validTimestamp(source.checked_at)) quarantine.push('Source checked_at must be a timestamp');
  if (clean(source.type) !== 'manufacturer') {
    quarantine.push('Manufacturer-origin identity evidence is required for initial product approval');
  }
  if (lifecycle === 'unknown') quarantine.push('Lifecycle is unknown and needs human review');
  if (!Array.isArray(record.variants) || record.variants.length === 0) {
    quarantine.push('At least one exact orderable variant is required');
  } else {
    const variantKeys = new Set();
    record.variants.forEach((variant, index) => {
      if (!isObject(variant)) {
        errors.push(`variants[${index}] must be an object`);
        return;
      }
      if (!clean(variant.variant_name)) errors.push(`variants[${index}].variant_name is required`);
      const variantModel = clean(variant.model_number);
      const mpn = clean(variant.manufacturer_part_number);
      if (!variantModel && !mpn) quarantine.push(`variants[${index}] needs a model number or manufacturer part number`);
      if (variant.attributes !== undefined && !isObject(variant.attributes)) {
        errors.push(`variants[${index}].attributes must be an object`);
      }
      const key = (variantModel || mpn).toLowerCase();
      if (key && variantKeys.has(key)) errors.push(`duplicate variant identity: ${key}`);
      if (key) variantKeys.add(key);
    });
  }

  return {
    status: errors.length ? 'rejected' : quarantine.length ? 'quarantined' : 'accepted',
    errors,
    quarantine,
  };
}

/**
 * Validate manufacturer-sourced catalog rows before they enter private staging.
 * "accepted" means structurally/source-complete enough for human review only;
 * it never means verified, published, priced, stocked, or purchasable.
 */
export function validateCatalogBatch(records) {
  if (!Array.isArray(records)) throw new TypeError('Catalog batch must be an array');

  const seenIdentities = new Map();
  const seenFingerprints = new Set();

  return records.map((record, index) => {
    const fingerprint = digest(record);
    const identity = isObject(record)
      ? [clean(record.manufacturer_slug).toLowerCase(), clean(record.model_number).toLowerCase()].join(':')
      : '';
    const result = validateRecord(record);

    if (seenFingerprints.has(fingerprint)) {
      result.status = 'quarantined';
      result.quarantine.push('Identical source row already appeared in this batch');
    }
    seenFingerprints.add(fingerprint);

    if (identity && identity !== ':' && seenIdentities.has(identity)) {
      result.status = 'quarantined';
      result.quarantine.push(`Duplicate manufacturer/model identity in this batch (row ${seenIdentities.get(identity) + 1})`);
    } else if (identity && identity !== ':') {
      seenIdentities.set(identity, index);
    }

    return {
      row_number: index + 1,
      row_fingerprint: fingerprint,
      idempotency_key: digest({ source_url: record?.source?.url ?? null, fingerprint }),
      status: result.status,
      errors: result.errors,
      quarantine_reasons: result.quarantine,
    };
  });
}
