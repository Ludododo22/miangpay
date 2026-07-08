<?php

return [
    'gateway' => env('PAYMENT_GATEWAY', 'fake'),

    'pawapay' => [
        'base_url' => env('PAWAPAY_BASE_URL'),
        'api_key' => env('PAWAPAY_API_KEY'),
        'secret' => env('PAWAPAY_SECRET'),
        'merchant_id' => env('PAWAPAY_MERCHANT_ID'),
    ],
];
