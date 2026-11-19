-- Isolated PostgreSQL integration checks for the physical catalog migration.
-- Run only against a disposable database, never the production Supabase project.

\set ON_ERROR_STOP on
BEGIN;

INSERT INTO public.catalog_manufacturers (slug, name, website_url, is_active)
VALUES
  ('test-manufacturer', 'Test Manufacturer', 'https://manufacturer.example', true),
  ('inactive-manufacturer', 'Inactive Manufacturer', 'https://inactive.example', false);

INSERT INTO public.catalog_products (
  manufacturer_id, slug, name, model_number, lifecycle_status, is_verified, is_published
)
SELECT id, 'visible-product', 'Visible Product', 'VISIBLE-1', 'active', true, true
FROM public.catalog_manufacturers WHERE slug = 'test-manufacturer';

INSERT INTO public.catalog_products (
  manufacturer_id, slug, name, model_number, lifecycle_status, is_verified, is_published
)
SELECT id, 'hidden-product', 'Hidden Product', 'HIDDEN-1', 'active', false, true
FROM public.catalog_manufacturers WHERE slug = 'test-manufacturer';

INSERT INTO catalog_private.suppliers (legal_name, authorization_status)
VALUES ('Private Test Supplier', 'unverified');

SET ROLE anon;
DO $$
DECLARE visible_count integer;
BEGIN
  SELECT count(*) INTO visible_count FROM public.catalog_products;
  IF visible_count <> 1 THEN
    RAISE EXCEPTION 'anon should see exactly one verified published active product; saw %', visible_count;
  END IF;

  SELECT count(*) INTO visible_count FROM public.catalog_manufacturers;
  IF visible_count <> 1 THEN
    RAISE EXCEPTION 'anon should see only active manufacturers; saw %', visible_count;
  END IF;

  BEGIN
    INSERT INTO public.catalog_manufacturers (slug, name, website_url)
    VALUES ('anon-write', 'Unauthorized', 'https://unauthorized.example');
    RAISE EXCEPTION 'anon unexpectedly inserted a manufacturer';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;

  BEGIN
    PERFORM count(*) FROM catalog_private.suppliers;
    RAISE EXCEPTION 'anon unexpectedly read private suppliers';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;
END
$$;
RESET ROLE;

SET ROLE authenticated;
DO $$
DECLARE visible_count integer;
BEGIN
  SELECT count(*) INTO visible_count FROM public.catalog_products;
  IF visible_count <> 1 THEN
    RAISE EXCEPTION 'authenticated customer should see exactly one approved product; saw %', visible_count;
  END IF;

  BEGIN
    UPDATE public.catalog_products SET is_published = true WHERE slug = 'hidden-product';
    RAISE EXCEPTION 'authenticated customer unexpectedly updated a product';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;

  BEGIN
    PERFORM count(*) FROM catalog_private.suppliers;
    RAISE EXCEPTION 'authenticated customer unexpectedly read private suppliers';
  EXCEPTION WHEN insufficient_privilege THEN
    NULL;
  END;
END
$$;
RESET ROLE;

SET ROLE service_role;
DO $$
DECLARE private_count integer;
BEGIN
  SELECT count(*) INTO private_count FROM catalog_private.suppliers;
  IF private_count <> 1 THEN
    RAISE EXCEPTION 'service_role should read private supplier records; saw %', private_count;
  END IF;
END
$$;
RESET ROLE;

ROLLBACK;
