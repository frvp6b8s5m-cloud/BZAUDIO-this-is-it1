# Catalog Import and Review Process

**Status:** Validation foundation implemented; secure database ingestion is not yet enabled.  
**Branch:** `feature/website-foundation`

## Current implementation

- `scripts/catalog-validation.mjs` validates normalized manufacturer product batches using only Node.js built-ins.
- It rejects malformed records, quarantines incomplete source evidence and uncertain lifecycle, detects duplicate manufacturer/model identities within a batch, and calculates deterministic SHA-256 row fingerprints and idempotency keys.
- `tests/catalog-validation.test.mjs` covers valid records, malformed rows, source/lifecycle quarantine, duplicate identities, deterministic fingerprints, variant requirements, and invalid batch input.

## Input contract

Each row contains:

- `manufacturer_slug`: one of `allen-heath`, `yamaha`, or `shure`
- `name`, `model_number`, `lifecycle_status`
- `product_url`: optional HTTPS manufacturer product page
- `categories`: one or more normalized category slugs
- `source`: source type, canonical HTTPS URL, and ISO timestamp when checked
- `variants`: one or more exact variant identities with a model number or manufacturer part number

The validator does not infer missing data, create SKUs, determine MAP, assign stock, or claim supplier authorization.

## Row outcomes

| Outcome | Meaning | Next step |
|---|---|---|
| `rejected` | Required fields or data shape are invalid | Correct source record; do not import |
| `quarantined` | Identity, lifecycle, provenance, or duplicate status needs review | Human review and fresh evidence |
| `accepted` | Structurally complete with manufacturer source evidence | Still requires human verification and approval |

**Important:** accepted means eligible for a review queue only. It does not mean verified, publishable, priced, in stock, authorized for resale, or purchasable.

## Required next stage before any database write

1. Add a server-only ingestion endpoint after Supabase Auth/service-role boundaries and current documentation are verified.
2. Revalidate the complete payload server-side; never trust browser-submitted validation results.
3. Persist import run and row status, source records, product/variant candidates, and audit events in a single transaction or a recoverable staged workflow.
4. Make repeated identical imports idempotent; never overwrite reviewed product facts without an explicit conflict/review path.
5. Quarantine duplicate, discontinued, ambiguous, stale, and conflicting records.
6. Keep all new records unpublished until a reviewer approves identity, lifecycle, category, source evidence, image rights, and any variant-specific facts.
7. Add integration tests against a disposable Supabase-local Auth/Data API environment before considering production application.

## Security and release boundary

- No service-role key or supplier credential belongs in this repository's browser assets.
- No importer is deployed or connected to the live Supabase project.
- The catalog migration remains unapplied to the live project.
- The validator is a local/CI quality gate, not an import service or admin interface.
- No manufacturer data is automatically published by running the validator.
