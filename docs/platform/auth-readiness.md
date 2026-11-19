# Customer Accounts and ORIGIN Authentication Readiness

**Status:** Read-only assessment. No authentication settings, database tables, email providers, or production configuration were changed.

## Current platform

- Existing Supabase project: `BZ audio` (`cgakpcvptyhxwfujzqoe`), Free plan, currently `ACTIVE_HEALTHY`.
- Project URL and a non-disabled publishable key are available for browser clients. Never place a Supabase secret/service-role key in GitHub Pages code.
- The existing `public.profiles` table is linked to `auth.users` and currently includes a `role` field. Its policies and trigger behavior must be reviewed before using it for new commerce or ORIGIN authorization.
- No Edge Functions currently exist.
- The existing digital-download schema must remain separate from physical catalog and contributor workflows.

## Email authentication limitation

Supabase's hosted default email provider is not a production email service:
- It only sends to email addresses belonging to the Supabase organization's team.
- It currently limits the project to two Auth emails per hour.
- Delivery is best-effort and has no SLA.

Sources:
- https://supabase.com/docs/guides/auth/auth-smtp
- https://supabase.com/docs/guides/auth/testing-auth-flows
- https://supabase.com/docs/guides/auth/rate-limits

Therefore, do not launch public email/password confirmation, magic-link, or OTP sign-in on the default SMTP provider and claim it works for arbitrary customers.

## $0 recurring-cost-compatible options

1. **Google OAuth:** Supabase Free supports social OAuth, but a Google OAuth client must be created and its client ID/secret configured securely. This avoids relying on Supabase's default email sender for sign-in. It still needs redirect URL and production-domain configuration.
2. **Custom SMTP:** Supabase Free supports custom SMTP configuration, but the SMTP provider must have a genuinely free tier, and sender-domain verification and DNS setup may be required. Do not assume the owner's Gmail address can be used as a verified sending domain.
3. **Email inquiry fallback:** Until a public authentication method is configured, product inquiries can open the visitor's own email app using a prefilled `mailto:` message. This is not an on-site submission and must be described honestly.

## Required implementation safeguards

- Use the Supabase publishable key only in browser code; never expose secret/service-role keys.
- Keep email confirmation enabled for email/password accounts; do not disable verification merely to bypass SMTP limits.
- Do not use user-editable profile metadata or `user_metadata` for admin/Founder authorization.
- Store access decisions in server-controlled database records and enforce them with RLS.
- Separate ordinary customer accounts from ORIGIN contributor applications and Founder access.
- Prevent duplicate contributor applications using a database uniqueness rule, not only browser checks.
- Keep Founder number assignment manual, owner-approved, unique, permanent, and based on the owner's contribution rules.
- Do not send automated owner notifications until a real delivery provider is configured and tested.

## Current decision

Keep the ORIGIN LOGIN entry visibly inactive. Build the public gateway and the rest of the static UI, but do not activate authentication until Google OAuth credentials or a verified custom SMTP route is configured and tested. No paid recurring service is required for the Google OAuth route, but the owner must create/configure the OAuth application.
