<?php

namespace App\Services\Payments;

interface PaymentGatewayInterface
{
    public function collect(array $payload): array;
    public function disburse(array $payload): array;
    public function status(string $transactionReference): array;
}
