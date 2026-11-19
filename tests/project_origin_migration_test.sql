-- Runs against a disposable PostgreSQL instance in CI, never production.
create role anon nologin;
create role authenticated nologin;
create schema auth;
create table auth.users (
  id uuid primary key,
  email text unique
);
create function auth.uid() returns uuid
language sql stable
as $$ select nullif(current_setting('request.jwt.claim.sub', true), '')::uuid $$;
create function auth.jwt() returns jsonb
language sql stable
as $$ select coalesce(nullif(current_setting('request.jwt.claims', true), '')::jsonb, '{}'::jsonb) $$;
grant usage on schema auth to anon, authenticated;
grant execute on function auth.uid() to anon, authenticated;
grant execute on function auth.jwt() to anon, authenticated;

\i supabase/migrations/20261119170000_project_origin_membership.sql

insert into auth.users(id,email) values
  ('00000000-0000-4000-8000-000000000001','benrz101@gmail.com'),
  ('00000000-0000-4000-8000-000000000002','applicant@example.com');

-- Privilege regression checks: public roles must not read contribution amounts
-- or execute privileged SECURITY DEFINER routines.
do $$
begin
  if has_column_privilege('anon','public.project_origin_founders','contribution_amount','select') then
    raise exception 'anon can read private Founder contribution amounts';
  end if;
  if has_column_privilege('authenticated','public.project_origin_founders','contribution_amount','select') then
    raise exception 'authenticated users can read private Founder contribution amounts';
  end if;
  if has_function_privilege('anon','public.project_origin_review_application(uuid,text,text)','execute') then
    raise exception 'anon can execute the owner review function';
  end if;
  if has_function_privilege('anon','public.project_origin_assign_founder(uuid,text,integer,numeric,text,boolean,text)','execute') then
    raise exception 'anon can execute Founder assignment';
  end if;
  if has_function_privilege('anon','public.project_origin_admin_founders()','execute') then
    raise exception 'anon can execute the private Founder register';
  end if;
end;
$$;

-- Applicant can create and read only their own application.
set role authenticated;
select set_config('request.jwt.claim.sub','00000000-0000-4000-8000-000000000002',false);
select set_config('request.jwt.claims','{"sub":"00000000-0000-4000-8000-000000000002","email":"applicant@example.com"}',false);
insert into public.project_origin_applications(user_id,full_name,email,message)
values ('00000000-0000-4000-8000-000000000002','Test Applicant','applicant@example.com','CI test');
do $$
begin
  if public.project_origin_is_admin() then raise exception 'Applicant incorrectly has admin access'; end if;
  if (select count(*) from public.project_origin_applications) <> 1 then
    raise exception 'Applicant cannot read their own application';
  end if;
end;
$$;
reset role;

-- Verified owner email bootstraps admin access, then approval creates membership.
set role authenticated;
select set_config('request.jwt.claim.sub','00000000-0000-4000-8000-000000000001',false);
select set_config('request.jwt.claims','{"sub":"00000000-0000-4000-8000-000000000001","email":"benrz101@gmail.com"}',false);
do $$
begin
  if not public.project_origin_is_admin() then raise exception 'Owner was not bootstrapped as admin'; end if;
end;
$$;
select public.project_origin_review_application(
  (select id from public.project_origin_applications where email='applicant@example.com'),
  'approved', null
);
select public.project_origin_assign_founder(
  '00000000-0000-4000-8000-000000000002','Test Applicant',7,100.00,'Test Applicant',true,'CI test'
);
do $$
begin
  if (select count(*) from public.project_origin_members where user_id='00000000-0000-4000-8000-000000000002' and active) <> 1 then
    raise exception 'Approval did not create active membership';
  end if;
  if (select count(*) from public.project_origin_admin_founders()) <> 1 then
    raise exception 'Owner-only Founder register did not return assigned Founder';
  end if;
end;
$$;
reset role;

-- Anonymous visitors may see public recognition fields, never private money data.
set role anon;
do $$
begin
  if (select count(*) from public.project_origin_founders) <> 1 then
    raise exception 'Public Founder recognition is not visible';
  end if;
end;
$$;
reset role;
