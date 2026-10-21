-- HILLO v1 initial schema. Run only against the HILLO Supabase project.
create extension if not exists pgcrypto;
create table if not exists public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 display_name text not null default '',
 plz text check (plz is null or plz ~ '^[0-9]{5}$'),
 city text,
 is_helper boolean not null default false,
 bio text,
 created_at timestamptz not null default now()
);
create table if not exists public.tasks (
 id uuid primary key default gen_random_uuid(),
 owner_id uuid not null references public.profiles(id) on delete cascade,
 category text not null check (category in ('Haushalt','Einkauf','Garten')),
 title text not null check (char_length(title) between 3 and 120),
 description text not null default '',
 plz text not null check (plz ~ '^[0-9]{5}$'),
 status text not null default 'open' check (status in ('open','assigned','completed','cancelled')),
 created_at timestamptz not null default now()
);
create table if not exists public.messages (
 id uuid primary key default gen_random_uuid(),
 task_id uuid not null references public.tasks(id) on delete cascade,
 sender_id uuid not null references public.profiles(id) on delete cascade,
 recipient_id uuid not null references public.profiles(id) on delete cascade,
 body text not null check (char_length(body) between 1 and 3000),
 created_at timestamptz not null default now(),
 check (sender_id <> recipient_id)
);
create index if not exists tasks_plz_status_idx on public.tasks(plz,status);
create index if not exists messages_task_idx on public.messages(task_id,created_at);
alter table public.profiles enable row level security;
alter table public.tasks enable row level security;
alter table public.messages enable row level security;
create policy "Profiles visible to signed in users" on public.profiles for select to authenticated using (true);
create policy "Users create own profile" on public.profiles for insert to authenticated with check ((select auth.uid())=id);
create policy "Users update own profile" on public.profiles for update to authenticated using ((select auth.uid())=id) with check ((select auth.uid())=id);
create policy "Tasks visible to signed in users" on public.tasks for select to authenticated using (true);
create policy "Task owner inserts" on public.tasks for insert to authenticated with check ((select auth.uid())=owner_id);
create policy "Task owner updates" on public.tasks for update to authenticated using ((select auth.uid())=owner_id) with check ((select auth.uid())=owner_id);
create policy "Task owner deletes" on public.tasks for delete to authenticated using ((select auth.uid())=owner_id);
create policy "Message participants read" on public.messages for select to authenticated using ((select auth.uid())=sender_id or (select auth.uid())=recipient_id);
create policy "Message sender creates" on public.messages for insert to authenticated with check (
 (select auth.uid())=sender_id and
 exists (select 1 from public.tasks t where t.id=task_id and (t.owner_id=sender_id or t.owner_id=recipient_id))
);
grant select,insert,update on public.profiles to authenticated;
grant select,insert,update,delete on public.tasks to authenticated;
grant select,insert on public.messages to authenticated;
