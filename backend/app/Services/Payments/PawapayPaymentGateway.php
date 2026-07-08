<?php

namespace App\Services\Payments;

class PawapayPaymentGateway implements PaymentGatewayInterface
{
    public function collect(array $payload): array
    {
        // TODO: integrate PAWAPAY collection API after account approval.
        return ['status' => 'not_configured', 'payload' => $payload];
    }

    public function disburse(array $payload): array
    {
        // TODO: integrate PAWAPAY disbursement API after account approval.
        return ['status' => 'not_configured', 'payload' => $payload];
    }

    public function status(string $transactionReference): array
    {
        // TODO: integrate PAWAPAY status API.
        return ['reference' => $transactionReference, 'status' => 'not_configured'];
    }
}
