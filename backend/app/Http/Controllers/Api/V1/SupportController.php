<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Api\V1\Concerns\ResolvesDemoUser;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class SupportController extends Controller
{
    use ResolvesDemoUser;

    public function index()
    {
        return response()->json([
            'data' => DB::table('support_tickets')
                ->where('user_id', $this->currentUserId())
                ->orderByDesc('created_at')
                ->get(),
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'subject' => ['required', 'string', 'max:180'],
            'category' => ['required', 'string', 'max:80'],
            'message' => ['required', 'string'],
            'priority' => ['nullable', 'string', 'max:40'],
        ]);

        $ticketId = (string) Str::uuid();
        $reference = 'SUP-' . random_int(1000, 9999);

        DB::transaction(function () use ($ticketId, $reference, $validated) {
            DB::table('support_tickets')->insert([
                'id' => $ticketId,
                'user_id' => $this->currentUserId(),
                'reference' => $reference,
                'subject' => $validated['subject'],
                'category' => $validated['category'],
                'status' => 'open',
                'priority' => $validated['priority'] ?? 'normal',
                'created_at' => now(),
                'updated_at' => now(),
            ]);

            DB::table('support_messages')->insert([
                'id' => (string) Str::uuid(),
                'ticket_id' => $ticketId,
                'sender_type' => 'user',
                'message' => $validated['message'],
                'created_at' => now(),
            ]);
        });

        return response()->json(['data' => $this->ticketWithMessages($ticketId)], 201);
    }

    public function show(string $ticket)
    {
        $item = $this->ticketWithMessages($ticket);
        abort_if(!$item, 404, 'Ticket not found');

        return response()->json(['data' => $item]);
    }

    public function update(Request $request, string $ticket)
    {
        $validated = $request->validate([
            'status' => ['sometimes', 'string', 'max:40'],
            'priority' => ['sometimes', 'string', 'max:40'],
            'message' => ['nullable', 'string'],
        ]);

        $item = DB::table('support_tickets')
            ->where('id', $ticket)
            ->where('user_id', $this->currentUserId())
            ->first();

        abort_if(!$item, 404, 'Ticket not found');

        DB::table('support_tickets')
            ->where('id', $ticket)
            ->update([
                'status' => $validated['status'] ?? $item->status,
                'priority' => $validated['priority'] ?? $item->priority,
                'updated_at' => now(),
            ]);

        if (!empty($validated['message'])) {
            DB::table('support_messages')->insert([
                'id' => (string) Str::uuid(),
                'ticket_id' => $ticket,
                'sender_type' => 'user',
                'message' => $validated['message'],
                'created_at' => now(),
            ]);
        }

        return $this->show($ticket);
    }

    public function destroy(string $ticket)
    {
        $exists = DB::table('support_tickets')
            ->where('id', $ticket)
            ->where('user_id', $this->currentUserId())
            ->exists();

        abort_if(!$exists, 404, 'Ticket not found');

        DB::table('support_messages')->where('ticket_id', $ticket)->delete();
        DB::table('support_tickets')->where('id', $ticket)->delete();

        return response()->noContent();
    }

    private function ticketWithMessages(string $ticket)
    {
        $item = DB::table('support_tickets')
            ->where('id', $ticket)
            ->where('user_id', $this->currentUserId())
            ->first();

        if (!$item) {
            return null;
        }

        $item->messages = DB::table('support_messages')
            ->where('ticket_id', $ticket)
            ->orderBy('created_at')
            ->get();

        return $item;
    }
}
