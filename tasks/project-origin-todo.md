# PROJECT ORIGIN — Task List

## Phase 1 — Public gateway
- [ ] **Task 1: Add PROJECT ORIGIN gateway regression tests**
  - Acceptance: tests require exact PROJECT ORIGIN title/branding, a single H1, semantic landmarks, and honest unavailable login/application states.
  - Verify: run focused Python unittest and observe the new test fail before implementation.
  - Dependencies: None.
  - Files: `tests/test_site.py`.
  - Scope: Small.

- [ ] **Task 2: Implement the public gateway content**
  - Acceptance: visitors understand PROJECT ORIGIN's purpose, the separation from customer accounts, and that applying does not automatically grant membership; unavailable actions are not interactive.
  - Verify: focused gateway tests pass.
  - Dependencies: Task 1.
  - Files: `origin.html`.
  - Scope: Small.

- [ ] **Task 3: Style the gateway responsively**
  - Acceptance: layout works at narrow and wide widths, preserves the existing monochrome identity, and supports keyboard focus and reduced motion.
  - Verify: static regression checks pass; review the scoped CSS diff.
  - Dependencies: Task 2.
  - Files: `styles.css`.
  - Scope: Small.

- [ ] **Task 4: Run integrated verification and review**
  - Acceptance: all repository Python and Node tests pass; JavaScript parses; no unrelated files are changed.
  - Verify: `python3 -m unittest discover -s tests -v`, `node --check script.js`, `node --test tests/*.test.mjs`.
  - Dependencies: Tasks 1–3.
  - Files: none expected.
  - Scope: Small.

## Checkpoint — Owner review
- [ ] Gateway is ready for PR review.
- [ ] No production deployment or backend activation occurred.
