<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Api\V1\Concerns\ResolvesDemoUser;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class TransferController extends Controller
{
    use ResolvesDemoUser;

    public function calculate(Request $request)
    {
        $validated = $request->validate([
            'amount' => ['required', 'numeric', 'min:1'],
            'source_country' => ['required', 'string', 'size:2'],
            'destination_country' => ['required', 'string', 'size:2'],
        ]);

        $source = $this->country($validated['source_country']);
        $destination = $this->country($validated['destination_country']);
        $corridor = $this->corridor($source->id, $destination->id);
        $feePercent = $corridor?->fee_percent ?? ($source->code === $destination->code ? 1.5 : 2.5);
        $fee = min(max($validated['amount'] * ($feePercent / 100), $corridor?->min_fee ?? 250), $corridor?->max_fee ?? 5000);
        $exchangeRate = $corridor?->exchange_rate ?? 1;

        return response()->json([
            'data' => [
                'amount' => (float) $validated['amount'],
                'fee' => round($fee, 2),
                'exchange_rate' => (float) $exchangeRate,
                'received_amount' => round(($validated['amount'] - $fee) * $exchangeRate, 2),
                'source_currency' => $source->currency_code,
                'destination_currency' => $destination->currency_code,
                'estimated_minutes' => $corridor?->estimated_minutes ?? 5,
            ],
        ]);
    }

    public function send(Request $request)
    {
        $validated = $request->validate([
            'beneficiary_id' => ['required', 'uuid'],
            'amount' => ['required', 'numeric', 'min:1'],
            'source_country' => ['required', 'string', 'size:2'],
        ]);

        $beneficiary = DB::table('beneficiaries')->where('id', $validated['beneficiary_id'])->first();
        abort_if(!$beneficiary, 404, 'Beneficiary not found');

        $source = $this->country($validated['source_country']);
        $destination = DB::table('countries')->where('id', $beneficiary->country_id)->first();
        $quote = $this->quote($validated['amount'], $source, $destination);
        $reference = 'MP' . now()->format('YmdHis') . random_int(100, 999);

        $id = (string) Str::uuid();
        DB::table('transactions')->insert([
            'id' => $id,
            'reference' => $reference,
            'user_id' => $this->currentUserId(),
            'beneficiary_id' => $beneficiary->id,
            'origin_country_id' => $source->id,
            'destination_country_id' => $destination->id,
            'operator_id' => $beneficiary->operator_id,
            'status' => 'completed',
            'amount' => $quote['amount'],
            'fee' => $quote['fee'],
            'received_amount' => $quote['received_amount'],
            'currency' => $source->currency_code,
            'destination_currency' => $destination->currency_code,
            'exchange_rate' => $quote['exchange_rate'],
            'gateway_reference' => 'FAKE-' . $reference,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return response()->json(['data' => $this->transactionQuery()->where('transactions.id', $id)->first()], 201);
    }

    public function status(string $transaction)
    {
        $item = $this->transactionQuery()
            ->where(fn ($query) => $query->where('transactions.id', $transaction)->orWhere('transactions.reference', $transaction))
            ->first();

        abort_if(!$item, 404, 'Transaction not found');

        return response()->json(['data' => $item]);
    }

    public function history()
    {
        return response()->json(['data' => $this->transactionQuery()->limit(50)->get()]);
    }

    private function quote(float $amount, object $source, object $destination): array
    {
        $corridor = $this->corridor($source->id, $destination->id);
        $feePercent = $corridor?->fee_percent ?? ($source->code === $destination->code ? 1.5 : 2.5);
        $fee = min(max($amount * ($feePercent / 100), $corridor?->min_fee ?? 250), $corridor?->max_fee ?? 5000);
        $exchangeRate = $corridor?->exchange_rate ?? 1;

        return [
            'amount' => $amount,
            'fee' => round($fee, 2),
            'received_amount' => round(($amount - $fee) * $exchangeRate, 2),
            'exchange_rate' => $exchangeRate,
        ];
    }

    private function country(string $code)
    {
        $country = DB::table('countries')->where('code', strtoupper($code))->first();
        abort_if(!$country, 422, 'Unsupported country');

        return $country;
    }

    private function corridor(string $sourceId, string $destinationId)
    {
        return DB::table('corridors')
            ->where('origin_country_id', $sourceId)
            ->where('destination_country_id', $destinationId)
            ->where('is_active', true)
            ->first();
    }

    private function transactionQuery()
    {
        return DB::table('transactions')
            ->leftJoin('beneficiaries', 'beneficiaries.id', '=', 'transactions.beneficiary_id')
            ->join('countries as origin', 'origin.id', '=', 'transactions.origin_country_id')
            ->join('countries as destination', 'destination.id', '=', 'transactions.destination_country_id')
            ->leftJoin('operators', 'operators.id', '=', 'transactions.operator_id')
            ->where('transactions.user_id', $this->currentUserId())
            ->orderByDesc('transactions.created_at')
            ->select([
                'transactions.*',
                'beneficiaries.full_name as beneficiary_name',
                'origin.code as origin_code',
                'origin.name as origin_name',
                'destination.code as destination_code',
                'destination.name as destination_name',
                'operators.name as operator_name',
            ]);
    }
}
