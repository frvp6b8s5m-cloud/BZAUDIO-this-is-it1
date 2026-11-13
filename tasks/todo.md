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

- [x] **Task 0.3: Define email-only contact activation**
  - Acceptance: email-only contact and quote request; no phone number; actual address supplied after launch; no fake submission form.
  - Verify: plan documents deferred activation through a configurable mailto link.
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
- [x] GitHub Pages, email-only deferred contact, approved category taxonomy, and GitHub-based content editing are reflected in the architecture; stack is recorded and custom-domain preference is explicitly left open.
- [x] Risks and decisions are recorded.
- [x] Owner approved the technical architecture on 2026-11-13.

**Foundation note:** shared design tokens, responsive breakpoints, motion/reduced-motion rules, and the initial brand homepage are now present. Tasks 1.2–1.4 remain open until the full responsive visual and interactive browser review is completed.

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

## Phase 4 — C4 Customer contact

- [ ] **Task 4.1: Build accessible quote/contact form UI and validation**
  - Acceptance: approved fields, labels, inline validation, clear consent/privacy language, and success/error states are implemented accessibly.
  - Verify: keyboard, screen-reader semantics, invalid inputs, and mobile layouts are checked.
  - Dependencies: Phase 0 contact architecture approval; Task 1.3.
  - Files likely touched: approximately 3–5 form/schema/component/test files.
  - Scope: Medium.

- [ ] **Task 4.2: Connect and verify real form delivery**
  - Acceptance: valid submissions reach the approved configurable destination; secrets remain server-side; spam protection and failure handling are active.
  - Verify: test submissions confirm delivery; provider/service failure is surfaced honestly and safely.
  - Dependencies: Task 4.1 and approved contact service credentials/configuration supplied securely by owner.
  - Files likely touched: approximately 2–5 server/config/test files.
  - Scope: Medium.

### Checkpoint — Customer contact
- [ ] Email destination is supplied by the owner and the mailto link is tested before activation.
- [ ] The visitor is told that the link opens their configured email app.
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
