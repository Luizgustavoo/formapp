import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:ucif/app/data/provider/internet_status_provider.dart';
import 'package:ucif/app/data/repository/marital_status_repository.dart';
import 'package:ucif/app/routes/app_pages.dart';
import 'package:ucif/app/routes/app_routes.dart';
import 'package:ucif/app/theme/app_theme.dart';
import 'package:ucif/app/utils/firebase_push_notification.dart';
import 'package:ucif/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await GetStorage.init('credenciado');

  Get.put(InternetStatusProvider());
  Get.put(MaritalStatusRepository());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseApi().initNotifications();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark));

  runApp(
    ShowCaseWidget(
      builder: Builder(
        builder: (context) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'UCIF',
          theme: appThemeData,
          initialRoute: Routes.INITIAL,
          getPages: AppPages.routes,
        ),
      ),
    ),
  );
}
