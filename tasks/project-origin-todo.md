# PROJECT ORIGIN — Task List

## Implemented on feature branch
- [x] Public PROJECT ORIGIN gateway and responsive visual design.
- [x] Supabase Auth signup/sign-in browser interface using publishable key only.
- [x] Contributor application interface with one-per-account and case-insensitive one-per-email constraints in the migration.
- [x] Owner review RPC with approve/decline, audit record, and membership creation on approval.
- [x] Private member-content access policy for active members.
- [x] Manual Founder assignment RPC; unique, permanent number; no automatic assignment.
- [x] Public Founder recognition restricted to records explicitly marked public.
- [x] Website regression, JavaScript syntax, and interaction checks pass on latest commit.

## Remaining release gates
- [ ] Review and apply supabase/migrations/20261119170000_project_origin_membership.sql to the live Supabase project.
- [ ] Configure Supabase Auth site URL and GitHub Pages redirect allowlist.
- [ ] Configure verified SMTP delivery for signup confirmation and owner application notifications.
- [ ] Implement and verify automatic owner application notification after SMTP provider setup.
- [ ] Create/confirm owner account at benrz101@gmail.com; verify owner bootstrap and admin access.
- [ ] Run end-to-end tests: signup → confirmation → application → owner review → member access → Founder assignment → public listing.
- [ ] Browser visual inspection at mobile and desktop widths.
- [ ] Merge and publish only after all release gates pass.

## Owner-controlled rules
- Founder number remains manually designed and assigned by the owner.
- Contribution-to-number mapping remains undefined and must not be inferred or automated.
- Do not expose service-role secrets or grant membership on account creation alone.
- No paid infrastructure or paid email provider without separate approval.
