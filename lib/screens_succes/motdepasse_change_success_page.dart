import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pvit_gestion/screens/home.dart';
import 'package:pvit_gestion/screens/login_page.dart';

class MotDePasseChangeSuccessPage extends StatefulWidget {
  final int utilisateurId;
  const MotDePasseChangeSuccessPage({super.key, required this.utilisateurId});

  @override
  State<MotDePasseChangeSuccessPage> createState() =>
      _MotDePasseChangeSuccessPageState();
}

class _MotDePasseChangeSuccessPageState
    extends State<MotDePasseChangeSuccessPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Logo",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50.h),
            Text(
              "Félicitation",
              style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            Text(
              "Votre mot de passe a été réinitialisé\navec succès !",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
            ),
            SizedBox(height: 40.h),
            CircleAvatar(
              radius: 60.r,
              backgroundColor: Color(0xffF26822),
              child: Icon(Icons.check, color: Colors.white, size: 40.sp),
            ),
          ],
        ),
      ),
    );
  }
}
