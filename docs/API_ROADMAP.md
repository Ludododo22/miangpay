# Roadmap API

## Auth

- POST /api/v1/auth/register
- POST /api/v1/auth/login
- POST /api/v1/auth/verify-otp
- GET /api/v1/user/profile
- POST /api/v1/user/kyc

## Pays

- GET /api/v1/countries
- GET /api/v1/operators/{countryCode}
- GET /api/v1/corridors

## Transferts

- POST /api/v1/transfer/calculate
- POST /api/v1/transfer/send
- GET /api/v1/transfer/status/{transaction}
- GET /api/v1/transfer/history

## Bénéficiaires

- GET /api/v1/beneficiaries
- POST /api/v1/beneficiaries
- PUT /api/v1/beneficiaries/{id}
- DELETE /api/v1/beneficiaries/{id}

## Cartes

- GET /api/v1/cards
- POST /api/v1/cards
- POST /api/v1/cards/{id}/load
- POST /api/v1/cards/{id}/block
- POST /api/v1/cards/{id}/unblock
