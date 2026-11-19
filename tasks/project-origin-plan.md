# PROJECT ORIGIN — Public Gateway Implementation Plan

Source spec: `docs/project-origin/SPEC-public-gateway.md`
Capability map: `docs/project-origin/CAPABILITY-MAP.md`

## Overview
Deliver the first complete PROJECT ORIGIN slice: a polished, truthful public gateway on the existing static GitHub Pages site. This slice does not implement authentication, applications, approvals, Founder assignment, private member access, or automated email.

## Architecture decisions
- Keep the existing HTML/CSS/vanilla-JS stack and shared BZaudio site shell.
- Keep PROJECT ORIGIN membership separate from ordinary BZaudio customer accounts.
- Use static content only until a secure backend is configured and verified.
- Keep login and application actions visibly unavailable rather than presenting fake controls.
- Do not touch the existing BZaudio plan/task files; PROJECT ORIGIN uses its own task files.

## Task List

### Phase 1 — Public gateway
- [ ] Task 1: Add failing regression tests for PROJECT ORIGIN branding, page metadata, one H1, semantic landmarks, and truthful unavailable actions.
- [ ] Task 2: Update `origin.html` with PROJECT ORIGIN copy, clear membership explanation, separate customer-account clarification, contributor application explanation, and disabled-until-ready login/application states.
- [ ] Task 3: Add focused responsive styles for the gateway, preserving the monochrome design, logo aspect ratio, focus visibility, and reduced-motion behavior.
- [ ] Task 4: Run Python and Node regression suites and JavaScript syntax checks; inspect the diff for scope and security.

### Checkpoint — Gateway ready for review
- [ ] All tests pass.
- [ ] Exact PROJECT ORIGIN branding appears throughout the gateway.
- [ ] No fake login, application submission, or access-grant behavior exists.
- [ ] No backend secrets, new dependencies, or production changes are introduced.

## Risks and mitigations
| Risk | Impact | Mitigation |
|---|---|---|
| Static page could imply membership services are live | High | Explicitly mark unavailable actions and describe application as not yet open |
| Existing shared CSS could regress other pages | Medium | Append narrowly scoped `.project-origin-*` rules only |
| Existing task list could be overwritten | High | Keep all new planning artifacts under PROJECT ORIGIN-specific filenames |

## Open questions
- Member-only resources remain intentionally undecided and will be resolved during the member-portal specification.
- Authentication provider and verified email delivery remain configuration decisions for later modules.
