import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:path_provider/path_provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  bool _isFlutterLocalNotificationsPluginInitialized = false;

  Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await _requestPermission();
    await _setupMessageHandlers();
    await setupFlutterNotifications();
  }

  Future<void> _requestPermission() async {
    final settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    print('Permission status: ${settings.authorizationStatus}');
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsPluginInitialized) {
      return;
    }

    // Android setup
    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notification',
      description: 'هذه القناة تستخدم من اجل بلاغ الطلاب عبر أشعارات',
      importance: Importance.high,
      enableLights: false,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/launcher");

    // iOS setup
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap here
      },
    );

    _isFlutterLocalNotificationsPluginInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final androidNotification = message.notification?.android;

    if (notification == null && androidNotification == null) {
      print("Notification data is null");
      return;
    }

    String? imageUrl = androidNotification?.imageUrl;
    String? localImagePath;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        localImagePath =
            await _downloadAndSaveImage(imageUrl, "notification_img.jpg");
      } catch (e) {
        print("Error downloading image: $e");
      }
    }

    final BigPictureStyleInformation bigPictureStyle =
        BigPictureStyleInformation(
      localImagePath != null
          ? FilePathAndroidBitmap(localImagePath)
          : FilePathAndroidBitmap(''),
      largeIcon:
          localImagePath != null ? FilePathAndroidBitmap(localImagePath) : null,
      contentTitle: notification!.title,
      summaryText: notification.body,
    );

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notification',
      channelDescription: 'هذه القناة تستخدم من اجل بلاغ الطلاب عبر أشعارات',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: localImagePath != null ? bigPictureStyle : null,
      icon: '@mipmap/launcher',
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: message.data.toString(),
    );
  }

  Future<String> _downloadAndSaveImage(String url, String fileName) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/$fileName';

      await Dio().download(
        url,
        filePath,
        options: Options(responseType: ResponseType.bytes),
      );

      return filePath;
    } catch (e) {
      throw Exception('Failed to download image: $e');
    }
  }

  Future<void> _setupMessageHandlers() async {
    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
    });

    // Background message handler
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundNotification);

    final initialMessage = await firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      _handleBackgroundNotification(initialMessage);
    }
  }

  void _handleBackgroundNotification(RemoteMessage message) {
    if (message.data['screen'] != null) {
      // Navigate to the specified screen
      // Get.toNamed(message.data['screen']);
    }
  }
}
