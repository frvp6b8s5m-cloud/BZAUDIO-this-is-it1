# Implementation Plan: BZaudio Product Catalog

## Status
**Planning draft — awaiting owner approval before implementation.** The owner approved `SPEC-CATALOG.md` in chat and has authorized the broader project work, including integrations, payment setup, security work, supplier coordination, and production launch. This plan covers Module 1 only; it does not silently treat the other five modules as specified or implemented.

**Task list:** `tasks/catalog-todo.md`  
**Specification:** `SPEC-CATALOG.md`  
**Capability map:** six-module BZaudio commerce/customer platform approved in the project conversation.

## Overview
Build a trustworthy, searchable catalog for currently marketed Allen & Heath, Yamaha professional-audio, and Shure professional-audio/music products. Preserve the existing static HTML/CSS/vanilla-JavaScript public site and GitHub Pages direction, while using the existing Supabase project as the catalog's secure data source after its actual readiness is verified. Product facts, lifecycle, MAP publication status, imagery rights, supplier eligibility, and inventory freshness remain separately evidenced. This module delivers discovery and a documented data contract; it does not add customer accounts, cart, checkout, payment processing, order management, supplier ordering, or ORIGIN.

## Repository findings
- The active branch is `feature/website-foundation`.
- The site is currently static HTML, CSS, and vanilla JavaScript. `products.html` contains eight category links that currently lead to the contact page; `script.js` handles the shared mobile menu, reveal animation, and footer year.
- Existing tests are Python standard-library tests and Node.js built-in `node:test`; CI workflow is `.github/workflows/quality.yml`.
- Existing website plan and task list are incomplete and belong to a different workstream. They remain untouched.
- `docs/decisions/ADR-0001-static-first.md` records the initial static-site decision and explicitly says to revisit architecture when server-side data or authenticated workflows become necessary.
- `SPEC-CATALOG.md` already defines catalog trust rules, manufacturer scope, MAP rules, supplier eligibility, stock freshness, test requirements, and module boundaries.
- The repository currently has no catalog database migrations, catalog importer, catalog data model, catalog-specific UI, or catalog tests.

## Architecture decisions
1. **Keep the public website static.** Do not introduce a frontend framework, bundler, package manager, or runtime dependency. Continue using semantic HTML, CSS, and vanilla JavaScript.
2. **Use Supabase Postgres as the catalog source of truth**, subject to a read-only readiness check of the existing BZaudio project before implementation. Do not duplicate authoritative catalog records in checked-in JSON and the database.
3. **Expose only a deliberately safe public catalog read surface.** Public browser access must be limited by Row Level Security and/or a restricted view/RPC. The public anon/publishable key is not a secret, but service-role keys, supplier credentials, and privileged tokens must remain server-side.
4. **Keep imports and supplier synchronization server-side.** Use controlled, validated import jobs/Edge Functions or another approved server-side mechanism. Never place supplier credentials in GitHub Pages code.
5. **No purchase promise in this module.** A product can be browsable without being purchasable. Purchase eligibility remains false unless an approved supplier and dropship terms, warranty handling, accurate availability, and later store flow are verified.
6. **MAP is evidence-backed.** Only publish a matched, current, permitted MAP amount. Otherwise display the approved “Contact for price” state. Never infer transaction price or expose dealer cost.
7. **Image assets require documented rights.** Manufacturer page image URLs are not treated as permission to republish.
8. **No production deployment or public catalog activation until the release checkpoint.** Owner authorization permits the work, but a tested release candidate and verified credentials/data are still required.

## Dependency graph
```
Supabase project readiness + architecture decision
                 |
        Catalog schema + RLS
                 |
      Import/validation pipeline
                 |
     Manufacturer source registry
       /          |            \
Allen & Heath   Yamaha        Shure
       \          |            /
       Verified normalized records
                 |
        Restricted public read API
                 |
     Catalog browse/search/filter UI
                 |
      Product details + MAP/status UI
                 |
     Security, accessibility, data QA
                 |
          Catalog release review
                 |
   Customer Accounts → Online Store
                 |
    Dropshipping & Fulfillment → ORIGIN
                 |
       Administration + integration
```

## Implementation phases

### Phase 1 — Architecture and readiness
- Confirm the Supabase project is active and accessible without modifying production data.
- Confirm GitHub Pages deployment constraints and the public-site branch/workflow.
- Record a catalog-specific architecture decision that explains the static frontend + Supabase data boundary.
- Verify the catalog's RLS/public read design before creating tables or exposing any data.
- Record supplier roster, manufacturer-source access, MAP evidence sources, image permissions, and any unavailable prerequisites.

### Phase 2 — Catalog data foundation
- Design normalized manufacturer, category, product, variant, source, MAP evidence, image-rights, supplier eligibility, inventory snapshot, and audit records.
- Add versioned database migrations and rollback notes.
- Add constraints/indexes and least-privilege RLS policies.
- Add a restricted public read interface that excludes private supplier, dealer-cost, credential, and audit data.
- Test anonymous/public access and privileged access separately.

