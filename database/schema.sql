-- ============================================================================
-- STANDALONE VERTICAL COMPLIANCE SAAS — POSTGRESQL / SUPABASE SCHEMA
-- Draft tenant tables and RLS policies; deployment grants and isolation require testing
-- ============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. CLINICS (Tenants)
CREATE TABLE public.clinics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    owner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    manager_email TEXT NOT NULL,
    manager_phone TEXT,
    timezone TEXT NOT NULL DEFAULT 'America/New_York',
    stripe_customer_id TEXT UNIQUE,
    stripe_subscription_id TEXT UNIQUE,
    subscription_status TEXT NOT NULL DEFAULT 'trialing', -- trialing, active, past_due, canceled
    trial_ends_at TIMESTAMPTZ NOT NULL DEFAULT (NOW() + INTERVAL '14 days'),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 2. STAFF MEMBERS
CREATE TABLE public.staff_members (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinic_id UUID NOT NULL REFERENCES public.clinics(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    role TEXT NOT NULL, -- e.g., Dentist, Dental Hygienist, Dental Assistant, Esthetician, Nurse
    email TEXT,
    phone TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 3. CREDENTIALS & LICENSES
CREATE TABLE public.credentials (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    clinic_id UUID NOT NULL REFERENCES public.clinics(id) ON DELETE CASCADE,
    staff_id UUID NOT NULL REFERENCES public.staff_members(id) ON DELETE CASCADE,
    credential_type TEXT NOT NULL, -- e.g., State Hygiene License, CPR/BLS, DEA Registration, X-Ray Permit
    license_number TEXT,
    issuing_state TEXT,
    expiration_date DATE NOT NULL,
    document_path TEXT, -- Path in Supabase Storage private bucket
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 4. NOTIFICATION LOGS (unique per credential, threshold, renewal date and channel)
CREATE TABLE public.notification_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    credential_id UUID NOT NULL REFERENCES public.credentials(id) ON DELETE CASCADE,
    clinic_id UUID NOT NULL REFERENCES public.clinics(id) ON DELETE CASCADE,
    threshold_days INTEGER NOT NULL, -- 90, 60, 30, 7, 0
    expiration_snapshot DATE NOT NULL, -- Ties log to specific renewal cycle
    channel TEXT NOT NULL DEFAULT 'email', -- email, sms
    recipient TEXT NOT NULL,
    sent_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (credential_id, threshold_days, expiration_snapshot, channel)
);

-- ============================================================================
-- INDEXES FOR FAST CRON & DASHBOARD QUERIES
-- ============================================================================
CREATE INDEX idx_clinics_owner ON public.clinics(owner_id);
CREATE INDEX idx_staff_clinic ON public.staff_members(clinic_id) WHERE is_active = TRUE;
CREATE INDEX idx_credentials_clinic ON public.credentials(clinic_id);
CREATE INDEX idx_credentials_expiration ON public.credentials(expiration_date);

-- ============================================================================
-- ROW-LEVEL SECURITY (RLS) POLICIES
-- ============================================================================
ALTER TABLE public.clinics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.staff_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.credentials ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notification_logs ENABLE ROW LEVEL SECURITY;

-- Clinics: Owners can only access their own clinic
CREATE POLICY "Users can manage own clinic"
    ON public.clinics
    FOR ALL
    USING (auth.uid() = owner_id)
    WITH CHECK (auth.uid() = owner_id);

-- Staff Members: Access scoped to user's clinic
CREATE POLICY "Users can manage staff in own clinic"
    ON public.staff_members
    FOR ALL
    USING (
        clinic_id IN (SELECT id FROM public.clinics WHERE owner_id = auth.uid())
    )
    WITH CHECK (
        clinic_id IN (SELECT id FROM public.clinics WHERE owner_id = auth.uid())
    );

-- Credentials: Access scoped to user's clinic
CREATE POLICY "Users can manage credentials in own clinic"
    ON public.credentials
    FOR ALL
    USING (
        clinic_id IN (SELECT id FROM public.clinics WHERE owner_id = auth.uid())
    )
    WITH CHECK (
        clinic_id IN (SELECT id FROM public.clinics WHERE owner_id = auth.uid())
    );

-- Notification Logs: Read-only for clinic owners
CREATE POLICY "Users can view notification logs for own clinic"
    ON public.notification_logs
    FOR SELECT
    USING (
        clinic_id IN (SELECT id FROM public.clinics WHERE owner_id = auth.uid())
    );

-- ============================================================================
-- HELPER VIEW FOR PROPOSED DAILY SCANNER (exact database-date matches; no schedule installed)
-- ============================================================================
CREATE OR REPLACE VIEW public.v_pending_reminders AS
SELECT
    c.id AS credential_id,
    c.credential_type,
    c.license_number,
    c.expiration_date,
    (c.expiration_date - CURRENT_DATE) AS days_remaining,
    s.full_name AS staff_name,
    s.role AS staff_role,
    s.email AS staff_email,
    cl.id AS clinic_id,
    cl.name AS clinic_name,
    cl.manager_email,
    cl.subscription_status,
    cl.trial_ends_at
FROM public.credentials c
JOIN public.staff_members s ON c.staff_id = s.id
JOIN public.clinics cl ON c.clinic_id = cl.id
WHERE s.is_active = TRUE
  AND (cl.subscription_status = 'active' OR (cl.subscription_status = 'trialing' AND cl.trial_ends_at > NOW()))
  AND (c.expiration_date - CURRENT_DATE) IN (90, 60, 30, 7, 0);
