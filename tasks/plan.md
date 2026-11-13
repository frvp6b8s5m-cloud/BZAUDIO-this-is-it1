# BZaudio Website — Technical Implementation Plan

## Status
**For owner review and approval. No implementation is authorized by this document.**

This plan follows the approved BZaudio vision, staged roadmap, and website specification. The owner approved the first-release capability map and order:
1. Brand experience
2. Product discovery
3. Solutions
4. Customer contact

The architectural, cinematic design direction and rich, purposeful animations are retained as first-class requirements. The experience must remain clear and never overwhelming.

## Repository findings

Inspection of the default branch (`main`) found:
- Repository is public and currently contains `README.md`, `VISION.md`, `ROADMAP.md`, and `SPEC.md`.
- No application source, `package.json`, lockfile, `index.html`, `AGENTS.md`, `tasks/` directory, or `.github/workflows/` directory was present at planning time.
- The repository currently has only the `main` branch.
- The repository therefore does not establish an existing application framework, build command, test runner, deployment workflow, or form-processing service.

These findings mean the implementation stack and deployment integration must be deliberately selected and documented before code is written. Do not assume that a prior deployment or workflow in another repository applies here.

## Approved capability map and build order

| ID | Capability | Responsibility | Dependencies |
|---|---|---|---|
| C1 | Brand experience | Visual identity, global navigation, home page, responsive layout, motion language, accessibility foundations | Repository/platform foundation |
| C2 | Product discovery | Product categories, verified product content, product detail presentation, discovery/navigation patterns | C1 design system and content model |
| C3 | Solutions | Customer/application pathways and solution content, with only verified claims | C1 design system; may link to C2 |
| C4 | Customer contact | Quote request and contact journeys, validation, submission feedback, privacy-conscious handling | C1 global shell; contact-processing architecture decision |

Build order: foundation → C1 → C2 → C3 → C4 → integrated quality review. C2 and C3 may share content conventions, but keep their acceptance tests and deliverables separate. Do not introduce future BZaudio Technology, Experience Lab, or BZaudio Care applications into this initial website scope.

## Objectives and non-goals

### Objectives
- Deliver a distinctive, premium, architectural and cinematic BZaudio public website.
- Make the company's purpose and customer pathways immediately understandable.
- Help visitors discover verified products and relevant solutions.
- Make quote/contact requests straightforward, accessible, and reliable.
- Provide polished micro-interactions and cinematic transitions without sacrificing performance, readability, or control.
- Establish maintainable content and design foundations for later growth.

### Non-goals for this release
- No BZaudio operating system or OS-like product.
- No independent BZaudio Technology platform implementation.
- No Experience Lab, System DNA, customer account portal, or lifecycle-care product implementation.
- No ecommerce checkout, payment, inventory, or unverified product pricing.
- No AI chatbot or fabricated recommendation/engineering capability.
- No PA design calculations or safety-critical engineering output.
- No trading/barter features.
- No universal equipment compatibility claims.

## Architecture decisions

### D1 — Selected stack: static HTML, CSS, and vanilla JavaScript
The repository is documentation-only and the first release is a public marketing/catalog website on GitHub Pages. Use semantic HTML, CSS, and small vanilla JavaScript modules directly in the repository root. Do not introduce a frontend framework, package manager, bundler, or runtime dependencies unless a later approved requirement demonstrates a concrete need. This keeps the published artifact simple, fast, inspectable, and compatible with GitHub Pages.

- **Local preview:** `python3 -m http.server 8000` (Python standard library).
- **Automated tests:** `python3 -m unittest discover -s tests -v` (Python standard library).
- **Build:** no build step; the checked-in static files are the deployable artifact.
- **Source layout:** `index.html`, `styles.css`, `script.js`, `tests/`, `docs/decisions/`, and `.github/workflows/` for quality checks only.
- **Dependencies:** none for the site runtime or tests. External font loading is progressive enhancement with system fallbacks; content remains readable if the font host is unavailable.

### D2 — Hosting: GitHub Pages selected
GitHub Pages is the approved target. The repository root is the intended static source. Deployment configuration and production activation remain separate, explicitly approval-gated work; this implementation branch will not enable Pages, change repository settings, alter DNS, or publish the site. GitHub documents publishing static files from a branch root and also supports a custom Actions workflow when needed: https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site.

