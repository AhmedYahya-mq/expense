import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

void subscribeToTopic() {
  print("Subscribing to all users");
  messaging.subscribeToTopic("all_users");
}

Future<String?> getFCMToken() async {
  return await messaging.getToken();
}

void toTopicId(String topicId) {
  messaging.subscribeToTopic("user_${topicId.replaceAll("#", "")}");
}
