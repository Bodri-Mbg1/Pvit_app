import 'package:pvit_gestion/class/marchand.dart';
import 'package:pvit_gestion/class/demande_installation.dart';

class InterventionModel {
  final int id;
  final String type;
  final String? datePlanifier;
  final String? description; // pour les visites
  final Marchand? marchand; // pour les visites
  final DemandeInstallation? demandeInstallation; // pour installations
  final int technicienId;
  final bool rapportExiste;
  String statut;

  InterventionModel({
    required this.id,
    required this.type,
    required this.datePlanifier,
    this.description,
    this.marchand,
    this.demandeInstallation,
    required this.technicienId,
    this.rapportExiste = false,
    required this.statut,
  });

  factory InterventionModel.fromJson(Map<String, dynamic> json) {
    return InterventionModel(
      id: json['id'],
      type: json['type'],
      datePlanifier: json['datePlanifier'],
      technicienId: json['technicien']['id'],
      description: json['description'],
      statut: json['statut'] ?? 'EN_ATTENTE',
      marchand: json['marchand'] != null
          ? Marchand.fromJson(json['marchand'])
          : null,
      demandeInstallation: json['demandeInstallation'] != null
          ? DemandeInstallation.fromJson(json['demandeInstallation'])
          : null,
      rapportExiste: json['rapportExiste'] ?? false,
    );
  }
}
