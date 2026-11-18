# Spec: BZaudio Dropshipping and Fulfillment

**Status:** Owner-approved direction (2026-11-18)

## Objective
Prepare BZaudio to sell eligible professional-audio equipment using authorized suppliers who ship directly to the customer.

## Requirements
- Only suppliers with written resale and dropship authorization may be used.
- Supplier product/SKU must map exactly to a verified catalog variant.
- Store warranty, returns, territory, shipping, lead-time, and customer-support terms from the actual agreement.
- Live inventory is shown only from a trusted, fresh, validated supplier feed.
- Before payment activation, fulfillment can be reviewed manually from an email inquiry; no supplier order is created automatically.
- After payment activation, order dispatch must be idempotent, auditable, and fail closed on missing authorization, mapping, payment, or inventory.
- Supplier credentials remain server-side.

## Constraints
- No invented suppliers, authorization, stock, shipping times, warranty, or returns.
- No automated supplier ordering until payment activation and explicit release approval.
- No recurring paid infrastructure or supplier software subscriptions without a separate owner decision.

## Success criteria
- [ ] Authorized supplier register and agreements are documented.
- [ ] SKU mapping and feed freshness tests pass.
- [ ] Manual inquiry review is usable before payment activation.
- [ ] Automated dispatch remains disabled until payment is active and supplier sandbox tests pass.
- [ ] Retry, duplicate, cancellation, return, and audit behavior is tested.
