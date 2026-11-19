# BZaudio Website — Task Breakdown

**Status:** Owner-approved plan. Implementation is underway on `feature/website-foundation`; production deployment remains separately approval-gated.

## Phase 0 — Prerequisites and architecture decisions

- [x] **Task 0.1: Select GitHub Pages as the hosting target (configuration/deployment still deferred)**
  - Acceptance: GitHub Pages is selected and the repository root is the planned static source; custom-domain preference remains open.
  - Verify: GitHub Pages documentation was checked; no production setting or DNS was changed.
  - Dependencies: None.
  - Files likely touched: `tasks/plan.md`, architecture decision notes.
  - Scope: Small.

- [x] **Task 0.2: Select the minimal frontend stack and quality tooling**
  - Acceptance: static HTML/CSS/vanilla JavaScript, no runtime dependencies or build step, Python standard-library tests, and local preview command are documented.
  - Verify: architecture is compatible with GitHub Pages and avoids unnecessary dependencies.
  - Dependencies: Task 0.1.
  - Files likely touched: `tasks/plan.md`.
  - Scope: Small.

- [x] **Task 0.3: Define and configure email-only contact**
  - Acceptance: email-only contact and quote request; no phone number; owner-supplied address is configured; no fake submission form.
  - Verify: `contact.html` uses `mailto:benrz101@gmail.com` and explains that it opens the visitor's configured email app.
  - Dependencies: Task 0.1.
  - Files likely touched: `tasks/plan.md`.
  - Scope: Small.

- [x] **Task 0.4: Apply approved catalog and content workflow (media and model data remain future inputs)**
  - Acceptance: approved categories and GitHub-based content editing are documented; individual product data and licensed media are explicitly held until verified.
  - Verify: no unverified product facts or unlicensed public imagery are introduced.
  - Dependencies: None.
  - Files likely touched: content inventory/asset provenance notes.
  - Scope: Small.

### Checkpoint — Architecture approval
- [x] GitHub Pages, owner-supplied email-only contact, approved category taxonomy, and GitHub-based content editing are reflected in the architecture; stack is recorded and custom-domain preference is explicitly left open.
- [x] Risks and decisions are recorded.
- [x] Owner approved the technical architecture on 2026-11-13.

**Foundation note:** on 2026-11-18, the complete visual system was redesigned across Home, Products, Solutions, About, and Contact from the official BZaudio logo. The new direction is monochrome black/white, oval geometry, expressive editorial typography, and a logo-led homepage. This supersedes the earlier lime-accent architectural design. Automated checks and responsive visual review are being completed; production deployment remains approval-gated.

## Phase 1 — Foundation and C1 Brand experience

- [x] **Task 1.1: Establish minimal application foundation**
  - Acceptance: static root structure, local preview instructions, and Python standard-library regression tests are in place; no install or build step is required.
  - Verify: `python3 -m unittest discover -s tests -v` passes all 12 Python tests and 2 Node.js interaction tests; `node --check script.js` passes.
  - Dependencies: Phase 0 checkpoint.
  - Files likely touched: approximately 3–5 configuration/source files.
  - Scope: Medium.

- [ ] **Task 1.2: Build shared architectural-cinematic design system**
  - Acceptance: typography, color, spacing, grid, image, responsive, and motion tokens are defined; reusable primitives support consistent visual hierarchy.
  - Verify: representative components render consistently at mobile and desktop widths; reduced-motion and focus states are demonstrated.
  - Dependencies: Task 1.1.
  - Files likely touched: approximately 3–5 design/style/component files.
  - Scope: Medium.

- [ ] **Task 1.3: Build global navigation, footer, and responsive shell**
  - Acceptance: concise navigation, clear active/focus states, touch-friendly mobile menu, and consistent page shell are functional.
  - Verify: keyboard and touch navigation work at mobile and desktop viewports.
  - Dependencies: Task 1.2.
  - Files likely touched: approximately 3–5 component/style/test files.
  - Scope: Medium.

