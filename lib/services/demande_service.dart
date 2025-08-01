import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pvit_gestion/class/demande_installation_model.dart';

class DemandeService {
  static Future<bool> envoyerDemande(
    DemandeInstallationModel demande,
    int technicienId,
    String token,
  ) async {
    final url = Uri.parse(
      'http://192.168.1.85:8080/api/demandes/creer/$technicienId',
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(demande.toJson()),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
