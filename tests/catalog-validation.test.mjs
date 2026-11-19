import assert from 'node:assert/strict';
import test from 'node:test';
import { validateCatalogBatch } from '../scripts/catalog-validation.mjs';

const valid = {
  manufacturer_slug: 'allen-heath',
  name: 'SQ-5 Digital Mixer',
  model_number: 'SQ-5',
  product_url: 'https://www.allen-heath.com/hardware/sq/sq-5/',
  lifecycle_status: 'active',
  categories: ['mixing-consoles'],
  source: {
    type: 'manufacturer',
    url: 'https://www.allen-heath.com/hardware/',
    checked_at: '2026-11-19T00:00:00Z',
  },
  variants: [{
    variant_name: 'SQ-5',
    model_number: 'SQ-5',
    manufacturer_part_number: 'SQ-5',
    attributes: { surface: 'compact digital mixer' },
  }],
};

test('accepts a complete manufacturer-sourced row for human review', () => {
  const [row] = validateCatalogBatch([valid]);
  assert.equal(row.status, 'accepted');
  assert.deepEqual(row.errors, []);
  assert.deepEqual(row.quarantine_reasons, []);
  assert.match(row.row_fingerprint, /^[a-f0-9]{64}$/);
});

test('rejects malformed rows rather than silently filling missing fields', () => {
  const [row] = validateCatalogBatch([{ ...valid, model_number: '', product_url: 'http://unsafe.example' }]);
  assert.equal(row.status, 'rejected');
  assert.ok(row.errors.some((error) => error.includes('model_number')));
  assert.ok(row.errors.some((error) => error.includes('HTTPS')));
});

test('quarantines unknown lifecycle and incomplete source evidence', () => {
  const [row] = validateCatalogBatch([{
    ...valid,
    lifecycle_status: 'unknown',
    source: { type: 'other', url: 'https://example.com', checked_at: '2026-11-19' },
  }]);
  assert.equal(row.status, 'quarantined');
  assert.ok(row.quarantine_reasons.some((reason) => reason.includes('Lifecycle')));
  assert.ok(row.quarantine_reasons.some((reason) => reason.includes('Manufacturer-origin')));
});

test('quarantines duplicate product identities within a batch', () => {
  const [first, second] = validateCatalogBatch([valid, { ...valid, name: 'Renamed duplicate' }]);
  assert.equal(first.status, 'accepted');
  assert.equal(second.status, 'quarantined');
  assert.ok(second.quarantine_reasons.some((reason) => reason.includes('Duplicate manufacturer/model')));
});

test('identical rows receive deterministic fingerprints and are quarantined on repeat', () => {
  const [first, second] = validateCatalogBatch([valid, valid]);
  assert.equal(first.row_fingerprint, second.row_fingerprint);
  assert.equal(first.idempotency_key, second.idempotency_key);
  assert.equal(second.status, 'quarantined');
});

test('requires exact variant identity and object attributes', () => {
  const [row] = validateCatalogBatch([{
    ...valid,
    variants: [{ variant_name: 'Variant', attributes: [] }],
  }]);
  assert.equal(row.status, 'rejected');
  assert.ok(row.errors.some((error) => error.includes('attributes')));
  assert.ok(row.quarantine_reasons.some((reason) => reason.includes('manufacturer part number')));
});

test('requires an array batch', () => {
  assert.throws(() => validateCatalogBatch({}), /must be an array/);
});
