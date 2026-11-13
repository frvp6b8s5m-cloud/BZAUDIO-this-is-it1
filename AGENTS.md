# BZaudio Repository Instructions

## Project
Public BZaudio company website. Follow `VISION.md`, `ROADMAP.md`, `SPEC.md`, and the owner-approved `tasks/plan.md` and `tasks/todo.md`.

## Workflow
- Follow the skill workflow in https://github.com/frvp6b8s5m-cloud/agent-skills.
- Work in small, verifiable tasks and keep changes scoped to the approved task.
- Test each increment before committing; review the diff and record what changed.
- Do not deploy, change DNS, enable GitHub Pages, or alter production settings without separate owner approval.
- Do not claim a feature is complete without test and runtime evidence.

## Stack
- Static HTML, CSS, and vanilla JavaScript.
- No framework, bundler, package manager, or runtime dependencies without an approved architecture change.
- Local preview: `python3 -m http.server 8000`.
- Tests: `python3 -m unittest discover -s tests -v`, `node --check script.js`, and `node --test tests/*.test.mjs` (Node.js 22 test-only tooling).
- No build step; repository-root files are the static artifact.

## Product and brand constraints
- Architectural, cinematic, premium/editorial design; refined, purposeful animation.
- Keep the experience clear and never overwhelming.
- Respect `prefers-reduced-motion`; support keyboard, touch, and responsive layouts.
- Use genuine, properly licensed photography only and record provenance. Do not use AI-generated/synthetic-looking public brand photography.
- Until licensed assets are verified, prefer original CSS/SVG artwork.
- Never invent product specifications, pricing, stock, testimonials, compatibility, certifications, or performance claims.
- No OS, ecommerce checkout, AI chatbot, trading/barter, or unapproved platform features.
- Contact is email only, no phone number. Do not invent the email address; owner will supply it after launch.
- Product categories approved: mixing consoles; speakers and subwoofers; microphones; wireless systems; headphones; audio processors and effects; amplifiers; cables and accessories.

## Definition of done
- Acceptance criteria are met.
- Automated tests pass.
- Core behavior is verified at runtime where tooling permits.
- Accessibility, reduced-motion, and responsive behavior are considered.
- No secrets, fake controls, broken links, or unverified claims.
- Documentation and task checklist reflect the actual state.
