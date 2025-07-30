import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:pvit_gestion/config/config.dart';

class RapportFormPage extends StatefulWidget {
  final int interventionId;
  final int technicienId;

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Rapport envoyé avec succès ✅")));
        Navigator.pop(context);
      } else {
        print("Erreur serveur : ${response.statusCode}");
        print("Réponse : ${response.body}");
        throw Exception("Échec de l'envoi");
      }
    } catch (e) {
      print("Erreur : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'envoi du rapport")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _takePhoto() async {
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
      appBar: AppBar(title: Text("Envoie de rapport")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Description *",
                border: OutlineInputBorder(),
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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedImages.map((img) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(img.path),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 0,
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
            SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _showImageSourceDialog,
              icon: Icon(Icons.add_a_photo),
              label: Text("Ajouter photo(s)"),
            ),
            Spacer(),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _envoyerRapport,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text("Envoyer le rapport"),
                  ),
          ],
        ),
      ),
    );
  }
}