- [x] Implement the official BZaudio logo in the shared header/footer and refresh the homepage hero; automated static-site regression tests pass. Visual sign-off remains pending.

- [ ] **Task 1.4: Build the home/brand experience**
  - Acceptance: brand belief, company proposition, clear customer pathways, and primary quote/contact call to action are presented in a premium architectural-cinematic layout.
  - Verify: content hierarchy is clear in a short usability review; motion is reduced when requested and does not delay core content.
  - Dependencies: Task 1.3.
  - Files likely touched: approximately 3–5 page/content/style files.
  - Scope: Medium.

### Checkpoint — Brand foundation
- [ ] Production build and baseline tests pass.
- [ ] Home, navigation, and footer work on mobile and desktop.
- [ ] Architectural/cinematic direction is present without visual overload.
- [ ] Accessibility and motion checks pass for the shared shell.

## Phase 2 — C2 Product discovery

- [x] **Task 2.0: Build the approved product-category directory**
  - Acceptance: all eight owner-approved categories have a clear description and a next-step path; no unsupported model-level product facts are displayed.
  - Verify: all category links resolve to the contact page; the five-page navigation and responsive layout pass automated checks.
  - Dependencies: Task 1.2 and Task 1.3.
  - Files touched: `products.html`, `styles.css`.
  - Scope: Medium.

- [ ] **Task 2.1: Define verified product content model**
  - Acceptance: product/category schema supports sourced facts, optional fields, media provenance, and unavailable data without fabricated defaults.
  - Verify: schema/content validation tests cover missing and malformed fields.
  - Dependencies: Phase 1 checkpoint.
  - Files likely touched: approximately 2–4 data/schema/test files.
  - Scope: Medium.

- [ ] **Task 2.2: Build product category and detail views**
  - Acceptance: visitors can browse available categories and view product details using reusable components and only approved content.
  - Verify: links, empty states, missing optional fields, and responsive layouts are tested.
  - Dependencies: Task 2.1.
  - Files likely touched: approximately 3–5 route/component/style files.
  - Scope: Medium.

### Checkpoint — Product discovery
- [ ] All displayed specifications and claims have traceable sources.
- [ ] No invented price, stock, review, or compatibility data appears.
- [ ] Product navigation and responsive behavior pass.

## Phase 3 — C3 Solutions

- [x] **Task 3.1: Approve solution content and claim boundaries**
  - Acceptance: initial customer/application pathways and their source/approval owners are documented; educational content is distinguished from engineered design.
  - Verify: each solution claim has evidence or is clearly framed as general guidance.
  - Dependencies: Phase 1 checkpoint; may proceed alongside Phase 2 content review.
  - Files likely touched: solution content inventory.
  - Scope: Small.

- [x] **Task 3.2: Build solutions pages and product pathways**
  - Acceptance: concise solution pages explain relevant use cases and link to appropriate verified products or quote/contact paths.
  - Verify: all links work; no unvalidated coverage, power, rigging, acoustic, or compatibility claims are presented as engineering results.
  - Dependencies: Task 3.1 and shared design system; Task 2.2 only where product links are required.
  - Files likely touched: approximately 3–5 content/route/component files.
  - Scope: Medium.

### Checkpoint — Solutions
- [x] Each page has a clear audience and purpose.
- [x] Guidance is appropriately qualified and links to next steps.
- [x] No unsupported engineering claims appear.

## Phase 4 — C4 Customer contact

- [x] **Task 4.1: Build the email-only contact information page**
  - Acceptance: the page explains how to start a conversation, displays the owner-supplied email, and clearly states that the link opens the visitor's email app; no phone number, placeholder email, inactive form, or false submission promise appears.
  - Verify: the contact page is in the shared navigation, has accessible semantic structure, and passes the site-wide page tests.
  - Dependencies: Task 1.3.
  - Files touched: `contact.html`, `styles.css`.
  - Scope: Small.

