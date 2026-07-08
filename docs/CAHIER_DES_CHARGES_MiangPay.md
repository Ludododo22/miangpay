# CAHIER DES CHARGES – APPLICATION MOBILE DE TRANSFERT D'ARGENT MULTI-PAYS AFRICAINS
## Version 3.0 – PAWAPAY Multi-Pays Intégré

---

## 1. PRÉSENTATION GÉNÉRALE

### 1.1 Contexte et Objectif
Développement d'une application mobile permettant les transferts d'argent entre **plusieurs pays africains** via les services Mobile Money, en utilisant l'API **PAWAPAY** comme passerelle unique.

**Pays couverts initialement (extensible) :**
- 🇬🇦 Gabon (Airtel Money)
- 🇧🇯 Bénin (MTN Mobile Money)
- 🇨🇮 Côte d'Ivoire (MTN, Orange)
- 🇸🇳 Sénégal (Orange Money, Free)
- 🇨🇲 Cameroun (MTN, Orange)
- 🇲🇱 Mali (Orange Money)
- 🇹🇬 Togo (Flooz, T-Money)
- 🇧🇫 Burkina Faso (Orange Money)
- 🇳🇪 Niger (Orange Money)
- 🇨🇩 RDC (Airtel Money, Orange Money)

**Objectif stratégique :** Créer un super-app de transfert panafricain, scalable et extensible à tout pays couvert par PAWAPAY.

### 1.2 Périmètre Fonctionnel
- **Transferts multi-pays** : Envoi/réception entre tous les pays couverts
- **Retraits Mobile Money** : Retrait depuis le compte utilisateur
- **Cartes virtuelles** : Génération de cartes prépayées multi-devises
- **Gestion de compte** : KYC, historique, bénéficiaires multi-pays
- **Taux de change en temps réel** : Conversion dynamique entre devises
- **Programme de fidélité** : Points, niveaux, avantages
- **Promotions ciblées** : Offres par pays/corridor

---

## 2. ARCHITECTURE TECHNIQUE

### 2.1 Stack Technologique
| Composant | Technologie | Justification |
|-----------|-------------|---------------|
| **Frontend** | Flutter 3.16+ | Cross-platform, performance native |
| **Backend API** | PHP 8.2+ (Laravel 10+) | Robuste, écosystème riche |
| **Base de données** | PostgreSQL 15 | JSONB pour données flexibles |
| **Cache** | Redis | Sessions, rate limiting, queues |
| **Passerelle Paiement** | PAWAPAY API | Couverture multi-pays |
| **Queue** | Laravel Horizon | Traitement asynchrone |
| **Hébergement** | AWS/Azure/Ovh (multi-région) | Haute disponibilité |

### 2.2 Architecture Système

```
┌─────────────────────────────────────────────────────────────────────────┐
│                           APPLICATION MOBILE                           │
│                           (Flutter – iOS/Android)                      │
└────────────────────────────────────┬────────────────────────────────────┘
                                     │ HTTPS – JWT
                                     ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         API GATEWAY / LOAD BALANCER                    │
│                            (NGINX / AWS ALB)                           │
└────────────────────────────────────┬────────────────────────────────────┘
                                     │
                                     ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                        BACKEND LARAVEL (PHP 8.2)                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                │
│  │  Auth Module │  │Transfer Module│  │  Card Module  │                │
│  └──────────────┘  └──────────────┘  └──────────────┘                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐                │
│  │Loyalty Module│  │Promo Module   │  │   Admin       │                │
│  └──────────────┘  └──────────────┘  └──────────────┘                │
└──────────────────────────┬──────────────┬──────────────────────────────┘
                           │              │
              ┌────────────▼──────────────▼────────────┐
              │          REDIS / PostgreSQL            │
              └────────────────────┬───────────────────┘
                                   │
                                   ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                         PAWAPAY API GATEWAY                            │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌────────────┐     │
│  │   Airtel   │  │    MTN     │  │   Orange   │  │    Moov    │     │
│  │  Gabon,    │  │  Benin,    │  │  Côte d'Ivoire│ │   Togo,   │     │
│  │  RDC, ...  │  │  Cameroun  │  │  Sénégal,  │  │   Benin   │     │
│  └────────────┘  └────────────┘  └────────────┘  └────────────┘     │
└──────────────────────────────────────────────────────────────────────────┘
```

### 2.3 Modèle de Données Multi-Pays

