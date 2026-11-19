# Spec: PROJECT ORIGIN Public Gateway

## Objective
Replace the current minimal ORIGIN placeholder with a clear, polished public gateway branded exactly **PROJECT ORIGIN**. Explain that PROJECT ORIGIN is the exclusive BZaudio contributor and Founder community, and provide truthful paths toward member login and contributor information without implying that inactive backend functionality is live.

### User stories and acceptance criteria
- A visitor immediately sees the exact name PROJECT ORIGIN.
- The existing black-and-white design direction and original BZaudio logo remain intact.
- The page explains that ordinary BZaudio customer accounts and PROJECT ORIGIN membership are separate.
- The page distinguishes applying to contribute from being an approved member.
- Login and application actions must not pretend to work until their respective backend modules are implemented and released.
- Navigation, keyboard access, focus visibility, reduced-motion preferences, and mobile layout remain usable.
- Page metadata, semantic landmarks, and a single primary heading are correct.

## Tech Stack
Static HTML, CSS, and vanilla JavaScript on the existing GitHub Pages site. No new runtime dependency, build system, or paid service.

## Commands
- Local preview: `python3 -m http.server 8000`
- Website tests: `python3 -m unittest discover -s tests -v`
- JavaScript syntax: `node --check script.js`
- Node tests: `node --test tests/*.test.mjs`
- Build: no build step; checked-in static files are the deployable artifact.

## Project Structure
- `origin.html` — PROJECT ORIGIN public gateway
- `styles.css` — shared visual system and page-specific styles
- `script.js` — shared navigation and interaction behavior
- `tests/test_site.py` — static page and accessibility regression checks
- `docs/project-origin/CAPABILITY-MAP.md` — approved module boundaries and order
- `docs/project-origin/SPEC-public-gateway.md` — this module's requirements

## Code Style
Use semantic HTML, existing CSS conventions, and small vanilla JavaScript enhancements. Preserve the existing logo asset and render it without cropping.

Example:
```html
<h1 id="project-origin-title">PROJECT ORIGIN</h1>
```

## Testing Strategy
- Extend Python standard-library HTML regression tests for exact branding, metadata, one primary heading, internal links, and semantic landmarks.
- Run all existing Python and Node tests.
- Run JavaScript syntax validation.
- Manually inspect the gateway at narrow mobile and desktop widths, including keyboard focus and reduced-motion behavior, before release.
- Verify the final page does not falsely report login, application submission, or membership success.

## Boundaries

### Always do
- Use the exact brand name PROJECT ORIGIN.
- Preserve the original BZaudio logo and its aspect ratio.
- Keep account, application, approval, Founder, and member access states clearly distinguished.
- Be honest about inactive functionality and test every interactive control.

### Ask first
- Live Supabase schema migrations or authentication configuration.
- Production release or deployment of new membership functionality.
- Paid infrastructure, email providers, or recurring services.
- Changes to Founder contribution-to-number rules.

### Never do
- Put service-role keys or privileged credentials in frontend code.
- Automatically assign Founder numbers.
- Grant membership based only on a user-editable profile field.
- Claim email delivery, application receipt, or authentication success without confirmation.
- Treat a mailto link as an automatic submission service.

## Success Criteria
- All visible references on the gateway use PROJECT ORIGIN, not ORIGIN PROJECT.
- The page clearly describes the gateway without implying inactive functionality is live.
- Existing site tests pass and new branding regression tests pass.
- No existing BZaudio page or logo asset is unintentionally changed.
- The change remains isolated on a feature branch until reviewed.

## Open Questions
- Which exact exclusive resources and content should approved members receive? This can be decided while specifying the member-portal module.
- Which OAuth provider will the owner configure for public sign-in? Current readiness assessment identifies Google OAuth as a $0 recurring-cost-compatible candidate, but credentials and redirect configuration are still required.
