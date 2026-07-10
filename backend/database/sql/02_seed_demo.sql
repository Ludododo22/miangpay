INSERT INTO countries (code, name, iso_code, currency_code, currency_name, phone_code, flag_emoji, mobile_money_operators)
VALUES
  ('BJ', 'Bénin', 'BEN', 'XOF', 'Franc CFA BCEAO', '+229', '🇧🇯', '["MTN Mobile Money", "Moov Money"]'),
  ('GA', 'Gabon', 'GAB', 'XAF', 'Franc CFA BEAC', '+241', '🇬🇦', '["Airtel Money", "Moov Money"]'),
  ('CI', 'Côte d’Ivoire', 'CIV', 'XOF', 'Franc CFA BCEAO', '+225', '🇨🇮', '["Orange Money", "MTN Mobile Money", "Moov Money"]'),
  ('SN', 'Sénégal', 'SEN', 'XOF', 'Franc CFA BCEAO', '+221', '🇸🇳', '["Orange Money", "Free Money", "Wave"]'),
  ('CM', 'Cameroun', 'CMR', 'XAF', 'Franc CFA BEAC', '+237', '🇨🇲', '["Orange Money", "MTN Mobile Money"]'),
  ('TG', 'Togo', 'TGO', 'XOF', 'Franc CFA BCEAO', '+228', '🇹🇬', '["Flooz", "T-Money"]'),
  ('ML', 'Mali', 'MLI', 'XOF', 'Franc CFA BCEAO', '+223', '🇲🇱', '["Orange Money", "Moov Money"]'),
  ('BF', 'Burkina Faso', 'BFA', 'XOF', 'Franc CFA BCEAO', '+226', '🇧🇫', '["Orange Money", "Moov Money"]'),
  ('NE', 'Niger', 'NER', 'XOF', 'Franc CFA BCEAO', '+227', '🇳🇪', '["Airtel Money", "Moov Money"]'),
  ('CD', 'RDC', 'COD', 'CDF', 'Franc congolais', '+243', '🇨🇩', '["Orange Money", "Airtel Money", "M-Pesa"]')
ON CONFLICT (code) DO UPDATE SET
  name = EXCLUDED.name,
  iso_code = EXCLUDED.iso_code,
  currency_code = EXCLUDED.currency_code,
  currency_name = EXCLUDED.currency_name,
  phone_code = EXCLUDED.phone_code,
  flag_emoji = EXCLUDED.flag_emoji,
  mobile_money_operators = EXCLUDED.mobile_money_operators,
  updated_at = now();

INSERT INTO operators (country_id, code, name, service_code)
VALUES
  ((SELECT id FROM countries WHERE code = 'BJ'), 'mtn_bj', 'MTN Mobile Money', 'MTN_BEN'),
  ((SELECT id FROM countries WHERE code = 'BJ'), 'moov_bj', 'Moov Money', 'MOOV_BEN'),
  ((SELECT id FROM countries WHERE code = 'GA'), 'airtel_ga', 'Airtel Money', 'AIRTEL_GAB'),
  ((SELECT id FROM countries WHERE code = 'CI'), 'orange_ci', 'Orange Money', 'ORANGE_CI'),
  ((SELECT id FROM countries WHERE code = 'CI'), 'mtn_ci', 'MTN Mobile Money', 'MTN_CI'),
  ((SELECT id FROM countries WHERE code = 'SN'), 'orange_sn', 'Orange Money', 'ORANGE_SN'),
  ((SELECT id FROM countries WHERE code = 'SN'), 'free_sn', 'Free Money', 'FREE_SN'),
  ((SELECT id FROM countries WHERE code = 'CM'), 'orange_cm', 'Orange Money', 'ORANGE_CM'),
  ((SELECT id FROM countries WHERE code = 'CM'), 'mtn_cm', 'MTN Mobile Money', 'MTN_CM'),
  ((SELECT id FROM countries WHERE code = 'TG'), 'flooz_tg', 'Flooz', 'FLOOZ_TG'),
  ((SELECT id FROM countries WHERE code = 'TG'), 'tmoney_tg', 'T-Money', 'TMONEY_TG')
ON CONFLICT (code) DO UPDATE SET
  name = EXCLUDED.name,
  service_code = EXCLUDED.service_code,
  country_id = EXCLUDED.country_id,
  updated_at = now();

