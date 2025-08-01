import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_plus/iconsax_plus.dart';

class ChangerMotDePassePage extends StatefulWidget {
  final int utilisateurId;
  const ChangerMotDePassePage({super.key, required this.utilisateurId});

  @override
  State<ChangerMotDePassePage> createState() => _ChangerMotDePassePageState();
}

class _ChangerMotDePassePageState extends State<ChangerMotDePassePage> {
  final TextEditingController _motDePasseController = TextEditingController();
  final TextEditingController _confirmationController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

  Future<void> _soumettre() async {
    final mdp = _motDePasseController.text.trim();
    final confirmation = _confirmationController.text.trim();

    if (mdp.isEmpty || confirmation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    if (mdp != confirmation) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Les mots de passe ne correspondent pas")),
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mot de passe changé avec succès")),
      );
      Navigator.pop(context); // Retour à la page de connexion
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Une erreur est survenue")));
    }
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
            ),

            SizedBox(height: 24.h),

            // Champ Confirmation
            Text(
              "Confirmation de mot de passe",
              style: TextStyle(
                letterSpacing: -0.5,
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
            ),

            SizedBox(height: 40.h),

            // Bouton
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                onPressed: _soumettre,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
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
  }) {
    return Container(
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
              controller: controller,
              obscureText: isObscure,
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
              _obscurePassword
                  ? IconsaxPlusLinear.eye_slash
                  : IconsaxPlusLinear.eye,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
