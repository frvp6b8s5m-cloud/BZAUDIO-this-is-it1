# PROJECT ORIGIN — Capability Map

## Objective
Build PROJECT ORIGIN as BZaudio's exclusive contributor and Founder membership experience. Keep ordinary BZaudio customer accounts separate from PROJECT ORIGIN membership. Preserve the existing monochrome visual direction and original BZaudio logo.

## Approved modules and build order

| Module ID | Responsibility | Depends on |
|---|---|---|
| public-gateway | PROJECT ORIGIN public landing page and clear entry paths | Existing BZaudio static site |
| accounts | Secure ordinary customer identity and sessions | Authentication architecture |
| applications | One contributor application per person; pending/reviewed states | Accounts, database |
| admin-approval | Private owner review, approval, decline, and audit trail | Accounts, applications |
| founder-system | Contribution records and manually approved permanent Founder numbers | Admin approval, contribution rules |
| member-portal | Private content and access for approved PROJECT ORIGIN members | Accounts, admin approval |
| notifications | Reliable owner and applicant notifications | Applications, approved delivery provider |

Build order: public-gateway → accounts → applications → admin-approval → founder-system → member-portal → notifications.

## Shared product rules
- PROJECT ORIGIN membership is distinct from an ordinary BZaudio customer account.
- A contributor application is not membership and does not grant access.
- Duplicate applications must be prevented by a database constraint, not only client-side checks.
- Applications remain pending until the owner approves or declines them.
- Founder numbers are numerical, based on financial contribution, personally designed by the owner, manually approved, unique, permanent, and never automatically assigned. The exact contribution-to-number mapping remains an owner decision.
- Founder recognition includes the contributor's name on the official BZaudio Contribution Page and an individually numbered black metal Founder’s Edition card engraved with the contributor's name.
- No public or private flow may claim an application was sent, an account was created, or access was granted unless the backend confirms it.
- No service-role key or other privileged secret may appear in browser code.
- Keep recurring infrastructure costs at $0. No paid provider or plan may be activated without explicit approval.
- Automated email notifications require a verified delivery route; Supabase Auth SMTP alone does not create application alerts.

## Release boundaries
- Build and test incrementally on feature branches with reviewable pull requests.
- Do not enable public membership flows until Auth redirect/email settings and end-to-end tests are verified.
- Existing static GitHub Pages hosting remains the public site.

## Implementation status — 2026-11-19
- Public gateway and browser account/application/admin/member UI are implemented on the feature branch.
- Additive Supabase migration was applied to the live database and confirmed in the migration ledger.
- Live tables exist; currently there are zero applications and zero owner-admin records.
- Owner bootstrap uses the auth account email allowlist for benrz101@gmail.com. The owner Auth account does not yet exist, so admin access is not yet active.
- Privileged SECURITY DEFINER routines have explicit execute revocations; public Founder reads are column-limited, and private contribution amounts are available only through an owner-checked RPC.
- Dedicated PostgreSQL 17 CI test passed on the previous feature-branch revision. A browser-client repair has just been committed and requires fresh CI verification.
- Auth redirect settings, verified email delivery, and automatic owner application notifications are not configured.
- Do not merge or publish the account/application UI until the remaining launch gates and end-to-end tests pass.