INSERT INTO corridors (origin_country_id, destination_country_id, exchange_rate, fee_percent, min_fee, max_fee, estimated_minutes)
SELECT origin.id, destination.id, 1, fee_percent, 250, 5000, estimated_minutes
FROM (
  VALUES
    ('GA', 'BJ', 2.5, 4),
    ('BJ', 'GA', 2.5, 4),
    ('CI', 'SN', 2.0, 3),
    ('SN', 'CI', 2.0, 3),
    ('CM', 'BJ', 2.5, 5),
    ('BJ', 'TG', 1.5, 2),
    ('TG', 'BJ', 1.5, 2),
    ('CI', 'BF', 1.8, 3),
    ('ML', 'SN', 1.8, 4)
) AS seed(origin_code, destination_code, fee_percent, estimated_minutes)
JOIN countries origin ON origin.code = seed.origin_code
JOIN countries destination ON destination.code = seed.destination_code
ON CONFLICT (origin_country_id, destination_country_id) DO UPDATE SET
  fee_percent = EXCLUDED.fee_percent,
  estimated_minutes = EXCLUDED.estimated_minutes,
  updated_at = now();

INSERT INTO users (first_name, last_name, phone, email, country_id, password_hash, kyc_status, kyc_documents, balance, currency, loyalty_points, loyalty_tier, referral_code)
VALUES
  ('Jean', 'Dupont', '+22961000000', 'jean.dupont@miangpay.demo', (SELECT id FROM countries WHERE code = 'BJ'), '$2y$12$demo.hash.not.for.production', 'verified', '{"document_type":"passport","document_number":"BJ1234567"}', 245800, 'XOF', 8420, 'Or', 'JEAN2026'),
  ('Amina', 'Mensah', '+22507000000', 'amina.mensah@miangpay.demo', (SELECT id FROM countries WHERE code = 'CI'), '$2y$12$demo.hash.not.for.production', 'submitted', '{"document_type":"id_card"}', 128400, 'XOF', 2200, 'Argent', 'AMINA26')
ON CONFLICT (phone) DO UPDATE SET
  email = EXCLUDED.email,
  kyc_status = EXCLUDED.kyc_status,
  balance = EXCLUDED.balance,
  loyalty_points = EXCLUDED.loyalty_points,
  loyalty_tier = EXCLUDED.loyalty_tier,
  updated_at = now();

INSERT INTO beneficiaries (user_id, full_name, phone, country_id, operator_id, relationship, is_favorite)
VALUES
  ((SELECT id FROM users WHERE phone = '+22961000000'), 'Ahmed Diallo', '+22961234567', (SELECT id FROM countries WHERE code = 'BJ'), (SELECT id FROM operators WHERE code = 'mtn_bj'), 'Famille', true),
  ((SELECT id FROM users WHERE phone = '+22961000000'), 'Fatou Koffi', '+22507445566', (SELECT id FROM countries WHERE code = 'CI'), (SELECT id FROM operators WHERE code = 'orange_ci'), 'Amie', true),
  ((SELECT id FROM users WHERE phone = '+22961000000'), 'Mamadou Ndiaye', '+221773214598', (SELECT id FROM countries WHERE code = 'SN'), (SELECT id FROM operators WHERE code = 'orange_sn'), 'Famille', false),
  ((SELECT id FROM users WHERE phone = '+22961000000'), 'Jean Fotso', '+237671004422', (SELECT id FROM countries WHERE code = 'CM'), (SELECT id FROM operators WHERE code = 'mtn_cm'), 'Partenaire', false)
ON CONFLICT (user_id, phone) DO UPDATE SET
  full_name = EXCLUDED.full_name,
  country_id = EXCLUDED.country_id,
  operator_id = EXCLUDED.operator_id,
  relationship = EXCLUDED.relationship,
  is_favorite = EXCLUDED.is_favorite,
  updated_at = now();

