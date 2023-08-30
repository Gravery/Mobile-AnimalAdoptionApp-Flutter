import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'home_screen.dart';

class ManagementScreen extends StatefulWidget {
  @override
  _ManagementScreenState createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  List<Animal> animalList = [];

  @override
  void initState() {
    super.initState();
    _loadAnimalList();
  }

  Future<void> deleteAnimalAd(String animalId) async {
    try {
      await _databaseRef.child("animals").child(animalId).remove();
      _loadAnimalList();
    } catch (e) {
      print("Erro ao deletar anúncio: $e");
    }
  }

  Future<void> _loadAnimalList() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      final userId = user.uid;

      final DatabaseEvent event = (await _databaseRef
          .child("animals")
          .orderByChild("user")
          .equalTo(userId)
          .once());

      final DataSnapshot snapshot = event.snapshot;

      Map<dynamic, dynamic>? animalsMap =
          snapshot.value as Map<dynamic, dynamic>?;
      if (animalsMap != null) {
        animalList.clear();
        animalsMap.forEach((key, value) {
          Animal animal = Animal(
            id: value['id'],
            image: value['image'],
            name: value['name'],
            description: value['description'],
            breed: value['breed'],
            age: value['age'],
            type: value['type'],
            contact: value['contact'],
            user: value['user'],
          );
          animalList.add(animal);
        });
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.management),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 60),
        child: Center(
          child: ListView.builder(
            itemCount: animalList.length,
            itemBuilder: (context, index) {
              return ManagementCard(
                animal: animalList[index],
                onDeleteClick: () {
                  deleteAnimalAd(animalList[index].id);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class ManagementCard extends StatelessWidget {
  final Animal animal;
  final VoidCallback onDeleteClick;

  ManagementCard({required this.animal, required this.onDeleteClick});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(top: 10, left: 6, right: 6),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: animal.image,
            width: 190,
            height: 150,
            fit: BoxFit.cover,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  animal.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  animal.description,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: onDeleteClick,
            child: Text(AppLocalizations.of(context)!.delete),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              onPrimary: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
