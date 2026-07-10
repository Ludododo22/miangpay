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
}
