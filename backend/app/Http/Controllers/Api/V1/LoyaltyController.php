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
                'next_tier_points' => $this->nextTierPoints((int) $user->loyalty_points),
                'referrals' => 8,
                'referral_code' => $user->referral_code,
                'tiers' => $this->tiers(),
                'rewards' => $this->rewards((int) $user->loyalty_points),
                'challenges' => $this->challenges(),
                'activities' => $activities,
            ],
        ]);
    }

    private function nextTierPoints(int $points): int
    {
        return match (true) {
            $points < 500 => 500,
            $points < 2000 => 2000,
            $points < 5000 => 5000,
            default => 10000,
        };
    }

    private function tiers(): array
    {
        return [
            [
                'id' => 'bronze',
                'name' => 'Bronze',
                'min_points' => 0,
                'max_points' => 499,
                'description' => 'Compte standard avec avantages de base',
                'fee_discount' => 10,
                'free_transfers' => 0,
                'icon' => 'bronze',
            ],
            [
                'id' => 'silver',
                'name' => 'Argent',
                'min_points' => 500,
                'max_points' => 1999,
                'description' => 'Frais reduits et 1 transfert gratuit par mois',
                'fee_discount' => 25,
                'free_transfers' => 1,
                'icon' => 'silver',
            ],
            [
                'id' => 'gold',
                'name' => 'Or',
                'min_points' => 2000,
                'max_points' => 4999,
                'description' => 'Frais fortement reduits et support prioritaire',
                'fee_discount' => 50,
                'free_transfers' => 2,
                'icon' => 'gold',
            ],
            [
                'id' => 'platinum',
                'name' => 'Platine',
                'min_points' => 5000,
                'max_points' => null,
                'description' => 'Support VIP, offres exclusives et frais minimum',
                'fee_discount' => 75,
                'free_transfers' => 3,
                'icon' => 'platinum',
            ],
        ];
    }

    private function rewards(int $points): array
    {
        $items = [
            ['id' => 'r1', 'title' => '1 transfert gratuit', 'description' => 'A utiliser sur un corridor actif', 'points_cost' => 500, 'category' => 'Transfert'],
            ['id' => 'r2', 'title' => '-25% sur les frais', 'description' => 'Reduction immediate sur le prochain envoi', 'points_cost' => 1000, 'category' => 'Frais'],
            ['id' => 'r3', 'title' => 'Carte virtuelle gratuite', 'description' => 'Creation d une carte sans frais', 'points_cost' => 3000, 'category' => 'Carte'],
            ['id' => 'r4', 'title' => 'Bonus Mobile Money', 'description' => 'Recevez 2 000 XOF de bonus', 'points_cost' => 5000, 'category' => 'Bonus'],
        ];

        return array_map(fn (array $item) => array_merge($item, [
            'available' => $points >= $item['points_cost'],
        ]), $items);
    }

    private function challenges(): array
    {
        return [
            ['id' => 'c1', 'title' => '5 transferts cette semaine', 'description' => 'Effectuez 5 transferts pour gagner des points bonus', 'reward_points' => 150, 'progress' => 3, 'target' => 5, 'deadline' => 'Expire dimanche'],
            ['id' => 'c2', 'title' => '3 pays differents', 'description' => 'Envoyez vers 3 pays africains differents', 'reward_points' => 300, 'progress' => 2, 'target' => 3, 'deadline' => 'Encore 10 jours'],
            ['id' => 'c3', 'title' => 'Parrainer 2 amis', 'description' => 'Invitez 2 amis et gagnez des points', 'reward_points' => 500, 'progress' => 1, 'target' => 2, 'deadline' => 'Ce mois-ci'],
        ];
    }
}
