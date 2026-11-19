# ADR-0002: Isolate the physical-equipment catalog from the existing digital-products platform

- **Status:** Accepted for the catalog implementation
- **Date:** 2026-11-18
- **Decision owners:** BZaudio project owner (catalog plan approved)
- **Related:** `SPEC-CATALOG.md`, `tasks/catalog-plan.md`, `tasks/catalog-todo.md`

## Context

The existing Supabase project `BZ audio` (`cgakpcvptyhxwfujzqoe`) is healthy and already contains a platform foundation from migration `20260928195620_bz_audio_platform_foundation`. Its public schema includes `products`, `product_files`, `collections`, `orders`, `order_items`, `licenses`, `downloads`, `profiles`, `coupons`, `events`, `audit_logs`, and `site_sections`.

The existing `public.products` model is a digital-product/download model: its `product_type` constraint allows plugin, sample, preset, MIDI, template, bundle, tool, and other; it includes creator ownership, downloadable product files, licenses, and download relationships. It is not a suitable direct representation of physical professional-audio equipment, variants, manufacturer lifecycle, MAP evidence, media rights, or supplier inventory.

The public site remains static HTML/CSS/vanilla JavaScript and the repository has no package manager or frontend framework.

## Decision

1. Keep the existing digital-products tables and their relationships intact. Do not rename, repurpose, or widen `public.products` for physical equipment.
2. Implement the equipment catalog as a separately named `catalog_*` table family, with explicit foreign keys and indexes, and a separate private-data boundary for supplier credentials/terms, source evidence not approved for publication, inventory feed details, and audit/review notes.
3. Public catalog records must contain only fields intended for publication. Any public read surface must be deliberately allowlisted, protected by RLS, and tested as `anon` and `authenticated`.
4. Keep supplier credentials, dealer cost, non-public MAP evidence, private source notes, and raw supplier payloads out of public tables and browser responses.
5. Retain the static frontend. Do not add a framework, bundler, or client-side privileged credential. A browser-safe Supabase publishable key may be used only after the public read interface and RLS are tested.
6. Do not create tables, change RLS, alter Data API exposure, or apply migrations until the catalog schema and access matrix in Task 2 are reviewed. Use a non-production/test branch or project for schema iteration where available.
7. The existing platform migration and its policies are not to be silently refactored as part of the catalog. Existing security/performance observations are recorded separately for later project-wide review.

## Consequences

- Catalog equipment can evolve independently of the existing digital-download product model.
- The later online store will need an explicit order-line integration contract rather than assuming equipment is the same kind of product as a downloadable license.
- Additional tables and a documented public interface are required.
- Existing digital-product checkout and licensing behavior is preserved.

## Verification

- Supabase project status is `ACTIVE_HEALTHY`; Postgres version is 17.6.1.166.
- Existing public schema contains 13 tables, all reported with RLS enabled.
- Existing migration history contains one migration: `20260928195620_bz_audio_platform_foundation`.
- Existing product schema and foreign keys confirm the digital-download use case.
- Supabase security advisor returned no lints at the time of inspection; performance advisor returned existing baseline findings. These are recorded in `docs/catalog/prerequisites.md`.
