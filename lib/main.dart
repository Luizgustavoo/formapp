import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formapp/app/modules/initial/initial_binding.dart';
import 'package:formapp/app/routes/app_pages.dart';
import 'package:formapp/app/routes/app_routes.dart';
import 'package:formapp/app/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init('credenciado');
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
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
