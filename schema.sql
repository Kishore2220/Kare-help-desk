-- Run this in Supabase -> SQL Editor

-- 1. Profiles (one row per student/admin)
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  register_number text unique not null,
  full_name text,
  role text not null default 'student' check (role in ('student','admin')),
  created_at timestamptz default now()
);

-- auto-create a profile when someone registers
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, register_number, full_name)
  values (new.id,
          new.raw_user_meta_data->>'register_number',
          new.raw_user_meta_data->>'full_name');
  return new;
end $$;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

-- helper: is the current user an admin?
create or replace function public.is_admin()
returns boolean language sql security definer set search_path = public stable as $$
  select exists (select 1 from public.profiles where id = auth.uid() and role = 'admin');
$$;

-- 2. Complaints
create sequence public.complaint_seq start 1024;

create table public.complaints (
  id bigint primary key default nextval('public.complaint_seq'),
  student_id uuid not null references public.profiles(id) on delete cascade,
  category text not null,
  location text,
  description text not null,
  image_url text,
  status text not null default 'Pending'
         check (status in ('Pending','In Progress','Resolved')),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);
-- shown in the app as "KARE-" || id

-- 3. Row Level Security
alter table public.profiles   enable row level security;
alter table public.complaints enable row level security;

create policy "own profile" on public.profiles
  for select using (id = auth.uid() or public.is_admin());

create policy "students read own complaints" on public.complaints
  for select using (student_id = auth.uid() or public.is_admin());

create policy "students create own complaints" on public.complaints
  for insert with check (student_id = auth.uid());

create policy "admin updates complaints" on public.complaints
  for update using (public.is_admin());

-- 4. Storage bucket for complaint photos
insert into storage.buckets (id, name, public) values ('complaint-images','complaint-images', true);

create policy "upload own images" on storage.objects
  for insert to authenticated with check (bucket_id = 'complaint-images');
create policy "read images" on storage.objects
  for select using (bucket_id = 'complaint-images');

-- 5. Make yourself admin (after registering in the app):
-- update public.profiles set role = 'admin' where register_number = 'YOURREGNO';

-- ============ Information tables (already created in your project) ============
-- programs(id, name, tuition, other_fee, years, sort_order)
-- subjects(id, program_id, year, name, sort_order)
-- info_items(id, section, group_title, title, subtitle, details, icon, action, sort_order)
-- Everyone signed in can read. Only admins can insert / update / delete.
