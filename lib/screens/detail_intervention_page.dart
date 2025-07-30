import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:pvit_gestion/class/intervention_model.dart';
import 'package:pvit_gestion/screens/rapport_form_page.dart';

class DetailInterventionPage extends StatefulWidget {
  final InterventionModel intervention;

  const DetailInterventionPage({Key? key, required this.intervention})
    : super(key: key);

  @override
  State<DetailInterventionPage> createState() => _DetailInterventionPageState();
}

class _DetailInterventionPageState extends State<DetailInterventionPage> {
  late InterventionModel intervention;

  @override
  void initState() {
    super.initState();
    intervention = widget.intervention;
  }

  void refreshIntervention() async {
    setState(() {
      intervention.statut = 'TERMINEE';
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isInstallation = widget.intervention.type == "INSTALLATION";

    // Description
    final String description = isInstallation
        ? (widget.intervention.demandeInstallation?.description ??
              "Pas de description")
        : (widget.intervention.description ?? "Pas de description");

    // Marchand
    final marchand = isInstallation
        ? widget.intervention.demandeInstallation?.marchand
        : widget.intervention.marchand;

    final String nomMarchand = marchand?.nom ?? "Non renseigné";
    final String localisation = marchand?.localisation ?? "Non renseigné";
    final String telephone = marchand?.telephone ?? "Non renseigné";

    // Date

    final date = DateTime.parse(widget.intervention.datePlanifier);
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
            child: intervention.statut == "TERMINEE"
                ? Container(
                    width: 200.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "Rapport envoyé",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RapportFormPage(
                            interventionId: widget.intervention.id,
                            technicienId: widget.intervention.technicienId,
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
