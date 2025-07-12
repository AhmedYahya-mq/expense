<?php

namespace Database\Seeders;

use App\Enums\Role;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UsersTableSeeder extends Seeder
{
    public function run()
    {
        // مصفوفة تحتوي على جميع المستخدمين
        $users = [
            // لجنة إدارة العلاقات
            [
                'name' => 'محمد علي صالح عبدالله عرنوط',
                'username' => 'mohamed.ar',
                'password' => Hash::make('ma45678910'),
                'role' => Role::HEAD_OF_RELATIONS_COMMITTEE,
            ],
            [
                'name' => 'البراء محمد عبده مصلح الشلفي',
                'username' => 'albaraa.sh',
                'password' => Hash::make('ab23456789'),
                'role' => Role::HEAD_OF_RELATIONS_COMMITTEE,
            ],

            // اللجنة الإعلامية
            [
                'name' => 'زين العابدين علي حسين محمد الزبير',
                'username' => 'zein.zb',
                'password' => Hash::make('za65432198'),
                'role' => Role::HEAD_OF_MEDIA_COMMITTEE,
            ],
            [
                'name' => 'حذيفة محمد حسن ناجي العاطفي',
                'username' => 'hudhaifa.al',
                'password' => Hash::make('hm34567890'),
                'role' => Role::HEAD_OF_MEDIA_COMMITTEE,
            ],

            // اللجنة الفنية
            [
                'name' => 'محمد عبدالله أحمد سعد الجشاعة',
                'username' => 'mohamed.gj',
                'password' => Hash::make('ma54329876'),
                'role' => Role::HEAD_OF_TECHNICAL_COMMITTEE,
            ],
            [
                'name' => 'محمد عبدالله علي سيف', // محمد الشرعبي
                'username' => 'mohamed.sf',
                'password' => Hash::make('ma89012345'),
                'role' => Role::HEAD_OF_TECHNICAL_COMMITTEE,
            ],

            // اللجنة المالية
            [
                'name' => 'أحمد يحيى علي محمد مقبول',
                'username' => 'ahmed.mq',
                'password' => Hash::make('ay67891234'),
                'role' => Role::HEAD_OF_FINANCIAL_COMMITTEE,
            ],
            [
                'name' => 'أحمد أمين سعيد ثابت',
                'username' => 'ahmed.st',
                'password' => Hash::make('as98765432'),
                'role' => Role::HEAD_OF_FINANCIAL_COMMITTEE,
            ],

            // اللجنة الرقابية
            [
                'name' => 'إبراهيم محمد أحمد محمد زليل',
                'username' => 'ibrahim.mz',
                'password' => Hash::make('im12345678'),
                'role' => Role::HEAD_OF_SUPERVISORY_COMMITTEE,
            ],
            [
                'name' => 'أمين محمد راوح حزام',
                'username' => 'amin.hz',
                'password' => Hash::make('am56789012'),
                'role' => Role::HEAD_OF_SUPERVISORY_COMMITTEE,
            ],

            // اللجنة التحضيرية
            [
                'name' => 'أسامة عادل أحمد الشيباني',
                'username' => 'osama.sh',
                'password' => Hash::make('oa23456789'),
                'role' => Role::HEAD_OF_PREPARATORY_COMMITTEE,
            ],
            [
                'name' => 'سلمان عبد الكريم أحمد درويش',
                'username' => 'salman.dr',
                'password' => Hash::make('sd23459876'),
                'role' => Role::HEAD_OF_PREPARATORY_COMMITTEE,
            ],

            // باقي المستخدمين (صلاحيات عادية)
            [
                'name' => 'أحمد عادل أحمد الشيباني',
                'username' => 'ahmed.sh',
                'password' => Hash::make('aa45678901'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'العنود عبدالله عبدالله سوده طعيمان',
                'username' => 'alanoud.tt',
                'password' => Hash::make('at87654321'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'خالد عبدالله علي محمد',
                'username' => 'khaled.ma',
                'password' => Hash::make('ka76543210'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'رشاء فضل علي محمد مزروع',
                'username' => 'rasha.mz',
                'password' => Hash::make('rf12349876'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'رنا فواز علي المهدي',
                'username' => 'rana.al',
                'password' => Hash::make('rf87654321'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'شيماء عبدالله سيف عثمان',
                'username' => 'shaima.os',
                'password' => Hash::make('sa78906543'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'عبد المجيد أحمد يحيى البورة',
                'username' => 'abdulmajid.ba',
                'password' => Hash::make('ab98760123'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'محمد أحمد ثابت أحمد البحري',
                'username' => 'mohamed.bh',
                'password' => Hash::make('ma23459876'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'محمد علي حسين الزراعي',
                'username' => 'mohamed.zr',
                'password' => Hash::make('ma67891245'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'محمد منير أحمد أمير',
                'username' => 'mohamed.am',
                'password' => Hash::make('mm09876543'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'معاذ صالح حسين الشوكاني',
                'username' => 'moath.sh',
                'password' => Hash::make('ms67891234'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'نبيهة أحمد محمد أمين الجرموزي',
                'username' => 'nabiha.gj',
                'password' => Hash::make('na87659012'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'وفاء سلطان سعيد ثابت',
                'username' => 'wafaa.st',
                'password' => Hash::make('ws09876123'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'الاء عبداللطيف أحمد الضوراني',
                'username' => 'alaa.ad',
                'password' => Hash::make('aa23456789'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'أحمد جميل أحمد راجح',
                'username' => 'ahmed.rj',
                'password' => Hash::make('aj89017654'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'رؤى محمد حميد أحمد المكش',
                'username' => 'roaa.mk',
                'password' => Hash::make('rm56784321'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'أحمد عبدالله علي إبراهيم بكري',
                'username' => 'ahmed.bk',
                'password' => Hash::make('ab45678123'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'فاطمة هيلان علي عبدالله قطينة',
                'username' => 'fatima.qt',
                'password' => Hash::make('fh56789012'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'محمد سعيد عبد الله إسماعيل اليوسفي',
                'username' => 'mohamed.ys',
                'password' => Hash::make('ms89076543'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'محمد صالح عبدربة الفروي',
                'username' => 'mohamed.fr',
                'password' => Hash::make('ms65432987'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'وفاء عبدالله علي عايش',
                'username' => 'wafaa.aa',
                'password' => Hash::make('wa78906543'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'سهيل يحيى محمد يحيى الضوحاء',
                'username' => 'suhail.dh',
                'password' => Hash::make('sy98761234'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'راويه خالد علي فهاد الصلاحي',
                'username' => 'rawiah.sl',
                'password' => Hash::make('rk12345678'),
                'role' => Role::NORMAL,
            ],
            [
                'name' => 'رحاب علي حسن علي عزيز',
                'username' => 'rehab.az',
                'password' => Hash::make('ra98765432'),
                'role' => Role::NORMAL,
            ],
        ];

        // إدخال البيانات باستخدام UserFactory
        foreach ($users as $userData) {
            User::factory()->withData($userData)->create();
        }
    }
}