### Phase 3 — Import and verified product data
- Build a server-side import/validation path with idempotency, duplicate detection, quarantine/review states, source provenance, and audit history.
- Establish manufacturer source registers and a coverage matrix.
- Ingest Allen & Heath, Yamaha professional audio, and Shure professional-audio/music product families from permitted official sources.
- Record coverage dates and gaps. Do not claim “every product” until the coverage report supports that claim.
- Do not bulk scrape or republish content/images where source terms or rights do not permit it.
- Supplier feed synchronization is a gated extension: implement only when an approved supplier roster, feed/API access, field definitions, and dropship agreement are available.

### Phase 4 — Public catalog experience
- Connect the static site to the restricted public catalog interface using the supported browser-safe configuration.
- Replace contact-only category links with real category/manufacturer navigation.
- Add accessible search and filters for manufacturer, category, and relevant product attributes.
- Add product detail presentation with source/verification context, variant handling, MAP/contact-for-price behavior, and clear unknown/unavailable states.
- Do not show live stock unless the approved supplier source provides current, timestamped data.
- Do not add cart, checkout, customer login, or purchase actions in this module.

### Phase 5 — Verification and release readiness
- Test import validation, duplicate handling, lifecycle filtering, MAP evidence, image rights, supplier eligibility, stale/conflicting stock, and public/private data separation.
- Test representative records from all three manufacturers and several categories.
- Run existing site tests, new catalog tests, accessibility checks, keyboard checks, responsive checks, and runtime browser journeys.
- Produce a manufacturer coverage report and unresolved-data report.
- Prepare a release candidate; do not enable/alter production hosting or publish the catalog until all release checks and owner review are satisfied.

## Task index
See `tasks/catalog-todo.md` for full acceptance criteria, verification steps, dependencies, likely files, and checkpoints.

1. Catalog architecture decision and environment readiness.
2. Catalog schema, migrations, and access policies.
3. Secure importer and data validation.
4. Manufacturer source register and Allen & Heath coverage.
5. Yamaha and Shure coverage ingestion.
6. Restricted public catalog read interface.
7. Catalog browsing, search, and filters.
8. Product detail, variant, MAP, and availability states.
9. Full catalog quality, security, accessibility, and release review.

## Risks and mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Supabase project is paused, unavailable, or misconfigured | High | Verify actual project state and access before schema work; no assumptions based on earlier restore attempt. |
| No authorized dropship supplier or supplier feed is available | High | Catalog can still be browsable, but keep purchase eligibility and live stock disabled until evidence and agreements exist. |
| Manufacturer catalog scope is large and changes frequently | High | Build a source register and coverage matrix; record last-checked dates and known gaps. |
| MAP is confidential, stale, or not publishable | High | Store evidence and publication permission separately; default to “Contact for price.” |
| Product images are not licensed for reseller use | High | Use only assets with documented permission; otherwise use text-only/product-placeholder presentation approved for launch. |
| Static frontend exposes private data | High | Public-safe database view/RPC, RLS, least privilege, and anonymous-access tests. |
| Supplier feeds are incomplete or inconsistent | Medium/High | Validate timestamps, variant/SKU matching, and source identity; quarantine conflicts and stale records. |
| Catalog becomes coupled to future checkout logic | Medium | Document a stable catalog interface and keep cart/payment/order logic in later modules. |
| Scope expands into all six modules at once | High | Complete this module's spec/plan/tasks/review first; create separate specs and approval gates for Accounts, Store, Fulfillment, ORIGIN, and Administration. |

## External prerequisites and unresolved data inputs
Owner authorization is granted for the project work, but it does not create third-party agreements, API access, credentials, MAP permissions, or image licenses. Before a product can be marked purchasable, BZaudio must have:
- A confirmed authorized supplier and explicit resale/dropship permission.
- Supplier SKU/variant mapping, current inventory feed/API access, timestamps, and fulfillment terms.
- Warranty/returns and customer-support responsibility documented.
- Verified MAP source, effective date, and publication permission.
- Approved product image/copy usage rights.

Where these are not yet available, implementation proceeds with safe non-purchasable states and clear review queues rather than invented data.

## Parallelization
- Safe in parallel after schema/interface contracts are approved: manufacturer source research, independent test fixtures, and accessibility review.
- Must remain sequential: project readiness → schema/RLS → importer → public API → UI integration.
- Supplier feed adapters can be developed separately only after a real supplier contract and sample feed are available.
- The remaining five modules require their own approved module specifications before their detailed plans and implementation begin.

## Definition of done
- All catalog success criteria in `SPEC-CATALOG.md` are met.
- No unchecked critical security, MAP, supplier, lifecycle, or image-rights issue remains for the published dataset.
- Public users can browse and search verified catalog records; private supplier/admin information is inaccessible.
- Stale/missing data is never represented as live.
- Automated tests and documented runtime checks pass.
- Manufacturer coverage and known gaps are documented.
- Catalog interface and operational procedures are documented for later modules.
- Owner reviews the release candidate before public activation.
