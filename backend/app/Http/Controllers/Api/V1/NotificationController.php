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

    public function markRead(string $notification)
    {
        $exists = DB::table('notifications')
            ->where('id', $notification)
            ->where('user_id', $this->currentUserId())
            ->exists();

        abort_if(!$exists, 404, 'Notification not found');

        DB::table('notifications')
            ->where('id', $notification)
            ->where('user_id', $this->currentUserId())
            ->update(['is_read' => true]);

        return response()->json([
            'data' => DB::table('notifications')->where('id', $notification)->first(),
        ]);
    }

    public function markAllRead()
    {
        DB::table('notifications')
            ->where('user_id', $this->currentUserId())
            ->update(['is_read' => true]);

        return $this->index();
    }
}
