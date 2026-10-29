# Ohana Events & Management — Admin CRM Starter

A polished, interactive **Next.js** admin workflow prototype for Ohana Events & Management by TINE YC.

## Start locally

```bash
npm install
npm run dev
```

Open http://localhost:3000.

## Deploy to Vercel

1. Extract the ZIP and upload its folder to a new GitHub repository.
2. In Vercel, select **Add New → Project → Import Git Repository**.
3. Keep framework preset **Next.js**, then deploy.
4. No environment variables are required for the local-only prototype.

## Included workflows

- Dashboard: booking pipeline, action center, invoiced/collected/outstanding totals.
- Client CRM: add inquiries, search, inspect client profile and checklist, export CSV.
- Quotations: create versions, mark sent/approved/revision, printable document.
- Contracts: draft, mark sent/signed, printable document.
- Invoices: draft, mark sent, due dates, verified balance and printable document.
- Payments: record transactions, verify/reject, update invoice balances.
- Events: show confirmed/partially paid events and completion status.
- Data persists in **browser localStorage**, not a server database.

## IMPORTANT — Not production-ready

This is an **interactive front-end prototype**, not a secure deployed business application. It has no authentication, access controls, shared database, secure file uploads, real e-signatures, automated email sending, payment gateway, or live client portal. Data is browser-local, can be lost on browser reset, and is not shared across devices. Sample records are fictional. Do **not** enter actual customer personal data into a publicly accessible deployment.

Status changes such as "Sent", "Approved", and "Signed" are manual admin marks and **do not send messages or obtain client consent**. The print feature creates a draft document and is not a validated invoice, receipt, or legally reviewed contract.

## Production database blueprint

`database/schema.sql` defines tenant-aware PostgreSQL tables for organizations, users, clients, quotations, contracts, invoices, payments, events, and audit logs. Row-level security is enabled without permissive policies (fail-closed). **The front end does not yet use this schema.**

## Production roadmap (recommended order)

1. Supabase Auth: owner/admin/finance/coordinator roles; secure invite and password reset.
2. Server-side Next.js actions and Supabase Postgres persistence with membership-based RLS, server validation, transactional writes, and organization ownership checks. Do not expose service-role keys in browser code.
3. Client approval portal with expiring signed links and approval audit trail; immutable quotation version snapshots.
4. Contract template management, PDF generation, secure e-signature integration, and signed-document storage.
5. Invoice numbering, payment schedules/installments, official tax/receipt compliance review, and payment proof upload with admin verification.
6. Email provider integration for sending quotations/contracts/invoices and delivery logs; reminders and webhook retries.
7. Event planning checklists, suppliers, crew meals, guest counts, timelines, tasks, and calendar.
8. Reports, exports, automated backups, data retention, consent/privacy policies, and full audit logging.

## Suggested lifecycle rules

- Inquiry → quotation draft → quotation sent → client approved or revision requested.
- Approved quotation → contract generated from approved snapshot → contract signed.
- Signed contract → invoice generated → invoice sent → payment verified.
- Booking confirmed according to configurable deposit policy, **not automatically based on full payment**.
- Event planning workspace created on confirmation; remaining balances tracked until settled.

## Notes for Philippine operations

Review contracts, data privacy, receipts, and tax invoicing with qualified local professionals before production use. Amounts are in PHP. Use a real signature provider for enforceable acceptance records and a verified payment provider for real payments.
