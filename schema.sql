-- Run once in Supabase SQL Editor. All application data is private to the server.
create extension if not exists pgcrypto;
create table if not exists public.admins (
 id uuid primary key default gen_random_uuid(), username text not null unique,
 name text not null, role text not null check (role in ('owner','admin')),
 password_hash text not null, active boolean not null default true,
 session_version integer not null default 1, created_at timestamptz not null default now()
);
create unique index if not exists only_one_owner on public.admins(role) where role='owner';
create table if not exists public.profiles (
 id uuid primary key default gen_random_uuid(), name text not null, gender text not null,
 birth_year integer, height integer, region text not null default '', job text not null default '',
 intro text not null default '', ideal text not null default '', status text not null default '소개 가능',
 photos jsonb not null default '[]'::jsonb, consent boolean not null default false,
 created_at timestamptz not null default now()
);
create table if not exists public.invites (
 id uuid primary key default gen_random_uuid(), label text not null,
 token_hash text not null unique, profile_ids uuid[] not null default '{}',
 active boolean not null default true, expires_at timestamptz not null,
 created_at timestamptz not null default now()
);
create table if not exists public.login_attempts (
 id bigint generated always as identity primary key, ip_hash text not null,
 created_at timestamptz not null default now()
);
create index if not exists login_attempts_ip_time on public.login_attempts(ip_hash, created_at);
-- No direct browser database access; service-role requests only.
alter table public.admins enable row level security;
alter table public.profiles enable row level security;
alter table public.invites enable row level security;
alter table public.login_attempts enable row level security;
revoke all on public.admins, public.profiles, public.invites, public.login_attempts from anon, authenticated;
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types)
values ('profile-photos','profile-photos',false,2097152,array['image/jpeg','image/png','image/webp'])
on conflict (id) do update set public=false;
