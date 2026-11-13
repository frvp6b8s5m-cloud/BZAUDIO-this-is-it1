# BZaudio

A static-first public website for BZaudio, a professional-audio company.

## Local preview

Run from the repository root:

```bash
python3 -m http.server 8000
```

Then open http://localhost:8000.

## Quality check

The site has no frontend package dependencies. Run the standard-library structural and accessibility guardrails with:

```bash
python3 scripts/check_site.py
```

## Project files

- `index.html` — semantic brand homepage
- `styles.css` — responsive architectural-cinematic design system and reduced-motion behavior
- `script.js` — accessible mobile navigation and progressive reveal motion
- `scripts/check_site.py` — dependency-free structural checks
- `.github/workflows/site-checks.yml` — automated checks on pushes and pull requests

## Content and trust rules

- Add product details only when their specifications and sources are verified.
- Use genuine, properly licensed photography and record provenance before publishing it.
- Do not publish a phone number or an invented email address.
- Add the owner-supplied email contact link after the site is running.
- GitHub commits are the initial content-management workflow; no admin panel is included.
- Respect reduced-motion preferences and preserve keyboard access.

## Deployment

GitHub Pages is the approved host. Production deployment is kept separate from feature-branch checks and will be prepared after the complete site passes its release review.
