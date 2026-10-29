-- PRODUCTION DATABASE BLUEPRINT (PostgreSQL / Supabase)
-- IMPORTANT: This schema is not connected to the local prototype.
-- Deploy only after adding Supabase Auth, role-based RLS, audit trails, and server-side operations.
create extension if not exists pgcrypto;
create table organizations (id uuid primary key default gen_random_uuid(),name text not null,created_at timestamptz not null default now());
create table organization_members (organization_id uuid not null references organizations(id),user_id uuid not null references auth.users(id),role text not null check(role in ('owner','admin','coordinator','finance')),primary key(organization_id,user_id));
create table clients (id uuid primary key default gen_random_uuid(),organization_id uuid not null references organizations(id),full_name text not null,email text,phone text,event_type text,event_date date,venue text,package_name text,estimated_amount numeric(12,2) not null default 0 check(estimated_amount>=0),stage text not null default 'Inquiry',notes text,created_at timestamptz not null default now());
create table quotations (id uuid primary key default gen_random_uuid(),organization_id uuid not null references organizations(id),client_id uuid not null references clients(id),version integer not null default 1,amount numeric(12,2) not null check(amount>=0),currency char(3) not null default 'PHP',inclusions text,status text not null default 'Draft' check(status in ('Draft','Sent','Approved','Revision Requested','Declined')),valid_until date,approved_at timestamptz,created_at timestamptz not null default now(),unique(client_id,version));
create table contracts (id uuid primary key default gen_random_uuid(),organization_id uuid not null references organizations(id),client_id uuid not null references clients(id),quotation_id uuid references quotations(id),terms text not null,status text not null default 'Draft' check(status in ('Draft','Sent','Signed','Cancelled')),signed_at timestamptz,signature_provider_id text,document_url text,created_at timestamptz not null default now());
create table invoices (id uuid primary key default gen_random_uuid(),organization_id uuid not null references organizations(id),client_id uuid not null references clients(id),contract_id uuid references contracts(id),invoice_number text not null,amount numeric(12,2) not null check(amount>=0),due_date date,status text not null default 'Draft' check(status in ('Draft','Sent','Partially Paid','Paid','Void')),created_at timestamptz not null default now(),unique(organization_id,invoice_number));
create table payments (id uuid primary key default gen_random_uuid(),organization_id uuid not null references organizations(id),invoice_id uuid not null references invoices(id),amount numeric(12,2) not null check(amount>0),method text,reference text,payment_date date not null,status text not null default 'Pending Verification' check(status in ('Pending Verification','Verified','Rejected')),verified_by uuid references auth.users(id),verified_at timestamptz,created_at timestamptz not null default now());
create table events (id uuid primary key default gen_random_uuid(),organization_id uuid not null references organizations(id),client_id uuid not null references clients(id),title text not null,event_date date,venue text,status text not null default 'Planning',created_at timestamptz not null default now());
create table activity_log (id uuid primary key default gen_random_uuid(),organization_id uuid not null references organizations(id),actor_id uuid references auth.users(id),entity_type text not null,entity_id uuid not null,action text not null,metadata jsonb not null default '{}'::jsonb,created_at timestamptz not null default now());
create index on clients(organization_id,stage);create index on clients(organization_id,event_date);create index on quotations(organization_id,client_id);create index on invoices(organization_id,client_id);create index on payments(organization_id,invoice_id);create index on activity_log(organization_id,created_at desc);
-- Fail closed: turn on RLS for ALL tenant tables. No public policies are created here.
-- Production access remains blocked until membership-based policies are reviewed and added.
alter table organizations enable row level security;
alter table organization_members enable row level security;
alter table clients enable row level security;
alter table quotations enable row level security;
alter table contracts enable row level security;
alter table invoices enable row level security;
alter table payments enable row level security;
alter table events enable row level security;
alter table activity_log enable row level security;
