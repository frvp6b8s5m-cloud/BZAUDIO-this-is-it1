# Spec: BZaudio Customer Accounts

**Status:** Owner-approved direction (2026-11-18)

## Objective
Allow anyone to create a BZaudio customer account. Accounts provide a customer identity for future purchases, inquiry history, and account-required purchasing.

## Requirements
- Email-based account registration and sign-in.
- Customer can access and update their own basic profile.
- A customer account is required before a real purchase can be placed once purchasing is activated.
- Public product browsing and non-binding email quote inquiries may remain available without signing in.
- The customer role is the default and cannot be self-assigned to admin.
- Account ownership is enforced with Supabase Auth identity and row-level security.
- Never use user-editable user_metadata as an authorization source.
- Do not collect card data or enable payments in this module.

## Technical constraints
- Use the existing Supabase Auth and public.profiles foundation after verifying current settings and policies.
- No paid branches, SMTP subscriptions, or paid authentication services.
- Supabase's built-in SMTP is not suitable for public signups: it only sends to project-team email addresses and currently allows 2 messages per hour. Public email-based signup therefore requires a verified custom SMTP sender. If a genuinely free sender is not available, leave email auth inactive.\n- Google sign-in avoids email confirmation messages but requires a Google OAuth client and configuration. Do not configure it without the owner's selection and credentials.\n- Do not disable email confirmation as a workaround; that would allow unverified email addresses to register.
- Static GitHub Pages frontend; no secrets in browser code.

## Success criteria
- [ ] Signup, verification, sign-in, sign-out, and session persistence work.
- [ ] Profiles are private to their owner except explicitly public profile fields.
- [ ] Customer role cannot be elevated from the browser.
- [ ] Expired/invalid sessions are handled safely.
- [ ] Automated tests cover registration, session, ownership, and unauthorized access.
- [ ] Email delivery is verified without recurring cost.
