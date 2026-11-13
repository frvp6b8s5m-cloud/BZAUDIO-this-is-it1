# BZaudio Company Website — Product Specification

## Status
Draft for owner approval. Specification only; implementation must not begin until approved.

## Objective
Create a premium, memorable BZaudio company website presenting a serious professional-audio company. The experience should feel architectural, cinematic, composed, tactile, confident, and unmistakably human.

Brand belief: MUSIC BRINGS LIFE. MUSIC IS EVERYTHING.
The site helps customers discover professional audio equipment and solutions, understand the BZaudio ecosystem, and submit quote/contact requests. It must not resemble a generic AI-generated website, SaaS landing page, or off-the-shelf ecommerce template.

## Assumptions to Validate
1. This is the public-facing BZaudio company website in frvp6b8s5m-cloud/BZAUDIO-this-is-it1.
2. The visual direction is architectural and cinematic—not arctic: monumental forms, strong grid systems, editorial typography, sculptural product presentation, dramatic real photography, and restrained motion.
3. Initial palette: graphite/charcoal, warm white, concrete neutrals, and restrained electric-blue accents.
4. The company presents professional audio equipment and solutions, including mixing consoles, speakers, and related live-sound equipment.
5. Quote requests and contact are the initial conversion paths; do not invent checkout, prices, inventory, or product claims.
6. Use properly licensed real photography. Do not use AI-generated imagery or synthetic-looking AI visuals. Document asset licenses and sources.
7. Keep trading/barter out of the public experience.
8. Do not include a BZaudio OS system, dedicated-device operating system, desktop OS platform, or touchscreen OS controller as part of this company website.
9. If /admin is included, it must use genuine authentication and protected management storage—not a decorative or client-only password gate.
10. The site must work on mobile and desktop; no duplicate quizzes or overlapping tools.

## User Experience and Information Architecture
- Home: cinematic brand introduction, clear value proposition, product/solution pathways, quote/contact calls to action.
- Products: professional audio categories and product details; specifications and availability must be sourced and verified.
- Solutions: live-sound and system-use cases, with useful supporting imagery.
- Signature BZaudio experience: a distinctive, interactive sound-and-light installation (working title: The Sound Wall) that gives visitors a memorable way to explore audio. It should respond to user interaction and, where technically feasible, optional microphone input with explicit permission. No audio is recorded or uploaded; default experience works without microphone access.
- About: company purpose, standards, and the belief that music brings life.
- Contact / Request a Quote: validated forms, clear success/error states, configurable contact destination; no invented email address.
- The Sound Wall is the proposed signature differentiator, subject to owner approval and a technical feasibility check. Include a graceful non-audio fallback and accessible controls.
- Interactive tools only when explicitly approved and supported by verified data/calculations. Avoid redundant quizzes.

## Visual and Motion Direction
- Architectural composition: asymmetry, strong alignment, generous negative space, deep layered sections, large-scale imagery, disciplined grids.
- Cinematic presentation: intentional image crops, art direction, restrained parallax/reveal transitions, polished page transitions where useful.
- Expressive editorial display typography paired with highly legible interface/body typography.
- Real equipment photography with consistent lighting, detail crops, and contextual environments.
- Motion must be purposeful, performant, reduced-motion aware, and never block navigation or content. Include a rich library of small, polished interactions across navigation, buttons, product reveals, section transitions, image treatments, hover/focus states, and page feedback. Motion quality should feel cohesive and intentional—not a pile of distracting effects.
- Build a distinctive motion language: consistent easing, timing, stagger, depth, and transitions; use scroll-triggered reveals sparingly and provide reduced-motion alternatives. Keep interactions fast on mobile and avoid scroll hijacking.
- Avoid generic gradient blobs, chatbot visuals, fake dashboards, excessive glassmorphism, and template-like card grids.

## Functional Requirements
- Responsive navigation and accessible mobile menu.
- Product/category browsing; filters only when supported by actual catalog data.
- Quote/contact submission with client/server validation and appropriate spam protection.
- Configurable contact details; no fabricated addresses.
- SEO/social metadata, semantic headings, descriptive image alt text, and deployment-appropriate sitemap/robots configuration.
- Privacy-conscious analytics/error reporting only when configured; no hardcoded secrets.
- If admin is in scope: server-side authentication/authorization, protected persistence, secure sessions, and no privileged keys in public code.

