import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pvit_gestion/class/intervention_model.dart';
import 'package:pvit_gestion/config/config.dart';

class InterventionService {
  static Future<List<InterventionModel>> fetchInterventions(
    int userId,
    String token,
  ) async {
    final url = Uri.parse(
      "${AppConfig.baseUrl}/api/interventions/technicien/$userId",
    );
    final response = await http.get(
      url,
      headers: {'accept': '*/*', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((json) => InterventionModel.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des interventions');
    }
  }
}
