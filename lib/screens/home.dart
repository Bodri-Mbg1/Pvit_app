import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final int utilisateurId;
  final String token;
  const Home({super.key, required this.utilisateurId, required this.token});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Bienvenue utilisateur : ${widget.utilisateurId}'),
      ),
    );
  }
}
