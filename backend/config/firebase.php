<?php

return [
    /*
    |--------------------------------------------------------------------------
    | Firebase Credentials File Path
    |--------------------------------------------------------------------------
    |
    | The path to the Firebase service account credentials JSON file.
    | Ensure that you have downloaded the Firebase service account key
    | from the Firebase Console and place it in the appropriate directory.
    |
    */

    'credentials' => env('FIREBASE_CREDENTIALS', storage_path('app/firebase_credentials.json')), // المسار إلى ملف JSON الخاص بـ Firebase
];
