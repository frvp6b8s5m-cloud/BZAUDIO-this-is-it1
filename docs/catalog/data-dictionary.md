# Physical Equipment Catalog — Data Dictionary

**Status:** Owner-approved data contract (2026-11-18). No database objects have been created yet.  
**Related:** `SPEC-CATALOG.md`, ADR-0002, `docs/catalog/access-matrix.md`.

## Design rules

- Keep digital downloads in the existing `public.products` domain. Physical equipment uses a distinct `catalog_*` table family.
- Use UUID primary keys, UTC `timestamptz` audit timestamps, foreign keys, uniqueness constraints, and indexes for lookup/join columns.
- Public tables contain only safe, intended-to-publish fields. Supplier agreements, costs, credentials, raw feeds, MAP evidence, media-rights proof, source payloads, and audit notes stay in the non-exposed `catalog_private` schema.
- All new tables have RLS enabled. New public-schema tables require explicit grants: Supabase no longer automatically exposes newly created public tables to the Data API as of 2026-10-30. Grant only the minimum required privileges.
- Products and variants default unpublished. Unknown/unverified/discontinued records are not returned as active shopping results.
- Numeric MAP is copied to a public variant field only after the private evidence record proves exact variant match, current effective date, and permission to publish.
- Inventory is not displayed as live unless it comes from an approved supplier feed and is within its configured freshness window. Never expose stale quantity as current stock.
- Supplier credentials are never stored as plaintext database fields; store a secret reference only. Actual credentials live in server-side secret storage.

## Public catalog tables

### `public.catalog_manufacturers`
- `id uuid primary key`
- `slug text unique not null`
- `name text not null`
- `website_url text not null`
- `is_active boolean not null default true`
- `created_at, updated_at timestamptz not null`

Initial manufacturer records are Allen & Heath, Yamaha, and Shure. Manufacturer records are not automatically evidence of authorization to resell.

### `public.catalog_categories`
- `id uuid primary key`
- `parent_id uuid null references catalog_categories(id)`
- `slug text unique not null`
- `name text not null`
- `description text null`
- `sort_order integer not null default 0`
- `is_active boolean not null default true`
- `created_at, updated_at timestamptz not null`

Categories are hierarchical and manufacturer-neutral. The approved taxonomy includes mixing consoles, speakers/subwoofers, microphones, wireless systems, headphones, in-ear monitoring, amplifiers, processors/effects, installation audio, software, and accessories. Manufacturer-specific categories can be added when the official taxonomy requires them.

### `public.catalog_products`
- `id uuid primary key`
- `manufacturer_id uuid not null references catalog_manufacturers(id)`
- `slug text unique not null`
- `name text not null`
- `model_number text null`
- `product_family text null`
- `short_description text null`
- `description text null`
- `manufacturer_product_url text null`
- `lifecycle_status text not null` — `active`, `discontinued`, or `unknown`
- `is_verified boolean not null default false`
- `is_published boolean not null default false`
- `source_checked_at timestamptz null`
- `created_at, updated_at timestamptz not null`

A product is publicly selectable only when active, verified, and published. Product facts must have traceable source evidence in the private source registry.

### `public.catalog_product_categories`
- `product_id uuid references catalog_products(id) on delete cascade`
- `category_id uuid references catalog_categories(id)`
- `primary key (product_id, category_id)`

### `public.catalog_variants`
- `id uuid primary key`
- `product_id uuid not null references catalog_products(id) on delete cascade`
- `variant_name text not null`
- `model_number text null`
- `manufacturer_part_number text null`
- `attributes jsonb not null default '{}'` — allowlisted, descriptive variant attributes only
- `lifecycle_status text not null default 'unknown'`
- `is_verified boolean not null default false`
- `is_published boolean not null default false`
- `map_price_amount numeric(12,2) null`
- `currency char(3) null`
- `map_effective_at timestamptz null`
- `map_verified_at timestamptz null`
- `availability_status text not null default 'unknown'` — `unknown`, `in_stock`, `limited`, `backorder`, `out_of_stock`, `contact_supplier`
- `availability_checked_at timestamptz null`
- `created_at, updated_at timestamptz not null`