```sql
-- PAYS SUPPORTÉS
CREATE TABLE countries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(2) UNIQUE NOT NULL,          -- GA, BJ, CI, SN, CM, etc.
    name VARCHAR(100) NOT NULL,
    iso_code VARCHAR(3) NOT NULL,              -- XAF, XOF, etc.
    currency_name VARCHAR(50) NOT NULL,
    currency_symbol VARCHAR(5),
    phone_code VARCHAR(5),                     -- +241, +229, etc.
    mobile_money_operators JSONB NOT NULL,     -- Liste des opérateurs actifs
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- EXEMPLE DE DONNÉES
INSERT INTO countries (code, name, iso_code, currency_name, mobile_money_operators) VALUES
('GA', 'Gabon', 'XAF', 'Franc CFA', '{"operators": [{"name": "Airtel Money", "code": "AIRTEL_GAB"}]}'),
('BJ', 'Bénin', 'XOF', 'Franc CFA', '{"operators": [{"name": "MTN Mobile Money", "code": "MTN_BEN"}]}'),
('CI', 'Côte d''Ivoire', 'XOF', 'Franc CFA', '{"operators": [{"name": "MTN", "code": "MTN_CI"}, {"name": "Orange", "code": "ORANGE_CI"}]}'),
('SN', 'Sénégal', 'XOF', 'Franc CFA', '{"operators": [{"name": "Orange Money", "code": "ORANGE_SN"}, {"name": "Free", "code": "FREE_SN"}]}'),
('CM', 'Cameroun', 'XAF', 'Franc CFA', '{"operators": [{"name": "MTN", "code": "MTN_CM"}, {"name": "Orange", "code": "ORANGE_CM"}]}');

-- CONFIGURATION DES FRAIS PAR CORRIDOR
CREATE TABLE transfer_fees (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    origin_country_id UUID NOT NULL REFERENCES countries(id),
    destination_country_id UUID NOT NULL REFERENCES countries(id),
    transfer_type VARCHAR(20) NOT NULL,        -- 'disbursement', 'collection'
    pawapay_fee_percentage DECIMAL(5,2) NOT NULL, -- Frais PAWAPAY
    our_margin_percentage DECIMAL(5,2) NOT NULL,  -- Notre marge
    fixed_fee DECIMAL(10,2) DEFAULT 0,          -- Frais fixes optionnels
    min_amount DECIMAL(15,2) DEFAULT 0,
    max_amount DECIMAL(15,2) DEFAULT 999999999,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(origin_country_id, destination_country_id, transfer_type)
);

-- EXEMPLE DE TARIFICATION
-- Gabon -> Côte d'Ivoire (disbursement)
INSERT INTO transfer_fees (origin_country_id, destination_country_id, transfer_type, pawapay_fee_percentage, our_margin_percentage) 
SELECT ga.id, ci.id, 'disbursement', 1.0, 1.5 
FROM countries ga, countries ci WHERE ga.code='GA' AND ci.code='CI';

-- UTILISATEURS
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    country_id UUID NOT NULL REFERENCES countries(id),
    mobile_money_operator VARCHAR(50) NOT NULL,  -- Nom de l'opérateur
    mobile_money_phone VARCHAR(20) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    kyc_status VARCHAR(20) DEFAULT 'pending',    -- pending, submitted, verified, rejected
    kyc_documents JSONB,
    tier VARCHAR(20) DEFAULT 'bronze',           -- bronze, silver, gold, platinum
    loyalty_points INTEGER DEFAULT 0,
    is_email_verified BOOLEAN DEFAULT false,
    is_phone_verified BOOLEAN DEFAULT false,
    referral_code VARCHAR(20) UNIQUE,
    referred_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP
);

-- TRANSACTIONS (MULTI-PAYS)
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    beneficiary_id UUID REFERENCES beneficiaries(id),
    type VARCHAR(30) NOT NULL,                   -- send, receive, withdraw, card_load, card_payment
    origin_country_id UUID NOT NULL REFERENCES countries(id),
    destination_country_id UUID NOT NULL REFERENCES countries(id),
    amount DECIMAL(15,2) NOT NULL,
    fee DECIMAL(15,2) NOT NULL,
    net_amount DECIMAL(15,2) NOT NULL,
    exchange_rate DECIMAL(10,4),
    currency_from VARCHAR(3) NOT NULL,
    currency_to VARCHAR(3) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',       -- pending, processing, completed, failed, cancelled
    pawapay_transaction_id VARCHAR(255),
    pawapay_response JSONB,
    metadata JSONB,
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- BÉNÉFICIAIRES MULTI-PAYS
CREATE TABLE beneficiaries (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    country_id UUID NOT NULL REFERENCES countries(id),
    mobile_money_operator VARCHAR(50) NOT NULL,
    is_favorite BOOLEAN DEFAULT false,
    nickname VARCHAR(50),
    metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- CARTES VIRTUELLES
CREATE TABLE virtual_cards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    card_number VARCHAR(255) NOT NULL,           -- Chiffré
    card_holder_name VARCHAR(100) NOT NULL,
    expiry_month VARCHAR(2) NOT NULL,
    expiry_year VARCHAR(4) NOT NULL,
    cvv_hash VARCHAR(255) NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0,
    currency VARCHAR(3) DEFAULT 'XAF',
    daily_limit DECIMAL(15,2),
    monthly_limit DECIMAL(15,2),
    status VARCHAR(20) DEFAULT 'active',         -- active, inactive, blocked, expired
    pawapay_card_id VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- PROGRAMME DE FIDÉLITÉ (Multi-pays)
CREATE TABLE loyalty_tiers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(20) NOT NULL,                   -- bronze, silver, gold, platinum
    points_threshold INTEGER NOT NULL,
    fee_discount_percentage DECIMAL(5,2) DEFAULT 0,
    free_transfers_per_month INTEGER DEFAULT 0,
    priority_support BOOLEAN DEFAULT false,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- POINTS DE FIDÉLITÉ
CREATE TABLE loyalty_rewards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    points_earned INTEGER NOT NULL,
    action VARCHAR(50) NOT NULL,                 -- transfer, referral, promo
    reference_id UUID,                          -- transaction_id ou autre
    expiry_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

-- PROMOTIONS CIBLÉES (par pays/corridor)
CREATE TABLE promotions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    type VARCHAR(20) NOT NULL,                   -- percent, fixed, free_transfer
    value DECIMAL(10,2) NOT NULL,
    max_discount DECIMAL(15,2),
    target_country_id UUID REFERENCES countries(id), -- NULL = tous les pays
    target_corridor VARCHAR(20),                -- 'GA_to_BJ', 'all'
    conditions JSONB,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    usage_limit INTEGER,
    usage_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
```

---

## 3. EXIGENCES FONCTIONNELLES DÉTAILLÉES

### 3.1 Module Pays & Configuration

| Fonctionnalité | Description | Priorité |
|----------------|-------------|----------|
| Liste des pays | Récupération dynamique des pays couverts | P0 |
| Taux de change | Conversion temps réel entre devises | P0 |
| Opérateurs Mobile Money | Liste par pays | P0 |
| Disponibilité | Vérification d'un corridor actif | P0 |
| Configuration admin | Interface pour ajouter/activer des pays | P2 |

### 3.2 Module Authentification & Profil

| Fonctionnalité | Description | Priorité |
|----------------|-------------|----------|
| Inscription | Email/téléphone + pays + opérateur Mobile Money | P0 |
| Connexion | JWT + OTP | P0 |
| KYC | Vérification d'identité (CNI, passeport) | P1 |
| Gestion pays | Changement de pays/résidence | P2 |
| Multi-devises | Affichage des soldes dans différentes devises | P1 |

### 3.3 Module Transfert (Core Business)

| Corridor | Frais Client | Frais PAWAPAY | Notre Marge |
|----------|--------------|---------------|-------------|
| Pays A → Pays B (hors zone CFA) | 2.5% - 4.0% | 1.0% - 2.2% | 1.5% - 2.5% |
| Pays A → Pays B (zone CFA) | 2.0% - 3.0% | 1.0% - 1.5% | 1.0% - 1.5% |
| Intra-pays | 1.5% - 2.0% | 0.5% - 1.0% | 1.0% |
| Retrait pays | 2.0% - 3.0% | 1.0% - 1.5% | 1.0% - 1.5% |

**Matrice de tarification dynamique (exemples) :**

| Corridor | Frais PAWAPAY | Marge | Total Client |
|----------|---------------|-------|--------------|
| GA → BJ | 1.0% | +1.5% | **2.5%** |
| BJ → CI | 1.2% | +1.5% | **2.7%** |
| CI → SN | 1.0% | +1.5% | **2.5%** |
| GA → CM | 1.5% | +1.5% | **3.0%** |
| SN → CI | 1.0% | +1.5% | **2.5%** |
| CM → GA | 1.5% | +1.5% | **3.0%** |
| BJ → BJ | 1.5% | +0.5% | **2.0%** |
| GA → GA | 1.0% | +0.5% | **1.5%** |

**Fonctionnalités :**
- Sélection dynamique du pays d'origine et de destination
- Affichage en temps réel du taux de change
- Calcul automatique des frais selon corridor
- Limites de transaction par pays
- Gestion des bénéficiaires multi-pays

### 3.4 Module Cartes Virtuelles

