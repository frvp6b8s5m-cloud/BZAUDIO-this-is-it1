-- Assert the physical-equipment catalog's RLS and grants.
do $$
declare
  item record;
  table_count integer;
  policy_count integer;
begin
  select count(*) into table_count
  from pg_class c
  join pg_namespace n on n.oid = c.relnamespace
  where c.relkind = 'r'
    and ((n.nspname = 'public' and c.relname like 'catalog_%')
      or n.nspname = 'catalog_private');

  if table_count <> 16 then
    raise exception 'Expected 16 catalog tables, found %', table_count;
  end if;

  for item in
    select n.nspname as schema_name, c.relname as table_name, c.relrowsecurity
    from pg_class c
    join pg_namespace n on n.oid = c.relnamespace
    where c.relkind = 'r'
      and ((n.nspname = 'public' and c.relname like 'catalog_%')
        or n.nspname = 'catalog_private')
  loop
    if not item.relrowsecurity then
      raise exception 'RLS is not enabled on %.%', item.schema_name, item.table_name;
    end if;

    if item.schema_name = 'public' then
      if not has_table_privilege('anon', format('%I.%I', item.schema_name, item.table_name), 'SELECT') then
        raise exception 'anon is missing SELECT on %.%', item.schema_name, item.table_name;
      end if;
      if has_table_privilege('anon', format('%I.%I', item.schema_name, item.table_name), 'INSERT')
        or has_table_privilege('anon', format('%I.%I', item.schema_name, item.table_name), 'UPDATE')
        or has_table_privilege('anon', format('%I.%I', item.schema_name, item.table_name), 'DELETE') then
        raise exception 'anon has write access on %.%', item.schema_name, item.table_name;
      end if;
    else
      if has_table_privilege('anon', format('%I.%I', item.schema_name, item.table_name), 'SELECT')
        or has_table_privilege('authenticated', format('%I.%I', item.schema_name, item.table_name), 'SELECT') then
        raise exception 'Browser role can read private table %.%', item.schema_name, item.table_name;
      end if;
    end if;
  end loop;

  if has_schema_privilege('anon', 'catalog_private', 'USAGE')
    or has_schema_privilege('authenticated', 'catalog_private', 'USAGE') then
    raise exception 'Browser role has USAGE on catalog_private';
  end if;

  if not has_table_privilege('service_role', 'catalog_private.suppliers', 'INSERT')
    or not has_table_privilege('service_role', 'public.catalog_products', 'INSERT') then
    raise exception 'service_role is missing required catalog write access';
  end if;

  select count(*) into policy_count
  from pg_policies
  where schemaname = 'public'
    and tablename like 'catalog_%'
    and policyname like 'catalog_%_public_read';

  if policy_count <> 6 then
    raise exception 'Expected 6 public read policies, found %', policy_count;
  end if;
end
$$;


-- Publication guards must reject missing source evidence and missing media rights.
insert into public.catalog_manufacturers (slug, name, website_url)
values ('ci-manufacturer', 'CI Manufacturer', 'https://www.shure.com');

insert into public.catalog_products (manufacturer_id, slug, name, lifecycle_status)
select id, 'ci-product', 'CI Product', 'active'
from public.catalog_manufacturers where slug = 'ci-manufacturer';

do $
declare
  product_id uuid;
  blocked boolean := false;
begin
  select id into product_id from public.catalog_products where slug = 'ci-product';

  begin
    update public.catalog_products set is_verified = true where id = product_id;
  exception when check_violation then
    blocked := true;
  end;

  if not blocked then
    raise exception 'Product was verified without approved source evidence';
  end if;
end
$;

insert into catalog_private.source_records (
  manufacturer_id, source_url, source_type, source_title, review_status
)
select id, 'https://www.shure.com/en-US/products', 'manufacturer', 'CI source', 'approved'
from public.catalog_manufacturers where slug = 'ci-manufacturer';

insert into catalog_private.product_source_links (
  product_id, source_record_id, fact_scope, verification_status
)
select p.id, s.id, 'identity', 'verified'
from public.catalog_products p
cross join catalog_private.source_records s
where p.slug = 'ci-product' and s.source_title = 'CI source';

update public.catalog_products
set is_verified = true, is_published = true
where slug = 'ci-product';

insert into public.catalog_variants (product_id, variant_name, lifecycle_status)
select id, 'CI variant', 'active'
from public.catalog_products where slug = 'ci-product';

do $
declare
  variant_id uuid;
  blocked boolean := false;
begin
  select id into variant_id from public.catalog_variants where variant_name = 'CI variant';

  begin
    update public.catalog_variants set is_verified = true where id = variant_id;
  exception when check_violation then
    blocked := true;
  end;

  if not blocked then
    raise exception 'Variant was verified without approved source evidence';
  end if;
end
$;

insert into catalog_private.product_source_links (
  variant_id, source_record_id, fact_scope, verification_status
)
select v.id, s.id, 'identity', 'verified'
from public.catalog_variants v
cross join catalog_private.source_records s
where v.variant_name = 'CI variant' and s.source_title = 'CI source';

update public.catalog_variants
set is_verified = true, is_published = true
where variant_name = 'CI variant';

insert into public.catalog_media (product_id, variant_id, asset_url, alt_text)
select p.id, v.id, 'https://www.shure.com/assets/ci-test.jpg', 'CI test image'
from public.catalog_products p
join public.catalog_variants v on v.product_id = p.id
where p.slug = 'ci-product' and v.variant_name = 'CI variant';

do $
declare
  media_id uuid;
  blocked boolean := false;
begin
  select id into media_id from public.catalog_media where alt_text = 'CI test image';

  begin
    update public.catalog_media set is_published = true where id = media_id;
  exception when check_violation then
    blocked := true;
  end;

  if not blocked then
    raise exception 'Media was published without approved usage rights';
  end if;
end
$;

insert into catalog_private.media_rights (
  media_id, rights_holder, permission_type, allowed_channels,
  proof_reference, approval_status, reviewed_at
)
select id, 'CI Rights Holder', 'written permission', array['website'],
  'ci-test-proof', 'approved', now()
from public.catalog_media where alt_text = 'CI test image';

update public.catalog_media
set is_published = true
where alt_text = 'CI test image';

do $
begin
  if (select count(*) from public.catalog_products where slug = 'ci-product' and is_published) <> 1 then
    raise exception 'Approved product did not publish';
  end if;
  if (select count(*) from public.catalog_variants where variant_name = 'CI variant' and is_published) <> 1 then
    raise exception 'Approved variant did not publish';
  end if;
  if (select count(*) from public.catalog_media where alt_text = 'CI test image' and is_published) <> 1 then
    raise exception 'Media with approved rights did not publish';
  end if;
end
$;

select 'catalog migration RLS/grants/publication assertions passed' as result;
