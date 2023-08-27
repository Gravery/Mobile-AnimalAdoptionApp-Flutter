import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

class AnnouncementScreen extends StatefulWidget {
  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.reference();
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
          SnackBar(content: Text('Anúncio criado com sucesso')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário não logado')),
      );
    }
  }

  bool _validateEmptyForm() {
    final icon = Icons.warning;

    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackBar("Insira o nome do animal", icon);
      return false;
    }
    if (_breedController.text.trim().isEmpty) {
      _showErrorSnackBar("Insira a raça do animal", icon);
      return false;
    }
    if (_ageController.text.trim().isEmpty) {
      _showErrorSnackBar("Insira a idade do animal", icon);
      return false;
    }
    if (_typeController.text.trim().isEmpty) {
      _showErrorSnackBar("Insira o tipo do animal", icon);
      return false;
    }
    if (_contactController.text.trim().isEmpty) {
      _showErrorSnackBar("Insira o contato", icon);
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
        title: Text('Anunciar Animal'),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.onPrimary,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              'Anunciar',
              style: TextStyle(fontSize: 50),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome do Animal'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(labelText: 'Descrição do Animal'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  child: TextFormField(
                    controller: _breedController,
                    decoration: InputDecoration(labelText: 'Raça'),
                  ),
                ),
                Container(
                  width: 100,
                  child: TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(labelText: 'Idade'),
                  ),
                ),
                Container(
                  width: 100,
                  child: TextFormField(
                    controller: _typeController,
                    decoration: InputDecoration(labelText: 'Tamanho'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _contactController,
              decoration: InputDecoration(labelText: 'Contato'),
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
              child: Text('Adicionar Imagem'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _announceAnimal,
              child: Text('Anunciar'),
            ),
          ],
        ),
      ),
    );
  }
}
