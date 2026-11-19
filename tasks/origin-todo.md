# ORIGIN Gateway — Task List

**Status:** Public gateway implemented and automated checks pass. Real authentication and the member area remain inactive.

- [x] Create the minimal monochrome ORIGIN page with the oversized wordmark and LOGIN entry.
- [x] Add ORIGIN to the shared navigation across all six public pages.
- [x] Keep the LOGIN entry non-authenticating and clearly marked as inactive; no credentials are collected.
- [x] Add responsive styling and reduced-motion compatibility through the shared site styles.
- [x] Extend static-site tests for page structure, navigation, and the inactive login state.
- [ ] Define and implement real customer sign-in with a free-tier-compatible provider, after verifying provider settings and email delivery limits.
- [ ] Define the post-login ORIGIN member experience, founder approval workflow, permanent contributor numbering, and contribution records.
- [ ] Test authentication, authorization, duplicate application prevention, email notification, and owner approval flows before launch.

## Boundaries
- Do not store passwords in the static site.
- Do not assign Founder numbers automatically; owner designs and approves each permanent number.
- Do not imply that login or applications work until a real backend and email path are configured and tested.
- No paid infrastructure, payment activation, or supplier ordering.
