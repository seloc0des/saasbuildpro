# Numerical evidence and operating model

Reviewed November 23, 2026. Prices are published US-dollar offers. Calculations below are illustrative US scenarios. This repository supplies no measured sales, cohorts, search traffic, delivery volume, operating invoices or support time. The original milestones are retained so a reader can reproduce and compare the projections.

## Buyers and comparable products

| Question | Evidence and limit |
|---|---|
| Is a small dental office a plausible buyer? | In the ADA's 2023 data, 35.2% of dentists worked in single-location, single-dentist practices and 39.5% in single-location, multi-dentist practices. The denominator is dentists. These figures cannot be converted directly into independent clinics with 5–25 staff. Census employer establishment tables group 20–49 employees together, crossing the proposed cutoff. Ownership, software usage and intent to buy require separate evidence. [ADA HPI](https://www.ada.org/-/media/project/ada-organization/ada/ada-org/files/resources/research/hpi/hpi_evolving_dental_practice_model_2023.pdf) · [Census CBP, offices of dentists](https://data.census.gov/table/CBP2023.CB2300CBP?codeset=naics~621210) |
| Does the same evidence apply to medical spas? | AmSpa's 2022 report described an average of eight employees at single-location practices. This historical mean does not establish today's distribution, demand or willingness to pay. Validate this segment independently. [AmSpa report summary](https://www.americanmedspa.org/news/the-2022-medical-spa-state-of-the-industry-executive-summary-in-context/) |
| What can a buyer already buy? | The retrieved LeaveCalc dental page lists $15/month for 4–25 people with a 14-day trial. An earlier indexed version showed $19. Confirm the live offer when quoting a buyer. Smile Compliance lists $149/month for a single practice with extraction, reports and document storage. Both include renewal alerts. Vendor prices establish alternatives, not transaction volumes. [LeaveCalc](https://leavecalc.com/dental-license-tracking/) · [Smile Compliance](https://smilecompliance.com/) |
| Do enterprise prices establish a floor? | MedTrainer describes tailored pricing. The symplr Provider page offers a demo. Neither cited page establishes the former $2,000–$5,000+ annual comparison. Obtain a comparable written quote before using a dollar range. [MedTrainer](https://medtrainer.com/pricing/) · [symplr Provider](https://www.symplr.com/products/symplr-provider/demo-request) |

## Provider inputs

| Service | Published input and modeled scope |
|---|---|
| Vercel | Pro starts at $20/month. Model one paid seat at base usage. [Pricing](https://vercel.com/pricing) |
| Supabase | Pro starts at $25/month and includes $10/month in compute credits, enough for one Micro instance. Model one production project. Extra projects, compute and usage can increase spend. [Pricing](https://supabase.com/pricing) |
| Resend | Transactional Free allows 3,000 emails/month and 100/day. Pro starts at $20/month for 50,000/month with no daily quota. The model uses Pro to allow clustered deadlines. [Pricing](https://resend.com/pricing) |
| Stripe | US standard domestic online cards cost 2.9% + $0.30 per successful charge. Pay-as-you-go Billing adds 0.7% of billing volume. Assumes one successful domestic-card payment per billing period. [Payments](https://stripe.com/pricing) · [Billing](https://stripe.com/billing/pricing) |
| Twilio | US outbound long-code SMS base is $0.0083 per segment. Carrier fees apply per segment. For example, the published Verizon long-code outbound surcharge is $0.005, giving $13.30 per 1,000 single segments before number rental and registration/campaign fees. Numbers start at $1.15/month. The former $0.0079/message omitted these costs. SMS is excluded from the email-only scenario. [US rates](https://www.twilio.com/en-us/sms/pricing/us) · [Sender pricing](https://www.twilio.com/en-us/pricing/messaging) · [A2P fees](https://help.twilio.com/articles/1260803965530) |

### What drives delivery volume

Example inputs, pending pilot data: 25 staff × 4 credentials × 1 renewal per year × 5 thresholds × 2 distinct recipients = 1,000 reminder emails per clinic per year if every threshold fires. At 130 clinics that averages about 10,833/month. Renewals completed early reduce volume. Shared due dates, new imports, trial accounts, retries and onboarding email change peak demand. If 51 credentials reach one threshold on the same day, two separate emails per credential require 102 sends, exceeding the free daily quota. Measure peak daily sends and provider invoices before assigning a clinic capacity to a plan.

## Per-clinic economics

Twelve monthly payments total $468. The $390 annual offer saves $78 (16.67%) and contributes $32.50 of normalized monthly recurring revenue (MRR). Cash arrives on the payment date. Under the pricing above, estimated monthly-plan fees are $39 × 0.036 + $0.30 = $1.704 per clinic-month. Annual-plan fees are $390 × 0.036 + $0.30 = $14.34 per year, or $1.195 per clinic-month. Actual fee rounding and individual invoices can differ by cents.

For M monthly and A annual clinics, MRR = $39M + $32.50A. Estimated monthly fee equivalent = $1.704M + $1.195A. The base email-only stack is $65/month ($20 + $25 + $20). Subtract that and payment fees to get the balance below. Figures are rounded after calculation.

| Paying clinics | All monthly MRR | Monthly-plan fees | Balance after fees and stack | All annual MRR | Annual-plan fees per month | Balance after fees and stack |
|---:|---:|---:|---:|---:|---:|---:|
| 2 | $78 | $3.41 | $9.59 | $65 | $2.39 | −$2.39 |
| 25 | $975 | $42.60 | $867.40 | $812.50 | $29.88 | $717.63 |
| 65 | $2,535 | $110.76 | $2,359.24 | $2,112.50 | $77.68 | $1,969.83 |
| 130 | $5,070 | $221.52 | $4,783.48 | $4,225 | $155.35 | $4,004.65 |

At 130 monthly clinics the original $212 combined expense estimate is below payment fees alone. The modeled balance is 94.35% of monthly-plan revenue at 130 clinics and 12.30% at two. The former 95%+ gross-margin claim and net-profit estimates have no supporting operating ledger. Omitted expenses include owner support and development time, acquisition, domain, monitoring, backups beyond plan allowances, usage overages, SMS, refunds, disputes and taxes. Domain and multiple environments also affect the fixed budget.

Covering only this $65 base takes ceiling($65 / $37.296) = 2 monthly clinics or ceiling($65 / $31.305) = 3 annual clinics on a normalized basis. If email fits both Free quotas, the modeled base falls to $45. Neither base is a verified ceiling for 0–100 clinics. For an operating break-even estimate, add measured fixed expenses and reduce per-clinic contribution by observed variable expenses and support labor before dividing.

## Retention and acquisition

The former 2% monthly customer churn is a sensitivity input. At constant monthly loss rates and no reactivation, annual original-cohort retention is (1 − monthly rate) raised to the 12th power. New sales replace losses for a flat clinic count.

| Hypothetical monthly loss | Original cohort still paying after a year | Average replacement sales/month at 130 clinics |
|---:|---:|---:|
| 1% | 88.64% | 1.3 |
| 2% | 78.47% | 2.6 |
| 5% | 54.04% | 6.5 |

These scenarios apply to monthly renewal opportunities. Track annual renewals among accounts actually due. ChartMogul reports gross revenue retention by revenue per account across SaaS companies. That metric and population cannot establish clinic-level customer churn. [ChartMogul retention methodology and results](https://chartmogul.com/reports/saas-retention-report/saas-retention-report-2023.pdf)

## Product, timing and sample numbers

| Original number | Interpretation and verification |
|---|---|
| 100% separation, zero maintenance, zero ad spend | Separation is a design requirement. This public repository has an identifiable owner. No paid ads is a proposed channel constraint. Support, moderation, content review and incident response still consume time. |
| 5–25 staff, 25-seat cap, $39/$390, 14 days | Segment, packaging and trial choices. The SQL defaults to a 14-day trial. The database has no staff-cap enforcement. Measure paid adoption by practice size, plan mix and trial completion. |
| Five screens, one-click packet | The original list counts a background worker and export endpoint among five workflows. One-action export is a usability target. Verify it on a working product with an actual records request. |
| Daily 08:00 UTC, 90/60/30/7/0 days | Proposed schedule and thresholds. An 08:00 UTC trigger is absent from the repository. The draft view implements exact-day matches against the database date. Document and test clinic-local dates, skipped runs and late imports. No reviewed source establishes that these thresholds are optimal. |
| Two recipients, never double-send | Staff and manager are intended recipients. The SQL uniqueness key omits recipient, and a database log alone cannot guarantee external delivery. Measure intended, attempted, accepted, bounced and unresolved deliveries per recipient. |
| 21 days, three weeks, numbered day ranges, 15 SEO pages | Historical work estimates and editorial inventory. No completed sprint, time-to-sale data, keyword-volume export or Search Console cohort supports a launch date or ranking forecast. See the [SEO measurement plan](../seo_templates/landing_pages_plan.md). |
| Sample licenses, IDs, dates and CE note | Four synthetic credential records. Each alert date equals expiration minus the column's calendar-day offset. Status uses November 23, 2026 as a fixed reference. Dates and identifiers do not represent real credentials. Massachusetts lists a general minimum of 20 CEUs per two-year dental hygiene renewal cycle with exemptions. Individual qualification belongs with the board. [Massachusetts board](https://www.mass.gov/info-details/continuing-education-for-dentistry) |

## Replacing assumptions with operating data

For each closed month reconcile Stripe charges and fees, recognized plan mix, provider invoices, refunds and owner hours. Report opening paid clinics, additions, losses and closing paid clinics. Count logo churn as lost opening clinics / opening clinics. Record exact counts alongside rates and mark a zero denominator unavailable. Track support minutes per paying clinic, oldest pending delivery and share of due credentials renewed before expiry. Link each metric to its period, cohort and source export. Recompute this model when vendor prices or measured volumes change.
