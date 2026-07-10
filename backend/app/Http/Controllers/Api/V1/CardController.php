<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Api\V1\Concerns\ResolvesDemoUser;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class CardController extends Controller
{
    use ResolvesDemoUser;

    public function index()
    {
        return response()->json(['data' => $this->cardsQuery()->get()]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'currency' => ['required', 'string', 'size:3'],
            'daily_limit' => ['required', 'numeric', 'min:1000'],
            'label' => ['nullable', 'string', 'max:120'],
        ]);

        $user = $this->currentUser();
        $id = (string) Str::uuid();

        DB::table('virtual_cards')->insert([
            'id' => $id,
            'user_id' => $user->id,
            'label' => $validated['label'] ?? 'Nouvelle carte',
            'holder_name' => trim($user->first_name . ' ' . $user->last_name),
            'last_digits' => (string) random_int(1000, 9999),
            'currency' => strtoupper($validated['currency']),
            'balance' => 0,
            'expiry_month' => 12,
            'expiry_year' => now()->addYears(3)->year,
            'daily_limit' => $validated['daily_limit'],
            'monthly_limit' => $validated['daily_limit'] * 10,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return response()->json(['data' => $this->cardsQuery()->where('virtual_cards.id', $id)->first()], 201);
    }

    public function show(string $card)
    {
        $item = $this->cardsQuery()->where('virtual_cards.id', $card)->first();
        abort_if(!$item, 404, 'Card not found');

        $transactions = DB::table('card_transactions')
            ->where('virtual_card_id', $card)
            ->orderByDesc('created_at')
            ->get();

        return response()->json([
            'data' => $item,
            'transactions' => $transactions,
        ]);
    }

    public function update(Request $request, string $card)
    {
        $validated = $request->validate([
            'label' => ['sometimes', 'string', 'max:120'],
            'daily_limit' => ['sometimes', 'numeric', 'min:1000'],
            'online_payments_enabled' => ['sometimes', 'boolean'],
        ]);

        if (isset($validated['daily_limit'])) {
            $validated['monthly_limit'] = $validated['daily_limit'] * 10;
        }

        $exists = DB::table('virtual_cards')
            ->where('id', $card)
            ->where('user_id', $this->currentUserId())
            ->exists();

        abort_if(!$exists, 404, 'Card not found');

        DB::table('virtual_cards')
            ->where('id', $card)
            ->update(array_merge($validated, ['updated_at' => now()]));

        return $this->show($card);
    }

    public function destroy(string $card)
    {
        $exists = DB::table('virtual_cards')
            ->where('id', $card)
            ->where('user_id', $this->currentUserId())
            ->exists();

        abort_if(!$exists, 404, 'Card not found');

        DB::table('card_transactions')->where('virtual_card_id', $card)->delete();
        DB::table('virtual_cards')->where('id', $card)->delete();

        return response()->noContent();
    }

    public function load(Request $request, string $card)
    {
        $validated = $request->validate(['amount' => ['required', 'numeric', 'min:1']]);
        $item = DB::table('virtual_cards')->where('id', $card)->where('user_id', $this->currentUserId())->first();
        abort_if(!$item, 404, 'Card not found');

        DB::table('virtual_cards')->where('id', $card)->update([
            'balance' => $item->balance + $validated['amount'],
            'updated_at' => now(),
        ]);

        DB::table('card_transactions')->insert([
            'id' => (string) Str::uuid(),
            'virtual_card_id' => $card,
            'merchant' => 'Recharge Mobile Money',
            'subtitle' => 'Crédit carte • Maintenant',
            'amount' => $validated['amount'],
            'currency' => $item->currency,
            'is_credit' => true,
            'status' => 'completed',
            'created_at' => now(),
        ]);

        return $this->show($card);
    }

    public function block(string $card)
    {
        return $this->setFrozen($card, true);
    }

    public function unblock(string $card)
    {
        return $this->setFrozen($card, false);
    }

    private function setFrozen(string $card, bool $frozen)
    {
        $updated = DB::table('virtual_cards')
            ->where('id', $card)
            ->where('user_id', $this->currentUserId())
            ->update([
                'is_frozen' => $frozen,
                'updated_at' => now(),
            ]);

        abort_if(!$updated, 404, 'Card not found');

        return $this->show($card);
    }

    private function cardsQuery()
    {
        return DB::table('virtual_cards')
            ->where('user_id', $this->currentUserId())
            ->orderByDesc('created_at');
    }
}
