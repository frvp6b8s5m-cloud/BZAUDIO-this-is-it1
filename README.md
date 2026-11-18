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

This is a static-first site with no frontend framework or runtime package dependencies. The equipment request form prepares an email draft; it does not submit an order, collect payment, or contact a supplier automatically.

## Public pages

- `index.html` — cinematic brand introduction and company principles
- `products.html` — the eight approved product categories\n- `store.html` — manufacturer catalog entry and email-based equipment inquiry (not checkout)\n- `origin.html` — minimal ORIGIN contributor gateway; authentication is not active yet
- `solutions.html` — pathways for live production, worship, education, studios, venues, and audio professionals
- `about.html` — company purpose and trust standards
- `contact.html` — email-only contact page with a direct quote/inquiry email link

## Brand and content rules

- The design uses a dark architectural canvas, warm ivory typography, restrained copper accents, original vector artwork, and purposeful motion.
- Respect reduced-motion preferences and keyboard navigation.
- Do not add unlicensed photography, invented product data, testimonials, pricing, or compatibility claims.
- Contact is email only: benrz101@gmail.com. The mail link opens the visitor's configured email app; no phone number or fake submission form is used.
- GitHub Pages is the intended host. Production deployment remains separately approval-gated.