INSERT INTO transactions (reference, user_id, beneficiary_id, origin_country_id, destination_country_id, operator_id, status, amount, fee, received_amount, currency, destination_currency, exchange_rate, gateway_reference, created_at)
VALUES
  ('TXN-20260707-001', (SELECT id FROM users WHERE phone = '+22961000000'), (SELECT id FROM beneficiaries WHERE phone = '+22961234567'), (SELECT id FROM countries WHERE code = 'GA'), (SELECT id FROM countries WHERE code = 'BJ'), (SELECT id FROM operators WHERE code = 'mtn_bj'), 'completed', 50000, 1250, 48750, 'XOF', 'XOF', 1, 'FAKE-PAYOUT-001', now() - interval '2 days'),
  ('TXN-20260707-002', (SELECT id FROM users WHERE phone = '+22961000000'), (SELECT id FROM beneficiaries WHERE phone = '+22507445566'), (SELECT id FROM countries WHERE code = 'BJ'), (SELECT id FROM countries WHERE code = 'CI'), (SELECT id FROM operators WHERE code = 'orange_ci'), 'pending', 75000, 1875, 73125, 'XOF', 'XOF', 1, 'FAKE-PAYOUT-002', now() - interval '1 day'),
  ('TXN-20260707-003', (SELECT id FROM users WHERE phone = '+22961000000'), (SELECT id FROM beneficiaries WHERE phone = '+221773214598'), (SELECT id FROM countries WHERE code = 'CI'), (SELECT id FROM countries WHERE code = 'SN'), (SELECT id FROM operators WHERE code = 'orange_sn'), 'completed', 25000, 500, 24500, 'XOF', 'XOF', 1, 'FAKE-PAYOUT-003', now() - interval '6 hours')
ON CONFLICT (reference) DO UPDATE SET
  status = EXCLUDED.status,
  amount = EXCLUDED.amount,
  fee = EXCLUDED.fee,
  received_amount = EXCLUDED.received_amount,
  updated_at = now();

INSERT INTO virtual_cards (user_id, label, holder_name, last_digits, currency, balance, expiry_month, expiry_year, is_frozen, daily_limit, monthly_limit, online_payments_enabled)
VALUES
  ((SELECT id FROM users WHERE phone = '+22961000000'), 'Carte principale', 'Jean Dupont', '4568', 'XOF', 250000, 9, 2029, false, 100000, 1000000, true),
  ((SELECT id FROM users WHERE phone = '+22961000000'), 'Voyage Afrique centrale', 'Jean Dupont', '9821', 'XAF', 145000, 11, 2028, true, 75000, 750000, false)
ON CONFLICT (user_id, last_digits) DO UPDATE SET
  label = EXCLUDED.label,
  balance = EXCLUDED.balance,
  is_frozen = EXCLUDED.is_frozen,
  daily_limit = EXCLUDED.daily_limit,
  monthly_limit = EXCLUDED.monthly_limit,
  online_payments_enabled = EXCLUDED.online_payments_enabled,
  updated_at = now();

INSERT INTO card_transactions (virtual_card_id, merchant, subtitle, amount, currency, is_credit, status, created_at)
SELECT card.id, seed.merchant, seed.subtitle, seed.amount, seed.currency, seed.is_credit, 'completed', seed.created_at
FROM (
  VALUES
    ('4568', 'Recharge MTN', 'Crédit carte • Aujourd’hui', 50000::numeric, 'XOF', true, now() - interval '2 hours'),
    ('4568', 'Netflix', 'Paiement en ligne • Hier', 7000::numeric, 'XOF', false, now() - interval '1 day'),
    ('4568', 'Google Play', 'Paiement en ligne • Cette semaine', 3000::numeric, 'XOF', false, now() - interval '3 days'),
    ('9821', 'Recharge Airtel', 'Crédit carte • Cette semaine', 75000::numeric, 'XAF', true, now() - interval '4 days')
) AS seed(last_digits, merchant, subtitle, amount, currency, is_credit, created_at)
JOIN virtual_cards card ON card.last_digits = seed.last_digits
WHERE NOT EXISTS (
  SELECT 1 FROM card_transactions existing
  WHERE existing.virtual_card_id = card.id AND existing.merchant = seed.merchant AND existing.created_at::date = seed.created_at::date
);

