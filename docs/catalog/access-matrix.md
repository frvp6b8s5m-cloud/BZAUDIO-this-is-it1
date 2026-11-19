# Catalog Database Access Matrix

**Status:** Owner-approved access contract (2026-11-18). Schema, RLS policies, and explicit grants are represented in the development migration and tested in isolated PostgreSQL CI; no live Supabase changes have been applied.

## Trust boundaries

- Public browser: untrusted. It may read approved catalog facts only.
- Authenticated customer browser: still untrusted. It receives the same public catalog read permissions as anonymous visitors.
- BZaudio server-side import/admin functions: trusted only after service authentication, input validation, and authorization checks.
- Manufacturer and supplier feeds: external/untrusted. Validate every payload and preserve provenance.
- Private catalog evidence and supplier data: never available to browser roles.

## Role matrix

| Resource | anon | authenticated customer | Server-side service role | Supplier |
|---|---|---|---|---|
| Published public manufacturers/categories/products/variants/media | SELECT only, published rows | Same as anon | Read/write as required | No direct access |
| Private source/MAP/media-rights evidence | No access | No access | Controlled read/write | No direct access |
| Supplier agreements and SKU mappings | No access | No access | Controlled read/write | No direct access |
| Inventory snapshots/raw feed payloads | No access | No access | Controlled read/write | No direct access |
| Import runs, quarantine, audit records | No access | No access | Controlled read/write | No direct access |
| Catalog writes | Denied | Denied | Server-side only | Denied |

## Required database controls

1. Enable RLS on every table in both schemas.
2. Do not grant `USAGE` on `catalog_private` to `anon` or `authenticated`.
3. Do not grant any table privileges on private tables to browser roles.
4. Public tables contain only publishable fields; private supplier/evidence fields are structurally separated rather than merely hidden in the UI.
5. Explicitly grant only `SELECT` on approved public catalog tables to `anon` and `authenticated`. Supabase's Data API no longer automatically exposes newly created `public` tables; grants must be explicit.
6. Public SELECT policies are limited to verified, published, active records. Variants additionally require their parent product to be verified, published, and active.
7. No `INSERT`, `UPDATE`, or `DELETE` for `anon` or ordinary `authenticated` users on catalog tables.
8. Do not use `SECURITY DEFINER` as a shortcut around RLS. Prefer invoker permissions and narrow grants.
9. Keep the Supabase service-role/secret key and supplier API credentials exclusively in server-side secret storage. Never put them in GitHub Pages assets or browser JavaScript.
10. Do not rely on user-editable `user_metadata` for administrator authorization. Future admin workflows must use server-verified authorization and appropriate trusted claims or database-backed roles.

## Publication invariants

- Product: `is_published = true`, `is_verified = true`, `lifecycle_status = 'active'`.
- Variant: same conditions, plus its parent product meets the product invariant.
- Media: `is_published = true` and private rights review has approved current website/catalog use.
- MAP: never expose a stored MAP value directly from a table. The server-side public read service returns a numeric amount only when private evidence matches the exact variant, is in its effective period, is verified, and permits publication. Otherwise it returns “Contact for price.”
- Availability: never expose supplier snapshots directly. The server-side public read service shows live status only when the source is an approved dropship supplier and its timestamp is within the configured freshness window. Otherwise status is unknown/contact supplier.
- Purchasability: catalog publication does not imply the item is available to purchase. A future store module must check supplier authorization, variant mapping, territory, fulfillment, warranty/returns, and current stock independently.

## Verification matrix before any public release

- Anonymous SELECT returns only approved active records.
- Anonymous INSERT/UPDATE/DELETE are denied.
- Authenticated customer SELECT returns the same public records and no additional private records.
- Authenticated customer writes are denied.
- Private schema/table reads are denied for both browser roles.
- Service-side workflow can import and publish only after validation and review.
- Attempts to publish stale MAP, expired media rights, unapproved supplier stock, discontinued products, or unverified variants fail closed.
- API responses contain no dealer cost, supplier credentials, private contract terms, raw feed payloads, moderation notes, or internal audit data.

## Documentation source

Supabase's official changelog states that newly created tables in the `public` schema are no longer automatically exposed to the Data and GraphQL APIs, with enforcement on existing projects from 2026-10-30: https://supabase.com/changelog/45329-breaking-change-tables-not-exposed-to-data-and-graphql-api-automatically
