class Marchand {
  final String nom;
  final String email;
  final String telephone;
  final String localisation;

  Marchand({
    required this.nom,
    required this.email,
    required this.telephone,
    required this.localisation,
  });

  factory Marchand.fromJson(Map<String, dynamic> json) {
    return Marchand(
      nom: json['nom'],
      email: json['email'],
      telephone: json['telephone'],
      localisation: json['localisation'],
    );
  }
}
