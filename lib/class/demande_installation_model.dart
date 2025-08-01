class DemandeInstallationModel {
  final String description;
  final int nombreTPE;
  final String nomMarchand;
  final String emailMarchand;
  final String telephoneMarchand;
  final String localisationMarchand;

  DemandeInstallationModel({
    required this.description,
    required this.nombreTPE,
    required this.nomMarchand,
    required this.emailMarchand,
    required this.telephoneMarchand,
    required this.localisationMarchand,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'nombreTPE': nombreTPE,
      'nomMarchand': nomMarchand,
      'emailMarchand': emailMarchand,
      'telephoneMarchand': telephoneMarchand,
      'localisationMarchand': localisationMarchand,
    };
  }
}
