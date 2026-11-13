# BZaudio

The public BZaudio website: a premium, architectural and cinematic introduction to the company, its approach to professional audio, and the standards behind its recommendations.

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
- `contact.html` — email-ready contact page; the actual email address is added after launch

## Brand and content rules

- The design uses a dark architectural canvas, warm ivory typography, restrained copper accents, original vector artwork, and purposeful motion.
- Respect reduced-motion preferences and keyboard navigation.
- Do not add unlicensed photography, invented product data, testimonials, pricing, or compatibility claims.
- Contact is email only. No phone number or placeholder email is published; activate the address after the site is running and the owner supplies it.
- GitHub Pages is the intended host. Production deployment remains separately approval-gated.