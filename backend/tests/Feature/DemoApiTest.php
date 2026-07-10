<?php

namespace Tests\Feature;

use Tests\TestCase;

class DemoApiTest extends TestCase
{
    public function test_demo_api_exposes_frontend_bootstrap_data(): void
    {
        $this->getJson('/api/v1/countries')
            ->assertOk()
            ->assertJsonStructure(['data' => [['code', 'name', 'currency_code']]]);

        $this->getJson('/api/v1/beneficiaries')
            ->assertOk()
            ->assertJsonStructure(['data' => [['id', 'full_name', 'country_code', 'operator_name']]]);
    }

    public function test_demo_auth_and_transfer_quote_work(): void
    {
        $this->postJson('/api/v1/auth/login', [
            'phone' => '+22961000000',
            'password' => 'ludovic',
        ])
            ->assertOk()
            ->assertJsonStructure(['data' => ['id', 'phone'], 'token']);

        $this->postJson('/api/v1/transfer/calculate', [
            'amount' => 10000,
            'source_country' => 'BJ',
            'destination_country' => 'CI',
        ])
            ->assertOk()
            ->assertJsonStructure([
                'data' => [
                    'amount',
                    'fee',
                    'exchange_rate',
                    'received_amount',
                    'source_currency',
                    'destination_currency',
                ],
            ]);
    }

    public function test_demo_api_exposes_account_modules(): void
    {
        $this->getJson('/api/v1/user/profile')
            ->assertOk()
            ->assertJsonStructure(['data' => ['id', 'phone', 'country_name', 'flag_emoji']]);

        $this->getJson('/api/v1/cards')
            ->assertOk()
            ->assertJsonStructure(['data' => [['id', 'holder_name', 'last_digits', 'currency']]]);

        $this->getJson('/api/v1/notifications')
            ->assertOk()
            ->assertJsonStructure(['data' => [['id', 'title', 'body', 'category']]]);

        $this->getJson('/api/v1/promotions/active')
            ->assertOk()
            ->assertJsonStructure(['data' => [['id', 'title', 'description', 'discount_percent']]]);

        $this->getJson('/api/v1/support/tickets')
            ->assertOk()
            ->assertJsonStructure(['data' => [['id', 'reference', 'subject', 'status']]]);

        $this->getJson('/api/v1/loyalty/overview')
            ->assertOk()
            ->assertJsonStructure([
                'data' => [
                    'points',
                    'tier',
                    'next_tier_points',
                    'referrals',
                    'referral_code',
                    'tiers' => [['id', 'name', 'min_points', 'fee_discount']],
                    'rewards' => [['id', 'title', 'points_cost', 'available']],
                    'challenges' => [['id', 'title', 'reward_points', 'progress', 'target']],
                    'activities' => [['id', 'label', 'points', 'activity_type']],
                ],
            ]);
    }
}
