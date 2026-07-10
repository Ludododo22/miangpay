<?php

namespace App\Http\Controllers\Api\V1\Concerns;

use Illuminate\Support\Facades\DB;

trait ResolvesDemoUser
{
    protected function currentUserId(): string
    {
        $authId = auth()->id();
        if ($authId) {
            return (string) $authId;
        }

        $demoUserId = DB::table('users')->where('phone', '+22961000000')->value('id');

        if (!$demoUserId) {
            abort(404, 'Demo user not found. Run backend/database/sql/02_seed_demo.sql first.');
        }

        return (string) $demoUserId;
    }

    protected function currentUser()
    {
        return DB::table('users')->where('id', $this->currentUserId())->first();
    }
}
