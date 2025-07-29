import 'package:pvit_gestion/class/marchand.dart';

class DemandeInstallation {
  final String description;
  final Marchand marchand;

  DemandeInstallation({required this.description, required this.marchand});

  factory DemandeInstallation.fromJson(Map<String, dynamic> json) {
    return DemandeInstallation(
      description: json['description'],
      marchand: Marchand.fromJson(json['marchand']),
    );
  }
}