## Technical Approach
- Inspect repository, deployment, workflows, and infrastructure before selecting or changing the stack.
- Preserve existing conventions where present. Initial inspection found a minimal README and no AGENTS.md, package.json, or index.html; confirm repository state before implementation.
- Prefer a maintainable accessible component system and minimal dependencies.
- Separate content/product data, contact configuration, design tokens, and UI components.
- Do not add a backend, database, auth provider, paid service, or dependency without establishing need and documenting the decision.
- Match deployment to actual hosting; static GitHub Pages cannot provide server-side admin or form processing by itself.

## Commands
Finalize after stack inspection. Required commands: lockfile-respecting install, development server, production build, tests, lint/type checks where supported, and browser smoke/accessibility checks.

## Project Structure
Finalize after stack inspection. Maintain clear boundaries for routes/pages, reusable components, design tokens/styles, product/content data, form/API or server actions, tests/browser checks, documentation, and asset-license records.

## Code Style
- TypeScript where supported by the selected framework.
- Small cohesive components, semantic HTML, explicit types at boundaries.
- Design tokens for color, spacing, typography, and motion.
- Avoid speculative abstractions and oversized components.
- Validate all external and user-controlled data at boundaries.
- No secrets, fake product facts, dead buttons, or placeholder links in production.

## Testing Strategy
- Unit tests for validation, data transformations, and business logic.
- Component/integration tests for navigation, forms, and interactive states.
- Browser smoke tests for critical paths at mobile and desktop viewports.
- Accessibility checks for keyboard use, focus, contrast, labels, and reduced motion.
- Production build and deployment verification.
- Measure Core Web Vitals; optimize images and motion based on evidence.

## Boundaries
### Always
- Follow agent-skills lifecycle: spec → plan → small tasks → incremental implementation → tests → review → ship.
- Keep changes small and verifiable; commit atomically.
- Verify behavior; never claim completion from appearance alone.
- Use real licensed assets and document provenance.
- Target WCAG 2.1 AA and respect reduced-motion preferences.
- Keep product and compatibility claims accurate.
### Ask first
- New paid services, hosting changes, databases, authentication providers, or dependencies.
- Domain/DNS changes, production deployment, destructive repository changes, or changes to existing admin/security behavior.
- Publishing unverified specifications, prices, availability, or compatibility claims.
- Adding or removing major interactive tools.
### Never
- Use AI-generated imagery for public brand photography.
- Add trading/barter functionality.
- Expose secrets or privileged keys in client code.
- Fake authentication, form submissions, inventory, reviews, certifications, or product capabilities.
- Claim universal Allen & Heath compatibility; verify compatibility model by model.
- Declare launch-ready without test/build/runtime evidence.

## Success Criteria
1. A distinctive architectural-cinematic identity across all pages.
2. The company story and MUSIC BRINGS LIFE. MUSIC IS EVERYTHING. belief are clear.
3. Visitors can discover product categories and submit quote/contact requests on mobile and desktop.
4. All navigation, links, controls, and forms work; no duplicate quizzes or dead controls.
5. All photography has documented usage rights; no AI-generated imagery.
6. Product, company, and ecosystem claims are accurate and qualified.
7. Accessibility, responsive behavior, production build, and critical browser flows pass documented checks.
8. Deployment and any admin/backend capabilities match the actual hosting architecture and security requirements.
9. The signature sound experience is memorable, responsive, accessible, and usable without microphone permission.
10. Micro-interactions feel consistent and refined, with reduced-motion support and no usability/performance regressions.

## Open Questions
- Confirm whether the proposed Sound Wall signature experience is the right differentiator, or whether the owner prefers a different signature feature.
- Confirm whether the guided PA Designer belongs in the initial release or should be deferred.
- Confirm whether /admin and its authenticated content-management workflow are part of this repository's initial release.
- Confirm the production hosting target if it differs from the existing BZaudio deployment.