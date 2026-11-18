# Spec: ORIGIN Contributor Membership

**Status:** Owner-approved direction (2026-11-18)

## Purpose
ORIGIN is the exclusive contributor area of BZaudio. It is separate from ordinary customer accounts. Anyone may create a standard BZaudio customer account, but ORIGIN membership requires a separate application and owner approval.

## Applicant experience
- Applicant submits full name, email, and an optional message.
- Each person may submit only one application. Duplicate email addresses are rejected by a database uniqueness rule, not merely by browser storage.
- Every application is pending until the owner approves or declines it.
- Application notifications are intended for benrz101@gmail.com.
- No Founder number is assigned before owner approval.

## Founder recognition
- Approved Founders are listed by name on the official BZaudio Contribution Page.
- Each approved Founder receives an ORIGIN Founder’s Edition physical card: black metal, individually engraved with the approved name and unique Founder number.
- Founder numbers are numerical, unique, never reused, and permanent.
- Higher financial contribution receives a higher Founder number. The owner personally designs each number and approves each assignment.
- Exact contribution-to-number mapping is intentionally an owner-controlled manual decision; do not infer it or auto-assign a number.
- Do not promise delivery dates or card production until production arrangements are confirmed.

## Member access
- ORIGIN member login is separate from ordinary customer account creation.
- Only approved ORIGIN members may access private member content.
- The member-area content remains intentionally undefined until the owner specifies it.
- Public page remains minimal: oversized ORIGIN identity and a clear LOGIN entry point.

## Technical and cost constraints
- $0 recurring infrastructure cost.
- Use existing Supabase Free project and GitHub Pages.
- Enforce one-application-per-person in the database with normalized unique email.
- Enforce owner approval server-side; never trust user-editable metadata.
- Keep application message, email, contribution details, and moderation state private.
- Email notifications remain inactive until a free sender is verified and configured. A mailto draft is not an automatic notification.
- No paid email, database, or membership service.

## Success criteria
- [ ] Application form validates full name and email.
- [ ] Database blocks duplicate applications reliably across browsers/devices.
- [ ] Owner receives application notification at benrz101@gmail.com through a verified $0 email setup.
- [ ] Owner can approve/decline applications.
- [ ] Founder number assignment is owner-controlled, permanent, unique, and contribution-ordered.
- [ ] Contribution Page lists only approved names and assigned numbers.
- [ ] Member login denies pending/declined applicants.
- [ ] Card reward details are communicated accurately.
- [ ] RLS and authorization tests prove private applications and membership status are protected.
