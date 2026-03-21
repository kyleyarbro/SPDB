-- SHADOWPOINT WATCHTOWER V1 (FINAL FIXED SQL)

create extension if not exists pgcrypto;

-- =========================================
-- ALERTS TABLE (CORRECT VERSION)
-- =========================================
create table if not exists public.alerts (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  defendant_id uuid null,
  source_table text not null check (source_table in ('bail_intakes', 'recovery_requests')),
  case_name text null,
  case_number text null,
  county text null,
  alert_type text not null,
  severity text not null default 'Low' check (severity in ('Critical','High','Medium','Low')),
  title text not null,
  details text null,
  status text not null default 'New' check (status in ('New','Reviewed','Resolved','Closed')),
  assigned_agent text null,
  source_name text null,
  source_url text null,
  raw_payload jsonb null,
  resolved_at timestamptz null,
  resolved_by text null
);

-- =========================================
-- ALERT ACTIONS TABLE
-- =========================================
create table if not exists public.alert_actions (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default timezone('utc', now()),
  alert_id uuid not null references public.alerts(id) on delete cascade,
  action_type text not null,
  action_note text null,
  created_by text null default 'dashboard'
);

-- =========================================
-- INDEXES (SAFE)
-- =========================================
create index if not exists idx_alerts_created_at on public.alerts(created_at desc);
create index if not exists idx_alerts_status on public.alerts(status);
create index if not exists idx_alerts_severity on public.alerts(severity);
create index if not exists idx_alert_actions_alert_id on public.alert_actions(alert_id);