- [x] **Task 4.2: Configure the owner-supplied email contact**
  - Acceptance: configure a clearly labeled `mailto:` link for the owner-supplied address and a quote-request email subject. Explain that it opens the visitor's configured email app.
  - Verify: destination matches the address supplied by the owner; no phone number or fabricated address is introduced.
  - Dependencies: Task 4.1 and owner-provided email address.
  - Files touched: `contact.html`, `README.md`.
  - Scope: Small.

### Checkpoint — Customer contact
- [x] Email destination is supplied by the owner and the mailto link is configured.
- [x] The visitor is told that the link opens their configured email app.
- [x] No phone number, invented email, fake form submission, or exposed private data appears.

## Phase 5 — Integrated quality and release readiness

- [ ] **Task 5.1: Run accessibility, responsive, and browser journey checks**
  - Acceptance: critical paths work on representative mobile and desktop browsers; keyboard, focus, contrast, semantics, and reduced motion are checked.
  - Verify: automated checks and documented manual browser checks pass.
  - Dependencies: Phases 1–4.
  - Files likely touched: approximately 2–5 tests/fixes/docs files.
  - Scope: Medium.

- [ ] **Task 5.2: Optimize performance and verify asset provenance**
  - Acceptance: image loading, animation cost, and page performance are measured; all public photography has documented license/source records.
  - Verify: representative performance measurements and asset audit are recorded.
  - Dependencies: Phase 1–4 implementation and licensed media inputs.
  - Files likely touched: approximately 2–5 asset/config/docs files.
  - Scope: Medium.

- [ ] **Task 5.3: Verify production build and prepare release review**
  - Acceptance: production build and all required checks pass; SEO metadata and deployment configuration match the approved host; release notes list known limitations.
  - Verify: deployment preview/smoke test passes; production release is not triggered without separate owner approval.
  - Dependencies: Tasks 5.1 and 5.2.
  - Files likely touched: approximately 2–5 config/docs files.
  - Scope: Medium.

### Final checkpoint — Owner release review
- [ ] All acceptance criteria and verification evidence are available.
- [ ] No unresolved critical accessibility, security, performance, or content issues remain.
- [ ] Owner reviews the release candidate and explicitly approves production deployment.


## Phase 6 — ORIGIN gateway

- [x] **Task 6.1: Build the minimal ORIGIN gateway**
  - Acceptance: oversized ORIGIN heading, a clearly inactive LOGIN entry, monochrome identity, and no legacy member content.
  - Verify: page is present in shared navigation across all six public pages; the inactive login collects no credentials and makes no authentication claim.
  - Files: `origin.html`, `styles.css`, all shared-navigation pages, `tests/test_site.py`, `SPEC-ORIGIN.md`.
- [ ] **Task 6.2: Implement real authentication and contributor access**
  - Acceptance: free-tier-compatible email sign-in, secure sessions, owner-approved ORIGIN access, and no public exposure of privileged keys.
  - Verify: real email delivery, session handling, authorization/RLS, and duplicate-application protections pass integration tests.
  - Dependency: Supabase Auth configuration and verified email delivery. No paid provider or recurring infrastructure may be enabled without owner review.
- [ ] **Task 6.3: Build Founder application and approval workflow**
  - Acceptance: one application per person; owner receives application details; no Founder number is assigned before approval; permanent unique numbers are owner-designed and owner-assigned based on contribution.
  - Verify: duplicate prevention, owner approval/decline, audit history, and privacy controls.



## Equipment request workflow
- [x] Build a multi-item equipment inquiry form with customer name/email, manufacturer, model, quantity, and optional project notes.
- [x] Link all eight product categories to a prefilled request.
- [x] Keep the workflow email-only and clearly disclose that the visitor must send the email; no order, payment, or supplier action is triggered.
- [ ] Replace the email handoff with a secure server-backed inquiry inbox only after a verified free email/notification route is configured and tested.
