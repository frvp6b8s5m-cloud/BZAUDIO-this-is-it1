# Catalog Environment and Prerequisite Report

**Checked:** 2026-11-18  
**Project:** BZ audio / `cgakpcvptyhxwfujzqoe`  
**Region:** `us-west-2`  
**Branch:** `feature/website-foundation`

## Environment readiness

| Check | Observed result | Status |
|---|---|---|
| Supabase project | `ACTIVE_HEALTHY` | Ready |
| Database engine | PostgreSQL 17.6.1.166 | Ready |
| Existing migrations | `20260928195620_bz_audio_platform_foundation` | Inspected |
| Existing public tables | 13 tables; all reported with RLS enabled | Inspected |
| GitHub Pages/site stack | Static HTML/CSS/vanilla JS; existing tests use Python unittest and Node built-in test runner | Retain |
| Supplier roster and written dropship authorization | Not yet evidenced in repository or current project inspection | Blocked for purchasability |
| Supplier inventory feed/API and SKU mapping | Not yet evidenced | Blocked for live stock |
| MAP source, effective dates, publication permission | Not yet evidenced | Blocked for numeric MAP publication |
| Product image usage rights | Not yet evidenced | Blocked for external image publication |
| Warranty/returns responsibility | Not yet evidenced | Blocked for purchasability |

## Existing database inventory

The existing database has one baseline migration and these public tables:

- `profiles`
- `products`
- `product_files`
- `collections`
- `collection_products`
- `coupons`
- `orders`
- `order_items`
- `licenses`
- `downloads`
- `site_sections`
- `events`
- `audit_logs`

All 13 tables were reported with RLS enabled. The existing `public.products` table is for digital goods and licensing: its product-type constraint covers plugins, samples, presets, MIDI, templates, bundles, tools, and other digital products. It is connected to product files, licenses, downloads, and order items. It must not be reused as the physical equipment catalog.

See `docs/decisions/ADR-0002-catalog-data.md` for the isolation decision.

## Advisor checks

- **Security advisor:** returned no lints at the time of inspection. This is not a guarantee that all application policies are correct.
- **Performance advisor:** reported existing baseline findings, including 11 foreign keys without covering indexes, 13 RLS initialization-plan warnings, and 14 cases of multiple permissive policies. These apply to existing platform tables, not to new catalog tables (which do not yet exist). Do not change unrelated policies/indexes during catalog work.
- **Manual review follow-up:** the existing `downloads` insert policy appears to compare `l.product_id = l.product_id` rather than correlate the license product to the requested download product. This may permit a user with any active license to create a download row for a different product. It is outside this catalog foundation task; add it to the platform security review before the download flow is used in production.

## Safe next step

The owner approved the data dictionary and access matrix on 2026-11-18. The first catalog migration has been drafted in `supabase/migrations/20261118232000_create_physical_equipment_catalog.sql`, but it has not been applied. No database schema, grants, RLS policies, production data, or production settings have been changed. A Supabase development branch is required for safe application and verification; the quoted branch cost is $0.01344/hour and is awaiting the owner's specific cost confirmation. Keep private supplier/evidence data separate from public product fields, and keep purchase eligibility and live-stock claims disabled until third-party evidence is available.
