# Spec: BZaudio Product Catalog

**Module id:** `product-catalog`  
**Initiative:** BZaudio commerce and customer platform  
**Status:** Draft — awaiting owner approval  
**Capability map:** Approved six-module architecture; this specification covers Module 1 only.  
**Build order:** Product Catalog → Customer Accounts → Online Store → Dropshipping and Fulfillment → ORIGIN → Administration and final integration testing.

## Objective

Create a trustworthy, maintainable catalog of currently marketed professional-audio products that customers can discover on BZaudio. The catalog is the verified source of product identity, category, descriptions, specifications, images, variants, manufacturer references, advertised pricing status, supplier eligibility, and stock status. It will later supply the Online Store and Dropshipping modules through documented interfaces.

The experience must make it easy to browse, search, filter, and understand products without presenting unverified claims or implying that an item can be purchased or fulfilled before the required supplier and store capabilities exist.

## Confirmed scope

### Manufacturer coverage

- **Allen & Heath:** Every currently marketed product category and current product line, including mixing consoles, audio products, installation products, software, accessories, and other categories shown in the manufacturer's current catalog.
- **Yamaha:** Every currently marketed professional-audio product category, including digital and analog mixing consoles, speakers, microphones, amplifiers, processors, and other professional-audio categories.
- **Shure:** Every currently marketed professional-audio and music-related product category, including microphones, wireless systems, headphones, in-ear monitoring, accessories, and other relevant product lines.

“Every” is an accuracy goal, not permission to claim completeness without evidence. Catalog coverage must be checked against current manufacturer sources and recorded with a verification date. Consumer Yamaha products outside professional audio and unrelated Shure product lines are outside this module unless the owner expands scope.

### Product lifecycle

- Include products that the manufacturer currently markets/sells.
- Exclude discontinued products from the active shopping catalog.
- Do not infer lifecycle status from an old web page, reseller listing, or cached feed.
- If current status cannot be verified, mark the product for review and do not present it as an active purchasable item.

### Pricing

- MAP (Minimum Advertised Price) is the requested public catalog pricing standard.
- Display a MAP amount only when its value, currency, product/variant match, effective date, and source are verified and its publication is permitted by the applicable manufacturer policy and law.
- If no verified, publishable MAP exists, do not invent or substitute a price. Use a neutral “Contact for price” state until the owner approves another pricing rule.
- Record the source and last verification date for every displayed MAP value.
- Do not expose confidential dealer cost, margin, or supplier-only pricing.
- Checkout price behavior, discounts, promotions, taxes, and any difference between advertised and transaction price belong to the Online Store specification and must respect applicable policy and law.

### Suppliers and availability

- Only products sourced through suppliers that BZaudio has confirmed are authorized and permit the intended resale and dropshipping arrangement may be marked eligible for purchase.
- A manufacturer product listing alone does not establish supplier authorization, dealer status, stock, warranty eligibility, or dropshipping permission.
- Show stock status only when supplied by a trusted supplier feed/API or another approved, current source.
- Record supplier identity, source timestamp, and last successful sync. Show an appropriate “availability being confirmed” or “contact us” state when data is missing, stale, conflicting, or unavailable.
- Never represent stale or missing inventory data as live stock.
- Supplier agreements, credentials, feeds, APIs, and fulfillment terms are external prerequisites; they are not assumed to exist.

## Assumptions to validate during planning

1. The existing public site remains static HTML, CSS, and vanilla JavaScript unless a separate architecture change is approved.
2. The previously approved broader architecture proposes GitHub Pages for the public frontend and Supabase for secure backend services; this catalog specification does not authorize backend implementation or deployment changes.
3. The product catalog will need a trusted data store and a controlled import/update process before it can safely support a large, changing multi-brand inventory.
4. Manufacturer websites and official product documents are the primary sources for product identity, lifecycle, and specifications. Authorized supplier sources are required for supplier-specific availability and fulfillment eligibility.
5. Product imagery must be genuine and properly licensed/authorized for use; image URLs copied from manufacturer sites are not automatically licensed for BZaudio use.
6. The catalog is a foundation module. Cart, checkout, payment processing, customer accounts, order creation, supplier ordering, shipping labels, and ORIGIN are not implemented by this specification.