### D3 — Email-only contact, activated after launch
The owner chose email only: no phone number. The actual email address will be supplied after the website is up and running. Build the contact section and quote-request pathway so the destination is configurable, but do not invent an address or publish a broken/fake submission form. The initial implementation may include the contact layout and a clearly inactive/configurable email action; activate the email link and quote-request email draft only after the owner supplies the address. Keep this static-hosting-friendly (for example, a configured mailto link) unless the owner later requests a real server-side form. Explain that mailto opens the visitor's configured email app. No third-party form service or backend is in scope by default.

### D4 — Content is data-driven and evidence-based

### D2 — Hosting choice confirmed: GitHub Pages
The owner selected GitHub Pages as the intended host. Confirm whether a custom domain is desired and verify the repository's Pages configuration and deployment constraints during implementation planning. No DNS, production settings, or deployment changes are authorized by this plan.

### D3 — Email-only contact, activated after launch
The owner chose email only: no phone number. The actual email address will be supplied after the website is up and running. Build the contact section and quote-request pathway so the destination is configurable, but do not invent an address or publish a broken/fake submission form. The initial implementation may include the contact layout and a clearly inactive/configurable email action; activate the email link and quote-request email draft only after the owner supplies the address. Keep this static-hosting-friendly (for example, a configured mailto link) unless the owner later requests a real server-side form. Explain that mailto opens the visitor's configured email app. No third-party form service or backend is in scope by default.

### D5 — Content is data-driven and evidence-based
Keep product and solution content separate from presentation. Publish only verified model names, specifications, media rights, availability, and compatibility statements. Unknown fields are omitted or labeled unavailable, never invented. Start with a small verified catalog rather than a large empty taxonomy.

### D6 — Design system and motion are shared foundations
Create a small set of reusable design tokens and interaction primitives before building page-specific effects. The visual system should use:
- Architectural geometry, strong composition, editorial typography, and generous negative space.
- Cinematic art direction, authentic equipment/environment photography, and deliberate image crops.
- A coherent library of small animations: navigation feedback, focus/hover states, image treatments, section reveals, and page transitions where appropriate.
- Consistent easing, duration, and stagger rules; no random one-off motion.
- Reduced-motion alternatives, keyboard operability, touch-friendly controls, and no scroll hijacking.
- Quiet, task-focused layouts for product details and forms; not every page needs a cinematic effect.

Use only genuine, properly licensed photography for public brand imagery. Record source and license/provenance. Do not use AI-generated or synthetic-looking brand photography.

### D7 — Keep the first release intentionally small
Prioritize a short navigation, a clear primary call to action, concise pages, progressive disclosure, and one main purpose per screen. Do not add dashboard-like layouts, excessive card grids, redundant quizzes, decorative widgets, or features without a verified customer benefit.

## Implementation phases and task index

The detailed checklist and checkpoints are in `tasks/todo.md`. The sequence below describes the intended vertical slices.

### Phase 0 — Resolve implementation prerequisites
- Use GitHub Pages; confirm whether a custom domain is wanted and establish a preview/rollback strategy.
- Use the approved static HTML/CSS/vanilla-JS stack with Python standard-library tests; no package manager or build step.
- Build an email-only contact/quote pathway with a configurable destination; keep it inactive until the owner supplies the address after launch.
- Use the approved initial product category taxonomy; add individual products only when source specifications and media are verified.
- Use GitHub commits for content updates initially; no admin panel/CMS for the first release.
- Record architecture decisions and exact commands; no dependencies are required.

**Gate:** No unresolved platform/security decision that would force a rewrite or a fake contact workflow.

### Phase 1 — Foundation and C1 Brand experience
- Establish the minimal app structure, build pipeline, and quality checks.
- Implement design tokens, typography, layout grid, global navigation/footer, responsive behavior, and motion/accessibility primitives.
- Build the home page and concise company introduction.
- Verify the architectural-cinematic identity on mobile and desktop.

**Gate:** The site communicates BZaudio clearly, feels distinctive, and remains fast, accessible, and easy to navigate.

### Phase 2 — C2 Product discovery
- Define the smallest maintainable product content schema.
- Add only available, verified product categories and product entries.
- Implement category/product discovery and product details using shared components.
- Test empty, missing, and unavailable product data states.

