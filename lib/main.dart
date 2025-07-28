import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pvit_gestion/screens/intro1.dart';
import 'package:pvit_gestion/screens/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: Builder(
        // 👈 très important ici
        builder: (context) {
          return MaterialApp(
            theme: ThemeData(fontFamily: 'SFPro'),
            debugShowCheckedModeBanner: false,
            locale: const Locale('fr', 'FR'),
            home: const LoginPage(),
          );
        },
      ),
    );
  }
}
