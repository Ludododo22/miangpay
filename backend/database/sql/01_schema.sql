CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS countries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code VARCHAR(2) NOT NULL UNIQUE,
  name VARCHAR(120) NOT NULL,
  iso_code VARCHAR(3) NOT NULL UNIQUE,
  currency_code VARCHAR(3) NOT NULL,
  currency_name VARCHAR(80) NOT NULL,
  phone_code VARCHAR(8) NOT NULL,
  flag_emoji VARCHAR(12),
  mobile_money_operators JSONB NOT NULL DEFAULT '[]'::jsonb,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS operators (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  country_id UUID NOT NULL REFERENCES countries(id),
  code VARCHAR(40) NOT NULL UNIQUE,
  name VARCHAR(120) NOT NULL,
  service_code VARCHAR(80) NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS corridors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  origin_country_id UUID NOT NULL REFERENCES countries(id),
  destination_country_id UUID NOT NULL REFERENCES countries(id),
  exchange_rate NUMERIC(14, 6) NOT NULL DEFAULT 1,
  fee_percent NUMERIC(6, 4) NOT NULL DEFAULT 2.5,
  min_fee NUMERIC(14, 2) NOT NULL DEFAULT 250,
  max_fee NUMERIC(14, 2) NOT NULL DEFAULT 5000,
  estimated_minutes INTEGER NOT NULL DEFAULT 5,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (origin_country_id, destination_country_id)
);

CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name VARCHAR(80) NOT NULL,
  last_name VARCHAR(80) NOT NULL,
  phone VARCHAR(32) NOT NULL UNIQUE,
  email VARCHAR(160) UNIQUE,
  country_id UUID NOT NULL REFERENCES countries(id),
  password_hash VARCHAR(255) NOT NULL,
  kyc_status VARCHAR(24) NOT NULL DEFAULT 'pending',
  kyc_documents JSONB,
  balance NUMERIC(14, 2) NOT NULL DEFAULT 0,
  currency VARCHAR(3) NOT NULL DEFAULT 'XOF',
  loyalty_points INTEGER NOT NULL DEFAULT 0,
  loyalty_tier VARCHAR(40) NOT NULL DEFAULT 'Bronze',
  referral_code VARCHAR(40) UNIQUE,
  referred_by UUID REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS beneficiaries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  full_name VARCHAR(160) NOT NULL,
  phone VARCHAR(32) NOT NULL,
  country_id UUID NOT NULL REFERENCES countries(id),
  operator_id UUID NOT NULL REFERENCES operators(id),
  relationship VARCHAR(60),
  is_favorite BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, phone)
);

CREATE TABLE IF NOT EXISTS transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  reference VARCHAR(60) NOT NULL UNIQUE,
  user_id UUID NOT NULL REFERENCES users(id),
  beneficiary_id UUID REFERENCES beneficiaries(id),
  origin_country_id UUID NOT NULL REFERENCES countries(id),
  destination_country_id UUID NOT NULL REFERENCES countries(id),
  operator_id UUID REFERENCES operators(id),
  type VARCHAR(40) NOT NULL DEFAULT 'mobile_money_transfer',
  status VARCHAR(30) NOT NULL DEFAULT 'completed',
  amount NUMERIC(14, 2) NOT NULL,
  fee NUMERIC(14, 2) NOT NULL,
  received_amount NUMERIC(14, 2) NOT NULL,
  currency VARCHAR(3) NOT NULL,
  destination_currency VARCHAR(3) NOT NULL,
  exchange_rate NUMERIC(14, 6) NOT NULL DEFAULT 1,
  gateway_reference VARCHAR(120),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS virtual_cards (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  label VARCHAR(120) NOT NULL,
  holder_name VARCHAR(160) NOT NULL,
  last_digits VARCHAR(4) NOT NULL,
  currency VARCHAR(3) NOT NULL,
  balance NUMERIC(14, 2) NOT NULL DEFAULT 0,
  expiry_month INTEGER NOT NULL,
  expiry_year INTEGER NOT NULL,
  is_frozen BOOLEAN NOT NULL DEFAULT false,
  daily_limit NUMERIC(14, 2) NOT NULL,
  monthly_limit NUMERIC(14, 2) NOT NULL,
  online_payments_enabled BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (user_id, last_digits)
);

CREATE TABLE IF NOT EXISTS card_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  virtual_card_id UUID NOT NULL REFERENCES virtual_cards(id),
  merchant VARCHAR(160) NOT NULL,
  subtitle VARCHAR(180),
  amount NUMERIC(14, 2) NOT NULL,
  currency VARCHAR(3) NOT NULL,
  is_credit BOOLEAN NOT NULL DEFAULT false,
  status VARCHAR(30) NOT NULL DEFAULT 'completed',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS loyalty_activities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  label VARCHAR(160) NOT NULL,
  points INTEGER NOT NULL,
  activity_type VARCHAR(60) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS promotions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(160) NOT NULL UNIQUE,
  description TEXT NOT NULL,
  code VARCHAR(60) UNIQUE,
  target_country_id UUID REFERENCES countries(id),
  discount_percent NUMERIC(5, 2) NOT NULL DEFAULT 0,
  starts_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  expires_at TIMESTAMPTZ NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  title VARCHAR(160) NOT NULL,
  body TEXT NOT NULL,
  category VARCHAR(60) NOT NULL,
  priority VARCHAR(40) NOT NULL DEFAULT 'info',
  is_read BOOLEAN NOT NULL DEFAULT false,
  action_route VARCHAR(160),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS support_tickets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id),
  reference VARCHAR(40) NOT NULL UNIQUE,
  subject VARCHAR(180) NOT NULL,
  category VARCHAR(80) NOT NULL,
  status VARCHAR(40) NOT NULL DEFAULT 'open',
  priority VARCHAR(40) NOT NULL DEFAULT 'normal',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS support_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ticket_id UUID NOT NULL REFERENCES support_tickets(id),
  sender_type VARCHAR(20) NOT NULL,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_beneficiaries_user_id ON beneficiaries(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_user_id ON transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_status ON transactions(status);
CREATE INDEX IF NOT EXISTS idx_virtual_cards_user_id ON virtual_cards(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_support_tickets_user_id ON support_tickets(user_id);
