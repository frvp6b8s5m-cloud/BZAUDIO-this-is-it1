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

select 'catalog migration RLS/grants assertions passed' as result;
