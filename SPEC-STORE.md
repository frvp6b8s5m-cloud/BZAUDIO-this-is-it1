# Spec: BZaudio Equipment Store

**Status:** Owner-approved direction (2026-11-18)

## Objective
Create a trustworthy equipment store for Allen & Heath, Yamaha professional audio, and Shure music/pro-audio products. Before payment activation, customers can assemble a multi-item equipment request and prepare an email to BZaudio for manual review.

## Current approved behavior
- Public visitors can browse manufacturer and category coverage.
- Product model listings are added only after identity, lifecycle, specifications, and source are verified.
- MAP appears only when exact-variant evidence is current and publishable; otherwise use “Contact for price.”
- Live availability appears only from an approved dropship supplier's fresh, validated feed; otherwise availability remains unknown/being confirmed.
- The request cart supports multiple user-entered equipment lines and quantities while the verified catalog is being populated.
- Submitting the form creates a prefilled email draft addressed to benrz101@gmail.com. The visitor reviews it and presses Send in their own email app.
- The email is an inquiry only. It does not create an order, charge a payment method, reserve stock, or send a supplier order.
- Online payment and automatic supplier ordering remain disabled.
- Customer account is mandatory before any future purchase. Public inquiries are not purchases.

## Technical constraints
- Existing static HTML/CSS/vanilla JavaScript and GitHub Pages.
- Existing Supabase Free project for approved backend functionality; no paid branches or paid services.
- No new frontend framework, package manager, or runtime dependency.
- No server-side email delivery until a $0 sender configuration is verified.
- The catalog and store remain separate from the existing digital-download product tables.

## Success criteria
- [x] Store page is linked from shared navigation.
- [x] Manufacturer coverage is identified without pretending the model catalog is complete.
- [x] Multi-item equipment requests can be prepared as an email draft.
- [x] The page clearly states the visitor must send the email and no order/payment occurs.
- [ ] Verified model-level catalog and source register are populated.
- [ ] Customer account gating is implemented for future purchase activation.
- [ ] Admin review and inquiry tracking are implemented.
- [ ] Automated and manual accessibility/runtime checks pass before release.

## Boundaries
- Never display invented prices, MAP, stock, product specs, reviews, compatibility, supplier status, warranty, or image permissions.
- Never represent an email inquiry as a confirmed order.
- Never activate online payment or automatic supplier ordering in this phase.
- Never add a recurring paid dependency.
