# BZaudio Product Catalog — Task List

**Status:** Planning draft — no implementation tasks are complete.  
**Spec:** `SPEC-CATALOG.md`  
**Plan:** `tasks/catalog-plan.md`  
**Branch:** `feature/website-foundation`

## Phase 1 — Architecture and readiness

- [ ] **Task 1: Record catalog architecture decision and verify environment readiness**
  - **Description:** Document the static GitHub Pages frontend + Supabase catalog data boundary, inspect the existing Supabase project status and access, and verify the current repository/Pages workflow without changing production settings or data.
  - **Acceptance criteria:**
    - [ ] A catalog-specific ADR records source of truth, public/private data boundary, secret handling, and why the existing static frontend is retained.
    - [ ] Supabase project state and required configuration are verified from live project metadata; unavailable or paused state is recorded as a blocker, not guessed.
    - [ ] Required supplier/MAP/image-rights prerequisites are recorded as available, missing, or awaiting owner/supplier input.
  - **Verification:** Review ADR against `SPEC-CATALOG.md`; confirm project status through Supabase project metadata; inspect GitHub workflow and hosting configuration without deploying.
  - **Dependencies:** None.
  - **Files likely touched:** `docs/decisions/ADR-0002-catalog-data.md`, `docs/catalog/prerequisites.md`.
  - **Estimated scope:** Small.

- [ ] **Task 2: Define catalog schema and access-control contract**
  - **Description:** Specify the normalized relational model and public/private access contract before creating migrations.
  - **Acceptance criteria:**
    - [ ] Schema covers manufacturers, categories, products, variants, source evidence, lifecycle, MAP, image rights, supplier eligibility, inventory snapshots, and audit history.
    - [ ] Unknown, not applicable, unverified, unavailable, stale, and conflicting states are distinct.
    - [ ] Public access exposes only approved product fields; supplier cost, credentials, private notes, and audit-only fields are excluded.
  - **Verification:** Review schema/data dictionary and RLS policy matrix against all catalog trust rules; include example public and private record shapes.
  - **Dependencies:** Task 1.
  - **Files likely touched:** `docs/catalog/data-dictionary.md`, `docs/catalog/access-matrix.md`.
  - **Estimated scope:** Small.

### Checkpoint — Architecture and data contract
- [ ] Owner review of ADR and schema/access contract.
- [ ] Supabase readiness is verified.
- [ ] No privileged secret or private supplier field is planned for browser access.

## Phase 2 — Database and import foundation

- [ ] **Task 3: Implement catalog migrations, constraints, and RLS**
  - **Description:** Create versioned Supabase migrations for the approved catalog model, indexes, validation constraints, and least-privilege policies.
  - **Acceptance criteria:**
    - [ ] Migrations apply cleanly to a non-production/test project and include rollback/recovery notes.
    - [ ] Anonymous users can read only published, approved catalog fields; unauthenticated writes are denied.
    - [ ] Admin/import-only fields and supplier data remain private; duplicate manufacturer/model/variant identities are constrained.
  - **Verification:** Apply migrations to a test project; run SQL/RLS tests for anonymous, authenticated, and privileged roles; inspect exposed views/RPCs.
  - **Dependencies:** Tasks 1–2.
  - **Files likely touched:** `supabase/migrations/*`, `tests/catalog-rls.test.*`, `docs/catalog/schema.md`.
  - **Estimated scope:** Medium.

- [ ] **Task 4: Build secure import and validation pipeline**
  - **Description:** Add a server-side import path for normalized manufacturer/product data with schema validation, idempotency, duplicate detection, quarantine, source provenance, and audit logging.
  - **Acceptance criteria:**
    - [ ] Re-importing identical source data is idempotent and does not create duplicate products/variants.
    - [ ] Invalid, conflicting, discontinued, or insufficiently evidenced records are quarantined or excluded from public output.
    - [ ] Service-role and supplier credentials are used only server-side and never committed or sent to the browser.
  - **Verification:** Automated tests cover valid/invalid records, duplicate imports, partial failures, audit events, and secret-boundary checks.
  - **Dependencies:** Task 3.
  - **Files likely touched:** `supabase/functions/catalog-import/*`, `tests/catalog-import.test.*`, `docs/catalog/import-process.md`.
  - **Estimated scope:** Medium.

### Checkpoint — Data foundation
- [ ] Migrations and RLS tests pass in a non-production environment.
- [ ] Import tests prove idempotency, quarantine, and auditability.
- [ ] No manufacturer records are published without required source evidence.

