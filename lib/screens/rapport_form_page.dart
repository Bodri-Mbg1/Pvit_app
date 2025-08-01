// ignore_for_file: unused_import, use_build_context_synchronously, duplicate_ignore, avoid_print

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pvit_gestion/config/config.dart';

class RapportFormPage extends StatefulWidget {
  final int interventionId;
  final int technicienId;

  // ignore: use_super_parameters
  const RapportFormPage({
    Key? key,
    required this.interventionId,
    required this.technicienId,
  }) : super(key: key);

  @override
  State<RapportFormPage> createState() => _RapportFormPageState();
}

class _RapportFormPageState extends State<RapportFormPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  Future<void> _pickImages() async {
    if (_selectedImages.length >= 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Nous ne pouvez pas prendre plus de 8 photos.")),
      );
      return;
    }

    // ignore: unnecessary_nullable_for_final_variable_declarations
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  Future<void> _envoyerRapport() async {
    if (_descriptionController.text.isEmpty || _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Veuillez remplir la description et ajouter des photos.",
          ),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final uri = Uri.parse(
        "${AppConfig.baseUrl}/api/rapports/creer/${widget.interventionId}/${widget.technicienId}",
      );

      if (!mounted) return;

      var request = http.MultipartRequest("POST", uri);
      request.fields["description"] = _descriptionController.text;

      for (var image in _selectedImages) {
        var file = await http.MultipartFile.fromPath("photos", image.path);
        request.files.add(file);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Montrer le dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Dialog(
              elevation: 0,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.check, size: 40, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Envoyé",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Votre rapport a été envoyé avec succès !",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            );
          },
        );

        // ⏱️ Attendre 2 secondes
        await Future.delayed(Duration(seconds: 2));

        // ✅ Fermer la popup
        if (mounted) Navigator.pop(context); // Ferme le Dialog
        if (mounted)
          // ignore: curly_braces_in_flow_control_structures
          Navigator.pop(context, true); // Reviens à la page précédente
      } else {
        // ignore: avoid_print
        print("Erreur serveur : ${response.statusCode}");
        print("Réponse : ${response.body}");
        throw Exception("Échec de l'envoi");
      }
    } catch (e) {
      // ignore: avoid_print
      print("Erreur : $e");
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'envoi du rapport")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _takePhoto() async {
    if (_selectedImages.length >= 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Nous ne pouvez pas prendre plus de 8 photos.")),
      );
      return;
    }

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _selectedImages.add(photo);
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Prendre une photo"),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Importer depuis la galerie"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImages();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Envoie de rapport"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 5.h),
            Container(
              width: double.infinity,
              height: 300.h,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xdd3C89C5), width: 2),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Expanded(
                  child: TextField(
                    controller: _descriptionController,
                    maxLines: 13,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Photos *",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xdd3C89C5), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: _selectedImages.take(8).map((img) {
                  return Stack(
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(File(img.path), fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedImages.remove(img));
                          },
                          child: Icon(Icons.cancel, color: Colors.red),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 10),
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: SizedBox(
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Color(0xdd3C89C5), width: 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(IconsaxPlusLinear.gallery_add),
                      Text("Ajouter photo(s)"),
                    ],
                  ),
                ),
              ),
            ),
            /*OutlinedButton.icon(
              onPressed: _showImageSourceDialog,
              icon: Icon(IconsaxPlusLinear.gallery_add),
              label: Text("Ajouter photo(s)"),
            ),*/
            SizedBox(height: 15.h),
            Spacer(),
            isLoading
                ? CircularProgressIndicator()
                : GestureDetector(
                    onTap: _envoyerRapport,
                    child: Container(
                      width: 325.w,
                      height: 55.h,
                      decoration: BoxDecoration(
                        color: Color(0xff3C89C5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          "Envoyer le rapport",
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
    );
  }
}