## Commands

Current repository verification commands (no catalog-specific build command is approved yet):

- Local preview: `python3 -m http.server 8000`
- Python tests: `python3 -m unittest discover -s tests -v`
- JavaScript syntax: `node --check script.js`
- JavaScript tests: `node --test tests/*.test.mjs`

Any future catalog import, validation, or synchronization commands must be documented with exact executable arguments in the approved technical plan. Do not add a package manager, framework, build step, or runtime dependency without approval.

## Project structure

Proposed locations, subject to the approved technical plan:

- `data/catalog/` — normalized product records and category/manufacturer metadata, if a file-backed source is selected.
- `docs/catalog/` — source register, data dictionary, coverage reports, and catalog operating procedures.
- `tests/` — unit and integration tests for validation, imports, search/filter behavior, and stale-data handling.
- Existing public pages and assets remain in their current locations unless the plan explicitly approves a change.
- If the approved architecture uses a database as the catalog source of truth, schema and migration locations must be specified in the plan rather than duplicating the same authoritative records in static files.

Each product record should support, where applicable:

- Stable internal product ID and manufacturer product identifier/SKU.
- Manufacturer and product family.
- Product name, model, category, and subcategory.
- Current-market lifecycle status and verification date.
- Canonical manufacturer product URL and source references.
- Verified description and structured specifications, with source and verification date.
- Product variants/options and their distinct identifiers.
- Image asset/reference, usage-rights status, and provenance.
- MAP amount, currency, source, effective date, and publication permission/status.
- Supplier references, authorization/fulfillment eligibility, and source timestamps.
- Availability state, last synchronization time, and data freshness status.
- Created/updated timestamps and review status.

Do not force fields that do not apply to a product. Distinguish unknown, not applicable, unavailable, and unverified values.

## Code style

- Follow the existing repository's semantic HTML, CSS, and vanilla JavaScript conventions until a different stack is separately approved.
- Keep manufacturer/source data separate from presentation.
- Use stable IDs and explicit enums for lifecycle, price verification, supplier eligibility, and stock freshness; avoid relying on display text as business logic.
- Validate all imported data at system boundaries. Reject or quarantine malformed/conflicting records rather than silently publishing them.
- Keep secrets and supplier credentials server-side only.
- Example normalized in-memory record shape (illustrative, not a committed data record):

```js
const product = {
  id: "manufacturer-model-variant",
  manufacturer: "Example Manufacturer",
  model: "MODEL-100",
  lifecycle: {
    status: "current",
    verifiedAt: "YYYY-MM-DD"
  },
  pricing: {
    type: "map",
    amount: null,
    currency: "USD",
    verifiedAt: null,
    publishable: false
  },
  availability: {
    status: "unknown",
    sourceUpdatedAt: null,
    lastSyncedAt: null
  }
};
```

## Testing strategy

Tests must cover at least:

- Product identity and required-field validation, including duplicate manufacturer/model/variant identifiers.
- Correct manufacturer/category mapping and search/filter behavior.
- Product lifecycle rules: discontinued or unverified products cannot appear as active purchasable listings.
- MAP display rules: no price is shown without verified, publishable MAP evidence; currency and variant match are enforced.
- Supplier eligibility: unauthorized, unconfirmed, or non-dropship suppliers cannot make a product purchasable.
- Availability freshness: missing, stale, conflicting, or failed supplier data cannot be shown as live in-stock status.
- Import idempotency, duplicate handling, partial failures, and auditability.
- Product detail pages and catalog controls on mobile and desktop, keyboard operation, visible focus, readable contrast, and reduced-motion preferences.
- No broken product links or unlicensed/unprovenanced imagery in published records.