| Fonctionnalité | Description | API Requise |
|----------------|-------------|-------------|
| Génération carte | Création carte VISA/Mastercard | PAWAPAY / Klasha |
| Alimentation | Débit Mobile Money multi-pays | PAWAPAY Collection |
| Multi-devises | Solde en XAF/XOF selon pays | API Carte |
| Blocage/Déblocage | Sécurité | API Carte |

### 3.5 Module Fidélité & Promotions

**Tiers et Avantages :**

| Niveau | Points | Avantages |
|--------|--------|-----------|
| **Bronze** | 0-499 | -10% frais |
| **Argent** | 500-1999 | -25% frais + 1 transfert gratuit/mois |
| **Or** | 2000-4999 | -50% frais + 2 transferts gratuits/mois |
| **Platine** | 5000+ | -75% frais + 3 transferts gratuits/mois + Support VIP |

**Attribution des points :**
- Transfert inter-pays : 2 points / 1000 XOF
- Transfert intra-pays : 1 point / 1000 XOF
- Parrainage : 500 points
- Promotion spéciale : points bonus

**Promotions ciblées :**
- Par pays (ex: -30% frais pour envoi vers Sénégal)
- Par corridor (ex: -50% Gabon→Bénin en Ramadan)
- Par période (ex: Week-end -20% sur tous les envois)

---

## 4. MODÈLE ÉCONOMIQUE

### 4.1 Structure de Coûts

| Type de frais | Airtel | MTN | Orange | Moov |
|---------------|--------|-----|--------|------|
| Collection | 2.0% | 2.2% | 2.5% | 2.0% |
| Disbursement | 1.0% | 1.5% | 1.2% | 1.5% |

### 4.2 Projection Financière (Mensuelle - 3 000 transactions)

| Pays | Volume | Revenus | Coût PAWAPAY | Marge |
|------|--------|---------|--------------|-------|
| Gabon | 15M | 375 000 | 225 000 | 150 000 |
| Bénin | 15M | 450 000 | 300 000 | 150 000 |
| Côte d'Ivoire | 20M | 600 000 | 400 000 | 200 000 |
| Sénégal | 20M | 600 000 | 400 000 | 200 000 |
| Cameroun | 15M | 450 000 | 300 000 | 150 000 |
| Autres | 15M | 450 000 | 300 000 | 150 000 |
| **Total** | **100M** | **2 925 000** | **1 925 000** | **1 000 000** |

### 4.3 Breakeven Multi-Pays

- **Coûts fixes mensuels** : 500 000 XOF
- **Marge moyenne par transaction** : 500 XOF
- **Transactions nécessaires** : 1 000 transactions/mois

---

## 5. INTÉGRATION PAWAPAY MULTI-PAYS

### 5.1 Configuration PAWAPAY

```php
<?php
// config/pawapay.php

return [
    'base_url' => env('PAWAPAY_BASE_URL', 'https://api.pawapay.io/v3'),
    'api_key' => env('PAWAPAY_API_KEY'),
    'secret' => env('PAWAPAY_SECRET'),
    'merchant_id' => env('PAWAPAY_MERCHANT_ID'),
    
    // Mapping des pays vers les codes service PAWAPAY
    'countries' => [
        'GA' => [
            'name' => 'Gabon',
            'currency' => 'XAF',
            'operators' => [
                'Airtel Money' => 'AIRTEL_GAB'
            ]
        ],
        'BJ' => [
            'name' => 'Bénin',
            'currency' => 'XOF',
            'operators' => [
                'MTN Mobile Money' => 'MTN_BEN'
            ]
        ],
        'CI' => [
            'name' => 'Côte d\'Ivoire',
            'currency' => 'XOF',
            'operators' => [
                'MTN' => 'MTN_CI',
                'Orange' => 'ORANGE_CI'
            ]
        ],
        'SN' => [
            'name' => 'Sénégal',
            'currency' => 'XOF',
            'operators' => [
                'Orange Money' => 'ORANGE_SN',
                'Free' => 'FREE_SN'
            ]
        ],
        'CM' => [
            'name' => 'Cameroun',
            'currency' => 'XAF',
            'operators' => [
                'MTN' => 'MTN_CM',
                'Orange' => 'ORANGE_CM'
            ]
        ],
        // Ajouter plus de pays...
    ],
    
    // Frais PAWAPAY par pays et type d'opération
    'pawapay_fees' => [
        'AIRTEL_GAB' => [
            'collection' => 2.0,
            'disbursement' => 1.0
        ],
        'MTN_BEN' => [
            'collection' => 2.2,
            'disbursement' => 1.5
        ],
        'MTN_CI' => [
            'collection' => 2.5,
            'disbursement' => 1.2
        ],
        'ORANGE_CI' => [
            'collection' => 2.5,
            'disbursement' => 1.2
        ],
        'ORANGE_SN' => [
            'collection' => 2.3,
            'disbursement' => 1.3
        ],
        // Configuration par opérateur...
    ],
    
    // Nos marges par corridor
    'margins' => [
        'GA_to_BJ' => 1.5,
        'BJ_to_GA' => 1.5,
        'GA_to_CI' => 1.7,
        'CI_to_GA' => 1.7,
        'BJ_to_CI' => 1.5,
        'CI_to_BJ' => 1.5,
        'GA_to_GA' => 0.5,
        'BJ_to_BJ' => 0.5,
        'CI_to_CI' => 0.5,
        'default' => 1.5
    ]
];
```

### 5.2 Service PAWAPAY Multi-Pays

