-- XC Race Clock: run this once in Supabase → SQL Editor → New query → Run.

create table if not exists public.races (
  meet text primary key check (char_length(meet) between 8 and 40),
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

create table if not exists public.logs (
  id text primary key,
  meet text not null check (char_length(meet) between 8 and 40),
  race_id text not null,
  cp int not null,
  device text not null,
  coach text,
  taps jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);
create index if not exists logs_meet_race on public.logs (meet, race_id);

-- Anyone with the page (and a meet code) can read and write race data. No logins needed.
alter table public.races enable row level security;
alter table public.logs  enable row level security;
grant select, insert, update on public.races, public.logs to anon, authenticated;

drop policy if exists "xc read races"   on public.races;
drop policy if exists "xc add races"    on public.races;
drop policy if exists "xc change races" on public.races;
create policy "xc read races"   on public.races for select to anon, authenticated using (true);
create policy "xc add races"    on public.races for insert to anon, authenticated with check (char_length(meet) >= 8);
create policy "xc change races" on public.races for update to anon, authenticated using (true) with check (char_length(meet) >= 8);

drop policy if exists "xc read logs"   on public.logs;
drop policy if exists "xc add logs"    on public.logs;
drop policy if exists "xc change logs" on public.logs;
create policy "xc read logs"   on public.logs for select to anon, authenticated using (true);
create policy "xc add logs"    on public.logs for insert to anon, authenticated with check (char_length(meet) >= 8);
create policy "xc change logs" on public.logs for update to anon, authenticated using (true) with check (char_length(meet) >= 8);

-- Server clock, so every phone's race clock matches to a fraction of a second.
create or replace function public.server_now_ms() returns bigint
language sql stable as $$ select (extract(epoch from clock_timestamp()) * 1000)::bigint $$;
grant execute on function public.server_now_ms() to anon, authenticated;

-- Send live updates to every open phone.
do $$ begin
  begin alter publication supabase_realtime add table public.races; exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.logs;  exception when duplicate_object then null; end;
end $$;
