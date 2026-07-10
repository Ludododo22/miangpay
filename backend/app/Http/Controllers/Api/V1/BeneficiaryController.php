<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Api\V1\Concerns\ResolvesDemoUser;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\Rule;

class BeneficiaryController extends Controller
{
    use ResolvesDemoUser;

    public function index()
    {
        return response()->json(['data' => $this->query()->get()]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'full_name' => ['required', 'string', 'max:160'],
            'phone' => [
                'required',
                'string',
                'max:32',
                Rule::unique('beneficiaries', 'phone')
                    ->where(fn ($query) => $query->where('user_id', $this->currentUserId())),
            ],
            'country_code' => ['required', 'string', 'size:2'],
            'operator_code' => ['required', 'string', 'max:40'],
            'relationship' => ['nullable', 'string', 'max:60'],
            'is_favorite' => ['boolean'],
        ]);

        $countryId = DB::table('countries')->where('code', strtoupper($validated['country_code']))->value('id');
        $operatorId = DB::table('operators')->where('code', $validated['operator_code'])->value('id');
        abort_if(!$countryId || !$operatorId, 422, 'Invalid country or operator');

        $id = (string) Str::uuid();
        DB::table('beneficiaries')->insert([
            'id' => $id,
            'user_id' => $this->currentUserId(),
            'full_name' => $validated['full_name'],
            'phone' => $validated['phone'],
            'country_id' => $countryId,
            'operator_id' => $operatorId,
            'relationship' => $validated['relationship'] ?? null,
            'is_favorite' => $validated['is_favorite'] ?? false,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return response()->json(['data' => $this->query()->where('beneficiaries.id', $id)->first()], 201);
    }

    public function show(string $beneficiary)
    {
        $item = $this->query()->where('beneficiaries.id', $beneficiary)->first();
        abort_if(!$item, 404, 'Beneficiary not found');

        return response()->json(['data' => $item]);
    }

    public function update(Request $request, string $beneficiary)
    {
        $validated = $request->validate([
            'full_name' => ['sometimes', 'string', 'max:160'],
            'relationship' => ['nullable', 'string', 'max:60'],
            'is_favorite' => ['sometimes', 'boolean'],
        ]);

        $exists = DB::table('beneficiaries')
            ->where('id', $beneficiary)
            ->where('user_id', $this->currentUserId())
            ->exists();

        abort_if(!$exists, 404, 'Beneficiary not found');

        DB::table('beneficiaries')
            ->where('id', $beneficiary)
            ->update(array_merge($validated, ['updated_at' => now()]));

        return $this->show($beneficiary);
    }

    public function destroy(string $beneficiary)
    {
        $exists = DB::table('beneficiaries')
            ->where('id', $beneficiary)
            ->where('user_id', $this->currentUserId())
            ->exists();

        abort_if(!$exists, 404, 'Beneficiary not found');

        abort_if(
            DB::table('transactions')->where('beneficiary_id', $beneficiary)->exists(),
            409,
            'Beneficiary has transactions and cannot be deleted'
        );

        DB::table('beneficiaries')->where('id', $beneficiary)->delete();

        return response()->noContent();
    }

    public function toggleFavorite(string $beneficiary)
    {
        $item = DB::table('beneficiaries')
            ->where('id', $beneficiary)
            ->where('user_id', $this->currentUserId())
            ->first();

        abort_if(!$item, 404, 'Beneficiary not found');

        DB::table('beneficiaries')->where('id', $beneficiary)->update([
            'is_favorite' => !$item->is_favorite,
            'updated_at' => now(),
        ]);

        return $this->show($beneficiary);
    }

    private function query()
    {
        return DB::table('beneficiaries')
            ->join('countries', 'countries.id', '=', 'beneficiaries.country_id')
            ->join('operators', 'operators.id', '=', 'beneficiaries.operator_id')
            ->where('beneficiaries.user_id', $this->currentUserId())
            ->orderByDesc('beneficiaries.is_favorite')
            ->orderBy('beneficiaries.full_name')
            ->select([
                'beneficiaries.*',
                'countries.code as country_code',
                'countries.name as country_name',
                'countries.currency_code',
                'countries.flag_emoji',
                'operators.code as operator_code',
                'operators.name as operator_name',
                'operators.service_code',
            ]);
    }
}
