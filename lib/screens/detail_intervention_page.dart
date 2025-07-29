import 'package:flutter/material.dart';
import 'package:pvit_gestion/class/intervention_model.dart';

class DetailInterventionPage extends StatelessWidget {
  final InterventionModel intervention;

  const DetailInterventionPage({Key? key, required this.intervention})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isInstallation = intervention.type == "INSTALLATION";

    // Description
    final String description = isInstallation
        ? (intervention.demandeInstallation?.description ??
              "Pas de description")
        : (intervention.description ?? "Pas de description");

    // Marchand
    final marchand = isInstallation
        ? intervention.demandeInstallation?.marchand
        : intervention.marchand;

    final String nomMarchand = marchand?.nom ?? "Non renseigné";
    final String localisation = marchand?.localisation ?? "Non renseigné";
    final String telephone = marchand?.telephone ?? "Non renseigné";

    return Scaffold(
      appBar: AppBar(
        title: Text(isInstallation ? "Installation" : "Visite Technique"),
        backgroundColor: isInstallation ? Color(0xffF58642) : Color(0xff5DA0D3),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date ou délai
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              isInstallation
                  ? intervention.datePlanifier
                  : "Dans ${DateTime.parse(intervention.datePlanifier).difference(DateTime.now()).inDays} jours",
              style: TextStyle(color: Colors.grey),
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(description),
              ],
            ),
          ),

          // Informations du marchand
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Informations du marchand",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text(nomMarchand),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on),
                    SizedBox(width: 8),
                    Text(localisation),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.phone),
                    SizedBox(width: 8),
                    Text(telephone),
                  ],
                ),
              ],
            ),
          ),

          Spacer(),

          Center(
            child: ElevatedButton(
              onPressed: () {
                // Redirection vers le rapport
              },
              child: Text("Établir le rapport"),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
