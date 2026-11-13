# BZaudio

A static-first public website for BZaudio, a professional-audio company.

## Local preview

Run from the repository root:

```bash
python3 -m http.server 8000
```

Then open http://localhost:8000.

## Quality checks

The site has no frontend package dependencies. Run the standard-library structural and accessibility guardrails with:

```bash
python3 scripts/check_site.py
node --check script.js
```

These checks also run automatically in GitHub Actions on pushes and pull requests.

## Public pages

- `index.html` — brand homepage
- `products.html` — eight approved product categories; individual products appear only after their facts are verified
- `solutions.html` — customer and application pathways
- `about.html` — company purpose and trust standards
- `contact.html` — email-ready contact page; the email address is added after launch

## Project files

- `styles.css` — responsive architectural-cinematic design system and reduced-motion behavior
- `script.js` — accessible mobile navigation and progressive reveal motion
- `scripts/check_site.py` — dependency-free structural checks for every public page
- `.github/workflows/site-checks.yml` — automated checks

## Content and trust rules

- Add product details only when their specifications and sources are verified.
- Use genuine, properly licensed photography and record provenance before publishing it.
- Do not publish a phone number or an invented email address.
- Add the owner-supplied email contact link after the site is running.
- GitHub commits are the initial content-management workflow; no admin panel is included.
- Do not represent future BZaudio Technology, Experience, or Care capabilities as already available.
- Respect reduced-motion preferences and preserve keyboard access.

## Deployment

GitHub Pages is the approved host. Production deployment is separate from feature-branch checks and will be prepared after the complete site passes its release review.
