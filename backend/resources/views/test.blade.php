<!DOCTYPE html>
<html lang="ar" dir="rtl">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>كروت المستخدمين</title>
    <style>
        @font-face {
            font-family: 'Cairo';
            src: url('{{ storage_path("fonts/Cairo-Regular.ttf") }}') format('truetype');
            font-weight: normal;
        }

        @font-face {
            font-family: 'Cairo';
            src: url('{{ storage_path("fonts/Cairo-Bold.ttf") }}') format('truetype');
            font-weight: bold;
        }

        body {
            font-family: 'Cairo', sans-serif;
            direction: rtl;
            text-align: right;
            background-color: #f8f9fa;
            padding: 20px;
        }

        .container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }

        .card {
            background: linear-gradient(135deg, #ffffff, #f1f3f5);
            border: 1px solid #e0e0e0;
            border-radius: 15px;
            padding: 25px;
            width: calc(50% - 20px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .card h3 {
            font-size: 22px;
            color: #2c3e50;
            font-weight: 700;
        }

        .card p {
            font-size: 16px;
            color: #555;
        }
    </style>

</head>

<body dir="rtl">
    <div class="container">
        @foreach($users as $user)
        <div class="card">
            <div class="icon">👤</div>
            <h3>{{ $user['name'] }}</h3>
            <div class="details">
                <p><strong>اسم المستخدم:</strong> {{ $user['username'] }}</p>
                <p><strong>كلمة السر:</strong> {{ $user['password'] }}</p>
            </div>
        </div>
        @endforeach
    </div>
</body>

</html>