```php
<?php
namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Carbon\Carbon;

class PawapayService
{
    protected $baseUrl;
    protected $apiKey;
    protected $secret;
    protected $merchantId;
    
    public function __construct()
    {
        $this->baseUrl = config('pawapay.base_url');
        $this->apiKey = config('pawapay.api_key');
        $this->secret = config('pawapay.secret');
        $this->merchantId = config('pawapay.merchant_id');
    }

    /**
     * Initier un transfert vers Mobile Money
     * Support multi-pays via le paramètre country
     */
    public function initiateDisbursement(array $data): array
    {
        // Récupérer le code service PAWAPAY pour le pays et l'opérateur
        $serviceCode = $this->getServiceCode($data['country_code'], $data['operator']);
        
        $payload = [
            'country' => $data['country_code'],
            'amount' => $data['amount'],
            'accountNumber' => $data['phone'],
            'serviceCode' => $serviceCode,
            'requestId' => $this->generateRequestId(),
            'currency' => $data['currency'],
            'type' => 'mobile_money',
            'merchantId' => $this->merchantId,
            'metadata' => $data['metadata'] ?? null
        ];

        $response = Http::withHeaders([
            'Authorization' => 'Bearer ' . $this->apiKey,
            'Content-Type' => 'application/json',
            'X-API-Secret' => $this->secret
        ])->post($this->baseUrl . '/wallet/merchant/bank/transfer/request/v3', $payload);

        Log::info('PAWAPAY Disbursement Multi-Pays', [
            'payload' => $payload,
            'response' => $response->json()
        ]);

        return $response->json();
    }

    /**
     * Collecter des fonds via Mobile Money (multi-pays)
     */
    public function initiateCollection(array $data): array
    {
        $serviceCode = $this->getServiceCode($data['country_code'], $data['operator']);
        
        $payload = [
            'country' => $data['country_code'],
            'amount' => $data['amount'],
            'accountNumber' => $data['phone'],
            'serviceCode' => $serviceCode,
            'requestId' => $this->generateRequestId(),
            'currency' => $data['currency'],
            'type' => 'mobile_money',
            'merchantId' => $this->merchantId,
            'metadata' => $data['metadata'] ?? null
        ];

        $response = Http::withHeaders([
            'Authorization' => 'Bearer ' . $this->apiKey,
            'Content-Type' => 'application/json'
        ])->post($this->baseUrl . '/wallet/merchant/collection/request/v3', $payload);

        return $response->json();
    }

    /**
     * Vérifier le statut d'une transaction (multi-pays)
     */
    public function checkTransactionStatus(string $transactionId): array
    {
        $response = Http::withHeaders([
            'Authorization' => 'Bearer ' . $this->apiKey
        ])->get($this->baseUrl . '/wallet/merchant/payment/status/v3/' . $transactionId);

        return $response->json();
    }

    /**
     * Obtenir le taux de change entre deux devises
     */
    public function getExchangeRate(string $fromCurrency, string $toCurrency): array
    {
        $response = Http::withHeaders([
            'Authorization' => 'Bearer ' . $this->apiKey
        ])->get($this->baseUrl . '/wallet/merchant/exchange-rate/v3', [
            'from' => $fromCurrency,
            'to' => $toCurrency
        ]);

        return $response->json();
    }

    /**
     * Générer une carte virtuelle (multi-devises)
     */
    public function generateVirtualCard(array $data): array
    {
        $payload = [
            'customerId' => $data['user_id'],
            'currency' => $data['currency'],
            'limit' => $data['limit'],
            'cardType' => 'VIRTUAL_VISA',
            'country' => $data['country_code'] ?? null,
            'metadata' => $data['metadata'] ?? null
        ];

        $response = Http::withHeaders([
            'Authorization' => 'Bearer ' . $this->apiKey
        ])->post($this->baseUrl . '/virtual-card/generate', $payload);

        return $response->json();
    }

    /**
     * Obtenir le code service selon le pays et l'opérateur
     */
    private function getServiceCode(string $countryCode, string $operator): string
    {
        $countries = config('pawapay.countries');
        return $countries[$countryCode]['operators'][$operator] ?? null;
    }

    /**
     * Générer un ID de requête unique
     */
    private function generateRequestId(): string
    {
        return 'TXN_' . Carbon::now()->format('YmdHis') . '_' . uniqid();
    }

    /**
     * Calculer les frais de transfert
     */
    public function calculateFees(
        string $originCountry,
        string $destinationCountry,
        float $amount,
        string $type = 'disbursement'
    ): array {
        // Récupérer la configuration des frais
        $feeConfig = $this->getFeeConfig($originCountry, $destinationCountry, $type);
        
        // Frais PAWAPAY
        $pawapayFee = $amount * ($feeConfig['pawapay_fee_percentage'] / 100);
        
        // Notre marge
        $ourMargin = $amount * ($feeConfig['our_margin_percentage'] / 100);
        
        // Total des frais
        $totalFee = $pawapayFee + $ourMargin;
        
        // Application du programme de fidélité (réduction)
        $discount = $this->calculateLoyaltyDiscount($amount, $totalFee);
        
        return [
            'pawapay_fee' => round($pawapayFee, 2),
            'our_margin' => round($ourMargin, 2),
            'total_fee' => round($totalFee, 2),
            'discount' => round($discount, 2),
            'net_fee' => round($totalFee - $discount, 2),
            'exchange_rate' => $this->getExchangeRate(
                $feeConfig['currency_from'],
                $feeConfig['currency_to']
            )
        ];
    }

    /**
     * Récupérer la configuration des frais pour un corridor
     */
    private function getFeeConfig(string $origin, string $destination, string $type): array
    {
        // Logique de récupération depuis la base de données ou config
        // Priorité : DB > config
        return [
            'pawapay_fee_percentage' => 1.0,
            'our_margin_percentage' => 1.5,
            'currency_from' => 'XAF',
            'currency_to' => 'XOF'
        ];
    }

    /**
     * Calculer la réduction selon le programme de fidélité
     */
    private function calculateLoyaltyDiscount(float $amount, float $fee): float
    {
        // Logique à implémenter selon le tier de l'utilisateur
        return 0;
    }
}
```

---

## 6. API ENDPOINTS (Backend Laravel)

### 6.1 Routes API

