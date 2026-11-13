# ADR-0001: Static-first website architecture

- **Status:** Accepted
- **Date:** 2026-11-13
- **Decision owners:** BZaudio project owner

## Context

The repository initially contained strategy and planning documents only. The approved first release is a public-facing professional-audio company website hosted on GitHub Pages. Its first release needs a brand experience, verified product discovery, solutions content, and email-only contact that will be activated after launch when the owner supplies the address.

There is no need for accounts, server-side data, checkout, private user records, or a complex content workflow in this release. Product content can initially be managed through GitHub commits.

## Decision

Use semantic HTML, CSS, and small vanilla JavaScript directly in the repository root. Do not add a frontend framework, bundler, package manager, or runtime dependency for the initial release.

- Local preview: `python3 -m http.server 8000`
- Tests: `python3 -m unittest discover -s tests -v`
- Build: no build step; static files are the deployable artifact.
- Static-content tests use Python's standard library. Small JavaScript interaction tests use Node.js 22's built-in `node:test` runner; no test package is installed.
- GitHub Pages is the selected host, but Pages activation and production deployment remain separately approval-gated.

## Consequences

### Positive
- Minimal moving parts and no runtime dependency supply chain.
- Direct compatibility with static hosting.
- Fast initial load and straightforward long-term maintenance.
- Content changes are reviewable as ordinary Git commits.
- The site can progressively add product/solution pages without requiring a platform rewrite.

### Trade-offs
- No server-side form handling, private storage, authentication, or admin interface.
- Email and quote requests will open the visitor's configured email app through a mailto link once the owner supplies the destination.
- Rich future application features may require a separate platform and a new architecture decision.

## Revisit when
A concrete requirement needs server-side behavior, a CMS, authenticated content editing, customer accounts, or dynamic integrations. Evaluate the smallest service that satisfies that requirement and obtain owner approval before adding it.
