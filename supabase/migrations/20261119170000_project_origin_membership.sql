-- PROJECT ORIGIN secure membership foundation
-- Apply only after owner-approved release gate. No Founder number is ever auto-assigned.
create extension if not exists pgcrypto;

create table if not exists public.project_origin_admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  email text not null unique,
  created_at timestamptz not null default now()
);
alter table public.project_origin_admins enable row level security;

create table if not exists public.project_origin_applications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references auth.users(id) on delete cascade,
  full_name text not null check (char_length(trim(full_name)) between 2 and 120),
  email text not null,
  message text not null default '' check (char_length(message) <= 2000),
  status text not null default 'pending' check (status in ('pending','approved','declined')),
  submitted_at timestamptz not null default now(),
  reviewed_at timestamptz,
  reviewed_by uuid references auth.users(id),
  review_note text
);
create unique index if not exists project_origin_applications_email_lower_uidx on public.project_origin_applications (lower(email));
alter table public.project_origin_applications enable row level security;

create table if not exists public.project_origin_members (
  user_id uuid primary key references auth.users(id) on delete cascade,
  application_id uuid unique references public.project_origin_applications(id),
  member_since timestamptz not null default now(),
  active boolean not null default true,
  approved_by uuid not null references auth.users(id)
);
alter table public.project_origin_members enable row level security;

create table if not exists public.project_origin_founders (
  id uuid primary key default gen_random_uuid(),
  user_id uuid unique references auth.users(id) on delete set null,
  display_name text not null check (char_length(trim(display_name)) between 2 and 120),
  founder_number integer not null unique check (founder_number > 0),
  contribution_amount numeric(12,2) not null check (contribution_amount >= 0),
  card_engraving_name text not null check (char_length(trim(card_engraving_name)) between 2 and 120),
  publicly_listed boolean not null default false,
  assigned_by uuid not null references auth.users(id),
  assigned_at timestamptz not null default now(),
  notes text
);
alter table public.project_origin_founders enable row level security;

create table if not exists public.project_origin_member_content (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(trim(title)) between 1 and 160),
  body text not null,
  published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.project_origin_member_content enable row level security;

