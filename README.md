# Clinic credential reminders

A proposed self-service subscription for independent practices. An office manager imports a roster, records expiration dates, follows up on renewals, and exports a dated packet of staff records. The business is intended to operate under an independent brand, domain, billing account and infrastructure.

## What exists

This repository contains a draft Supabase schema, a synthetic spreadsheet example and an acquisition plan. The application, certificate storage policies, billing integration, reminder worker, packet generator and automated tests are planned. There are no customer cohorts, revenue records or acquisition results in this repository.

## Buyer and pilot offer

Start with independent dental offices employing 5–25 people. Medical spas are a second segment to investigate separately. Test **$39 per location per month or $390 per year**, up to 25 active staff, with a 14-day trial. These are product decisions. A paid pilot should establish whether the office values spreadsheet import, reliable follow-up and document retrieval enough to switch.

Comparable dental products already serve small teams. An enterprise-only comparison overstates the opportunity. Record each office's current tool, time spent preparing its last records request, quoted price, purchase decision and reason. [Market evidence, vendor rates and scenario calculations](docs/numbers-and-evidence.md)

## Proposed workflows

| Workflow | Acceptance condition for a pilot |
|---|---|
| Clinic setup | A manager can set the office timezone and invite or transfer responsibility to a successor. |
| Staff roster | Import the example CSV with a preview, identify duplicates and archive inactive staff. |
| Credential tracking | Record issuer, expiration date and optional certificate. Distinguish a missing credential or scan from an upcoming renewal. |
| Reminders | Proposed lead times are 90, 60, 30 and 7 calendar days plus the due date. Track staff and manager deliveries separately, recover overdue work after interruptions, and stop obsolete alerts after renewal. |
| Records packet | Export active staff, recorded dates, missing evidence and the preparation date in one action. Identify which documents the clinic reviewed. The packet represents clinic records. |

Use the clinic-local calendar date. Proposed labels are **Valid** above 90 days, **Expiring Soon** at 31–90, **Urgent** at 1–30, **Due today** at 0, and **Expired** below 0. These thresholds support office follow-up. Each issuer determines its own renewal requirements. The five rows describe workflows, including a background job and a report endpoint. Screen count and usability have yet to be tested.

## Implementation order

1. Validate the problem and offer with redacted rosters and a sample packet. Record whether a clinic actually pays.
2. Build the Next.js and Supabase workflow for onboarding, import, renewals and packet export. Test tenant isolation for records and files and keep billing fields server-managed.
3. Integrate Stripe Checkout, subscription webhooks and the Customer Portal. Test trial expiry, cancellations, duplicate events and the staff cap. Add a daily reminder worker and Resend delivery tracking. Evaluate Twilio separately after measuring demand and segment cost.
4. Pilot under observation. Test a missed scan, a failed recipient, a late import and a renewal. Measure setup time, delivery exceptions, support effort and receipts before expanding the acquisition channel.

The former 21-day schedule was a planning estimate. Dates for a paid launch depend on observed pilot outcomes. The draft SQL currently uses database dates and exact-day matching. It also lacks same-clinic composite references, worker-only view grants and per-recipient uniqueness. The acceptance conditions above describe work still to do. [Schema](database/schema.sql) · [Acquisition experiment](seo_templates/landing_pages_plan.md) · [Example CSV](seo_templates/dental_license_tracker_template.csv)
