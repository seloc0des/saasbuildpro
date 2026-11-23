# Standalone Vertical Compliance & Credential Reminder SaaS — Master Execution Blueprint

## 1. Strategic Mandate & Brand Separation
- **Core Objective:** Build a deterministic, low-maintenance ("set it and forget it") B2B micro-SaaS generating recurring subscription revenue.
- **Strict Brand Separation:** This entity, domain, GitHub repository, Stripe account, and infrastructure must remain **100% isolated** from SELO / SELODev and CindieForge.
- **No Marketplaces or Digital Downloads:** Direct B2B SaaS subscription sold via organic Google search intent and self-serve Stripe Checkout.

---

## 2. Validated Niche & Value Proposition
- **Target Vertical:** Independent Dental Practices & Med-Spas (5–25 staff per location).
- **The Pain Point:** Office managers rely on error-prone spreadsheets or paper binders to track staggered employee license renewals (State Dental/Hygiene/Esthetician licenses, DEA registrations, CPR/BLS cards, X-Ray/Radiology permits). Lapsed credentials risk state board fines, failed OSHA audits, and denied insurance claims.
- **The Solution:** A lightweight cloud tracker that stores staff credential expiration dates, automatically sends escalating email/SMS alerts before deadlines, and generates a 1-click PDF Audit Packet for inspections.
- **Why Enterprise Competitors Leave This Open:** Legacy healthcare compliance platforms (e.g., MedTrainer, Symplr) cost $2,000–$5,000+/year and require sales demos, pricing out solo clinics.

---

## 3. Definitive Pricing & Unit Economics
- **Pricing Model:** Flat **$39 / month** (or **$390 / year** — 2 months free) for up to 25 staff members per clinic location.
- **Trial Structure:** 14-day free trial (self-serve via Stripe Checkout).
- **Infrastructure Cost (0–100 Clinics):** ~$20 – $75 / month total (95%+ gross margin).
- **Breakeven Point:** **2 paying clinics** ($78/mo MRR covers fixed overhead).

### Revenue Milestones (Assuming 2.0% Monthly Churn)
| Active Clinics | Monthly Recurring Revenue (MRR) | Est. Monthly Infra + Stripe Fees | Est. Net Monthly Profit |
| :--- | :--- | :--- | :--- |
| **2 Clinics** | $78 | ~$62 | **~$16 (Breakeven)** |
| **25 Clinics** | $975 | ~$90 | **~$885 / mo** |
| **65 Clinics** | $2,535 | ~$136 | **~$2,399 / mo** |
| **130 Clinics** | $5,070 | ~$212 | **~$4,858 / mo** |

---

## 4. Zero-Maintenance Tech Stack
- **Frontend & API:** Next.js (App Router, TypeScript) hosted on **Vercel** (zero server maintenance, automatic SSL, static SSG for SEO pages).
- **Database, Auth & File Storage:** **Supabase** (Managed PostgreSQL with Row-Level Security, built-in magic-link/password Auth, private S3 bucket for certificate PDFs/photos, and `pg_cron`).
- **Scheduled Workers:** Supabase `pg_cron` + `pg_net` calling a secure Next.js `/api/cron/check-expirations` endpoint daily at 08:00 UTC.
- **Email & SMS Alerts:** **Resend** (transactional emails, 3,000/mo free tier) + **Twilio** (optional SMS alerts at ~$0.0079/msg).
- **Payments & Dunning:** **Stripe Billing** + **Stripe Customer Portal** (automatic invoices, card updates, failed-payment smart retries, and self-serve cancellation).

---

## 5. Strict v1 MVP Scope (5 Screens Only — Do Not Bloat)
1. **Onboarding & Clinic Settings:** Clinic name, primary office manager email/phone, timezone.
2. **Staff Roster (`/dashboard/staff`):** Add/edit/archive staff members (Full Name, Role, Email, Phone).
3. **Credential Tracker (`/dashboard/credentials`):** Assign credentials to staff (Credential Type, License/Cert Number, Expiration Date, Optional Certificate PDF/Image Upload). Status badges: `Valid` (>90d), `Expiring Soon` (<=90d), `Urgent` (<=30d), `Expired` (<0d).
4. **Automated Escalation Engine (Background Cron):**
   - Triggers alerts at **90 days, 60 days, 30 days, 7 days** before expiration, and **Day 0 (Expired)**.
   - Sends email to both the **Staff Member** and **Office Manager**.
   - Logs every sent alert in `notification_logs` to guarantee idempotency (never double-send).
5. **1-Click Inspector Audit Packet (`/api/audit-packet`):** Generates a clean, timestamped PDF listing all active staff, license numbers, expiration dates, compliance status, and links/pages for uploaded certificate scans.

---

## 6. 21-Day Execution Roadmap to First Dollar

### Week 1: Foundation & Database
- **Day 1:** Register a clean, clinical-sounding domain on Cloudflare (e.g., `dentapulse.io`, `clinicguard.co`, `renewtrack.health`). Set up isolated GitHub repo, Supabase project, Resend account, and Stripe account.
- **Day 2:** Run `database/schema.sql` in Supabase. Configure Row-Level Security (RLS) and private `certificates` storage bucket.
- **Day 3:** Scaffold Next.js + Tailwind + shadcn/ui app with Supabase Auth (signup, login, password reset).
- **Day 4–5:** Build Staff Roster CRUD and Credential CRUD + certificate file upload.

### Week 2: Automation, Billing & PDF Export
- **Day 6–7:** Build `/api/cron/check-expirations` route and Resend email templates (90/60/30/7/0-day alerts). Configure `pg_cron` trigger.
- **Day 8–9:** Build 1-Click PDF Audit Packet generator (`@react-pdf/renderer` or server-side HTML-to-PDF).
- **Day 10–11:** Integrate Stripe Checkout ($39/mo + $390/yr plans with 14-day trial), webhook listener (`/api/webhooks/stripe`), and Customer Portal button.
- **Day 12–14:** End-to-end testing (trial expiration, webhook sync, cron idempotency, RLS isolation).

### Week 3: Organic SEO Funnel & Launch
- **Day 15–17:** Build landing page + 15 static SEO checklist & template pages (using `seo_templates/landing_pages_plan.md` and `seo_templates/dental_license_tracker_template.csv`).
- **Day 18:** Submit XML sitemap to Google Search Console & Bing Webmaster Tools.
- **Day 19–21:** Post helpful free spreadsheet template links in dental office manager communities (Reddit `r/Dentistry`, Facebook dental office manager groups) to seed initial trial signups while Google indexes the SEO pages.