create table if not exists public.project_origin_audit (
  id bigint generated always as identity primary key,
  actor_id uuid not null references auth.users(id),
  action text not null,
  application_id uuid references public.project_origin_applications(id),
  founder_id uuid references public.project_origin_founders(id),
  details jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
alter table public.project_origin_audit enable row level security;

create or replace function public.project_origin_is_admin()
returns boolean language sql stable security definer set search_path = public, auth
as $$
  select exists (
    select 1 from public.project_origin_admins a
    where a.user_id = auth.uid()
      and lower(a.email) = lower(coalesce(auth.jwt() ->> 'email',''))
  );
$$;

create or replace function public.project_origin_review_application(
  p_application_id uuid,
  p_decision text,
  p_review_note text default null
) returns void
language plpgsql security definer set search_path = public, auth
as $$
declare
  v_app public.project_origin_applications%rowtype;
begin
  if not public.project_origin_is_admin() then
    raise exception 'Not authorized' using errcode = '42501';
  end if;
  if p_decision not in ('approved','declined') then
    raise exception 'Decision must be approved or declined';
  end if;
  select * into v_app from public.project_origin_applications
    where id = p_application_id for update;
  if not found then raise exception 'Application not found'; end if;
  if v_app.status <> 'pending' then raise exception 'Application has already been reviewed'; end if;

  update public.project_origin_applications
    set status = p_decision, reviewed_at = now(), reviewed_by = auth.uid(),
        review_note = nullif(trim(coalesce(p_review_note,'')),'')
    where id = p_application_id;

  if p_decision = 'approved' then
    insert into public.project_origin_members(user_id, application_id, approved_by)
      values (v_app.user_id, v_app.id, auth.uid())
      on conflict (user_id) do update set active = true, application_id = excluded.application_id,
        approved_by = excluded.approved_by;
  end if;

  insert into public.project_origin_audit(actor_id, action, application_id, details)
    values (auth.uid(), 'application_' || p_decision, v_app.id,
      jsonb_build_object('applicant_email', v_app.email));
end;
$$;

create or replace function public.project_origin_assign_founder(
  p_user_id uuid,
  p_display_name text,
  p_founder_number integer,
  p_contribution_amount numeric,
  p_card_engraving_name text,
  p_publicly_listed boolean default false,
  p_notes text default null
) returns uuid
language plpgsql security definer set search_path = public, auth
as $$
declare v_id uuid;
begin
  if not public.project_origin_is_admin() then
    raise exception 'Not authorized' using errcode = '42501';
  end if;
  if not exists (select 1 from public.project_origin_members m where m.user_id=p_user_id and m.active) then
    raise exception 'Only approved active members can be assigned Founder recognition';
  end if;
  insert into public.project_origin_founders(
    user_id, display_name, founder_number, contribution_amount,
    card_engraving_name, publicly_listed, assigned_by, notes
  ) values (
    p_user_id, trim(p_display_name), p_founder_number, p_contribution_amount,
    trim(p_card_engraving_name), p_publicly_listed, auth.uid(), nullif(trim(coalesce(p_notes,'')),'')
  ) returning id into v_id;
  insert into public.project_origin_audit(actor_id, action, founder_id, details)
    values (auth.uid(), 'founder_number_manually_assigned', v_id,
      jsonb_build_object('founder_number', p_founder_number, 'contribution_amount', p_contribution_amount));
  return v_id;
end;
$$;

create or replace function public.project_origin_admin_founders()
returns table(display_name text, founder_number integer, contribution_amount numeric, publicly_listed boolean)
language plpgsql security definer set search_path = public, auth
as $
begin
  if not public.project_origin_is_admin() then
    raise exception 'Not authorized' using errcode = '42501';
  end if;
  return query
    select f.display_name, f.founder_number, f.contribution_amount, f.publicly_listed
    from public.project_origin_founders f
    order by f.founder_number;
end;
$;

-- SECURITY DEFINER functions in public must not inherit PostgreSQL's default
-- PUBLIC execute grant. The bootstrap function is trigger-only.
revoke all on function public.project_origin_is_admin() from public, anon;
revoke all on function public.project_origin_review_application(uuid,text,text) from public, anon;
revoke all on function public.project_origin_assign_founder(uuid,text,integer,numeric,text,boolean,text) from public, anon;
revoke all on function public.project_origin_admin_founders() from public, anon;
revoke all on function public.project_origin_bootstrap_owner() from public, anon, authenticated;
grant execute on function public.project_origin_is_admin() to authenticated;
grant execute on function public.project_origin_review_application(uuid,text,text) to authenticated;
grant execute on function public.project_origin_assign_founder(uuid,text,integer,numeric,text,boolean,text) to authenticated;
grant execute on function public.project_origin_admin_founders() to authenticated;

-- Public Founder recognition must never expose contribution amounts, account IDs,
-- reviewer IDs, or private notes through the Data API.
revoke select on public.project_origin_founders from anon, authenticated;
grant select (display_name, founder_number, card_engraving_name)
  on public.project_origin_founders to anon, authenticated;

create policy "admins read admin allowlist" on public.project_origin_admins
  for select to authenticated using (public.project_origin_is_admin());
create policy "applicants create own application" on public.project_origin_applications
  for insert to authenticated with check (
    user_id = auth.uid()
    and lower(email) = lower(coalesce(auth.jwt() ->> 'email',''))
  );
create policy "applicants and admins read applications" on public.project_origin_applications
  for select to authenticated using (user_id = auth.uid() or public.project_origin_is_admin());
create policy "admins update applications" on public.project_origin_applications
  for update to authenticated using (public.project_origin_is_admin()) with check (public.project_origin_is_admin());
create policy "members read own membership" on public.project_origin_members
  for select to authenticated using (user_id = auth.uid() or public.project_origin_is_admin());
create policy "admins manage memberships" on public.project_origin_members
  for all to authenticated using (public.project_origin_is_admin()) with check (public.project_origin_is_admin());
create policy "public sees listed founders" on public.project_origin_founders
  for select to anon, authenticated using (publicly_listed = true);
create policy "admins manage founders" on public.project_origin_founders
  for all to authenticated using (public.project_origin_is_admin()) with check (public.project_origin_is_admin());
create policy "active members read published content" on public.project_origin_member_content
  for select to authenticated using (
    published = true and exists (
      select 1 from public.project_origin_members m where m.user_id = auth.uid() and m.active
    )
  );
create policy "admins manage member content" on public.project_origin_member_content
  for all to authenticated using (public.project_origin_is_admin()) with check (public.project_origin_is_admin());
create policy "admins read audit log" on public.project_origin_audit
  for select to authenticated using (public.project_origin_is_admin());

grant select, insert on public.project_origin_applications to authenticated;
grant update on public.project_origin_applications to authenticated;
grant select on public.project_origin_admins, public.project_origin_members, public.project_origin_member_content to authenticated;
grant select on public.project_origin_founders to anon, authenticated;
grant insert, update, delete on public.project_origin_members, public.project_origin_founders, public.project_origin_member_content to authenticated;
grant select on public.project_origin_audit to authenticated;
grant usage, select on sequence public.project_origin_audit_id_seq to authenticated;
grant execute on function public.project_origin_is_admin() to authenticated;
grant execute on function public.project_origin_review_application(uuid,text,text) to authenticated;
grant execute on function public.project_origin_assign_founder(uuid,text,integer,numeric,text,boolean,text) to authenticated;

-- Bootstrap the owner after the owner creates their Supabase account. This trigger
-- binds admin authority to the immutable auth.users email, never user-editable metadata.
create or replace function public.project_origin_bootstrap_owner()
returns trigger language plpgsql security definer set search_path = public, auth
as $$
begin
  if lower(coalesce(new.email,'')) = 'benrz101@gmail.com' then
    insert into public.project_origin_admins(user_id,email)
      values(new.id, lower(new.email))
      on conflict (user_id) do nothing;
  end if;
  return new;
end;
$$;
drop trigger if exists project_origin_owner_bootstrap on auth.users;
create trigger project_origin_owner_bootstrap
  after insert or update of email on auth.users
  for each row execute function public.project_origin_bootstrap_owner();

-- Backfill owner admin if the account already exists.
insert into public.project_origin_admins(user_id,email)
select id, lower(email) from auth.users where lower(email)='benrz101@gmail.com'
on conflict (user_id) do nothing;
