# Physical Catalog Schema and Recovery Notes

**Migration:** `supabase/migrations/20261118232000_create_physical_equipment_catalog.sql`  
**Status:** Draft migration; verified in disposable PostgreSQL 17 CI only. Not applied to the live Supabase project.

## What the migration creates

- Six public, read-only catalog tables: manufacturers, categories, products, product/category links, variants, and media.
- Ten private tables under `catalog_private` for sources, evidence, MAP, media rights, suppliers, SKU mapping, imports, inventory snapshots, and audit events.
- Row-level security on every new table.
- Explicit browser SELECT grants only on the public tables; no browser write grants and no browser access to the private schema.
- Service-role grants for server-side catalog workflows.

The migration does not alter the existing digital-download `public.products` table or any existing customer, order, license, or download tables.

## Verification

The public GitHub Actions workflow `.github/workflows/catalog-database.yml` applies the migration to a disposable PostgreSQL 17 service and runs `tests/catalog-rls.test.sql`.

The successful run verifies:
- The migration applies cleanly to a fresh PostgreSQL database.
- Anonymous and authenticated role stand-ins see only active manufacturers and verified, published, active products.
- Browser role stand-ins cannot write to catalog tables or read the private schema.
- The service-role stand-in can read private supplier records.

This is a PostgreSQL migration/RLS integration check. It does not yet verify the complete Supabase Auth, Data API, Edge Functions, or production configuration. Those checks remain required before any production application.

## Recovery and rollback policy

This migration is additive and has not been applied to production.

- **Disposable CI database:** discard and recreate the database to return to a clean state.
- **Local development database:** reset the local database and replay the checked-in migrations. Do not use the production project as a test target.
- **Production, if separately approved later:** prefer a forward corrective migration. Before considering removal, take and verify a backup, inspect dependent views/functions/data, plan a maintenance window, and obtain an explicit release decision. Dropping the catalog tables or private schema would permanently delete catalog data; never run a blanket `DROP SCHEMA ... CASCADE` as an automatic rollback.

## Release blockers

Do not apply this migration to the live Supabase project until:
1. Supabase-local/Auth/Data API verification is complete.
2. Security and performance advisors have been reviewed after the migration in a safe environment.
3. The public read interface and importer enforce MAP evidence, media rights, supplier authorization, and inventory freshness.
4. The catalog module's tests and release checklist pass.