Verification must use representative records from all three manufacturers and multiple product categories. Coverage reports must identify source, date checked, known gaps, and products awaiting review. A test passing against a small sample does not prove that a manufacturer's entire catalog has been captured.

## Boundaries

### Always

- Follow the approved six-module capability map and Agent Skills approval gates.
- Preserve the existing owner-approved `tasks/plan.md`, `tasks/todo.md`, and public-site specification; this module has its own specification and later plan.
- Use current manufacturer information and approved supplier data; record provenance and verification dates.
- Treat MAP, specifications, lifecycle, image rights, supplier authorization, and stock as separate facts requiring their own evidence.
- Make uncertainty visible; do not guess or silently fill missing data.
- Keep product browsing clear, responsive, accessible, and not overwhelming.
- Keep the catalog data model suitable for later account, store, and fulfillment integration without implementing those modules here.

### Ask first

- Adding manufacturers or product categories outside the confirmed scope.
- Displaying non-MAP prices, discounts, promotional pricing, or dealer pricing.
- Importing from a supplier or marketplace that has not been confirmed as authorized and dropship-capable.
- Publishing images or product copy without confirmed usage rights/source.
- Adding paid data services, supplier subscriptions, databases, dependencies, frameworks, or changing hosting/backend architecture.
- Making a product purchasable before supplier, warranty, fulfillment, and store requirements are verified.
- Changing the approved capability map, build order, or existing project plan.

### Never

- Invent product names, specifications, MAP prices, stock, warranty coverage, supplier authorization, or compatibility claims.
- Include discontinued products as currently available for purchase.
- Display confidential supplier cost or credentials publicly.
- Claim the catalog is complete without a documented manufacturer-by-manufacturer coverage check.
- Put service-role keys, payment secrets, supplier API credentials, or other privileged secrets in browser code or public repository files.
- Implement checkout, payment processing, customer accounts, order management, supplier ordering, or ORIGIN as part of this module.
- Deploy, enable GitHub Pages, change DNS, or alter production settings without separate owner approval.

## Success criteria

1. The catalog's three manufacturer scopes match the confirmed requirements.
2. Each published active product has a stable identity, category, current-market evidence, and traceable source.
3. MAP is displayed only when verified and publishable; otherwise no invented or substitute price is shown.
4. Stock is shown only from an approved supplier source with visible freshness handling.
5. A product cannot be marked purchasable without verified authorized-supplier and dropshipping eligibility.
6. Discontinued, unverified, duplicate, malformed, or conflicting records are excluded from active listings or routed to review.
7. Product images have documented usage rights and provenance.
8. Search, filtering, and product details are usable on mobile and desktop and meet the repository's accessibility standards.
9. Coverage and data-quality reports make missing manufacturer lines and unresolved records visible.
10. Automated tests and runtime checks pass before the module is considered complete.
11. The catalog exposes a documented, stable interface for later store and fulfillment modules without implementing them.

## Open questions

1. **Supplier roster and authorization:** Which authorized distributors/suppliers will BZaudio use? No supplier is assumed approved until the owner confirms the relationship and dropshipping terms.
2. **MAP source and refresh:** Will MAP values come from supplier feeds, manufacturer dealer portals, or manual verification? Access and update frequency must be established before implementation.
3. **Catalog coverage evidence:** Manufacturer catalog structures change. The technical plan must define how to identify all current product families and how often coverage is rechecked.
4. **Image rights:** Confirm whether manufacturers/suppliers provide approved product-image assets and permitted usage terms.
5. **Fallback pricing:** Current direction is “Contact for price” when a verified, publishable MAP is unavailable. Confirm this remains the intended display.
6. **Shure scope boundary:** The working interpretation is all current professional-audio and music-related product families, excluding unrelated Shure product lines. Confirm against the official product taxonomy during planning.
