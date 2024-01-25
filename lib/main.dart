import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formapp/screens/login_page.dart';
import 'package:formapp/utils/custom_route.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white.withAlpha(240),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          )),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          )),
          appBarTheme: AppBarTheme(
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            backgroundColor: Colors.orange.shade500,
            titleTextStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
          tabBarTheme: TabBarTheme(
            indicatorColor: Colors.grey.shade900,
          ),
          cardTheme: CardTheme(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5))),
          expansionTileTheme: const ExpansionTileThemeData(
              tilePadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.all(10),
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            labelStyle: TextStyle(
                color: Colors.grey.shade500,
                fontFamily: 'Poppins',
                fontSize: 14),
            hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontFamily: 'Poppins',
                fontSize: 12),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(5)),
          ),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CustomPageTransitionsBuilder(),
            TargetPlatform.iOS: CustomPageTransitionsBuilder(),
          }),
        ),
        home: const LoginPage());
  }
}
