<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Barryvdh\DomPDF\Facade\Pdf;

class UserCardController extends Controller
{
    public function generatePdf()
    {
        // بيانات جميع المستخدمين
        $users = [
            [
                'name' => 'محمد علي صالح عبدالله عرنوط',
                'username' => 'mohamed.ar',
                'password' => 'ma45678910',
            ],
            [
                'name' => 'البراء محمد عبده مصلح الشلفي',
                'username' => 'albaraa.sh',
                'password' => 'ab23456789',
            ],
            [
                'name' => 'زين العابدين علي حسين محمد الزبير',
                'username' => 'zein.zb',
                'password' => 'za65432198',
            ],
            [
                'name' => 'حذيفة محمد حسن ناجي العاطفي',
                'username' => 'hudhaifa.al',
                'password' => 'hm34567890',
            ],
            [
                'name' => 'محمد عبدالله أحمد سعد الجشاعة',
                'username' => 'mohamed.gj',
                'password' => 'ma54329876',
            ],
            [
                'name' => 'محمد عبدالله علي سيف', // محمد الشرعبي
                'username' => 'mohamed.sf',
                'password' => 'ma89012345',
            ],
            [
                'name' => 'أحمد يحيى علي محمد مقبول',
                'username' => 'ahmed.mq',
                'password' => 'ay67891234',
            ],
            [
                'name' => 'أحمد أمين سعيد ثابت',
                'username' => 'ahmed.st',
                'password' => 'as98765432',
            ],
            [
                'name' => 'إبراهيم محمد أحمد محمد زليل',
                'username' => 'ibrahim.mz',
                'password' => 'im12345678',
            ],
            [
                'name' => 'أمين محمد راوح حزام',
                'username' => 'amin.hz',
                'password' => 'am56789012',
            ],
            [
                'name' => 'أسامة عادل أحمد الشيباني',
                'username' => 'osama.sh',
                'password' => 'oa23456789',
            ],
            [
                'name' => 'سلمان عبد الكريم أحمد درويش',
                'username' => 'salman.dr',
                'password' => 'sd23459876',
            ],
            [
                'name' => 'أحمد عادل أحمد الشيباني',
                'username' => 'ahmed.sh',
                'password' => 'aa45678901',
            ],
            [
                'name' => 'العنود عبدالله عبدالله سوده طعيمان',
                'username' => 'alanoud.tt',
                'password' => 'at87654321',
            ],
            [
                'name' => 'خالد عبدالله علي محمد',
                'username' => 'khaled.ma',
                'password' => 'ka76543210',
            ],
            [
                'name' => 'رشاء فضل علي محمد مزروع',
                'username' => 'rasha.mz',
                'password' => 'rf12349876',
            ],
            [
                'name' => 'رنا فواز علي المهدي',
                'username' => 'rana.al',
                'password' => 'rf87654321',
            ],
            [
                'name' => 'شيماء عبدالله سيف عثمان',
                'username' => 'shaima.os',
                'password' => 'sa78906543',
            ],
            [
                'name' => 'عبد المجيد أحمد يحيى البورة',
                'username' => 'abdulmajid.ba',
                'password' => 'ab98760123',
            ],
            [
                'name' => 'محمد أحمد ثابت أحمد البحري',
                'username' => 'mohamed.bh',
                'password' => 'ma23459876',
            ],
            [
                'name' => 'محمد علي حسين الزراعي',
                'username' => 'mohamed.zr',
                'password' => 'ma67891245',
            ],
            [
                'name' => 'محمد منير أحمد أمير',
                'username' => 'mohamed.am',
                'password' => 'mm09876543',
            ],
            [
                'name' => 'معاذ صالح حسين الشوكاني',
                'username' => 'moath.sh',
                'password' => 'ms67891234',
            ],
            [
                'name' => 'نبيهة أحمد محمد أمين الجرموزي',
                'username' => 'nabiha.gj',
                'password' => 'na87659012',
            ],
            [
                'name' => 'وفاء سلطان سعيد ثابت',
                'username' => 'wafaa.st',
                'password' => 'ws09876123',
            ],
            [
                'name' => 'الاء عبداللطيف أحمد الضوراني',
                'username' => 'alaa.ad',
                'password' => 'aa23456789',
            ],
            [
                'name' => 'أحمد جميل أحمد راجح',
                'username' => 'ahmed.rj',
                'password' => 'aj89017654',
            ],
            [
                'name' => 'رؤى محمد حميد أحمد المكش',
                'username' => 'roaa.mk',
                'password' => 'rm56784321',
            ],
            [
                'name' => 'أحمد عبدالله علي إبراهيم بكري',
                'username' => 'ahmed.bk',
                'password' => 'ab45678123',
            ],
            [
                'name' => 'فاطمة هيلان علي عبدالله قطينة',
                'username' => 'fatima.qt',
                'password' => 'fh56789012',
            ],
            [
                'name' => 'محمد سعيد عبد الله إسماعيل اليوسفي',
                'username' => 'mohamed.ys',
                'password' => 'ms89076543',
            ],
            [
                'name' => 'محمد صالح عبدربة الفروي',
                'username' => 'mohamed.fr',
                'password' => 'ms65432987',
            ],
            [
                'name' => 'وفاء عبدالله علي عايش',
                'username' => 'wafaa.aa',
                'password' => 'wa78906543',
            ],
            [
                'name' => 'سهيل يحيى محمد يحيى الضوحاء',
                'username' => 'suhail.dh',
                'password' => 'sy98761234',
            ],
            [
                'name' => 'راويه خالد علي فهاد الصلاحي',
                'username' => 'rawiah.sl',
                'password' => 'rk12345678',
            ],
            [
                'name' => 'رحاب علي حسن علي عزيز',
                'username' => 'rehab.az',
                'password' => 'ra98765432',
            ],
        ];

        // إنشاء ملف PDF
        $pdf = Pdf::loadView('test', ['users' => $users]);
        Pdf::setOption(['dpi' => 150, 'defaultFont' => 'Cairo']);
        // تحميل الملف أو عرضه في المتصفح
        return $pdf->download('user_cards.pdf');
    }
}
