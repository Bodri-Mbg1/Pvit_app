import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:http/http.dart' as http;
import 'package:pvit_gestion/config/config.dart';
import 'package:pvit_gestion/screens/changer-motdepasse.dart';
import 'package:pvit_gestion/screens/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: ListView(
            children: [
              SizedBox(height: 40.h),
              Center(
                child: Text(
                  'Logo',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: Text(
                  'Connexion',
                  style: TextStyle(
                    letterSpacing: -1.8,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  'Connectez-vous à votre compte et commencez\nà utiliser Pvit GESTION',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ),
              SizedBox(height: 40.h),

              // Champ Email
              Text(
                'Email',
                style: TextStyle(
                  letterSpacing: -0.5,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                height: 60.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(IconsaxPlusBold.sms, color: Colors.blue),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        controller: _emailController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Entrez votre mail',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            letterSpacing: -0.2,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Champ Mot de passe
              Text(
                'Mot de passe',
                style: TextStyle(
                  letterSpacing: -0.5,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                height: 60.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(IconsaxPlusBold.key, color: Colors.blue),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Entrez votre mot de passe',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            letterSpacing: -0.2,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() {
                        _obscurePassword = !_obscurePassword;
                      }),
                      child: Icon(
                        _obscurePassword
                            ? IconsaxPlusLinear.eye_slash
                            : IconsaxPlusLinear.eye,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              // Bouton
              SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ElevatedButton(
                  onPressed: () async {
                    final email = _emailController.text.trim();
                    final motDePasse = _passwordController.text.trim();
                    try {
                      final response = await http.post(
                        Uri.parse('${AppConfig.baseUrl}/api/auth/login'),
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode({
                          'email': email,
                          'motDePasse': motDePasse,
                        }),
                      );

                      print('Code: ${response.statusCode}');
                      print('Body: ${response.body}');

                      if (response.statusCode == 200) {
                        final data = jsonDecode(response.body);

                        if (data['status'] == 'PREMIERE_CONNEXION') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangerMotDePassePage(
                                utilisateurId: data['utilisateurId'],
                              ),
                            ),
                          );
                        } else if (data['status'] == 'SUCCESS') {
                          final utilisateurId = data['utilisateurId'];
                          final nom = data['nom'];
                          final prenom = data['prenom'];
                          final token = data['token'];
                          if (utilisateurId == null || token == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Données manquantes (utilisateur ou token)',
                                ),
                              ),
                            );
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(
                                utilisateurId: utilisateurId,
                                token: token,
                                nom: nom,
                                prenom: prenom,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erreur inconnue')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Email ou mot de passe incorrect'),
                          ),
                        );
                      }
                    } catch (e) {
                      print('Exception: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Veuillez saisir les informations manquantes',
                          ),
                        ),
                      );
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: Text(
                    'Se connecter',
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.9,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
