<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class CountryController extends Controller
{
    public function index()
    {
        return response()->json([
            'data' => DB::table('countries')->where('is_active', true)->orderBy('name')->get(),
        ]);
    }

    public function show(string $code)
    {
        $country = DB::table('countries')->where('code', strtoupper($code))->first();

        abort_if(!$country, 404, 'Country not found');

        return response()->json(['data' => $country]);
    }

    public function operators(string $countryCode)
    {
        $operators = DB::table('operators')
            ->join('countries', 'countries.id', '=', 'operators.country_id')
            ->where('countries.code', strtoupper($countryCode))
            ->where('operators.is_active', true)
            ->orderBy('operators.name')
            ->select('operators.*')
            ->get();

        return response()->json(['data' => $operators]);
    }

    public function corridors()
    {
        $corridors = DB::table('corridors')
            ->join('countries as origin', 'origin.id', '=', 'corridors.origin_country_id')
            ->join('countries as destination', 'destination.id', '=', 'corridors.destination_country_id')
            ->where('corridors.is_active', true)
            ->orderBy('origin.name')
            ->select([
                'corridors.id',
                'origin.code as origin_code',
                'origin.name as origin_name',
                'destination.code as destination_code',
                'destination.name as destination_name',
                'corridors.exchange_rate',
                'corridors.fee_percent',
                'corridors.min_fee',
                'corridors.max_fee',
                'corridors.estimated_minutes',
            ])
            ->get();

        return response()->json(['data' => $corridors]);
    }
}