Constraints: nonnegative MAP amount; MAP amount requires currency and evidence verification timestamp; availability status must be from the allowlist. Numeric MAP must be exact-variant matched and publication-authorized in private evidence before it is copied here. If not, keep amount/currency null and show “Contact for price.” Availability is a status only; do not publish supplier quantities.

### `public.catalog_media`
- `id uuid primary key`
- `product_id uuid not null references catalog_products(id) on delete cascade`
- `variant_id uuid null references catalog_variants(id) on delete cascade`
- `asset_url text not null`
- `alt_text text not null`
- `sort_order integer not null default 0`
- `is_published boolean not null default false`
- `created_at timestamptz not null`

A media row may be published only after its private media-rights record is approved for the relevant BZaudio website/catalog use. The public table contains no contract, license document, or private rights notes.

## Private tables in non-exposed `catalog_private` schema

All private tables are RLS-enabled as defense in depth, have no grants to `anon` or `authenticated`, and are accessed only by authorized server-side workflows.

### `catalog_private.source_records`
- Canonical source URL, source type, manufacturer, checked timestamp, source title/description, permitted-use notes, content fingerprint, reviewer, and review status.
- Raw HTML/PDF/source payloads are not returned through public APIs.

### `catalog_private.product_source_links`
- Product/variant ID, source-record ID, fact scope (identity/specification/lifecycle/price/media), verification status, checked timestamp, and reviewer.
- Supports multiple evidence sources for a product and individual variants.

### `catalog_private.map_evidence`
- Variant ID, source-record ID, MAP amount/currency, effective start/end, exact-variant match result, publication permission, evidence reference, reviewer, and verification timestamp.
- Dealer cost and confidential price data are prohibited from public tables and responses.

### `catalog_private.media_rights`
- Media ID, rights holder, license/permission type, allowed channels, territory, attribution requirement, expiry, proof reference, reviewer, and approval status.
- Public media is withheld when rights are missing, expired, or not approved.

### `catalog_private.suppliers`
- Supplier legal/display name, authorization status, written resale/dropship permission, territory, agreement dates, warranty/returns responsibility, feed type, secret reference, and review status.
- No plaintext API keys, passwords, or tokens.

### `catalog_private.supplier_variant_map`
- Supplier ID, catalog variant ID, supplier SKU, fulfillment eligibility, supplier product reference, and last mapping verification.
- Unique constraints prevent ambiguous supplier-SKU-to-variant mappings within a supplier.

### `catalog_private.inventory_snapshots`
- Supplier ID, variant ID, normalized availability, optional supplier quantity (private only), source timestamp, fetched timestamp, feed run ID, and validation status.
- A public availability status is updated only from a trusted, validated, non-stale snapshot.

### `catalog_private.import_runs` and `catalog_private.import_rows`
- Import source, start/finish times, run status, counts, idempotency key, errors, row fingerprint, validation result, and quarantine reason.
- Raw supplier/manufacturer payloads remain private and are retained only as necessary.

### `catalog_private.audit_events`
- Actor/service identity, action, record type/ID, timestamp, and safe change summary.
- Never log secrets or unnecessary personal data.

## Data lifecycle

1. Import source data into a private staging/quarantine area.
2. Validate shape, source provenance, lifecycle, product/variant identity, and duplicate keys.
3. Human-review ambiguous facts, MAP, image rights, and supplier eligibility.
4. Publish only approved facts into public catalog tables.
5. Refresh inventory from approved supplier sources; mark unknown when stale, missing, or conflicting.
6. Preserve evidence and audit history for later review.

## Not included in this data model

- Customer profiles or login sessions.
- Cart, checkout, payment intent, tax, shipping address, or orders.
- Supplier purchase orders, fulfillment dispatch, returns processing, or webhooks.
- ORIGIN contributor applications, Founder numbering, or rewards.
- Admin user interface.

Those are separate modules with their own specifications and contracts.
