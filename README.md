# BZaudio

The public BZaudio website: a premium, architectural and cinematic introduction to the company, its approach to professional audio, and the standards behind its recommendations.

## Online preview

[Open the current BZaudio preview](https://bzaudio-site-psko9iumd-frvp6b8s5m-cloud.vercel.app/). This is a review snapshot of `feature/website-foundation`, not the production site; later branch changes require a fresh preview deployment.

## Local preview

Requires Python 3 (standard library only):

```bash
python3 -m http.server 8000
```

Open http://localhost:8000.

## Verification

```bash
python3 -m unittest discover -s tests -v
node --check script.js
node --test tests/*.test.mjs
```

This is a static-first site with no frontend framework or runtime package dependencies.

## Public pages

- `index.html` — cinematic brand introduction and company principles
- `products.html` — the eight approved product categories; individual models and specifications are added only after verification
- `solutions.html` — pathways for live production, worship, education, studios, venues, and audio professionals
- `about.html` — company purpose and trust standards
- `contact.html` — email-only contact page with a direct quote/inquiry email link
- `origin.html` — minimal private contributor gateway; LOGIN remains visibly inactive until authentication is implemented

## Brand and content rules

- The design uses a dark architectural canvas, warm ivory typography, restrained copper accents, original vector artwork, and purposeful motion.
- Respect reduced-motion preferences and keyboard navigation.
- Do not add unlicensed photography, invented product data, testimonials, pricing, or compatibility claims.
- Contact is email only: benrz101@gmail.com. The mail link opens the visitor's configured email app; no phone number or fake submission form is used.
- GitHub Pages is the public static-site host. A GitHub Actions workflow deploys the site from `main` after the static-site tests pass. The public site is an informational and inquiry-only release; account login, ORIGIN applications, supplier fulfillment, inventory, and checkout are not active.

## Equipment requests

The Products page links each category to an equipment-request builder. Visitors can add up to eight line items and continue to a pre-addressed email to `benrz101@gmail.com`. This is an inquiry only: it opens the visitor's configured email app, requires the visitor to press Send, and does not create an order, take payment, reserve stock, or contact a supplier automatically. BZaudio must confirm availability and pricing manually.