## Phase 3 — Manufacturer source coverage

- [ ] **Task 5: Establish source register and Allen & Heath coverage**
  - **Description:** Create the manufacturer source register and coverage matrix, then verify current Allen & Heath product families and ingest the first approved, evidenced product batch.
  - **Acceptance criteria:**
    - [ ] Each source has a canonical URL/reference, source type, access/usage notes, and checked date.
    - [ ] Coverage report identifies every verified current Allen & Heath product family found, known gaps, and records awaiting review.
    - [ ] Product facts and images are ingested only when source provenance and usage rights are recorded; unverified data remains unpublished.
  - **Verification:** Compare the coverage matrix with the current official manufacturer catalog; audit a representative sample of records and links.
  - **Dependencies:** Tasks 3–4.
  - **Files likely touched:** `docs/catalog/sources.md`, `docs/catalog/coverage/allen-heath.md`, `data/catalog/*`, `tests/catalog-coverage.test.*`.
  - **Estimated scope:** Medium.

- [ ] **Task 6: Verify and ingest Yamaha professional-audio coverage**
  - **Description:** Verify Yamaha professional-audio product families and ingest a reviewed batch using the shared importer.
  - **Acceptance criteria:**
    - [ ] Scope excludes unrelated consumer product lines.
    - [ ] Product identity, lifecycle, variant, specifications, and source verification dates are recorded.
    - [ ] Coverage gaps and unresolved product status are visible and no unsupported MAP/stock is published.
  - **Verification:** Audit against Yamaha's current official professional-audio catalog and run importer/data-quality tests.
  - **Dependencies:** Task 5.
  - **Files likely touched:** `docs/catalog/coverage/yamaha-pro-audio.md`, `data/catalog/*`, `tests/catalog-coverage.test.*`.
  - **Estimated scope:** Medium.

- [ ] **Task 7: Verify and ingest Shure professional-audio/music coverage**
  - **Description:** Verify Shure professional-audio and music-related product families and ingest a reviewed batch using the shared importer.
  - **Acceptance criteria:**
    - [ ] Scope includes relevant microphones, wireless, headphones, in-ear monitoring, accessories, and related music/pro-audio lines while excluding unrelated lines.
    - [ ] Product identity, lifecycle, variant, specifications, and source verification dates are recorded.
    - [ ] Coverage gaps and unresolved product status are visible and no unsupported MAP/stock is published.
  - **Verification:** Audit against Shure's current official product taxonomy and run importer/data-quality tests.
  - **Dependencies:** Task 5.
  - **Files likely touched:** `docs/catalog/coverage/shure-pro-audio.md`, `data/catalog/*`, `tests/catalog-coverage.test.*`.
  - **Estimated scope:** Medium.

### Checkpoint — Manufacturer coverage
- [ ] Coverage reports exist for all three manufacturers with checked dates and known gaps.
- [ ] Representative products from multiple categories pass data-quality validation.
- [ ] No completeness claim is made beyond the documented evidence.

## Phase 4 — Public catalog experience

- [ ] **Task 8: Publish restricted public catalog read interface**
  - **Description:** Add a stable, documented read-only interface for published products and their approved public fields.
  - **Acceptance criteria:**
    - [ ] Public interface returns only published, current, approved product and variant fields.
    - [ ] MAP is returned only when verified and publishable; otherwise the UI receives the approved contact-for-price state.
    - [ ] Private supplier details, credentials, dealer cost, moderation notes, and audit logs are never exposed.
  - **Verification:** Integration tests query as anonymous user and assert private fields are absent; test filtering/pagination and empty/error states.
  - **Dependencies:** Tasks 3–7.
  - **Files likely touched:** `supabase/migrations/*`, `supabase/functions/catalog-public/*` or approved SQL view/RPC, `docs/catalog/public-api.md`, `tests/catalog-public-api.test.*`.
  - **Estimated scope:** Medium.

- [ ] **Task 9: Build catalog browsing, search, and filters**
  - **Description:** Replace the current contact-only category links with a responsive catalog experience connected to the public read interface.
  - **Acceptance criteria:**
    - [ ] Visitors can browse by manufacturer and category and search product names/models.
    - [ ] Filters and search work with keyboard and touch, with useful loading, empty, and error states.
    - [ ] No product is shown as purchasable and no unsupported stock or price is invented.
  - **Verification:** Browser tests cover manufacturer/category navigation, search, filtering, empty/error responses, mobile layout, and keyboard use.
  - **Dependencies:** Task 8.
  - **Files likely touched:** `products.html`, `script.js`, `styles.css`, `tests/catalog-ui.test.*`.
  - **Estimated scope:** Medium.