INSERT INTO loyalty_activities (user_id, label, points, activity_type, created_at)
SELECT (SELECT id FROM users WHERE phone = '+22961000000'), label, points, activity_type, created_at
FROM (
  VALUES
    ('Transfert réussi vers le Bénin', 120, 'transfer', now() - interval '2 days'),
    ('Bonus niveau Or', 500, 'tier_bonus', now() - interval '7 days'),
    ('Parrainage validé', 1000, 'referral', now() - interval '14 days')
) AS seed(label, points, activity_type, created_at)
WHERE NOT EXISTS (
  SELECT 1 FROM loyalty_activities existing
  WHERE existing.user_id = (SELECT id FROM users WHERE phone = '+22961000000')
    AND existing.label = seed.label
);

INSERT INTO promotions (title, description, code, target_country_id, discount_percent, expires_at)
VALUES
  ('-30% vers le Sénégal', 'Frais réduits sur les transferts vers le Sénégal pendant la campagne diaspora.', 'SENEGAL30', (SELECT id FROM countries WHERE code = 'SN'), 30, now() + interval '14 days'),
  ('Carte virtuelle offerte', 'Création de carte virtuelle sans frais pour les utilisateurs vérifiés.', 'CARD0', NULL, 100, now() + interval '30 days'),
  ('Points doublés', 'Gagnez deux fois plus de points fidélité sur vos transferts du weekend.', 'POINTS2X', NULL, 0, now() + interval '10 days')
ON CONFLICT (title) DO UPDATE SET
  description = EXCLUDED.description,
  code = EXCLUDED.code,
  target_country_id = EXCLUDED.target_country_id,
  discount_percent = EXCLUDED.discount_percent,
  expires_at = EXCLUDED.expires_at,
  updated_at = now();

INSERT INTO notifications (user_id, title, body, category, priority, is_read, action_route, created_at)
SELECT (SELECT id FROM users WHERE phone = '+22961000000'), title, body, category, priority, is_read, action_route, created_at
FROM (
  VALUES
    ('Transfert réussi', 'Ahmed Diallo a reçu 48 750 XOF au Bénin via MTN.', 'transaction', 'important', false, '/history/receipt/TXN-20260707-001', now() - interval '8 minutes'),
    ('Nouvelle connexion détectée', 'Connexion depuis Chrome à Cotonou.', 'security', 'critical', false, '/profile/security', now() - interval '1 hour'),
    ('Promotion vers le Sénégal', '-30% sur les frais jusqu’à ce soir.', 'promotion', 'marketing', false, '/promotions', now() - interval '3 hours'),
    ('Vous gagnez 120 points', 'Votre dernier transfert vous rapporte des points fidélité MiangPay.', 'loyalty', 'info', true, '/loyalty', now() - interval '5 hours')
) AS seed(title, body, category, priority, is_read, action_route, created_at)
WHERE NOT EXISTS (
  SELECT 1 FROM notifications existing
  WHERE existing.user_id = (SELECT id FROM users WHERE phone = '+22961000000')
    AND existing.title = seed.title
);

INSERT INTO support_tickets (user_id, reference, subject, category, status, priority, created_at)
VALUES
  ((SELECT id FROM users WHERE phone = '+22961000000'), 'SUP-4521', 'Transfert en attente', 'Transaction', 'answered', 'high', now() - interval '2 days'),
  ((SELECT id FROM users WHERE phone = '+22961000000'), 'SUP-4522', 'Question sur carte virtuelle', 'Carte', 'open', 'normal', now() - interval '1 day')
ON CONFLICT (reference) DO UPDATE SET
  subject = EXCLUDED.subject,
  category = EXCLUDED.category,
  status = EXCLUDED.status,
  priority = EXCLUDED.priority,
  updated_at = now();

INSERT INTO support_messages (ticket_id, sender_type, message, created_at)
SELECT ticket.id, seed.sender_type, seed.message, seed.created_at
FROM (
  VALUES
    ('SUP-4521', 'user', 'Bonjour, mon transfert apparaît en attente depuis hier.', now() - interval '2 days'),
    ('SUP-4521', 'agent', 'Nous avons vérifié votre transfert. Il est maintenant confirmé.', now() - interval '1 day'),
    ('SUP-4522', 'user', 'Puis-je utiliser ma carte virtuelle sur Netflix ?', now() - interval '1 day')
) AS seed(reference, sender_type, message, created_at)
JOIN support_tickets ticket ON ticket.reference = seed.reference
WHERE NOT EXISTS (
  SELECT 1 FROM support_messages existing
  WHERE existing.ticket_id = ticket.id AND existing.message = seed.message
);
