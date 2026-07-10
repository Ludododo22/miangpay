<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Api\V1\Concerns\ResolvesDemoUser;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class NotificationController extends Controller
{
    use ResolvesDemoUser;

    public function index()
    {
        return response()->json([
            'data' => DB::table('notifications')
                ->where('user_id', $this->currentUserId())
                ->orderByDesc('created_at')
                ->get(),
        ]);
    }
}
