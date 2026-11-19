# PROJECT ORIGIN — Task List

## Implemented
- [x] Public PROJECT ORIGIN gateway and responsive visual design.
- [x] Supabase Auth signup/sign-in browser interface using the public publishable key only.
- [x] Contributor application flow with one-per-account and case-insensitive one-per-email database uniqueness.
- [x] Owner review RPC with approve/decline, audit record, and membership creation on approval.
- [x] Private member-content access policy for active members.
- [x] Manual Founder assignment RPC; unique, permanent number; no automatic assignment.
- [x] Public Founder recognition restricted to records explicitly marked public.
- [x] Dedicated PostgreSQL 17 migration/security test previously passed on the feature branch.
- [x] Website quality checks passed on the latest code commit before the most recent client repair.
- [x] Live Supabase migration applied on 2026-11-19 and confirmed in the migration ledger.
- [x] Live schema tables verified; no applicant records exist yet.
- [x] Repair the malformed PROJECT ORIGIN browser client script; fresh CI verification is running.

## Remaining launch gates
- [ ] Configure Supabase Auth Site URL and GitHub Pages redirect allowlist.
- [ ] Configure reliable verified SMTP for signup confirmations.
- [ ] Implement and verify automatic owner application email notifications; SMTP for Auth alone does not send application alerts.
- [ ] Create the owner Auth account at benrz101@gmail.com; verify the owner-bootstrap trigger creates admin access. The account does not currently exist.
- [ ] Run end-to-end tests: signup → email confirmation → application → owner review → member access → manual Founder assignment → public recognition.
- [ ] Browser visual inspection at mobile and desktop widths.
- [ ] Merge and publish only after the launch gates and CI checks pass.

## Owner-controlled rules
- Founder numbers remain personally designed and manually assigned by the owner.
- Contribution-to-number mapping remains undefined and must not be inferred or automated.
- Do not expose service-role secrets or grant membership on account creation alone.
- No paid infrastructure or paid email provider without separate approval.
