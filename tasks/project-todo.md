# BZaudio Full Project — Task Tracker

**Active development branch:** `feature/email-first-storefront`
**Recurring infrastructure budget:** $0
**Production deployment:** not approved by this task tracker; separate final release review remains required.\n**Database state:** migration is tested in disposable CI only; it has NOT been applied to the live Supabase project.

## Completed and verified in this branch

- [x] Added Store to the shared navigation.
- [x] Added the email-first equipment inquiry page.
- [x] Added multi-item equipment request entry; the email draft clearly says it is not an order or payment authorization.
- [x] Added tests for the email-draft and edit behavior.
- [x] Added the minimal ORIGIN gateway with login disabled and clearly marked as not active; no fake authentication.
- [x] Added ORIGIN to shared navigation.
- [x] Added a capability map and separate specifications for Store, Accounts, Fulfillment, Administration, and ORIGIN membership.
- [x] Added a disposable PostgreSQL CI test harness for the physical catalog migration (execution status is tracked by GitHub Actions).

## Catalog

- [x] Approved physical catalog data contract and access matrix.
- [x] Drafted physical equipment catalog migration in GitHub.
- [x] Verify migration passes disposable PostgreSQL CI, including RLS and least-privilege grants.
- [x] Review migration structure and least-privilege grants against the disposable PostgreSQL CI assertions.
- [ ] Build idempotent, validated, server-side import and quarantine pipeline.
- [ ] Verify Allen & Heath, Yamaha professional audio, and Shure music/pro-audio product-family coverage from official sources.
- [ ] Populate model-level products only from verified sources; no guessed specs, prices, MAP, stock, or image rights.
- [ ] Build read-only catalog interface and connect the public catalog UI.
- [ ] Complete catalog security, accessibility, and data-quality review.

## Customer accounts

- [ ] Verify existing Supabase Auth settings and email deliverability.
- [ ] Confirm a reliable email verification path that has $0 recurring cost.
- [ ] Implement customer registration, sign-in, sign-out, sessions, and profile.
- [ ] Enforce ownership and customer/admin role boundaries with RLS.
- [ ] Add purchase gating for later payment activation; public non-binding inquiries may remain open.

## Store

- [x] Build email-based multi-item equipment request draft.
- [ ] Populate verified product listings and detail views.
- [ ] Add catalog-driven add-to-request/cart controls.
- [ ] Connect inquiries to customer accounts when the account system is available.
- [ ] Add a private owner inquiry review workflow.
- [ ] Keep online checkout, payment capture, and automated supplier orders disabled until separately activated.

## Dropshipping and fulfillment

- [ ] Identify and verify authorized suppliers and written resale/dropship permission.
- [ ] Record SKU mapping, territories, warranty, returns, shipping, and support terms.
- [ ] Implement feed adapters only after real supplier access and sample data exist.
- [ ] Test stale inventory, mismatched SKUs, duplicates, supplier outages, and retries.
- [ ] Keep automatic supplier ordering disabled until payments and release checks are complete.

## ORIGIN

- [x] Build the minimal public ORIGIN gateway; login remains inactive and is not represented as working.
- [x] Document the approved Founder recognition and membership rules.
- [ ] Build private one-time applications with database-enforced duplicate prevention.
- [ ] Configure free email notification to benrz101@gmail.com only after a verified free sender is available.
- [ ] Build owner approval/decline workflow.
- [ ] Build permanent unique Founder number assignment under owner control.
- [ ] Build public Contribution Page and private approved-member access.
- [ ] Define post-login member experience with the owner before implementing it.

## Administration and final integration

- [ ] Implement secure admin authorization and audit trail.
- [ ] Build catalog, inquiry, supplier, account, and ORIGIN review tools.
- [ ] Verify no private data or service credentials reach the public browser.
- [ ] Run all automated tests and browser/accessibility checks.
- [ ] Prepare release notes and owner review.
- [ ] Enable GitHub Pages / production release only after final approval.

## Cost and safety gates

- [x] No paid Supabase branch created.
- [x] No online payments or automatic supplier ordering enabled.
- [ ] Verify every proposed external email/supplier integration has a genuinely free operating path before enabling it.
- [ ] Confirm no paid plan, recurring fee, or usage overage risk has been introduced.
