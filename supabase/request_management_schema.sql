-- PM-AJAY Multi-Level Request Management System Schema

-- State Government Requests (State -> Centre)
CREATE TABLE IF NOT EXISTS state_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  state_code TEXT NOT NULL,
  request_type TEXT CHECK (request_type IN ('fund_allocation', 'scheme_expansion', 'policy_clarification', 'technical_support')) NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  requested_amount DECIMAL(15,2),
  priority_level TEXT CHECK (priority_level IN ('high', 'medium', 'low')) DEFAULT 'medium',
  documents JSONB DEFAULT '[]'::jsonb,
  hierarchy_details JSONB NOT NULL,
  state_officer_details JSONB NOT NULL,
  status TEXT CHECK (status IN ('submitted', 'under_review', 'approved', 'rejected', 'revision_required')) DEFAULT 'submitted',
  centre_reviewer_id UUID REFERENCES auth.users(id),
  centre_review_notes TEXT,
  approved_guidelines TEXT,
  required_documents TEXT[],
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  reviewed_at TIMESTAMP WITH TIME ZONE
);

-- Public Requests (Public -> State)
CREATE TABLE IF NOT EXISTS public_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  state_code TEXT NOT NULL,
  district TEXT NOT NULL,
  block TEXT NOT NULL,
  village TEXT NOT NULL,
  request_type TEXT CHECK (request_type IN ('adarsh_gram', 'hostel', 'gia')) NOT NULL,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  beneficiary_count INTEGER,
  supporting_documents JSONB DEFAULT '[]'::jsonb,
  citizen_details JSONB NOT NULL,
  village_details JSONB NOT NULL,
  status TEXT CHECK (status IN ('submitted', 'under_review', 'approved', 'rejected', 'more_info_required')) DEFAULT 'submitted',
  state_reviewer_id UUID REFERENCES auth.users(id),
  state_review_notes TEXT,
  priority_score INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  reviewed_at TIMESTAMP WITH TIME ZONE
);

-- Agency Registration Requests
CREATE TABLE IF NOT EXISTS agency_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  agency_name TEXT NOT NULL,
  agency_type TEXT CHECK (agency_type IN ('government', 'psu', 'private', 'ngo')) NOT NULL,
  state_code TEXT NOT NULL,
  registration_documents JSONB DEFAULT '[]'::jsonb NOT NULL,
  geographical_coverage JSONB NOT NULL,
  technical_expertise JSONB NOT NULL,
  financial_capacity JSONB NOT NULL,
  previous_experience JSONB DEFAULT '[]'::jsonb,
  key_personnel JSONB DEFAULT '[]'::jsonb NOT NULL,
  proposed_components TEXT[] NOT NULL,
  status TEXT CHECK (status IN ('submitted', 'document_verification', 'approved', 'rejected', 'revision_required')) DEFAULT 'submitted',
  state_reviewer_id UUID REFERENCES auth.users(id),
  state_review_notes TEXT,
  verification_checklist JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  reviewed_at TIMESTAMP WITH TIME ZONE
);

-- Notifications System
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  recipient_id UUID NOT NULL REFERENCES auth.users(id),
  sender_id UUID REFERENCES auth.users(id),
  notification_type TEXT NOT NULL,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  related_entity_type TEXT,
  related_entity_id UUID,
  priority TEXT CHECK (priority IN ('high', 'medium', 'low')) DEFAULT 'medium',
  read_status BOOLEAN DEFAULT FALSE,
  action_required BOOLEAN DEFAULT FALSE,
  action_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Row Level Security Policies

-- State requests can only be viewed by Centre admins and the requesting state
ALTER TABLE state_requests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "State requests access policy"
ON state_requests FOR ALL
TO authenticated
USING (
  auth.jwt() ->> 'role' = 'centre_admin' OR 
  (auth.jwt() ->> 'role' = 'state_officer' AND state_code = auth.jwt() ->> 'state_code')
);

-- Public requests can only be viewed by state officers of the same state
ALTER TABLE public_requests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public requests access policy"
ON public_requests FOR ALL
TO authenticated
USING (
  auth.jwt() ->> 'role' = 'state_officer' AND 
  state_code = auth.jwt() ->> 'state_code'
);

-- Agency requests can only be viewed by state officers of the same state
ALTER TABLE agency_requests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Agency requests access policy"
ON agency_requests FOR ALL
TO authenticated
USING (
  auth.jwt() ->> 'role' = 'state_officer' AND 
  state_code = auth.jwt() ->> 'state_code'
);

-- Notifications can only be viewed by the recipient
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Notifications access policy"
ON notifications FOR ALL
TO authenticated
USING (recipient_id = auth.uid());

-- Indexes for performance
CREATE INDEX idx_state_requests_state_code ON state_requests(state_code);
CREATE INDEX idx_state_requests_status ON state_requests(status);
CREATE INDEX idx_state_requests_created_at ON state_requests(created_at DESC);

CREATE INDEX idx_public_requests_state_code ON public_requests(state_code);
CREATE INDEX idx_public_requests_status ON public_requests(status);
CREATE INDEX idx_public_requests_created_at ON public_requests(created_at DESC);

CREATE INDEX idx_agency_requests_state_code ON agency_requests(state_code);
CREATE INDEX idx_agency_requests_status ON agency_requests(status);
CREATE INDEX idx_agency_requests_created_at ON agency_requests(created_at DESC);

CREATE INDEX idx_notifications_recipient_id ON notifications(recipient_id);
CREATE INDEX idx_notifications_read_status ON notifications(read_status);
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);