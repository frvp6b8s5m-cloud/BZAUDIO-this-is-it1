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
- Automated email is not available until a verified, reliable delivery route is configured. A mailto link is not an automatic notification.

## Release boundaries
- Build and test incrementally on feature branches with reviewable pull requests.
- Do not apply live Supabase migrations, change production authentication settings, configure DNS, activate paid services, or enable public membership flows without a separate verified release gate and explicit approval.
- Existing static GitHub Pages hosting remains the public site.


## Implementation status — 2026-11-19
- Public gateway and browser account/application/admin/member UI are implemented on the feature branch.
- Additive Supabase migration defines RLS-protected applications, memberships, admin review, audit history, manual Founder assignment, and member content.
- Privileged SECURITY DEFINER routines have explicit execute revocations; public Founder reads are column-limited, and private contribution amounts are available only through an owner-checked RPC.
- Dedicated PostgreSQL 17 CI test passes for migration execution, owner bootstrap, application approval, membership, Founder assignment, and public/private access boundaries.
- Website quality and JavaScript checks pass on the current feature branch.
- Owner bootstrap uses the auth account email allowlist for benrz101@gmail.com.
- The live database migration has not been applied. Auth redirect/email delivery settings have not been configured. Owner email notifications are not active.
- Public UI must remain unreleased until the migration and Auth settings are applied and end-to-end tests pass.
