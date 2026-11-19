# Spec: BZaudio Origin Gateway

**Implementation status:** Gateway page and shared navigation implemented in `feature/website-foundation`; automated checks passed. Authentication and member access remain intentionally inactive.

## Objective
Create a new, intentionally minimal Origin page that extends the approved monochrome BZaudio identity. Origin is a private-area entry point, not a public product/marketing page. The page should communicate its identity through one oversized word — **ORIGIN** — and one **LOGIN** entry point. The content and experience shown after successful access are explicitly out of scope until the owner defines them.

## User and Success
- Public visitors can find Origin from the site's shared navigation.
- The Origin page feels like part of the redesigned BZaudio site: monochrome black/white, editorial typography, restrained oval geometry, and the existing official logo.
- The page contains no legacy Origin content, product descriptions, feature lists, or placeholder marketing copy.
- A clear LOGIN entry point is present.
- The experience works on desktop and mobile and respects keyboard accessibility and reduced-motion preferences.

## Tech Stack
- Existing static HTML, CSS, and vanilla JavaScript.
- No framework, bundler, package manager, or runtime dependency.
- Existing shared styles.css, script.js, and assets/bzaudio-logo.png.

## Commands
- Tests: python3 -m unittest discover -s tests -v
- JavaScript syntax: node --check script.js
- Mobile navigation tests: node --test tests/*.test.mjs
- Local preview: python3 -m http.server 8000

## Project Structure
- origin.html — new minimal Origin gateway page.
- index.html, products.html, solutions.html, about.html, contact.html — add Origin to shared navigation so the page is discoverable.
- styles.css — add narrowly scoped Origin page and login-entry styles, reusing existing brand tokens and components.
- tests/test_site.py — verify page semantics, minimal content, shared navigation, and local links.

## Design and Behavior
- Keep the shared BZaudio logo/header and the site's navigation system.
- The main page composition is only: (1) a very large ORIGIN wordmark/heading; (2) one visually clear LOGIN entry point.
- No legacy Origin copy or sections; no new explanatory paragraphs, feature cards, product content, or invented member benefits.
- Use the established black/white palette, expressive typography, and subtle oval geometry from the redesigned site. Avoid bringing back the earlier lime-accent direction.
- Keep the page visually sparse. Do not add a conventional marketing footer if it competes with the requested two-element composition.
- The login entry is a visual placeholder only for this phase. It must not collect credentials, pretend to authenticate, or imply that access control is already implemented. Its destination/interaction should be visibly and honestly marked as pending until an authentication provider and member-access flow are chosen. The member area itself remains undefined.

## Code Style
Follow the existing static-site conventions: semantic HTML landmarks, one clear h1, descriptive accessible names, shared CSS tokens, page-scoped classes, no inline scripts, no unnecessary dependencies, and responsive mobile-first adjustments where appropriate.

Example page structure:
    <main id="main" class="origin-page">
      <section class="origin-gateway" aria-labelledby="origin-title">
        <h1 id="origin-title">ORIGIN</h1>
        <!-- Clearly identified login entry point; no credential handling yet. -->
      </section>
    </main>

## Testing Strategy
- Extend static-site tests to include origin.html in the page inventory.
- Verify exactly one h1, shared navigation links, official logo usage, required local assets, and valid local links.
- Verify that Origin's main content includes ORIGIN and LOGIN but excludes legacy Origin sections/copy.
- Run the full Python test suite, JavaScript syntax check, and mobile-navigation tests.
- Review desktop and narrow/mobile layouts, keyboard focus, and reduced-motion behavior in a browser preview where tooling permits.

## Boundaries
### Always do
- Preserve the approved BZaudio redesign and official logo.
- Keep Origin intentionally minimal and honest about the login placeholder.
- Keep the public site navigation consistent across pages.
- Test the new page and all affected links.

### Ask first
- Choosing an authentication provider or implementing real sign-in/session handling.
- Defining member roles, access permissions, or the content behind login.
- Adding a database, backend, or new dependencies.
- Changing production deployment or DNS.

### Never do
- Reintroduce old Origin copy or invent content for members.
- Collect or store real credentials in this static page.
- Claim the login is secure or functional before authentication is implemented and tested.
- Deploy to production or change production settings without separate approval.

## Success Criteria
- [x] origin.html exists and follows the new BZaudio visual identity.
- [x] The page's only primary content is the large ORIGIN heading and a clearly identified LOGIN entry point.
- [x] Origin is present in the navigation on all six pages.
- [x] No legacy Origin content remains on the new page.
- [x] The login placeholder does not collect credentials or claim to authenticate.
- [ ] Automated checks pass and responsive/accessibility review is completed.

## Open Questions
- Authentication provider and the real login destination are intentionally undecided. Until the owner defines them, LOGIN remains a non-authenticating placeholder entry point.
- The post-login member experience is intentionally undefined and must be designed with the owner later.