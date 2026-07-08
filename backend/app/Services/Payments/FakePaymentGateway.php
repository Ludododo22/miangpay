<?php

namespace App\Services\Payments;

class FakePaymentGateway implements PaymentGatewayInterface
{
    public function collect(array $payload): array
    {
        return $this->fakeResponse('collection', $payload);
    }

    public function disburse(array $payload): array
    {
        return $this->fakeResponse('disbursement', $payload);
    }

    public function status(string $transactionReference): array
    {
        return [
            'reference' => $transactionReference,
            'status' => 'completed',
            'provider' => 'fake',
        ];
    }

    private function fakeResponse(string $type, array $payload): array
    {
        return [
            'provider' => 'fake',
            'type' => $type,
            'reference' => 'FAKE_' . now()->format('YmdHis') . '_' . random_int(1000, 9999),
            'status' => 'completed',
            'payload' => $payload,
        ];
    }
}
