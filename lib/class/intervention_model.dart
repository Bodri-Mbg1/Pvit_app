import 'package:pvit_gestion/class/marchand.dart';
import 'package:pvit_gestion/class/demande_installation.dart';

class InterventionModel {
  final String type;
  final String datePlanifier;
  final String? description; // pour les visites
  final Marchand? marchand; // pour les visites
  final DemandeInstallation? demandeInstallation; // pour installations

  InterventionModel({
    required this.type,
    required this.datePlanifier,
    this.description,
    this.marchand,
    this.demandeInstallation,
  });

  factory InterventionModel.fromJson(Map<String, dynamic> json) {
    return InterventionModel(
      type: json['type'],
      datePlanifier: json['datePlanifier'],
      description: json['description'],
      marchand: json['marchand'] != null
          ? Marchand.fromJson(json['marchand'])
          : null,
      demandeInstallation: json['demandeInstallation'] != null
          ? DemandeInstallation.fromJson(json['demandeInstallation'])
          : null,
    );
  }
}
