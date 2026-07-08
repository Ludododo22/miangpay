<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class TransferController extends Controller
{
    public function __call($method, $parameters)
    {
        return response()->json([
            'message' => 'MiangPay API endpoint placeholder',
            'controller' => static::class,
            'method' => $method,
        ]);
    }
}
