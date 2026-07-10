<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class PromotionController extends Controller
{
    public function active()
    {
        $promotions = DB::table('promotions')
            ->leftJoin('countries', 'countries.id', '=', 'promotions.target_country_id')
            ->where('promotions.is_active', true)
            ->where('promotions.expires_at', '>', now())
            ->orderBy('promotions.expires_at')
            ->select('promotions.*', 'countries.code as target_country_code', 'countries.name as target_country_name')
            ->get();

        return response()->json(['data' => $promotions]);
    }
}
