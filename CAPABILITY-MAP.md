# BZaudio Capability Map

**Status:** Owner-approved project direction (2026-11-18)

## Objective
Complete the BZaudio public website and its six connected business capabilities while keeping recurring infrastructure costs at **$0**. The store is email-first until the owner deliberately activates real payments and supplier ordering.

| Module | Responsibility | Depends on |
|---|---|---|
| catalog | Verified Allen & Heath, Yamaha professional-audio, and Shure music/pro-audio catalog | — |
| accounts | Customer registration, sign-in, profile, and account-required purchase access | Supabase Auth |
| store | Browse, multi-item request cart, quote/inquiry email draft, future payment-ready boundary | catalog, accounts for purchase activation |
| fulfillment | Authorized supplier records, SKU mapping, dropship readiness, future order dispatch | catalog, store |
| origin | Private contributor applications, owner approval, permanent Founder numbers, recognition | accounts, admin |
| administration | Secure management of catalog, customers, inquiries, suppliers, ORIGIN, and audit history | all modules |

## Build order
Catalog → Customer Accounts → Store → Dropshipping/Fulfillment → ORIGIN → Administration and final integration.

Shared admin/security foundations are introduced only as needed by the module being built.

## Non-negotiable operating constraints
- $0 recurring infrastructure cost. Do not create paid Supabase branches, paid plans, paid hosting, or paid email subscriptions.
- GitHub Pages and the existing Supabase Free project are the approved hosting/backend targets.
- Use free CI with disposable PostgreSQL containers for migration tests; never use a paid hosted database branch for testing.
- The public store can accept email inquiries. The inquiry form prepares a draft in the visitor's email app; the visitor must press Send.
- No card payments, online checkout charges, automated supplier purchase orders, or paid transactions until separately activated by the owner.
- An inquiry is not an order or a promise of stock, price, shipping, or availability.
- A customer account will be required before a future purchase can be placed. Public quote questions are not purchases.
- Do not invent manufacturer product data, MAP, stock, supplier authorization, image rights, warranty, or fulfillment terms.
- Do not expose service-role credentials, supplier secrets, private supplier data, MAP evidence, or ORIGIN moderation data to browser code.
- Preserve the existing digital-download product system; physical equipment uses its separate catalog tables.
- Do not deploy, enable GitHub Pages, change DNS, or alter production settings without release review and explicit launch approval.

## Current external prerequisites
- SMTP/email delivery for automated notifications is not configured. Email-draft links work without a sending service; automatic notifications must remain inactive until a free, properly configured sender is available.
- Supplier roster, written resale/dropship permission, feeds, warranty/returns terms, and SKU maps remain unverified.
- Product image licensing and MAP publication permissions must be documented before publishing those assets/values.
- The exact Founder contribution-to-number mapping remains an owner decision. The owner designs each Founder number and approves every assignment.
