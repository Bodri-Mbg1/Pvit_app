import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:pvit_gestion/class/intervention_model.dart';
import 'package:pvit_gestion/screens/rapport_form_page.dart';

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

    // Date

    final date = DateTime.parse(intervention.datePlanifier);
    final formattedDate = DateFormat('dd/MM/yyyy').format(date);
    final daysLeft = date.difference(DateTime.now()).inDays;

    final String labelDate = daysLeft > 0
        ? "Dans $daysLeft jour${daysLeft > 1 ? 's' : ''}"
        : "Aujourd'hui";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isInstallation ? Color(0xffF58642) : Color(0xff5DA0D3),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 250.h,
            decoration: BoxDecoration(
              color: isInstallation ? Color(0xffF58642) : Color(0xff5DA0D3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50.r),
                bottomRight: Radius.circular(50.r),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Icon(
                    isInstallation ? Icons.home : IconsaxPlusBroken.mouse_1,
                    color: Colors.white,
                    size: 110.sp,
                  ),
                  Text(
                    isInstallation ? "Installation" : "Visite Technique",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1.2,
                    ),
                  ),
                  Container(
                    width: 120.w,
                    height: 25.h,
                    decoration: BoxDecoration(
                      color: Color(isInstallation ? 0xffF9B382 : 0xff9DC5E4),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Center(
                      child: Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Container(
                  height: 120.h,
                  width: double.infinity,
                  child: Text(
                    description,
                    style: TextStyle(fontSize: 14.sp),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Informations du marchand
          Padding(
            padding: const EdgeInsets.all(25),
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
            child: intervention.rapportExiste
                ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Text(
                      "Rapport envoyé",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RapportFormPage(
                            interventionId: intervention.id,
                            technicienId: intervention.technicienId,
                          ),
                        ),
                      );
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
