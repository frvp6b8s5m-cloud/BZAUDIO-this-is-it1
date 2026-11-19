# BZaudio Zero-Recurring-Cost Operating Plan

**Owner requirement:** $0 recurring infrastructure cost.

## Approved free components
- GitHub Pages for the static public website.
- The existing public GitHub repository and standard GitHub Actions runners for CI.
- The existing Supabase Free project for backend functions and data, subject to its free quotas and inactivity behavior.
- Email-draft links (`mailto:`) for manual equipment inquiries. The visitor's own email app sends the message; BZaudio does not pay for a sending service.

## Not enabled
- No paid Supabase branch or paid plan.
- No paid hosting, paid database, paid email subscription, or paid catalog feed.
- No online payment capture.
- No automatic supplier order dispatch.
- No production deployment until final release review.

## Known constraints
- Supabase's built-in Auth email service is for testing: it only sends to project team addresses and currently allows 2 emails per hour. It cannot support public customer signup by arbitrary email addresses. Public email/password or magic-link auth requires custom SMTP or another Auth email hook.
- A custom SMTP provider may have a free tier, but may require a verified sender domain and has provider-specific limits. Do not enable it until a genuinely $0 path is verified.
- Google sign-in can avoid Auth email delivery, but requires a Google OAuth client and owner-approved configuration.
- Supplier catalog feeds and dropship access are not assumed free; only use them if suppliers provide authorized access at no recurring charge.
- Payment processing will have transaction fees if/when real purchasing is activated. Those costs belong to the later buying phase.

## Operating rule
If a feature cannot be delivered safely with the currently available free services, build and test the code without activating the paid or credential-dependent integration. Mark the feature as inactive and explain the exact blocker rather than silently introducing a cost.