```php
<?php
// routes/api.php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\{
    AuthController,
    CountryController,
    TransferController,
    BeneficiaryController,
    CardController,
    LoyaltyController,
    PromotionController,
    WebhookController,
    ExchangeRateController
};

// Routes publiques (multi-pays)
Route::prefix('v1')->group(function () {
    // Authentification
    Route::post('/auth/register', [AuthController::class, 'register']);
    Route::post('/auth/login', [AuthController::class, 'login']);
    Route::post('/auth/verify-otp', [AuthController::class, 'verifyOTP']);
    Route::post('/auth/refresh', [AuthController::class, 'refresh']);
    Route::post('/auth/forgot-password', [AuthController::class, 'forgotPassword']);
    
    // Pays et configurations (multi-pays - public)
    Route::get('/countries', [CountryController::class, 'index']);
    Route::get('/countries/{code}', [CountryController::class, 'show']);
    Route::get('/countries/{from}/{to}/rate', [ExchangeRateController::class, 'getRate']);
    Route::get('/corridors', [CountryController::class, 'getActiveCorridors']);
    Route::get('/operators/{countryCode}', [CountryController::class, 'getOperators']);
    
    // Webhook PAWAPAY
    Route::post('/webhooks/pawapay', [WebhookController::class, 'handle']);
});

// Routes protégées (JWT)
Route::prefix('v1')->middleware(['auth:sanctum', 'kyc.verified'])->group(function () {
    
    // Profil utilisateur
    Route::prefix('user')->group(function () {
        Route::get('/profile', [AuthController::class, 'getProfile']);
        Route::put('/profile', [AuthController::class, 'updateProfile']);
        Route::post('/kyc', [AuthController::class, 'submitKYC']);
        Route::get('/kyc-status', [AuthController::class, 'getKYCStatus']);
        Route::post('/switch-country', [AuthController::class, 'switchCountry']);
    });

    // Transferts multi-pays
    Route::prefix('transfer')->group(function () {
        Route::post('/send', [TransferController::class, 'sendMoney']);
        Route::get('/status/{id}', [TransferController::class, 'checkStatus']);
        Route::get('/history', [TransferController::class, 'getHistory']);
        Route::post('/calculate', [TransferController::class, 'calculateFees']);
        Route::get('/limits', [TransferController::class, 'getLimits']);
    });

    // Bénéficiaires multi-pays
    Route::prefix('beneficiaries')->group(function () {
        Route::get('/', [BeneficiaryController::class, 'index']);
        Route::post('/', [BeneficiaryController::class, 'store']);
        Route::get('/{id}', [BeneficiaryController::class, 'show']);
        Route::put('/{id}', [BeneficiaryController::class, 'update']);
        Route::delete('/{id}', [BeneficiaryController::class, 'destroy']);
        Route::post('/{id}/favorite', [BeneficiaryController::class, 'toggleFavorite']);
        Route::get('/country/{countryCode}', [BeneficiaryController::class, 'getByCountry']);
    });

    // Cartes virtuelles multi-devises
    Route::prefix('cards')->group(function () {
        Route::post('/generate', [CardController::class, 'generate']);
        Route::post('/{id}/load', [CardController::class, 'loadCard']);
        Route::get('/{id}/balance', [CardController::class, 'getBalance']);
        Route::get('/{id}/transactions', [CardController::class, 'getTransactions']);
        Route::post('/{id}/block', [CardController::class, 'blockCard']);
        Route::post('/{id}/unblock', [CardController::class, 'unblockCard']);
        Route::get('/active', [CardController::class, 'getActiveCards']);
    });

    // Fidélité
    Route::prefix('loyalty')->group(function () {
        Route::get('/points', [LoyaltyController::class, 'getPoints']);
        Route::get('/tier', [LoyaltyController::class, 'getTier']);
        Route::get('/tiers', [LoyaltyController::class, 'getAllTiers']);
        Route::get('/benefits', [LoyaltyController::class, 'getBenefits']);
        Route::get('/history', [LoyaltyController::class, 'getHistory']);
    });

    // Promotions
    Route::prefix('promotions')->group(function () {
        Route::get('/active', [PromotionController::class, 'getActive']);
        Route::get('/country/{countryCode}', [PromotionController::class, 'getByCountry']);
        Route::post('/validate', [PromotionController::class, 'validateCode']);
        Route::get('/applicable', [PromotionController::class, 'getApplicable']);
    });
});

// Routes admin (super-admin)
Route::prefix('v1/admin')->middleware(['auth:sanctum', 'admin'])->group(function () {
    // Gestion des pays
    Route::apiResource('countries', CountryController::class)->except(['index', 'show']);
    Route::post('/countries/{id}/toggle', [CountryController::class, 'toggleActive']);
    
    // Gestion des frais
    Route::apiResource('fees', FeeController::class);
    Route::post('/fees/{id}/toggle', [FeeController::class, 'toggleActive']);
    
    // Gestion des promotions
    Route::apiResource('promotions', PromotionController::class);
    
    // Statistiques
    Route::get('/stats/transactions', [StatsController::class, 'getTransactionStats']);
    Route::get('/stats/countries', [StatsController::class, 'getCountryStats']);
    Route::get('/stats/revenue', [StatsController::class, 'getRevenue']);
});
```

### 6.2 Contrôleur Multi-Pays (TransferController)

```php
<?php
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Transaction;
use App\Models\Country;
use App\Services\PawapayService;
use App\Http\Requests\SendMoneyRequest;
use App\Http\Resources\TransactionResource;
use Illuminate\Support\Facades\DB;

class TransferController extends Controller
{
    protected $pawapayService;

    public function __construct(PawapayService $pawapayService)
    {
        $this->pawapayService = $pawapayService;
    }

    /**
     * Envoyer de l'argent (multi-pays)
     * Supporte tous les pays couverts par PAWAPAY
     */
    public function sendMoney(SendMoneyRequest $request)
    {
        $user = auth()->user();
        $data = $request->validated();

        // Récupérer les pays
        $originCountry = Country::where('code', $data['origin_country'])->first();
        $destinationCountry = Country::where('code', $data['destination_country'])->first();

        // Vérifier que le corridor est actif
        if (!$this->isCorridorActive($originCountry, $destinationCountry)) {
            return response()->json([
                'message' => 'Ce corridor de transfert n\'est pas actif',
                'code' => 'INACTIVE_CORRIDOR'
            ], 400);
        }

        // Calculer les frais
        $feeCalculation = $this->pawapayService->calculateFees(
            $data['origin_country'],
            $data['destination_country'],
            $data['amount'],
            'disbursement'
        );

        // Vérifier les limites
        $this->checkLimits($user, $data['amount']);

        // Démarrer une transaction
        DB::beginTransaction();

        try {
            // Créer la transaction
            $transaction = Transaction::create([
                'user_id' => $user->id,
                'beneficiary_id' => $data['beneficiary_id'] ?? null,
                'type' => 'send',
                'origin_country_id' => $originCountry->id,
                'destination_country_id' => $destinationCountry->id,
                'amount' => $data['amount'],
                'fee' => $feeCalculation['net_fee'],
                'net_amount' => $data['amount'] - $feeCalculation['net_fee'],
                'exchange_rate' => $feeCalculation['exchange_rate']['rate'] ?? null,
                'currency_from' => $originCountry->iso_code,
                'currency_to' => $destinationCountry->iso_code,
                'status' => 'pending'
            ]);

            // Appel PAWAPAY
            $pawapayResponse = $this->pawapayService->initiateDisbursement([
                'country_code' => $destinationCountry->code,
                'operator' => $request->operator,
                'phone' => $request->phone,
                'amount' => $transaction->net_amount,
                'currency' => $destinationCountry->iso_code,
                'metadata' => [
                    'transaction_id' => $transaction->id,
                    'origin_country' => $originCountry->code,
                    'user_id' => $user->id
                ]
            ]);

            // Mettre à jour la transaction
            $transaction->update([
                'pawapay_transaction_id' => $pawapayResponse['id'] ?? null,
                'pawapay_response' => $pawapayResponse,
                'status' => $pawapayResponse['payoutStatus'] ?? 'pending'
            ]);

            // Ajouter les points de fidélité
            $this->addLoyaltyPoints($user, $transaction);

            DB::commit();

            return new TransactionResource($transaction);

        } catch (\Exception $e) {
            DB::rollBack();
            
            Log::error('Transfer failed', [
                'user_id' => $user->id,
                'error' => $e->getMessage()
            ]);

            return response()->json([
                'message' => 'Le transfert a échoué',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Vérifier si un corridor est actif
     */
    private function isCorridorActive(Country $from, Country $to): bool
    {
        // Vérifier dans la base de données
        $feeConfig = DB::table('transfer_fees')
            ->where('origin_country_id', $from->id)
            ->where('destination_country_id', $to->id)
            ->where('is_active', true)
            ->first();

        return $feeConfig !== null;
    }

    /**
     * Vérifier les limites de transaction (par pays)
     */
    private function checkLimits($user, float $amount): void
    {
        // Limites par pays
        $dailyLimit = config('limits.daily.' . $user->country->code, 2000000);
        $monthlyLimit = config('limits.monthly.' . $user->country->code, 10000000);

        // Vérifier les limites
        $dailyTotal = Transaction::where('user_id', $user->id)
            ->whereDate('created_at', today())
            ->where('status', 'completed')
            ->sum('amount');

        $monthlyTotal = Transaction::where('user_id', $user->id)
            ->whereMonth('created_at', now()->month)
            ->where('status', 'completed')
            ->sum('amount');

        if ($dailyTotal + $amount > $dailyLimit) {
            throw new \Exception('Limite quotidienne de ' . number_format($dailyLimit) . ' XOF atteinte');
        }

        if ($monthlyTotal + $amount > $monthlyLimit) {
            throw new \Exception('Limite mensuelle de ' . number_format($monthlyLimit) . ' XOF atteinte');
        }
    }

    /**
     * Ajouter des points de fidélité
     */
    private function addLoyaltyPoints($user, Transaction $transaction): void
    {
        // 2 points pour 1000 XOF pour les transferts inter-pays
        $points = 0;
        if ($transaction->origin_country_id !== $transaction->destination_country_id) {
            $points = floor($transaction->amount / 1000) * 2;
        } else {
            $points = floor($transaction->amount / 1000) * 1;
        }

        if ($points > 0) {
            DB::table('loyalty_rewards')->insert([
                'user_id' => $user->id,
                'points_earned' => $points,
                'action' => 'transfer',
                'reference_id' => $transaction->id,
                'created_at' => now()
            ]);

            // Mettre à jour les points de l'utilisateur
            $user->increment('loyalty_points', $points);
            
            // Vérifier si le tier doit être mis à jour
            $this->updateTier($user);
        }
    }

    /**
     * Mettre à jour le tier de l'utilisateur
     */
    private function updateTier($user): void
    {
        $tiers = [
            'platinum' => 5000,
            'gold' => 2000,
            'silver' => 500,
            'bronze' => 0
        ];

        foreach ($tiers as $tier => $threshold) {
            if ($user->loyalty_points >= $threshold) {
                $user->update(['tier' => $tier]);
                break;
            }
        }
    }
}
```

