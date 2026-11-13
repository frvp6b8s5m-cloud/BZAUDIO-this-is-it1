# BZaudio Company Website — Product Specification

## Status
**Strategic direction approved; technical specification awaiting owner review.** This document defines the public website scope and its relationship to the broader BZaudio vision. It is not authorization to begin implementation. A technical plan must be reviewed and approved before implementation starts.

## Objective
Create a premium, memorable, trustworthy public website for BZaudio, a professional-audio company helping people discover equipment, understand solutions, and request expert help.

Brand belief: **MUSIC BRINGS LIFE. MUSIC IS EVERYTHING.**

The website is the public company and customer-entry experience. It is not the independent BZaudio Technology platform, and it must not contain or be presented as a BZaudio operating system.

## Strategic context
The wider BZaudio company vision is documented in `VISION.md`; the staged company roadmap is documented in `ROADMAP.md`.

The company intends to grow through four strategic capability areas:
- **BZaudio Systems:** equipment, product expertise, and professional audio solutions.
- **BZaudio Technology:** an independent software platform for documenting and managing audio systems; not an OS.
- **BZaudio Experience:** demonstrations and education.
- **BZaudio Care:** ongoing support, maintenance, documentation, and upgrades.

These are long-term strategic areas, not a requirement to launch every capability on the initial website.

## Assumptions and constraints
1. This repository contains the public-facing BZaudio company website.
2. Visual direction is architectural and cinematic—not arctic—with strong composition, editorial typography, genuine product photography, disciplined grids, and generous negative space.
3. Initial palette may use graphite/charcoal, warm white, concrete neutrals, and restrained accent color; finalize during design planning.
4. Initial business conversion paths are quote requests and contact. Do not assume ecommerce checkout, prices, stock, or fulfillment capabilities.
5. Contact destination remains configurable; do not invent an email address.
6. Use genuine, properly licensed photography and document asset sources and usage rights. No AI-generated or synthetic-looking public brand photography.
7. Keep trading/barter functionality out of the public experience.
8. No BZaudio OS, desktop OS, dedicated-device OS, or touchscreen OS controller as a website feature.
9. Do not claim universal Allen & Heath compatibility. Compatibility must be verified model by model.
10. Do not add backend services, databases, authentication, paid services, or dependencies without an approved technical rationale.

## Experience and simplicity requirements

The experience must feel powerful without being overwhelming.

- Visitors should understand what BZaudio does and the main next step within moments.
- Keep primary navigation short and organized around customer needs.
- Show essential information first; reveal advanced detail progressively.
- Give each screen or section one clear primary purpose.
- Avoid crowded dashboards, excessive cards, competing calls to action, redundant quizzes, and feature overload.
- Use plain language, with optional technical depth for professional users.
- Keep navigation, labels, controls, and interaction patterns consistent.
- Use cinematic moments selectively; practical pages should be calm and efficient.
- Make mobile layouts as clear and usable as desktop layouts.
- Provide visible paths to request a quote, ask a question, or get support.
- Do not add a feature unless its customer benefit, content requirements, and maintenance cost are understood.

## Initial information architecture

- **Home:** clear company proposition, concise introduction, key pathways, and one primary call to action.
- **Products:** verified product categories and product details.
- **Solutions:** relevant applications and system approaches, without implying unvalidated engineering.
- **About:** company purpose, trust standards, and brand belief.
- **Contact / Request a Quote:** accessible, validated inquiry form with clear success and error states and configurable destination.
- **Resources:** include only if there is a useful, verified initial body of material; otherwise defer.

The website may introduce the broader BZaudio ecosystem, but should not present future or unbuilt capabilities as currently available.

## Visual and motion direction
- Architectural, premium, editorial, cinematic, and human.
- Strong typography, asymmetric composition where useful, intentional image crops, and generous negative space.
- Genuine equipment and real-world environment photography with documented rights.
- Purposeful micro-interactions and transitions with a coherent motion language.
- Animations must not delay navigation, obscure content, or create motion fatigue.
- Respect `prefers-reduced-motion`; provide keyboard-visible focus states and touch-friendly interactions.
- Avoid generic SaaS layouts, gradient blobs, chatbot aesthetics, fake dashboards, excessive glassmorphism, and repetitive template card grids.

