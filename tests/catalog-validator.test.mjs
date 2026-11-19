import assert from 'node:assert/strict';
import test from 'node:test';
import { validateCatalogProduct } from '../scripts/catalog-validator.mjs';

const validProduct = {
  manufacturer_slug: 'shure',
  slug: 'sm7b',
  name: 'SM7B Vocal Microphone',
  model_number: 'SM7B',
  product_url: 'https://www.shure.com/en-US/products/microphones/sm7b',
  source_url: 'https://www.shure.com/en-US/products',
  lifecycle_status: 'active',
  source_checked_at: '2026-11-18T00:00:00.000Z',
  specifications: {
    type: 'Dynamic microphone',
    connector: 'XLR',
  },
};

test('normalizes a sourced product but never auto-verifies or publishes it', () => {
  const result = validateCatalogProduct(validProduct);
  assert.equal(result.ok, true);
  assert.equal(result.value.slug, 'sm7b');
  assert.equal(result.value.is_verified, false);
  assert.equal(result.value.is_published, false);
});

test('rejects unknown manufacturers and non-official source domains', () => {
  const unknown = validateCatalogProduct({ ...validProduct, manufacturer_slug: 'unknown-brand' });
  assert.equal(unknown.ok, false);
  assert.ok(unknown.errors.some((error) => error.includes('manufacturer_slug')));

  const spoofed = validateCatalogProduct({
    ...validProduct,
    source_url: 'https://shure.com.example.org/fake',
  });
  assert.equal(spoofed.ok, false);
  assert.ok(spoofed.errors.some((error) => error.includes('official')));
});

test('rejects insecure URLs and malformed identity fields', () => {
  const result = validateCatalogProduct({
    ...validProduct,
    product_url: 'http://www.shure.com/product',
    slug: 'SM7B / fake',
    name: ' ',
  });
  assert.equal(result.ok, false);
  assert.ok(result.errors.length >= 3);
});

test('rejects imported price, MAP, stock, supplier, image, or publication claims', () => {
  const result = validateCatalogProduct({
    ...validProduct,
    map_price: 399,
    stock: 12,
    image_url: 'https://cdn.example.org/product.jpg',
    is_published: true,
  });
  assert.equal(result.ok, false);
  assert.ok(result.errors.some((error) => error.includes('map_price')));
  assert.ok(result.errors.some((error) => error.includes('stock')));
  assert.ok(result.errors.some((error) => error.includes('image_url')));
  assert.ok(result.errors.some((error) => error.includes('is_published')));
});

test('keeps discontinued and unknown lifecycle products unpublished', () => {
  for (const lifecycle_status of ['discontinued', 'unknown']) {
    const result = validateCatalogProduct({ ...validProduct, lifecycle_status });
    assert.equal(result.ok, true);
    assert.equal(result.value.is_published, false);
  }
});

test('rejects invalid timestamps and non-object specifications', () => {
  const result = validateCatalogProduct({
    ...validProduct,
    source_checked_at: 'not-a-date',
    specifications: '<script>alert(1)</script>',
  });
  assert.equal(result.ok, false);
  assert.ok(result.errors.some((error) => error.includes('source_checked_at')));
  assert.ok(result.errors.some((error) => error.includes('specifications')));
});
