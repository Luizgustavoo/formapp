import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formapp/app/data/provider/internet_status_provider.dart';
import 'package:formapp/app/data/repository/marital_status_repository.dart';
import 'package:formapp/app/modules/initial/initial_binding.dart';
import 'package:formapp/app/routes/app_pages.dart';
import 'package:formapp/app/routes/app_routes.dart';
import 'package:formapp/app/theme/app_theme.dart';
import 'package:formapp/firebase_options.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init('credenciado');

  Get.put(InternetStatusProvider());
  Get.put(MaritalStatusRepository());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // final String? token = await FirebaseMessaging.instance.getToken();
  // debugPrint(token);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.orange.shade300,
  ));

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Inclusão Familiar',
    theme: appThemeData,
    initialRoute: Routes.INITIAL,
    getPages: ApppPages.routes,
    initialBinding: InitialBinding(),
  ));
}
