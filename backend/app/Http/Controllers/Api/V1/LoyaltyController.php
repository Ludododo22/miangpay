<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Api\V1\Concerns\ResolvesDemoUser;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class LoyaltyController extends Controller
{
    use ResolvesDemoUser;

    public function overview()
    {
        $user = $this->currentUser();
        $activities = DB::table('loyalty_activities')
            ->where('user_id', $user->id)
            ->orderByDesc('created_at')
            ->get();

        return response()->json([
            'data' => [
                'points' => $user->loyalty_points,
                'tier' => $user->loyalty_tier,
                'next_tier' => $user->loyalty_points >= 10000 ? 'Platine' : 'Or',
                'activities' => $activities,
            ],
        ]);
    }
}
