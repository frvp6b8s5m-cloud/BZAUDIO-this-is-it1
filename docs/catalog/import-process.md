# Catalog Import Process

## Current implementation
`scripts/catalog-validator.mjs` validates one normalized manufacturer product record. It is a pure function with no network access, database writes, or secrets. It accepts only Allen & Heath, Yamaha, and Shure records sourced from HTTPS pages on the official manufacturer domains.

It rejects:
- Unknown or malformed manufacturer/model identity.
- Non-HTTPS or non-official product/source URLs.
- Invalid lifecycle status or source checked date.
- Unexpected fields and untrusted pricing, MAP, stock, inventory, supplier, image, verification, or publication claims.
- Invalid specification objects or values.

Every accepted record is normalized with `is_verified = false` and `is_published = false`. Import validation never grants publication approval.

## Required future server-side pipeline
1. Receive an authenticated import request from an approved operator or scheduled source adapter.
2. Validate the entire payload and source provenance before writing anything.
3. Normalize identity and compute a stable source fingerprint/idempotency key.
4. Match product/variant identity using manufacturer plus model/MPN; quarantine ambiguous or conflicting matches.
5. Write source records and pending product facts to private catalog staging tables.
6. Preserve rejected rows and safe error summaries in the quarantine tables.
7. Require owner/admin review before setting verified/published flags.
8. Record an audit event for every import and approval action.

## Explicit exclusions
The current validator does not import MAP, retail/dealer pricing, inventory, supplier data, product images, image licenses, or purchase eligibility. Those require separate evidence and authorization workflows. It does not write to Supabase yet.

## Verification
`node --test tests/catalog-validator.test.mjs`  
The full interaction suite also runs through `node --test tests/*.test.mjs`.
