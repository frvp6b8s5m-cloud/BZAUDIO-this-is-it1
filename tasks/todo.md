# BZaudio Website — Task Breakdown

**Status:** Approved by the owner. Implementation is authorized within the approved scope; production deployment and email activation remain separately gated.

## Phase 0 — Prerequisites and architecture decisions

- [x] **Task 0.1: Configure GitHub Pages deployment approach (planning only)**
  - Acceptance: GitHub Pages is the selected host; repository deployment source, custom-domain preference, preview workflow, and rollback approach are documented.
  - Verify: repository/Pages constraints are recorded; no production setting or DNS is changed.
  - Dependencies: None.
  - Files likely touched: `tasks/plan.md`, architecture decision notes.
  - Scope: Small.

- [x] **Task 0.2: Select the minimal frontend stack and quality tooling**
  - Acceptance: framework/static approach, versions, content strategy, accessibility approach, and exact install/build/test commands are documented with trade-offs.
  - Verify: selected approach is compatible with the confirmed host and repository workflow; no dependency is installed before plan approval.
  - Dependencies: Task 0.1.
  - Files likely touched: `tasks/plan.md`.
  - Scope: Small.

- [x] **Task 0.3: Define email-only contact activation**
  - Acceptance: contact section and quote-request email pathway have a configurable destination; no phone number or invented address is included; activation is deferred until the owner supplies the address after launch.
  - Verify: plan describes a tested mailto link/email draft and clearly states it opens the visitor's email app; no fake on-site form or third-party service is implied.
  - Dependencies: Task 0.1.
  - Files likely touched: `tasks/plan.md`.
  - Scope: Small.

- [x] **Task 0.4: Apply approved catalog and content workflow**
  - Acceptance: approved categories are documented (mixing consoles; speakers/subwoofers; microphones; wireless; headphones; processors/effects; amplifiers; cables/accessories); individual product data remains source-verified; GitHub commits are the initial content workflow; licensed photo provenance is tracked.
  - Verify: no unverified product facts or unlicensed public imagery are introduced.
  - Dependencies: None.
  - Files likely touched: content inventory/asset provenance notes.
  - Scope: Small.

### Checkpoint — Architecture approval
- [x] GitHub Pages, email-only deferred contact, approved category taxonomy, and GitHub-based content editing are reflected in the architecture; default GitHub Pages URL is the initial target.
- [x] Risks and decisions are recorded.
- [x] Owner approves the technical architecture before implementation tasks begin.

## Phase 1 — Foundation and C1 Brand experience

- [ ] **Task 1.1: Establish minimal application foundation**
  - Acceptance: selected app structure, scripts, formatting/lint/type checks, and build pipeline are configured without unnecessary dependencies.
  - Verify: clean install, development command, production build, and baseline checks pass.
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

- [ ] **Task 3.1: Approve solution content and claim boundaries**
  - Acceptance: initial customer/application pathways and their source/approval owners are documented; educational content is distinguished from engineered design.
  - Verify: each solution claim has evidence or is clearly framed as general guidance.
  - Dependencies: Phase 1 checkpoint; may proceed alongside Phase 2 content review.
  - Files likely touched: solution content inventory.
  - Scope: Small.

- [ ] **Task 3.2: Build solutions pages and product pathways**
  - Acceptance: concise solution pages explain relevant use cases and link to appropriate verified products or quote/contact paths.
  - Verify: all links work; no unvalidated coverage, power, rigging, acoustic, or compatibility claims are presented as engineering results.
  - Dependencies: Task 3.1 and shared design system; Task 2.2 only where product links are required.
  - Files likely touched: approximately 3–5 content/route/component files.
  - Scope: Medium.

### Checkpoint — Solutions
- [ ] Each page has a clear audience and purpose.
- [ ] Guidance is appropriately qualified and links to next steps.
- [ ] No unsupported engineering claims appear.

## Phase 4 — C4 Customer contact (email activation after launch)

- [ ] **Task 4.1: Prepare a truthful contact section without a fake form**
  - Acceptance: contact area is prepared for future email contact, but no inactive form, placeholder address, or phone number is displayed.
  - Verify: no form submission affordance or unconfigured mail link appears in the rendered site.
  - Dependencies: Task 1.3.
  - Files likely touched: approximately 1–3 page/component/style files.
  - Scope: Small.

- [ ] **Task 4.2: Activate owner-supplied email after launch**
  - Acceptance: once the owner supplies the address, a clear mailto link and quote-request draft are configured and verified.
  - Verify: link opens the visitor's email application with the intended recipient and subject/body; no backend form delivery is claimed.
  - Dependencies: owner supplies the email address after launch.
  - Files likely touched: configuration and contact UI files.
  - Scope: Small.

### Checkpoint — Customer contact
- [ ] Email destination is owner-supplied and verified before activation.
- [ ] The link clearly opens the visitor's email application.
- [ ] No phone number, invented email, fake form submission, or exposed private data appears.

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
