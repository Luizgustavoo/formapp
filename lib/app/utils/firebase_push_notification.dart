import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:formapp/firebase_options.dart';
import 'package:get/get.dart';

class NotificationSetUp {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initializeNotification() async {
    AwesomeNotifications().initialize('resource://drawable/res_launcher_icon', [
      NotificationChannel(
        channelKey: 'high_importance_channel',
        channelName: 'Credenciado',
        importance: NotificationImportance.Max,
        vibrationPattern: highVibrationPattern,
        channelShowBadge: true,
        channelDescription: 'Credenciado',
      ),
    ]);
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  void configurePushNotification() async {
    await initializeNotification();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    if (Platform.isIOS) getIOSPermission();
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        createOrderNotification(
          title: message.notification!.title,
          body: message.notification!.body,
        );
      }
    });
  }

  Future<void> createOrderNotification({String? title, String? body}) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
      id: 0,
      channelKey: 'high_importance_channel',
      title: title,
      body: body,
    ));
  }

  void eventListenerCallback() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
    );
  }

  void getIOSPermission() {
    _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
    );
  }

  @pragma('vm:entry-point')
  Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}

class NotificationController {
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedNotification receivedNotification) async {
    BuildContext? context = Get.context;

    // Verifica se o contexto é válido antes de tentar navegar
    if (context != null) {
      Get.offAllNamed('/list-message');
    } else {
      // Se o contexto não for válido, você pode tentar navegar de volta ao MaterialApp
      Get.toNamed('/list-message');
    }
  }
}