- [ ] **Task 10: Build product detail, variant, MAP, and availability states**
  - **Description:** Add accessible product detail views with verified specifications, source context, distinct variants, MAP/contact-for-price behavior, and honest availability states.
  - **Acceptance criteria:**
    - [ ] Product detail pages show only verified, sourced specifications and distinguish variants correctly.
    - [ ] MAP appears only with matched, current, publishable evidence; otherwise “Contact for price” is displayed.
    - [ ] Stock is shown as live only when an approved supplier feed provides fresh timestamped data; otherwise availability is unknown/being confirmed.
  - **Verification:** Test current/discontinued/unverified products, MAP evidence combinations, variant matching, stale/missing/conflicting inventory, and responsive detail views.
  - **Dependencies:** Tasks 8–9.
  - **Files likely touched:** `product.html` or approved detail route, `script.js`, `styles.css`, `tests/catalog-detail.test.*`.
  - **Estimated scope:** Medium.

### Checkpoint — Public catalog
- [ ] Anonymous visitors can browse verified products without accessing private data.
- [ ] Search, filters, product details, and all status states work.
- [ ] No cart, checkout, login, or order creation is included in this module.

## Phase 5 — Supplier readiness and release review

- [ ] **Task 11: Integrate an approved supplier feed when prerequisites are available**
  - **Description:** Add a supplier-specific adapter only after BZaudio confirms an authorized supplier, written dropship permission, feed/API access, SKU mapping, freshness rules, warranty/returns terms, and credentials.
  - **Acceptance criteria:**
    - [ ] Supplier authorization and dropship permission are documented before any item becomes purchase-eligible.
    - [ ] Feed records match exact product variants and include source timestamps; stale or conflicting records are quarantined.
    - [ ] Credentials remain server-side; missing supplier prerequisites leave purchase eligibility disabled.
  - **Verification:** Use supplier-provided test fixtures/sandbox feed; test SKU mismatches, missing data, stale stock, API failure, and credential isolation.
  - **Dependencies:** Tasks 3–4 and external supplier agreement/access.
  - **Files likely touched:** `supabase/functions/supplier-sync/*`, `docs/catalog/suppliers/*`, `tests/supplier-sync.test.*`.
  - **Estimated scope:** Medium.
  - **Blocker rule:** If supplier access/terms are not available, leave this task blocked and keep catalog items non-purchasable; do not fabricate a supplier or feed.

- [ ] **Task 12: Complete catalog security, accessibility, data-quality, and release review**
  - **Description:** Run the complete catalog test matrix, verify manufacturer coverage and public/private boundaries, document operational procedures, and prepare a release candidate.
  - **Acceptance criteria:**
    - [ ] All catalog and existing site tests pass; no critical security or data-quality issues remain.
    - [ ] Accessibility, keyboard, reduced-motion, mobile, and desktop checks pass for core catalog journeys.
    - [ ] Coverage, source provenance, MAP evidence, image rights, supplier status, known gaps, and release notes are documented.
  - **Verification:** Run `python3 -m unittest discover -s tests -v`, `node --check script.js`, `node --test tests/*.test.mjs`, migration/RLS/import tests, and documented browser checks.
  - **Dependencies:** Tasks 5–10; Task 11 only for any supplier-backed live availability or purchase-eligibility claim.
  - **Files likely touched:** `tests/*`, `docs/catalog/*`, `README.md` if public catalog behavior changes.
  - **Estimated scope:** Medium.

### Final checkpoint — Owner release review
- [ ] Catalog success criteria in `SPEC-CATALOG.md` are met.
- [ ] All published records have traceable sources and verification dates.
- [ ] Private supplier/admin data is inaccessible to public visitors.
- [ ] Unresolved supplier/MAP/image-rights gaps are clearly disclosed and do not create false purchase promises.
- [ ] Owner reviews the release candidate before public activation.

## Future modules — separate specifications required
The broader approved project continues after the catalog, in this order:
1. Customer Accounts.
2. Online Store and checkout/payments.
3. Dropshipping and fulfillment.
4. ORIGIN contributor/member experience.
5. Administration and final integration.

Each module needs its own specification, plan, task list, and approval checkpoint. This catalog task list does not authorize implementation of those modules by implication.
