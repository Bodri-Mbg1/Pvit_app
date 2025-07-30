import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pvit_gestion/class/intervention_model.dart';
import 'package:pvit_gestion/screens/demande_installation.dart';
import 'package:pvit_gestion/screens/detail_intervention_page.dart';
import 'package:pvit_gestion/screens/rapport_instantane.dart';
import 'package:pvit_gestion/services/intervention_service.dart';

class Home extends StatefulWidget {
  final int utilisateurId;
  final String token;
  final String nom;
  final String prenom;
  const Home({
    super.key,
    required this.utilisateurId,
    required this.token,
    required this.nom,
    required this.prenom,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<InterventionModel> interventions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInterventions();
  }

  Future<void> fetchInterventions() async {
    try {
      final data = await InterventionService.fetchInterventions(
        widget.utilisateurId,
        widget.token,
      );
      setState(() {
        interventions = data;
        isLoading = false;
      });
    } catch (e) {
      print("Erreur de chargement : $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            children: [
              SizedBox(height: 20.h),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 25.r,
                    backgroundImage: const NetworkImage(
                      "https://i.pravatar.cc/300",
                    ),
                  ),
                  const Icon(Icons.notifications_none, size: 28),
                ],
              ),

              SizedBox(height: 20.h),

              Text(
                "Mbɔlo, Hello",
                style: TextStyle(fontSize: 18.sp, color: Colors.grey[700]),
              ),
              Text(
                "Bienvenue, Mr ${widget.prenom} !",
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -2.5,
                ),
              ),

              SizedBox(height: 10.h),
              // Bouton Demande d'installation
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DemandeInstallation(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: Color(0xfff26822),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Demande \nd'installation",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.5,
                            height: 1,
                          ),
                        ),
                        CircleAvatar(
                          radius: 30.r,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage("assets/img/l1.png"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RapportInstantane(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: Color(0xff3C89C5),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rapport \ninstantané",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.5,
                            height: 1,
                          ),
                        ),
                        CircleAvatar(
                          radius: 30.r,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage("assets/img/l2.png"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // Titre section
              const Text(
                "Intervention Planifiées",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 16),

              // Filtres semaine
              const SizedBox(height: 20),

              // Cartes d'intervention
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: interventions.map((intervention) {
                        final isInstallation =
                            intervention.type == "INSTALLATION";
                        final daysLeft = DateTime.parse(
                          intervention.datePlanifier,
                        ).difference(DateTime.now()).inDays;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailInterventionPage(
                                  intervention: intervention,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isInstallation
                                  ? Color(0xffF58642)
                                  : Color(0xff5DA0D3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isInstallation
                                          ? "Installation"
                                          : "Visite Technique",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      "Dans $daysLeft jour${daysLeft > 1 ? 's' : ''}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),

      // BottomNavBar flottant arrondi
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Icon(Icons.home, color: Colors.blue),
              Icon(Icons.qr_code, color: Colors.grey),
              Icon(Icons.person, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