---

## 7. FRONTEND FLUTTER – ACTUALISATION MULTI-PAYS

### 7.1 Modèles

```dart
// lib/core/models/country.dart
class Country {
  final String id;
  final String code;
  final String name;
  final String isoCode;
  final String currencyName;
  final String currencySymbol;
  final String phoneCode;
  final List<Operator> operators;
  final bool isActive;

  Country({
    required this.id,
    required this.code,
    required this.name,
    required this.isoCode,
    required this.currencyName,
    required this.currencySymbol,
    required this.phoneCode,
    required this.operators,
    required this.isActive,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      isoCode: json['iso_code'],
      currencyName: json['currency_name'],
      currencySymbol: json['currency_symbol'] ?? '',
      phoneCode: json['phone_code'] ?? '',
      operators: (json['mobile_money_operators']?['operators'] as List? ?? [])
          .map((o) => Operator.fromJson(o))
          .toList(),
      isActive: json['is_active'] ?? true,
    );
  }

  String get flagEmoji {
    // Convertir code pays en emoji drapeau
    const offset = 0x1F1E6 - 65;
    final chars = code.toUpperCase().codeUnits;
    return String.fromCharCode(chars[0] + offset) + 
           String.fromCharCode(chars[1] + offset);
  }
}

// lib/core/models/operator.dart
class Operator {
  final String name;
  final String code;

  Operator({required this.name, required this.code});

  factory Operator.fromJson(Map<String, dynamic> json) {
    return Operator(
      name: json['name'],
      code: json['code'],
    );
  }
}

// lib/core/models/transfer_fee.dart
class TransferFee {
  final String id;
  final Country originCountry;
  final Country destinationCountry;
  final double pawapayFeePercentage;
  final double ourMarginPercentage;
  final double minAmount;
  final double maxAmount;
  final bool isActive;

  TransferFee({
    required this.id,
    required this.originCountry,
    required this.destinationCountry,
    required this.pawapayFeePercentage,
    required this.ourMarginPercentage,
    required this.minAmount,
    required this.maxAmount,
    required this.isActive,
  });

  double get totalFeePercentage => pawapayFeePercentage + ourMarginPercentage;
  String get corridor => '${originCountry.code}_to_${destinationCountry.code}';
}
```

### 7.2 Service Multi-Pays

```dart
// lib/core/services/country_service.dart
import 'package:dio/dio.dart';
import '../models/country.dart';
import '../models/operator.dart';
import '../models/transfer_fee.dart';
import 'api_service.dart';

class CountryService {
  final ApiService _apiService = ApiService();

  /// Récupérer la liste de tous les pays actifs
  Future<List<Country>> getCountries() async {
    try {
      final response = await _apiService.dio.get('/api/v1/countries');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => Country.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Erreur lors du chargement des pays: $e');
    }
  }

  /// Récupérer les opérateurs disponibles pour un pays
  Future<List<Operator>> getOperators(String countryCode) async {
    try {
      final response = await _apiService.dio.get(
        '/api/v1/operators/$countryCode'
      );
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => Operator.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Erreur lors du chargement des opérateurs: $e');
    }
  }

  /// Récupérer les corridors actifs
  Future<List<TransferFee>> getActiveCorridors() async {
    try {
      final response = await _apiService.dio.get('/api/v1/corridors');
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => TransferFee.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Erreur lors du chargement des corridors: $e');
    }
  }

  /// Calculer les frais de transfert
  Future<Map<String, dynamic>> calculateFees({
    required String originCountry,
    required String destinationCountry,
    required double amount,
  }) async {
    try {
      final response = await _apiService.dio.post(
        '/api/v1/transfer/calculate',
        data: {
          'origin_country': originCountry,
          'destination_country': destinationCountry,
          'amount': amount,
        },
      );
      if (response.statusCode == 200) {
        return response.data['data'];
      }
      throw Exception('Erreur calcul des frais');
    } catch (e) {
      throw Exception('Erreur lors du calcul des frais: $e');
    }
  }

  /// Obtenir le taux de change entre deux devises
  Future<Map<String, dynamic>> getExchangeRate(
    String fromCurrency,
    String toCurrency,
  ) async {
    try {
      final response = await _apiService.dio.get(
        '/api/v1/countries/$fromCurrency/$toCurrency/rate'
      );
      if (response.statusCode == 200) {
        return response.data['data'];
      }
      throw Exception('Erreur taux de change');
    } catch (e) {
      throw Exception('Erreur lors du chargement du taux de change: $e');
    }
  }
}
```

### 7.3 Écran d'Envoi Multi-Pays

