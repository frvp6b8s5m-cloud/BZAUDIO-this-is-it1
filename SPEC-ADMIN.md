# Spec: BZaudio Administration

**Status:** Owner-approved direction (2026-11-18)

## Objective
Provide a secure owner/admin workspace to manage the catalog, customers, inquiries, suppliers, fulfillment readiness, ORIGIN applications, Founder numbering, and public contribution recognition.

## Requirements
- Only owner-authorized administrators can access admin actions.
- Admin authorization is stored in trusted server-side/database-controlled roles, never user-editable user_metadata.
- Catalog product edits require source provenance and verification state.
- Supplier authorization, MAP evidence, image rights, inventory snapshots, and import errors are private.
- Email inquiries can be reviewed and tracked manually; no order/payment status is fabricated.
- ORIGIN applications can be approved or declined; Founder numbers are unique, permanent, owner-designed, and assigned only after owner approval.
- Admin actions are auditable without storing secrets or unnecessary personal information.

## Constraints
- No admin controls or secrets in the public static frontend.
- No unauthenticated writes to private data.
- No paid admin SaaS or recurring infrastructure.
- Keep customer account management separate from ORIGIN membership approval.

## Success criteria
- [ ] Role-based access and RLS are verified.
- [ ] Admin actions are server-authorized and audited.
- [ ] Catalog, inquiry, supplier, and ORIGIN review workflows work end-to-end.
- [ ] Sensitive supplier and contributor data is never publicly exposed.