## Functional requirements
- Responsive, accessible navigation and mobile menu.
- Product and category discovery based only on available, verified catalog data.
- Quote/contact forms with client- and server-side validation appropriate to the selected architecture.
- Clear submission, error, and spam-protection behavior.
- Configurable contact details.
- SEO and social metadata, semantic headings, descriptive alt text, and deployment-appropriate sitemap/robots configuration.
- Privacy-conscious analytics or error reporting only when deliberately configured.
- No dead buttons, fake forms, placeholder production links, fabricated reviews, or invented product data.

## Technical approach
- Inspect the repository, current deployment, workflows, and hosting before choosing or changing the stack.
- Preserve established project conventions where possible.
- Keep product data, content, configuration, design tokens, and UI components clearly separated.
- Prefer the smallest maintainable solution that meets approved requirements.
- Confirm hosting constraints before selecting forms, authentication, storage, or administrative capabilities.
- Static hosting alone does not provide secure server-side form processing, authentication, or private data storage.
- Do not select architecture or dependencies until the technical plan documents trade-offs and risks.

## Commands and project structure
To be finalized in the technical plan after repository and deployment inspection. Do not invent commands or project structure before confirming the actual stack.

## Code and quality standards
- Use semantic HTML and accessible controls.
- Use TypeScript where supported by the confirmed stack.
- Keep components small and cohesive; avoid speculative abstractions.
- Validate user-controlled data at system boundaries.
- Keep secrets and privileged keys out of client code.
- Target WCAG 2.1 AA and support reduced motion.
- Optimize image delivery, loading, and animation for real mobile performance.

## Testing strategy
The technical plan must identify actual test and build commands after stack inspection. Expected verification includes:
- Unit tests for validation and business logic where applicable.
- Component/integration tests for navigation and forms.
- Browser checks for core quote/contact journeys at mobile and desktop sizes.
- Keyboard, focus, contrast, labels, and reduced-motion checks.
- Production build and deployment verification.
- Performance checks based on measured results, not assumptions.

## Boundaries

### Always
- Follow the agent-skill repository workflow and approval gates.
- Keep changes small, reviewable, and verifiable.
- Verify behavior; do not claim completion based on appearance alone.
- Use licensed genuine photography and record provenance.
- Keep product and compatibility claims accurate and qualified.
- Make simplicity, accessibility, privacy, and performance acceptance criteria.

### Ask first
- New paid services, hosting changes, databases, authentication providers, or dependencies.
- Domain/DNS changes, production deployment, or destructive repository changes.
- Changes to existing admin/security behavior.
- Publishing specifications, prices, availability, certifications, or compatibility claims without evidence.
- Adding major interactive tools or expanding the initial website scope.

### Never
- Start implementation before the technical plan is reviewed and approved.
- Present the website as an operating system or imply the independent platform is an OS.
- Use AI-generated imagery for public brand photography.
- Add trading/barter functionality.
- Expose secrets or privileged keys in client code.
- Fake authentication, form submissions, inventory, reviews, certifications, or product capabilities.
- Claim universal Allen & Heath compatibility.

## Success criteria
1. The BZaudio proposition and brand belief are immediately understandable.
2. Visitors can find products/solutions and submit a quote or contact request without confusion.
3. The experience is visually distinctive but calm, clear, and not overwhelming.
4. All published product and company claims are supported by verified information.
5. All public photography has documented usage rights.
6. Core journeys work on mobile and desktop and meet the agreed accessibility standard.
7. Navigation, links, controls, and forms work with no duplicate quizzes or dead controls.
8. Performance and deployment are verified against the actual hosting environment.
9. Future BZaudio Technology, Experience, and Care capabilities are described honestly and not represented as already built.

## Open questions for technical planning
- Confirm the current production hosting target and constraints.
- Confirm which verified product/catalog data and licensed media are available for the first release.
- Confirm whether an authenticated admin/content workflow is actually required for the initial website.
- Determine the simplest secure form-processing approach compatible with the hosting environment.
- Define the initial product categories and exact quote form fields during technical planning.