**Gate:** Every published fact has a source; visitors can browse without invented data or dead controls.

### Phase 3 — C3 Solutions
- Define a small set of approved customer/application pathways.
- Publish concise solution pages with verified claims and useful links to relevant products or quote requests.
- Make limitations and the distinction between educational guidance and engineered designs clear.

**Gate:** Visitors can identify a relevant pathway without being presented with unvalidated system designs.

### Phase 4 — C4 Customer contact
- Build the email-only contact section and quote-request pathway with a configurable destination; do not include a phone number.
- Do not invent or publish an email address. Keep the email action inactive until the owner supplies the address after launch.
- Once supplied, activate a clearly labeled email link and quote-request email draft (mailto) with a useful subject/body template.
- Test the configured link and explain that it opens the visitor's email application; do not represent it as an on-site submission form.

**Gate:** The contact destination is owner-supplied and verified before the email action is activated; no fake form or phone contact appears.

### Phase 5 — Integrated quality and release readiness
- Complete responsive, keyboard, screen-reader/semantic, contrast, and reduced-motion checks.
- Verify links, navigation, form behavior, and content accuracy.
- Run production build and automated checks; perform browser smoke tests at representative mobile and desktop sizes.
- Measure and optimize image loading, animation cost, and Core Web Vitals.
- Review licensed asset provenance, SEO metadata, and deployment behavior.
- Prepare a release report; deployment remains separately approval-gated.

**Gate:** All acceptance criteria pass with recorded evidence and the owner approves release.

## Cross-cutting acceptance criteria

- The architecture/cinematic visual identity is unmistakable and consistent.
- Motion is polished and noticeable, but never overwhelms content or blocks tasks.
- Reduced-motion preferences are respected and all interactive features work by keyboard and touch.
- The site is responsive, readable, and accessible, targeting WCAG 2.1 AA.
- The navigation and page hierarchy are short and understandable; advanced details are progressively disclosed.
- Product and solution claims are verified and sourceable.
- All public photography is genuine and properly licensed with provenance recorded.
- Email-only contact and quote-request links use the owner-supplied address; until then, the contact action remains inactive and is not represented as a working submission form.
- No fake buttons, forms, product details, testimonials, compatibility claims, or unbuilt platform capabilities.
- Performance is measured on representative devices; no animation or imagery is allowed to make core journeys unusable.

## Risks and mitigations

| Risk | Impact | Mitigation |
|---|---|---|
| Unknown host/framework in a documentation-only repository | High | Resolve host and stack before implementation; keep architecture static-first and minimal |
| Email address is not available at launch | Low | Build the contact structure with a configurable destination; activate email/quote links only after the owner supplies and verifies the address |
| Product data or photography is incomplete | Medium | Launch a smaller verified catalog; track media rights and omit unknown data |
| Cinematic motion harms performance or accessibility | High | Shared motion system, reduced-motion path, device testing, performance budgets |
| Scope expands to future platform capabilities | High | Enforce the approved four-capability first-release map and explicit change approval |
| Marketing language implies engineered outcomes | High | Editorial review and clear boundaries between education, estimates, and qualified engineering |

## Confirmed owner decisions and architecture

- **Hosting:** GitHub Pages selected. Custom-domain preference remains to be confirmed.
- **Contact:** email only; no phone number. The owner will supply the actual email address after the site is running. Build the configurable contact structure now; activate the email/quote-request links later.
- **Product categories approved:** mixing consoles; speakers and subwoofers; microphones; wireless systems; headphones; audio processors and effects; amplifiers; cables and accessories. Individual products and specifications must still be verified before publication.
- **Content administration:** GitHub commits are acceptable initially; no admin panel/CMS in the first release.
- **Media:** source genuine, properly licensed photography and record provenance; the actual assets and licenses still need to be selected/verified.
- **Technical architecture:** static HTML/CSS/vanilla JavaScript, no frontend dependencies, Python standard-library tests, and no build step. GitHub Pages deployment configuration remains deferred until separate release approval.

No third-party form service, phone contact, fabricated email address, custom-domain change, or production deployment is authorized.

## Approval boundary
This is a planning artifact only. Do not create application source code, install packages, configure production hosting, change DNS, submit live forms, or deploy until the owner reviews and explicitly approves this technical plan and its open decisions.