```dart
// lib/features/transfer/send_money_screen.dart (extrait)
class _SendMoneyState extends State<SendMoneyScreen> {
  // Sélecteurs de pays dynamiques
  String? _selectedOriginCountryCode;
  String? _selectedDestinationCountryCode;
  String? _selectedOperator;
  
  List<Country> _countries = [];
  List<Operator> _operators = [];
  
  double _feePercentage = 0;
  double _exchangeRate = 1.0;
  double _amount = 0;
  
  final CountryService _countryService = CountryService();

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  /// Charger les pays depuis l'API
  Future<void> _loadCountries() async {
    try {
      final countries = await _countryService.getCountries();
      setState(() {
        _countries = countries;
        // Sélection par défaut
        if (countries.isNotEmpty) {
          _selectedOriginCountryCode = countries.first.code;
          _selectedDestinationCountryCode = countries.last.code;
          _loadOperators(countries.first.code);
          _calculateFees();
        }
      });
    } catch (e) {
      // Gérer l'erreur
    }
  }

  /// Charger les opérateurs pour un pays
  Future<void> _loadOperators(String countryCode) async {
    try {
      final operators = await _countryService.getOperators(countryCode);
      setState(() {
        _operators = operators;
        if (operators.isNotEmpty) {
          _selectedOperator = operators.first.code;
        }
      });
    } catch (e) {
      // Gérer l'erreur
    }
  }

  /// Calculer les frais en temps réel
  Future<void> _calculateFees() async {
    if (_selectedOriginCountryCode == null || 
        _selectedDestinationCountryCode == null || 
        _amount == 0) {
      return;
    }

    try {
      final result = await _countryService.calculateFees(
        originCountry: _selectedOriginCountryCode!,
        destinationCountry: _selectedDestinationCountryCode!,
        amount: _amount,
      );
      
      setState(() {
        _feePercentage = result['total_fee_percentage'] ?? 0;
        _exchangeRate = result['exchange_rate']?['rate'] ?? 1.0;
      });
    } catch (e) {
      // Gérer l'erreur
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Envoyer de l\'argent'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Pays d'origine
            DropdownButtonFormField<String>(
              value: _selectedOriginCountryCode,
              decoration: const InputDecoration(
                labelText: 'Pays d\'origine',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag),
              ),
              items: _countries.map((country) {
                return DropdownMenuItem(
                  value: country.code,
                  child: Row(
                    children: [
                      Text(country.flagEmoji),
                      const SizedBox(width: 8),
                      Text('${country.name} (${country.isoCode})'),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedOriginCountryCode = value;
                  if (value != null) _loadOperators(value);
                });
                _calculateFees();
              },
            ),

            const SizedBox(height: 16),

            // Pays de destination
            DropdownButtonFormField<String>(
              value: _selectedDestinationCountryCode,
              decoration: const InputDecoration(
                labelText: 'Pays de destination',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag),
              ),
              items: _countries.map((country) {
                return DropdownMenuItem(
                  value: country.code,
                  child: Row(
                    children: [
                      Text(country.flagEmoji),
                      const SizedBox(width: 8),
                      Text('${country.name} (${country.isoCode})'),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDestinationCountryCode = value;
                });
                _calculateFees();
              },
            ),

            const SizedBox(height: 16),

            // Opérateur Mobile Money
            DropdownButtonFormField<String>(
              value: _selectedOperator,
              decoration: const InputDecoration(
                labelText: 'Opérateur Mobile Money',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone_android),
              ),
              items: _operators.map((operator) {
                return DropdownMenuItem(
                  value: operator.code,
                  child: Text(operator.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedOperator = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // Montant
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Montant',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.attach_money),
                suffixText: _getCurrencyCode(),
              ),
              onChanged: (value) {
                setState(() {
                  _amount = double.tryParse(value) ?? 0;
                });
                _calculateFees();
              },
            ),

            const SizedBox(height: 16),

            // Résumé des frais
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildFeeRow('Frais de transfert', '${_feePercentage.toStringAsFixed(1)}%'),
                    _buildFeeRow('Taux de change', _exchangeRate.toStringAsFixed(4)),
                    _buildFeeRow(
                      'Vous envoyez',
                      '${(_amount * _exchangeRate).toStringAsFixed(2)} ${_getDestinationCurrency()}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Bouton envoyer
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _amount > 0 ? _sendMoney : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Envoyer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrencyCode() {
    final country = _countries.firstWhere(
      (c) => c.code == _selectedOriginCountryCode,
      orElse: () => _countries.first,
    );
    return country.isoCode;
  }

  String _getDestinationCurrency() {
    final country = _countries.firstWhere(
      (c) => c.code == _selectedDestinationCountryCode,
      orElse: () => _countries.first,
    );
    return country.isoCode;
  }

  Widget _buildFeeRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          )),
          Text(value, style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.green : null,
          )),
        ],
      ),
    );
  }
}
```

---

## 8. ADMIN PANEL – GESTION MULTI-PAYS

### 8.1 Interface d'Administration

```php
<?php
// app/Http/Controllers/Admin/CountryController.php

class CountryController extends Controller
{
    /**
     * Activer/désactiver un pays
     */
    public function toggleActive(Country $country)
    {
        $country->update(['is_active' => !$country->is_active]);
        
        return response()->json([
            'message' => 'Pays ' . ($country->is_active ? 'activé' : 'désactivé'),
            'data' => $country
        ]);
    }

    /**
     * Configurer les opérateurs Mobile Money d'un pays
     */
    public function updateOperators(Request $request, Country $country)
    {
        $validated = $request->validate([
            'operators' => 'required|array',
            'operators.*.name' => 'required|string',
            'operators.*.code' => 'required|string'
        ]);

        $country->update([
            'mobile_money_operators' => ['operators' => $validated['operators']]
        ]);

        return response()->json([
            'message' => 'Opérateurs mis à jour',
            'data' => $country
        ]);
    }
}
```

### 8.2 Configuration des Frais

```php
<?php
// app/Http/Controllers/Admin/FeeController.php

class FeeController extends Controller
{
    /**
     * Créer une configuration de frais pour un corridor
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'origin_country_id' => 'required|exists:countries,id',
            'destination_country_id' => 'required|exists:countries,id',
            'transfer_type' => 'required|in:disbursement,collection',
            'pawapay_fee_percentage' => 'required|numeric|min:0|max:100',
            'our_margin_percentage' => 'required|numeric|min:0|max:100',
            'min_amount' => 'nullable|numeric|min:0',
            'max_amount' => 'nullable|numeric|min:0'
        ]);

        $fee = TransferFee::create($validated);

        // Vider le cache des corridors
        Cache::forget('active_corridors');

        return response()->json([
            'message' => 'Configuration des frais créée',
            'data' => $fee
        ], 201);
    }

    /**
     * Mettre à jour une configuration de frais
     */
    public function update(Request $request, TransferFee $fee)
    {
        $fee->update($request->validate([
            'pawapay_fee_percentage' => 'numeric|min:0|max:100',
            'our_margin_percentage' => 'numeric|min:0|max:100',
            'min_amount' => 'numeric|min:0',
            'max_amount' => 'numeric|min:0',
            'is_active' => 'boolean'
        ]));

        Cache::forget('active_corridors');

        return response()->json([
            'message' => 'Configuration des frais mise à jour',
            'data' => $fee
        ]);
    }

    /**
     * Obtenir tous les corridors avec leurs frais
     */
    public function index()
    {
        $fees = TransferFee::with(['originCountry', 'destinationCountry'])
            ->get()
            ->map(function ($fee) {
                return [
                    'id' => $fee->id,
                    'corridor' => $fee->originCountry->code . ' → ' . $fee->destinationCountry->code,
                    'origin_country' => $fee->originCountry->name,
                    'destination_country' => $fee->destinationCountry->name,
                    'pawapay_fee_percentage' => $fee->pawapay_fee_percentage,
                    'our_margin_percentage' => $fee->our_margin_percentage,
                    'total_fee_percentage' => $fee->pawapay_fee_percentage + $fee->our_margin_percentage,
                    'min_amount' => $fee->min_amount,
                    'max_amount' => $fee->max_amount,
                    'is_active' => $fee->is_active
                ];
            });

        return response()->json([
            'data' => $fees
        ]);
    }
}
```

