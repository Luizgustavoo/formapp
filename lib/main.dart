import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formapp/app/routes/app_pages.dart';
import 'package:formapp/app/routes/app_routes.dart';
import 'package:formapp/app/screens/login_page.dart';
import 'package:formapp/app/theme/app_theme.dart';
import 'package:get/get.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: appThemeData,
    initialRoute: Routes.LOGIN,
    getPages: ApppPages.routes,
    home: const LoginPage(),
  ));
}
