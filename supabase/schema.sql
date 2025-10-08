-- PM-AJAY Agency Mapping Platform Database Schema
-- Supabase PostgreSQL with Row Level Security (RLS)

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- User roles table
CREATE TABLE user_roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  role_type TEXT CHECK (role_type IN ('centre_admin', 'state_officer', 'agency_user', 'auditor', 'public_viewer')) NOT NULL,
  state_code TEXT,
  agency_id UUID,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- States master table
CREATE TABLE states (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  region TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Districts master table
CREATE TABLE districts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  state_code TEXT REFERENCES states(code),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Agencies table
CREATE TABLE agencies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  registration_number TEXT UNIQUE NOT NULL,
  state_code TEXT REFERENCES states(code),
  district_code TEXT REFERENCES districts(code),
  contact_person TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT NOT NULL,
  capabilities TEXT[] DEFAULT '{}', -- Array of component types
  max_concurrent_capacity INTEGER DEFAULT 1,
  rating DECIMAL(3,2) DEFAULT 0.00,
  is_active BOOLEAN DEFAULT true,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Projects table
CREATE TABLE projects (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  component TEXT CHECK (component IN ('adarsh_gram', 'gia', 'hostel')) NOT NULL,
  state_code TEXT REFERENCES states(code),
  agency_id UUID REFERENCES agencies(id),
  status TEXT CHECK (status IN ('draft', 'active', 'completed', 'suspended')) DEFAULT 'draft',
  budget_allocated DECIMAL(15,2) DEFAULT 0.00,
  utilization DECIMAL(15,2) DEFAULT 0.00,
  location GEOGRAPHY(POINT),
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Milestones table
CREATE TABLE milestones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  due_date TIMESTAMP WITH TIME ZONE NOT NULL,
  completed_at TIMESTAMP WITH TIME ZONE,
  is_completed BOOLEAN DEFAULT false,
  budget_allocation DECIMAL(15,2) DEFAULT 0.00,
  evidence_url TEXT,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Fund transfers table (PFMS integration)
CREATE TABLE fund_transfers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  transaction_id TEXT UNIQUE NOT NULL,
  from_entity TEXT NOT NULL, -- Centre, State, etc.
  to_entity TEXT NOT NULL,
  amount DECIMAL(15,2) NOT NULL,
  purpose TEXT,
  project_id UUID REFERENCES projects(id),
  pfms_reference TEXT,
  status TEXT CHECK (status IN ('pending', 'processed', 'failed')) DEFAULT 'pending',
  processed_at TIMESTAMP WITH TIME ZONE,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Evidence/Documents table
CREATE TABLE evidence (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  milestone_id UUID REFERENCES milestones(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  file_url TEXT NOT NULL,
  file_type TEXT,
  file_size INTEGER,
  uploaded_by UUID REFERENCES auth.users(id),
  location GEOGRAPHY(POINT),
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Notifications table
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT CHECK (type IN ('info', 'warning', 'error', 'success')) DEFAULT 'info',
  read BOOLEAN DEFAULT false,
  action_url TEXT,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Audit logs table
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  action TEXT NOT NULL,
  table_name TEXT NOT NULL,
  record_id UUID,
  old_values JSONB,
  new_values JSONB,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX idx_user_roles_role_type ON user_roles(role_type);
CREATE INDEX idx_projects_state_code ON projects(state_code);
CREATE INDEX idx_projects_agency_id ON projects(agency_id);
CREATE INDEX idx_projects_component ON projects(component);
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_milestones_project_id ON milestones(project_id);
CREATE INDEX idx_fund_transfers_project_id ON fund_transfers(project_id);
CREATE INDEX idx_evidence_project_id ON evidence(project_id);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_read ON notifications(read);

-- Enable Row Level Security (RLS)
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE agencies ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE milestones ENABLE ROW LEVEL SECURITY;
ALTER TABLE fund_transfers ENABLE ROW LEVEL SECURITY;
ALTER TABLE evidence ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- RLS Policies

-- User roles policies
CREATE POLICY "Users can view own role" ON user_roles
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Centre admins can view all roles" ON user_roles
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM user_roles ur 
      WHERE ur.user_id = auth.uid() 
      AND ur.role_type = 'centre_admin'
    )
  );

-- Projects policies
CREATE POLICY "Centre admins see all projects" ON projects
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM user_roles ur 
      WHERE ur.user_id = auth.uid() 
      AND ur.role_type = 'centre_admin'
    )
  );

