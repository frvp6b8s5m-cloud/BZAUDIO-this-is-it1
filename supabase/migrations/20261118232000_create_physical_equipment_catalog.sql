-- Physical equipment catalog foundation.
-- Keep digital downloads in public.products; this is a separate domain.
-- Public catalog tables expose only publishable fields. Supplier/evidence data
-- remains in catalog_private, which is not exposed through the Data API.

create schema catalog_private;
revoke all on schema catalog_private from public, anon, authenticated;
grant usage on schema catalog_private to service_role;

create table public.catalog_manufacturers (
  id uuid primary key default gen_random_uuid(),
  slug text not null unique check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  name text not null,
  website_url text not null check (website_url ~ '^https://'),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.catalog_categories (
  id uuid primary key default gen_random_uuid(),
  parent_id uuid references public.catalog_categories(id) on delete restrict,
  slug text not null unique check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  name text not null,
  description text,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (parent_id is null or parent_id <> id)
);

create table public.catalog_products (
  id uuid primary key default gen_random_uuid(),
  manufacturer_id uuid not null references public.catalog_manufacturers(id) on delete restrict,
  slug text not null unique check (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
  name text not null,
  model_number text,
  product_family text,
  short_description text,
  description text,
  manufacturer_product_url text check (manufacturer_product_url is null or manufacturer_product_url ~ '^https://'),
  lifecycle_status text not null default 'unknown'
    check (lifecycle_status in ('active', 'discontinued', 'unknown')),
  is_verified boolean not null default false,
  is_published boolean not null default false,
  source_checked_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create unique index catalog_products_manufacturer_model_uidx
  on public.catalog_products (manufacturer_id, lower(model_number))
  where model_number is not null;
create index catalog_products_public_lookup_idx
  on public.catalog_products (manufacturer_id, lifecycle_status, is_verified, is_published);
create index catalog_products_name_search_idx
  on public.catalog_products using gin (to_tsvector('simple', coalesce(name, '') || ' ' || coalesce(model_number, '')));

create table public.catalog_product_categories (
  product_id uuid not null references public.catalog_products(id) on delete cascade,
  category_id uuid not null references public.catalog_categories(id) on delete restrict,
  primary key (product_id, category_id)
);
create index catalog_product_categories_category_idx
  on public.catalog_product_categories (category_id, product_id);

create table public.catalog_variants (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.catalog_products(id) on delete cascade,
  variant_name text not null,
  model_number text,
  manufacturer_part_number text,
  attributes jsonb not null default '{}'::jsonb
    check (jsonb_typeof(attributes) = 'object'),
  lifecycle_status text not null default 'unknown'
    check (lifecycle_status in ('active', 'discontinued', 'unknown')),
  is_verified boolean not null default false,
  is_published boolean not null default false,
  map_price_amount numeric(12,2),
  currency char(3),
  map_effective_at timestamptz,
  map_verified_at timestamptz,
  availability_status text not null default 'unknown'
    check (availability_status in ('unknown', 'in_stock', 'limited', 'backorder', 'out_of_stock', 'contact_supplier')),
  availability_checked_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (map_price_amount is null or map_price_amount >= 0),
  check (
    (map_price_amount is null and currency is null and map_verified_at is null)
    or
    (map_price_amount is not null and currency ~ '^[A-Z]{3}$' and map_verified_at is not null)
  )
);
create unique index catalog_variants_product_model_uidx
  on public.catalog_variants (product_id, lower(model_number))
  where model_number is not null;
create unique index catalog_variants_product_mpn_uidx
  on public.catalog_variants (product_id, lower(manufacturer_part_number))
  where manufacturer_part_number is not null;
create index catalog_variants_public_lookup_idx
  on public.catalog_variants (product_id, lifecycle_status, is_verified, is_published);

create table public.catalog_media (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.catalog_products(id) on delete cascade,
  variant_id uuid references public.catalog_variants(id) on delete cascade,
  asset_url text not null check (asset_url ~ '^https://'),
  alt_text text not null,
  sort_order integer not null default 0,
  is_published boolean not null default false,
  created_at timestamptz not null default now()
);
create index catalog_media_product_sort_idx
  on public.catalog_media (product_id, sort_order);

-- Private source and review evidence.
create table catalog_private.source_records (
  id uuid primary key default gen_random_uuid(),
  manufacturer_id uuid references public.catalog_manufacturers(id) on delete restrict,
  source_url text not null check (source_url ~ '^https://'),
  source_type text not null check (source_type in ('manufacturer', 'supplier', 'policy', 'license', 'other')),
  source_title text,
  permitted_use_notes text,
  content_fingerprint text,
  checked_at timestamptz not null default now(),
  reviewer text,
  review_status text not null default 'pending'
    check (review_status in ('pending', 'approved', 'rejected', 'expired')),
  created_at timestamptz not null default now()
);
create index catalog_source_records_manufacturer_checked_idx
  on catalog_private.source_records (manufacturer_id, checked_at desc);

create table catalog_private.product_source_links (
  id uuid primary key default gen_random_uuid(),
  product_id uuid references public.catalog_products(id) on delete cascade,
  variant_id uuid references public.catalog_variants(id) on delete cascade,
  source_record_id uuid not null references catalog_private.source_records(id) on delete restrict,
  fact_scope text not null check (fact_scope in ('identity', 'specification', 'lifecycle', 'price', 'media')),
  verification_status text not null default 'pending'
    check (verification_status in ('pending', 'verified', 'rejected', 'stale')),
  checked_at timestamptz not null default now(),
  reviewer text,
  check (product_id is not null or variant_id is not null)
);
create index catalog_product_source_links_product_idx
  on catalog_private.product_source_links (product_id, fact_scope);
create index catalog_product_source_links_variant_idx
  on catalog_private.product_source_links (variant_id, fact_scope);

create table catalog_private.map_evidence (
  id uuid primary key default gen_random_uuid(),
  variant_id uuid not null references public.catalog_variants(id) on delete cascade,
  source_record_id uuid not null references catalog_private.source_records(id) on delete restrict,
  map_price_amount numeric(12,2) not null check (map_price_amount >= 0),
  currency char(3) not null check (currency ~ '^[A-Z]{3}$'),
  effective_from timestamptz not null,
  effective_until timestamptz,
  exact_variant_match boolean not null default false,
  publication_permitted boolean not null default false,
  evidence_reference text not null,
  reviewer text,
  verified_at timestamptz,
  check (effective_until is null or effective_until > effective_from)
);
create index catalog_map_evidence_variant_period_idx
  on catalog_private.map_evidence (variant_id, effective_from, effective_until);

create table catalog_private.media_rights (
  id uuid primary key default gen_random_uuid(),
  media_id uuid not null references public.catalog_media(id) on delete cascade,
  rights_holder text not null,
  permission_type text not null,
  allowed_channels text[] not null default '{}',
  territory text,
  attribution_requirement text,
  expires_at timestamptz,
  proof_reference text not null,
  reviewer text,
  approval_status text not null default 'pending'
    check (approval_status in ('pending', 'approved', 'rejected', 'expired')),
  reviewed_at timestamptz
);
create index catalog_media_rights_media_idx
  on catalog_private.media_rights (media_id, approval_status);

create table catalog_private.suppliers (
  id uuid primary key default gen_random_uuid(),
  legal_name text not null,
  display_name text,
  authorization_status text not null default 'unverified'
    check (authorization_status in ('unverified', 'pending', 'approved', 'suspended', 'revoked')),
  written_resale_permission boolean not null default false,
  written_dropship_permission boolean not null default false,
  territory text,
  agreement_starts_at timestamptz,
  agreement_ends_at timestamptz,
  warranty_terms_reference text,
  returns_terms_reference text,
  feed_type text check (feed_type is null or feed_type in ('api', 'csv', 'xml', 'manual')),
  secret_reference text,
  review_status text not null default 'pending'
    check (review_status in ('pending', 'approved', 'rejected', 'expired')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (agreement_ends_at is null or agreement_starts_at is null or agreement_ends_at > agreement_starts_at)
);

create table catalog_private.supplier_variant_map (
  id uuid primary key default gen_random_uuid(),
  supplier_id uuid not null references catalog_private.suppliers(id) on delete restrict,
  variant_id uuid not null references public.catalog_variants(id) on delete cascade,
  supplier_sku text not null,
  supplier_product_reference text,
  fulfillment_eligible boolean not null default false,
  last_mapping_verified_at timestamptz,
  unique (supplier_id, supplier_sku),
  unique (supplier_id, variant_id)
);
create index catalog_supplier_variant_map_variant_idx
  on catalog_private.supplier_variant_map (variant_id);

create table catalog_private.import_runs (
  id uuid primary key default gen_random_uuid(),
  source_record_id uuid references catalog_private.source_records(id) on delete restrict,
  supplier_id uuid references catalog_private.suppliers(id) on delete restrict,
  idempotency_key text not null unique,
  run_status text not null default 'queued'
    check (run_status in ('queued', 'running', 'completed', 'completed_with_errors', 'failed', 'cancelled')),
  rows_received integer not null default 0 check (rows_received >= 0),
  rows_accepted integer not null default 0 check (rows_accepted >= 0),
  rows_rejected integer not null default 0 check (rows_rejected >= 0),
  started_at timestamptz,
  finished_at timestamptz,
  created_at timestamptz not null default now()
);

create table catalog_private.inventory_snapshots (
  id uuid primary key default gen_random_uuid(),
  supplier_id uuid not null references catalog_private.suppliers(id) on delete restrict,
  variant_id uuid not null references public.catalog_variants(id) on delete cascade,
  availability_status text not null
    check (availability_status in ('unknown', 'in_stock', 'limited', 'backorder', 'out_of_stock', 'contact_supplier')),
  supplier_quantity integer check (supplier_quantity is null or supplier_quantity >= 0),
  source_timestamp timestamptz not null,
  fetched_at timestamptz not null default now(),
  import_run_id uuid references catalog_private.import_runs(id) on delete set null,
  validation_status text not null default 'pending'
    check (validation_status in ('pending', 'validated', 'rejected', 'stale')),
  validation_notes text
);
create index catalog_inventory_snapshots_variant_fetched_idx
  on catalog_private.inventory_snapshots (variant_id, fetched_at desc);
create index catalog_inventory_snapshots_supplier_fetched_idx
  on catalog_private.inventory_snapshots (supplier_id, fetched_at desc);

create table catalog_private.import_rows (
  id uuid primary key default gen_random_uuid(),
  import_run_id uuid not null references catalog_private.import_runs(id) on delete cascade,
  row_number integer not null check (row_number > 0),
  row_fingerprint text not null,
  validation_status text not null default 'pending'
    check (validation_status in ('pending', 'accepted', 'rejected', 'quarantined')),
  quarantine_reason text,
  error_summary text,
  created_at timestamptz not null default now(),
  unique (import_run_id, row_number),
  unique (import_run_id, row_fingerprint)
);

create table catalog_private.audit_events (
  id uuid primary key default gen_random_uuid(),
  actor_type text not null check (actor_type in ('user', 'service', 'system')),
  actor_reference text,
  action text not null,
  record_type text not null,
  record_id uuid,
  occurred_at timestamptz not null default now(),
  safe_change_summary jsonb not null default '{}'::jsonb
    check (jsonb_typeof(safe_change_summary) = 'object')
);
create index catalog_audit_events_record_idx
  on catalog_private.audit_events (record_type, record_id, occurred_at desc);

-- RLS is enabled on every new table. Browser roles receive read-only access
-- only to explicitly approved public catalog rows.
alter table public.catalog_manufacturers enable row level security;
alter table public.catalog_categories enable row level security;
alter table public.catalog_products enable row level security;
alter table public.catalog_product_categories enable row level security;
alter table public.catalog_variants enable row level security;
alter table public.catalog_media enable row level security;

alter table catalog_private.source_records enable row level security;
alter table catalog_private.product_source_links enable row level security;
alter table catalog_private.map_evidence enable row level security;
alter table catalog_private.media_rights enable row level security;
alter table catalog_private.suppliers enable row level security;
alter table catalog_private.supplier_variant_map enable row level security;
alter table catalog_private.import_runs enable row level security;
alter table catalog_private.import_rows enable row level security;
alter table catalog_private.inventory_snapshots enable row level security;
alter table catalog_private.audit_events enable row level security;

create policy catalog_manufacturers_public_read
  on public.catalog_manufacturers for select to anon, authenticated
  using (is_active);

create policy catalog_categories_public_read
  on public.catalog_categories for select to anon, authenticated
  using (is_active);

create policy catalog_products_public_read
  on public.catalog_products for select to anon, authenticated
  using (is_published and is_verified and lifecycle_status = 'active');

create policy catalog_product_categories_public_read
  on public.catalog_product_categories for select to anon, authenticated
  using (
    exists (
      select 1 from public.catalog_products p
      join public.catalog_categories c on c.id = catalog_product_categories.category_id
      where p.id = catalog_product_categories.product_id
        and p.is_published and p.is_verified and p.lifecycle_status = 'active'
        and c.is_active
    )
  );

create policy catalog_variants_public_read
  on public.catalog_variants for select to anon, authenticated
  using (
    is_published and is_verified and lifecycle_status = 'active'
    and exists (
      select 1 from public.catalog_products p
      where p.id = catalog_variants.product_id
        and p.is_published and p.is_verified and p.lifecycle_status = 'active'
    )
  );

create policy catalog_media_public_read
  on public.catalog_media for select to anon, authenticated
  using (
    is_published
    and exists (
      select 1 from public.catalog_products p
      where p.id = catalog_media.product_id
        and p.is_published and p.is_verified and p.lifecycle_status = 'active'
    )
    and (
      variant_id is null or exists (
        select 1 from public.catalog_variants v
        where v.id = catalog_media.variant_id
          and v.product_id = catalog_media.product_id
          and v.is_published and v.is_verified and v.lifecycle_status = 'active'
      )
    )
  );

-- Explicit Data API grants: SELECT only for browsers, full catalog access
-- for trusted server-side workflows. No browser access to catalog_private.
grant select on public.catalog_manufacturers, public.catalog_categories,
  public.catalog_products, public.catalog_product_categories,
  public.catalog_variants, public.catalog_media to anon, authenticated;
grant select, insert, update, delete on public.catalog_manufacturers,
  public.catalog_categories, public.catalog_products,
  public.catalog_product_categories, public.catalog_variants,
  public.catalog_media to service_role;

grant select, insert, update, delete on all tables in schema catalog_private to service_role;

comment on schema catalog_private is
  'Non-exposed BZaudio catalog evidence, supplier, inventory, import, and audit records. Never grant browser roles access.';
comment on table public.catalog_products is
  'Physical pro-audio equipment catalog. Separate from the existing digital-download products table domain.';
comment on table public.catalog_variants is
  'Physical equipment variants. MAP and availability fields are publishable only after server-side evidence validation.';
