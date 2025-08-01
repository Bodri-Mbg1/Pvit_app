import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pvit_gestion/screens/home.dart';

class DemandeSuccessPage extends StatefulWidget {
  final int utilisateurId;
  final String token;
  final String nom;
  final String prenom;

  const DemandeSuccessPage({
    super.key,
    required this.utilisateurId,
    required this.token,
    required this.nom,
    required this.prenom,
  });

  @override
  State<DemandeSuccessPage> createState() => _DemandeSuccessPageState();
}

class _DemandeSuccessPageState extends State<DemandeSuccessPage> {
  @override
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            utilisateurId: widget.utilisateurId,
            token: widget.token,
            nom: widget.nom,
            prenom: widget.prenom,
          ),
        ),
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
              'Envoyé',
              style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              'Votre demande a été envoyée\navec succès !',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.sp, color: Colors.grey, height: -0),
            ),
            SizedBox(height: 40.h),
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: Color(0xffF26822),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(Icons.check, color: Colors.white, size: 48.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
