<?php
namespace Database\Factories;

use App\Enums\Role;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class UserFactory extends Factory
{
    /**
     * كلمة المرور الافتراضية.
     */
    protected static ?string $password;

    /**
     * تعريف الحقول الافتراضية للمستخدم.
     */
    public function definition(): array
    {
        return [
            'name' => $this->faker->name, // اسم عشوائي
            'username' => $this->faker->unique()->userName, // اسم مستخدم عشوائي
            'email' => function (array $attributes) {
                return $attributes['username'] . '@ahmed.com'; // إنشاء البريد الإلكتروني
            },
            'role' => Role::NORMAL, // دور افتراضي
            'email_verified_at' => now(),
            'password' => static::$password ??= Hash::make('password'), // كلمة مرور افتراضية
            'remember_token' => Str::random(10),
        ];
    }

    /**
     * تعيين بيانات محددة للمستخدم.
     */
    public function withData(array $data): static
    {
        return $this->state(fn (array $attributes) => $data);
    }

    /**
     * تعيين البريد الإلكتروني على أنه غير مؤكد.
     */
    public function unverified(): static
    {
        return $this->state(fn (array $attributes) => [
            'email_verified_at' => null,
        ]);
    }
}
