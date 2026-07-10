<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Api\V1\CountryController;
use App\Http\Controllers\Api\V1\TransferController;
use App\Http\Controllers\Api\V1\BeneficiaryController;
use App\Http\Controllers\Api\V1\CardController;
use App\Http\Controllers\Api\V1\LoyaltyController;
use App\Http\Controllers\Api\V1\PromotionController;
use App\Http\Controllers\Api\V1\NotificationController;
use App\Http\Controllers\Api\V1\SupportController;

Route::prefix('v1')->group(function () {
    Route::post('/auth/register', [AuthController::class, 'register']);
    Route::post('/auth/login', [AuthController::class, 'login']);
    Route::post('/auth/verify-otp', [AuthController::class, 'verifyOtp']);

    Route::get('/countries', [CountryController::class, 'index']);
    Route::get('/countries/{code}', [CountryController::class, 'show']);
    Route::get('/operators/{countryCode}', [CountryController::class, 'operators']);
    Route::get('/corridors', [CountryController::class, 'corridors']);

    // Demo phase: endpoints read from the local seeded database and fall back to
    // the demo user when Sanctum auth is not installed yet.
    Route::group([], function () {
        Route::get('/user/profile', [AuthController::class, 'profile']);
        Route::post('/user/kyc', [AuthController::class, 'submitKyc']);

        Route::apiResource('beneficiaries', BeneficiaryController::class);
        Route::post('/beneficiaries/{beneficiary}/favorite', [BeneficiaryController::class, 'toggleFavorite']);

        Route::post('/transfer/calculate', [TransferController::class, 'calculate']);
        Route::post('/transfer/send', [TransferController::class, 'send']);
        Route::get('/transfer/status/{transaction}', [TransferController::class, 'status']);
        Route::get('/transfer/history', [TransferController::class, 'history']);

        Route::apiResource('cards', CardController::class);
        Route::post('/cards/{card}/load', [CardController::class, 'load']);
        Route::post('/cards/{card}/block', [CardController::class, 'block']);
        Route::post('/cards/{card}/unblock', [CardController::class, 'unblock']);

        Route::get('/loyalty/overview', [LoyaltyController::class, 'overview']);
        Route::get('/promotions/active', [PromotionController::class, 'active']);
        Route::get('/notifications', [NotificationController::class, 'index']);
        Route::apiResource('support/tickets', SupportController::class);
    });
});
