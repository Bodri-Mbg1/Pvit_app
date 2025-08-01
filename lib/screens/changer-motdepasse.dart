// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:pvit_gestion/screens_succes/motdepasse_change_success_page.dart';

class ChangerMotDePassePage extends StatefulWidget {
  final int utilisateurId;
  const ChangerMotDePassePage({super.key, required this.utilisateurId});

  @override
  State<ChangerMotDePassePage> createState() => _ChangerMotDePassePageState();
}

class _ChangerMotDePassePageState extends State<ChangerMotDePassePage> {
  int _passwordStrengthLevel = 0; // de 0 à 4

  bool _isPasswordError = false;
  bool _isConfirmationError = false;
  String _passwordStrengthLabel = '';
  Color _passwordStrengthColor = Colors.grey;

  final TextEditingController _motDePasseController = TextEditingController();
  final TextEditingController _confirmationController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

  Future<void> _soumettre() async {
    final mdp = _motDePasseController.text.trim();
    final confirmation = _confirmationController.text.trim();

    setState(() {
      _isPasswordError = false;
      _isConfirmationError = false;
    });

    if (mdp.isEmpty || confirmation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    if (mdp != confirmation) {
      setState(() {
        _isConfirmationError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Les mots de passe ne correspondent pas")),
      );
      return;
    }

    if (mdp.length < 6) {
      setState(() {
        _isPasswordError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Le mot de passe est trop faible")),
      );
      return;
    }

    final response = await http.post(
      Uri.parse(
        'http://192.168.1.85:8080/api/auth/changer-motdepasse-premiere-connexion',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'utilisateurId': widget.utilisateurId,
        'nouveauMotDePasse': mdp,
        'confirmationMotDePasse': confirmation,
      }),
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mot de passe changé avec succès")),
      );
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) =>
              MotDePasseChangeSuccessPage(utilisateurId: widget.utilisateurId),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Une erreur est survenue")));
    }
  }

  @override
  // ignore: override_on_non_overriding_member
  void _evaluatePasswordStrength(String password) {
    int score = 0;

    if (password.length >= 6) score++;
    if (password.length >= 10) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    setState(() {
      _passwordStrengthLevel = score.clamp(1, 3); // de 1 à 4

      if (score <= 1) {
        _passwordStrengthLabel = "Faible";
        _passwordStrengthColor = Colors.red;
      } else if (score == 2) {
        _passwordStrengthLabel = "Moyen";
        _passwordStrengthColor = Colors.orange;
      } else {
        _passwordStrengthLabel = "Fort";
        _passwordStrengthColor = Colors.green;
      }
    });
  }

  Widget _buildPasswordStrengthBar() {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Row(
        children: [
          ...List.generate(3, (index) {
            return Expanded(
              child: Container(
                height: 5.h,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: index < _passwordStrengthLevel
                      ? _passwordStrengthColor
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
          SizedBox(width: 8.w),
          Text(
            _passwordStrengthLabel,
            style: TextStyle(
              color: _passwordStrengthColor,
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: ListView(
          children: [
            SizedBox(height: 60.h),
            Center(
              child: Text(
                'Logo',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.8,
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              'Créez votre nouveau\nMot de passe',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.3,
                height: -0,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Pour des raisons de sécurité veuillez svp\nentrez un nouveau mot de passe',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey[600],
                height: -0,
              ),
            ),
            SizedBox(height: 40.h),

            // Champ Mot de passe
            Text(
              "Mot de passe",
              style: TextStyle(
                letterSpacing: -0.5,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            _buildPasswordField(
              controller: _motDePasseController,
              isObscure: _obscurePassword,
              onToggle: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              showError: _isPasswordError,
              onChanged: (value) {
                setState(() {
                  _evaluatePasswordStrength(value);
                });
              },
            ),

            SizedBox(height: 10.h),

            // Champ Confirmation
            Text(
              "Confirmation de mot de passe",
              style: TextStyle(
                letterSpacing: -0.2,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            _buildPasswordField(
              controller: _confirmationController,
              isObscure: _obscureConfirmation,
              onToggle: () {
                setState(() {
                  _obscureConfirmation = !_obscureConfirmation;
                });
              },
              showError: _isConfirmationError,
              onChanged: (_) {},
            ),
            _buildPasswordStrengthBar(),

            SizedBox(height: 40.h),

            // Bouton
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                onPressed: _soumettre,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff3C89C5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Confirmez',
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
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool isObscure,
    required VoidCallback onToggle,
    required bool showError,
    required void Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          height: 60.h,
          decoration: BoxDecoration(
            border: Border.all(color: showError ? Colors.red : Colors.blue),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              Icon(IconsaxPlusBold.key, color: Color(0xff3C89C5)),
              SizedBox(width: 8.w),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: isObscure,
                  onChanged: onChanged,
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
                onTap: onToggle,
                child: Icon(
                  isObscure
                      ? IconsaxPlusLinear.eye_slash
                      : IconsaxPlusLinear.eye,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
