const MANUFACTURER_DOMAINS = Object.freeze({
  'allen-heath': ['allen-heath.com'],
  yamaha: ['yamaha.com'],
  shure: ['shure.com'],
});

const ALLOWED_FIELDS = new Set([
  'manufacturer_slug',
  'slug',
  'name',
  'model_number',
  'product_url',
  'source_url',
  'lifecycle_status',
  'source_checked_at',
  'specifications',
]);

const BLOCKED_FIELDS = new Set([
  'price',
  'price_cents',
  'retail_price',
  'map',
  'map_price',
  'map_price_amount',
  'stock',
  'inventory',
  'quantity',
  'supplier',
  'supplier_id',
  'supplier_sku',
  'image',
  'image_url',
  'image_path',
  'is_verified',
  'is_published',
]);

function isPlainObject(value) {
  if (value === null || typeof value !== 'object' || Array.isArray(value)) return false;
  const prototype = Object.getPrototypeOf(value);
  return prototype === Object.prototype || prototype === null;
}

function isOfficialHttpsUrl(value, allowedDomains) {
  if (typeof value !== 'string' || value.length > 2048) return false;
  try {
    const url = new URL(value);
    if (url.protocol !== 'https:' || url.username || url.password) return false;
    const hostname = url.hostname.toLowerCase();
    return allowedDomains.some((domain) => hostname === domain || hostname.endsWith(`.${domain}`));
  } catch {
    return false;
  }
}

function validateSpecifications(value, errors) {
  if (value === undefined) return {};
  if (!isPlainObject(value)) {
    errors.push('specifications must be a plain object');
    return {};
  }

  const entries = Object.entries(value);
  if (entries.length > 50) errors.push('specifications may contain at most 50 fields');

  const normalized = {};
  for (const [key, item] of entries.slice(0, 50)) {
    if (!/^[a-z][a-z0-9_]{0,39}$/.test(key)) {
      errors.push(`specifications contains an invalid field name: ${key}`);
      continue;
    }
    if (typeof item === 'string') {
      if (item.trim().length > 300) errors.push(`specifications.${key} is too long`);
      else normalized[key] = item.trim();
    } else if (typeof item === 'number' && Number.isFinite(item)) {
      normalized[key] = item;
    } else if (typeof item === 'boolean') {
      normalized[key] = item;
    } else {
      errors.push(`specifications.${key} must be a string, finite number, or boolean`);
    }
  }
  return normalized;
}

/**
 * Validate a normalized manufacturer product record.
 * This function never grants verification/publication and deliberately rejects
 * pricing, inventory, supplier, image, and publication fields from import data.
 */
export function validateCatalogProduct(input) {
  const errors = [];
  if (!isPlainObject(input)) {
    return { ok: false, errors: ['record must be a plain object'], value: null };
  }

  for (const key of Object.keys(input)) {
    if (BLOCKED_FIELDS.has(key)) errors.push(`${key} is not accepted from manufacturer imports`);
    else if (!ALLOWED_FIELDS.has(key)) errors.push(`unknown field: ${key}`);
  }

  const manufacturer = input.manufacturer_slug;
  const domains = Object.hasOwn(MANUFACTURER_DOMAINS, manufacturer)
    ? MANUFACTURER_DOMAINS[manufacturer]
    : null;
  if (!domains) errors.push('manufacturer_slug must be allen-heath, yamaha, or shure');

  if (typeof input.slug !== 'string' || !/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(input.slug)) {
    errors.push('slug must use lowercase letters, numbers, and single hyphens');
  }

  if (typeof input.name !== 'string' || !input.name.trim() || input.name.trim().length > 160) {
    errors.push('name must contain 1 to 160 characters');
  }

  if (input.model_number !== undefined
    && (typeof input.model_number !== 'string' || !input.model_number.trim() || input.model_number.trim().length > 80)) {
    errors.push('model_number must contain 1 to 80 characters when supplied');
  }

  if (domains && !isOfficialHttpsUrl(input.product_url, domains)) {
    errors.push('product_url must be an HTTPS URL on the official manufacturer domain');
  }
  if (domains && !isOfficialHttpsUrl(input.source_url, domains)) {
    errors.push('source_url must be an HTTPS URL on the official manufacturer domain');
  }

  if (!['active', 'discontinued', 'unknown'].includes(input.lifecycle_status)) {
    errors.push('lifecycle_status must be active, discontinued, or unknown');
  }

  const checkedAt = typeof input.source_checked_at === 'string'
    ? Date.parse(input.source_checked_at)
    : Number.NaN;
  if (!Number.isFinite(checkedAt)) errors.push('source_checked_at must be a valid date/time');

  const specifications = validateSpecifications(input.specifications, errors);

  if (errors.length) return { ok: false, errors, value: null };

  return {
    ok: true,
    errors: [],
    value: {
      manufacturer_slug: manufacturer,
      slug: input.slug,
      name: input.name.trim(),
      model_number: input.model_number?.trim() ?? null,
      product_url: input.product_url,
      source_url: input.source_url,
      lifecycle_status: input.lifecycle_status,
      source_checked_at: new Date(checkedAt).toISOString(),
      specifications,
      is_verified: false,
      is_published: false,
    },
  };
}
