import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pvit_gestion/class/demande_installation_model.dart';
import 'package:pvit_gestion/screens/demande_success_page.dart';
import '../services/demande_service.dart';

class DemandeInstallationPage extends StatefulWidget {
  final int technicienId;
  final String token;
  final String nom;
  final String prenom;

  const DemandeInstallationPage({
    super.key,
    required this.technicienId,
    required this.token,
    required this.nom,
    required this.prenom,
  });

  @override
  State<DemandeInstallationPage> createState() =>
      _DemandeInstallationPageState();
}

class _DemandeInstallationPageState extends State<DemandeInstallationPage> {
  // Géolocalisation
  Future<void> _detectEtRemplirAdresseAutomatique() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Service de localisation désactivé.")),
      );
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Permission de localisation refusée.")),
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      final adresse = [
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.country,
      ].where((e) => e != null && e.isNotEmpty).join(', ');

      setState(() {
        adresseController.text = adresse;
      });
    }
  }

  bool isAdresseManuelle = false;

  final PageController _pageController = PageController();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  // Étape 1
  final TextEditingController nombreTPEController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController adresseController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();

  // Étape 2
  final TextEditingController descriptionController = TextEditingController();

  int currentStep = 1;
  bool isNomFieldError = false;
  bool isPhoneFieldError = false;
  bool isEmailFieldError = false;
  bool isAdresseFieldError = false;
  bool isTPEFieldError = false;
  bool isDescriptionFieldError = false;

  //Étape 1
  void _goToNextStep() {
    final isValid = _formKey1.currentState!.validate();

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez remplir tous les champs obligatoires.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      currentStep = 2;
    });

    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _goToPreviousStep() {
    setState(() {
      currentStep = 1;
    });
    _pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  //Étape 2
  void _submitDemande() async {
    if (_formKey2.currentState!.validate()) {
      final demande = DemandeInstallationModel(
        description: descriptionController.text,
        nombreTPE: int.tryParse(nombreTPEController.text) ?? 0,
        nomMarchand: nomController.text,
        emailMarchand: emailController.text,
        telephoneMarchand: telephoneController.text,
        localisationMarchand: adresseController.text,
      );

      final success = await DemandeService.envoyerDemande(
        demande,
        widget.technicienId,
        widget.token,
      );

      if (success) {
        // Affiche un loader pendant 2 à 3 secondes
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(color: Color(0xff3C89C5)),
          ),
        );

        await Future.delayed(Duration(seconds: 2));

        Navigator.pop(context); // fermer le loader
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DemandeSuccessPage(
              utilisateurId: widget.technicienId,
              token: widget.token,
              nom: widget.nom,
              prenom: widget.prenom,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Échec de l\'envoi')));
      }
    }
  }

  // Fonction pour construire les cercles de progression
  Widget _buildStepCircle(int stepNumber, {required int currentStep}) {
    final isActive = stepNumber <= currentStep;

    return Container(
      width: 45.w,
      height: 45.w,
      decoration: BoxDecoration(
        color: isActive ? Color(0xff3D8ECC) : Colors.grey,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue.shade100, width: 3),
      ),
      child: Center(
        child: Text(
          '$stepNumber',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (currentStep == 2) {
              _goToPreviousStep();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text('Demande d\'installation'),
      ),

      body: Column(
        children: [
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStepCircle(1, currentStep: currentStep),
              Container(width: 30.w, height: 2.h, color: Colors.black),
              _buildStepCircle(2, currentStep: currentStep),
            ],
          ),
          SizedBox(height: 16.h),

          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                // Étape 1
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey1,
                    child: ListView(
                      children: [
                        Text(
                          'Nombre de TPE',
                          style: TextStyle(
                            letterSpacing: -0.2,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          height: 60.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isTPEFieldError ? Colors.red : Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.numbers, color: Colors.blue),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextFormField(
                                  controller: nombreTPEController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Entrez le nombre de TPE',
                                    hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                      letterSpacing: -0.2,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  validator: (value) {
                                    bool hasError = false;
                                    if (value == null || value.isEmpty) {
                                      hasError = true;
                                    } else {
                                      final intValue = int.tryParse(value);
                                      if (intValue == null || intValue <= 0) {
                                        hasError = true;
                                      }
                                    }

                                    setState(() {
                                      isTPEFieldError = hasError;
                                    });

                                    return hasError ? '' : null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue),
                            Text(
                              'Information du marchand',
                              style: TextStyle(
                                letterSpacing: -0.2,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Nom du marchand',
                          style: TextStyle(
                            letterSpacing: -0.2,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          height: 60.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isNomFieldError ? Colors.red : Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.person, color: Colors.blue),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextFormField(
                                  controller: nomController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Entrez le nom du marchand',
                                    hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                      letterSpacing: -0.2,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  validator: (value) {
                                    final hasError =
                                        value == null || value.isEmpty;
                                    setState(() {
                                      isNomFieldError = hasError;
                                    });
                                    return hasError ? '' : null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10.h),
                        Text(
                          'Email du marchand',
                          style: TextStyle(
                            letterSpacing: -0.2,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          height: 60.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isEmailFieldError
                                  ? Colors.red
                                  : Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.email, color: Colors.blue),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Entrez l'email du marchand",
                                    hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                      letterSpacing: -0.2,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  validator: (value) {
                                    final hasError =
                                        value == null || value.isEmpty;
                                    final isValidEmail = RegExp(
                                      r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                                    ).hasMatch(value ?? '');

                                    setState(() {
                                      isEmailFieldError =
                                          hasError || !isValidEmail;
                                    });

                                    if (hasError) return '';
                                    if (!isValidEmail)
                                      return 'Veuillez entrer une adresse email valide';
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'Adresse du marchand',
                          style: TextStyle(
                            letterSpacing: -0.2,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          height: 60.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isAdresseFieldError
                                  ? Colors.red
                                  : Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.blue),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextFormField(
                                  controller: adresseController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Entrez l'adresse du marchand",
                                    hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                      letterSpacing: -0.2,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  validator: (value) {
                                    final hasError =
                                        value == null || value.isEmpty;
                                    setState(() {
                                      isAdresseFieldError = hasError;
                                    });
                                    return hasError ? '' : null;
                                  },
                                ),
                              ),
                              Container(
                                width: 38.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.my_location,
                                      color: Colors.white,
                                      size: 20.sp,
                                    ),
                                    onPressed:
                                        _detectEtRemplirAdresseAutomatique,
                                    tooltip: "Utiliser ma position actuelle",
                                  ),
                                ),
                              ),

                              /*IconButton(
                                icon: Icon(
                                  Icons.my_location,
                                  color: Colors.black87,
                                ),
                                onPressed: _detectEtRemplirAdresseAutomatique,
                                tooltip: "Utiliser ma position actuelle",
                              ),*/
                            ],
                          ),
                        ),

                        SizedBox(height: 10.h),
                        Text(
                          'Numéro du marchand',
                          style: TextStyle(
                            letterSpacing: -0.2,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          height: 60.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isPhoneFieldError
                                  ? Colors.red
                                  : Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),

                          child: Row(
                            children: [
                              Icon(Icons.phone, color: Colors.blue),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextFormField(
                                  controller: telephoneController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Entrez le numéro du marchand',
                                    hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                      letterSpacing: -0.2,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  validator: (value) {
                                    final hasError =
                                        value == null || value.isEmpty;
                                    setState(() {
                                      isPhoneFieldError = hasError;
                                    });
                                    return hasError ? '' : null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 46.h),

                        GestureDetector(
                          onTap: _goToNextStep,
                          child: Container(
                            width: 325.w,
                            height: 55.h,
                            decoration: BoxDecoration(
                              color: Color(0xff3C89C5),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                "Suivant",
                                style: TextStyle(
                                  fontSize: 23.sp,
                                  letterSpacing: -1,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Étape 2
                // Étape 2
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey2,
                    child: ListView(
                      children: [
                        Text(
                          'Description de la demande',
                          style: TextStyle(
                            letterSpacing: -0.2,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          width: double.infinity,
                          height: 490.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isDescriptionFieldError
                                  ? Colors.red
                                  : Color(0xdd3C89C5),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          padding: EdgeInsets.all(12.w),
                          child: TextFormField(
                            controller: descriptionController,
                            maxLines: null, // pour qu'il prenne toute la place
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              border: InputBorder.none,

                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: (value) {
                              final hasError =
                                  value == null || value.trim().isEmpty;
                              setState(() {
                                isDescriptionFieldError = hasError;
                              });
                              return hasError
                                  ? 'La description est obligatoire'
                                  : null;
                            },
                          ),
                        ),
                        SizedBox(height: 16.h),

                        GestureDetector(
                          onTap: _submitDemande,
                          child: Container(
                            width: 325.w,
                            height: 55.h,
                            decoration: BoxDecoration(
                              color: Color(0xff3C89C5),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Text(
                                "Envoyer",
                                style: TextStyle(
                                  fontSize: 23.sp,
                                  letterSpacing: -1,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
