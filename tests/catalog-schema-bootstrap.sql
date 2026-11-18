-- Disposable PostgreSQL harness for the catalog migration CI test.
-- This runs only inside the GitHub Actions service container.
create role anon nologin;
create role authenticated nologin;
create role service_role nologin bypassrls;
create schema auth;
create function auth.uid() returns uuid
language sql stable
as $$ select null::uuid $$;