CREATE POLICY "State officers see state projects" ON projects
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM user_roles ur 
      WHERE ur.user_id = auth.uid() 
      AND ur.role_type = 'state_officer'
      AND ur.state_code = projects.state_code
    )
  );

CREATE POLICY "Agencies see assigned projects" ON projects
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM user_roles ur 
      WHERE ur.user_id = auth.uid() 
      AND ur.role_type = 'agency_user'
      AND ur.agency_id = projects.agency_id
    )
  );

CREATE POLICY "Auditors see all projects" ON projects
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM user_roles ur 
      WHERE ur.user_id = auth.uid() 
      AND ur.role_type = 'auditor'
    )
  );

-- Milestones inherit project permissions
CREATE POLICY "Milestone access follows project access" ON milestones
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM projects p 
      WHERE p.id = milestones.project_id
    )
  );

-- Evidence policies
CREATE POLICY "Evidence access follows project access" ON evidence
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM projects p 
      WHERE p.id = evidence.project_id
    )
  );

-- Notifications policies
CREATE POLICY "Users see own notifications" ON notifications
  FOR ALL USING (auth.uid() = user_id);

-- Functions for custom claims and triggers

-- Function to get user claims for JWT
CREATE OR REPLACE FUNCTION get_user_claims(user_id UUID)
RETURNS JSON AS $$
DECLARE
  claims JSON;
BEGIN
  SELECT json_build_object(
    'role', role_type,
    'state_code', state_code,
    'agency_id', agency_id
  ) INTO claims
  FROM user_roles
  WHERE user_roles.user_id = get_user_claims.user_id;
  
  RETURN COALESCE(claims, '{}');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
CREATE TRIGGER update_user_roles_updated_at BEFORE UPDATE ON user_roles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_agencies_updated_at BEFORE UPDATE ON agencies
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON projects
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_milestones_updated_at BEFORE UPDATE ON milestones
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert sample data for development

-- Sample states
INSERT INTO states (code, name, region) VALUES
('DL', 'Delhi', 'North'),
('MH', 'Maharashtra', 'West'),
('KA', 'Karnataka', 'South'),
('WB', 'West Bengal', 'East'),
('UP', 'Uttar Pradesh', 'North');

-- Sample districts
INSERT INTO districts (code, name, state_code) VALUES
('DL01', 'Central Delhi', 'DL'),
('DL02', 'North Delhi', 'DL'),
('MH01', 'Mumbai', 'MH'),
('MH02', 'Pune', 'MH'),
('KA01', 'Bangalore Urban', 'KA'),
('KA02', 'Mysore', 'KA');

-- Sample agencies
INSERT INTO agencies (name, registration_number, state_code, district_code, contact_person, email, phone, capabilities) VALUES
('Delhi Development Agency', 'DDA001', 'DL', 'DL01', 'Rajesh Kumar', 'contact@dda.gov.in', '+91-11-23456789', ARRAY['adarsh_gram', 'gia']),
('Maharashtra Rural Development', 'MRD001', 'MH', 'MH01', 'Priya Sharma', 'info@mrd.gov.in', '+91-22-98765432', ARRAY['adarsh_gram', 'hostel']),
('Karnataka Infrastructure Corp', 'KIC001', 'KA', 'KA01', 'Suresh Reddy', 'admin@kic.gov.in', '+91-80-87654321', ARRAY['gia', 'hostel']);

-- Function to create sample projects (to be called after user creation)
CREATE OR REPLACE FUNCTION create_sample_projects()
RETURNS void AS $$
BEGIN
  -- This function can be called to create sample projects
  -- after users and agencies are properly set up
  NULL;
END;
$$ LANGUAGE plpgsql;