---

## 9. STRATÉGIE D'EXPANSION

### 9.1 Feuille de Route Multi-Pays

| Phase | Pays | Opérateurs | Période |
|-------|------|------------|---------|
| Phase 1 | Gabon, Bénin | Airtel, MTN | M1-M2 |
| Phase 2 | Côte d'Ivoire, Sénégal | MTN, Orange, Free | M3-M4 |
| Phase 3 | Cameroun, Togo | MTN, Orange, Flooz | M5-M6 |
| Phase 4 | Mali, Burkina, Niger | Orange Money | M7-M8 |
| Phase 5 | RDC, Autres | Airtel, Orange | M9-M10 |

### 9.2 Processus d'Ajout d'un Nouveau Pays

1. **Vérification de la disponibilité PAWAPAY**
   - Vérifier le support de l'opérateur dans le pays
   - Obtenir les codes service PAWAPAY

2. **Configuration Backend**
   ```php
   // Ajouter dans config/pawapay.php
   'TG' => [
       'name' => 'Togo',
       'currency' => 'XOF',
       'operators' => [
           'Flooz' => 'FLOOZ_TG',
           'T-Money' => 'TMONEY_TG'
       ]
   ],
   ```

3. **Ajout dans la base de données**
   ```sql
   INSERT INTO countries (code, name, iso_code, currency_name, mobile_money_operators) 
   VALUES ('TG', 'Togo', 'XOF', 'Franc CFA', '{"operators": [{"name": "Flooz", "code": "FLOOZ_TG"}, {"name": "T-Money", "code": "TMONEY_TG"}]}');
   ```

4. **Configuration des frais**
   ```sql
   INSERT INTO transfer_fees (origin_country_id, destination_country_id, transfer_type, pawapay_fee_percentage, our_margin_percentage)
   SELECT ga.id, tg.id, 'disbursement', 1.0, 1.5
   FROM countries ga, countries tg 
   WHERE ga.code='GA' AND tg.code='TG';
   ```

5. **Mise à jour du Frontend**
   - Les listes de pays se mettent à jour dynamiquement
   - Aucune modification de code nécessaire
   - Déploiement transparent

---

## 10. INDICATEURS DE PERFORMANCE (KPIs)

### 10.1 KPIs Opérationnels

| KPI | Cible | Fréquence |
|-----|-------|-----------|
| **Pays actifs** | 10+ | Mensuel |
| **Transactions par pays** | > 500/mois | Mensuel |
| **Temps de traitement** | < 30s | Hebdo |
| **Taux de conversion client** | > 20% | Mensuel |
| **Rétention M+1** | > 70% | Mensuel |
| **NPS** | > 50 | Trimestriel |
| **Volume mensuel total** | 100M XOF | Mensuel |

### 10.2 KPIs Financiers

| KPI | Cible | Fréquence |
|-----|-------|-----------|
| **Marge nette** | 1 000 000 XOF/mois | Mensuel |
| **Breakeven** | 1 000 transactions | Mensuel |
| **Revenu par transaction** | 500 XOF | Mensuel |
| **Coût d'acquisition** | < 500 XOF | Trimestriel |
| **Valeur vie client** | 25 000 XOF | Annuel |

---

## 11. RISQUES ET MITIGATIONS (MULTI-PAYS)

| Risque | Probabilité | Impact | Mitigation |
|--------|-------------|--------|------------|
| **Variation des frais PAWAPAY par pays** | Élevé | Élevé | Révision mensuelle, marge variable |
| **Indisponibilité d'un opérateur** | Moyen | Élevé | Circuit de repli, notification utilisateur |
| **Réglementation différente par pays** | Élevé | Élevé | Compliance locale, partenaires locaux |
| **Taux de change volatil** | Élevé | Moyen | Mise à jour en temps réel, blocage si > 5% |
| **Concurrence par pays** | Moyen | Moyen | Offres locales, partenariats |
| **Problèmes d'intégration PAWAPAY** | Moyen | Élevé | Monitoring, équipe support dédiée |

---

## 12. LIVRABLES FINAUX

### 12.1 Backend Laravel
- ✅ Modèles et migrations Multi-Pays
- ✅ Contrôleurs API pour tous les endpoints
- ✅ Service PAWAPAY Multi-Pays
- ✅ Système de fidélité et promotions
- ✅ Admin Panel complet
- ✅ Documentation Swagger/OpenAPI
- ✅ Tests unitaires > 80%
- ✅ Code 100% commenté en français

### 12.2 Frontend Flutter
- ✅ Écrans multi-pays dynamiques
- ✅ Sélecteurs de pays et opérateurs
- ✅ Calcul des frais en temps réel
- ✅ Affichage du taux de change
- ✅ Gestion des bénéficiaires multi-pays
- ✅ Programme de fidélité
- ✅ Notifications push
- ✅ Code 100% commenté en français

### 12.3 Configuration
- ✅ Scripts de déploiement
- ✅ Fichiers de configuration PAWAPAY
- ✅ Seeders pour pays et opérateurs
- ✅ Guides d'intégration pour nouveaux pays

---

## 13. CONCLUSION

Cette version 3.0 du cahier des charges transforme l'application en une **plateforme panafricaine de transfert d'argent**, scalable et extensible à l'ensemble des pays couverts par PAWAPAY. L'architecture modulaire permet :

✅ **L'ajout rapide de nouveaux pays** sans modification du code existant  
✅ **La configuration dynamique des frais** par corridor  
✅ **Une interface utilisateur adaptative** qui s'enrichit avec la couverture  
✅ **Un modèle économique rentable** avec des marges optimisées  
✅ **Une expérience utilisateur unifiée** à travers tout le continent africain  

**L'application devient ainsi un super-app de transfert panafricain, positionnée pour dominer le marché des transferts d'argent mobile en Afrique.**