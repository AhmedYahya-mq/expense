<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;

use App\Enums\Role;
use App\Enums\TransactionCategory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasFactory, Notifiable, HasApiTokens;

    protected $fillable = [
        'name',
        'username',
        'email',
        'fcm_token',
        'balance',
        'image',
        'role',
        'password',
        'api_token',
    ];

    public function transactions()
    {
        return $this->hasMany(Transaction::class, 'user_id');
    }




    protected $hidden = [
        'password',
        'remember_token',
        'api_token',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
            'role' => Role::class,
        ];
    }


    /**
     * المصروفات التي قام بصرفها إذا كان المستخدم أمين صندوق.
     */
    public function expenses()
    {
        return $this->hasMany(Expense::class, 'cashier_id');
    }

    /**
     * جلب جميع المستخدمين.
     */
    public static function getAllUsers()
    {
        return self::all();
    }


    public static function getUsersByRole()
    {
        $normalUsers = self::where('role', Role::NORMAL)->get();
        $committeeUsers = self::where('role', '!=', Role::NORMAL)->get();

        return collect([
            'committee' => $committeeUsers,
            'normal' => $normalUsers
        ]);
    }

    // علاقة مع جدول الدخل (المبالغ المستلمة من المستخدم)
    public function incomes()
    {
        return $this->hasMany(Income::class, 'recipient_id');
    }


    public function getRoleLabel()
    {
        return Role::getDescription($this->role);
    }

    public function scopeCommittee($query)
    {
        return $query->where('role', '!=', Role::NORMAL);
    }

    public function scopeNormal($query)
    {
        return $query->where('role', Role::NORMAL);
    }

    public function scopeBalance()
    {

        return $this->transactions()->incomeCategory(TransactionCategory::STUDENTS)->sum('amount');
    }
}
