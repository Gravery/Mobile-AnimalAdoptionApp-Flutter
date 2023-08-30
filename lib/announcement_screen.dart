import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AnnouncementScreen extends StatefulWidget {
  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  File? _imageFile;
  final picker = ImagePicker();

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _announceAnimal() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final userId = currentUser.uid;

      if (_validateEmptyForm()) {
        final userRef = _databaseRef.child("animals").push();
        final uuid = Uuid().v4();

        userRef.set({
          "id": userRef.key,
          "name": _nameController.text,
          "description": _descriptionController.text,
          "breed": _breedController.text,
          "age": _ageController.text,
          "type": _typeController.text,
          "contact": _contactController.text,
          "user": userId,
        });

        if (_imageFile != null) {
          final path = "images/$uuid";
          final imageRef = _storage.ref().child(path);
          final uploadTask = imageRef.putFile(_imageFile!);

          await uploadTask.whenComplete(() async {
            final imageUrl = await imageRef.getDownloadURL();
            userRef.child("image").set(imageUrl);
          });
        }

        _nameController.clear();
        _descriptionController.clear();
        _breedController.clear();
        _ageController.clear();
        _typeController.clear();
        _contactController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.announce_success)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.user_not_logged)),
      );
    }
  }

  bool _validateEmptyForm() {
    final icon = Icons.warning;

    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackBar(
          AppLocalizations.of(context)!.insert_animal_name, icon);
      return false;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _showErrorSnackBar(
          AppLocalizations.of(context)!.insert_animal_description, icon);
      return false;
    }
    if (_breedController.text.trim().isEmpty) {
      _showErrorSnackBar(
          AppLocalizations.of(context)!.insert_animal_breed, icon);
      return false;
    }
    if (_ageController.text.trim().isEmpty) {
      _showErrorSnackBar(AppLocalizations.of(context)!.insert_animal_age, icon);
      return false;
    }
    if (_typeController.text.trim().isEmpty) {
      _showErrorSnackBar(
          AppLocalizations.of(context)!.insert_animal_size, icon);
      return false;
    }
    if (_contactController.text.trim().isEmpty) {
      _showErrorSnackBar(AppLocalizations.of(context)!.insert_contact, icon);
      return false;
    }
    return true;
  }

  void _showErrorSnackBar(String message, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.announce_animal),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.onPrimary,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.announce,
                style: TextStyle(fontSize: 50),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.animal_name),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.animal_description),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    child: TextFormField(
                      controller: _breedController,
                      decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.animal_breed),
                    ),
                  ),
                  Container(
                    width: 100,
                    child: TextFormField(
                      controller: _ageController,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.animal_age),
                    ),
                  ),
                  Container(
                    width: 100,
                    child: TextFormField(
                      controller: _typeController,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.animal_size),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.contact),
              ),
              SizedBox(height: 10),
              _imageFile != null
                  ? Image.file(
                      _imageFile!,
                      width: 130,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Container(),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _getImage,
                child: Text(AppLocalizations.of(context)!.add_image),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _announceAnimal,
                child: Text(AppLocalizations.of(context)!.announce),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
