import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _reference =
      FirebaseDatabase.instance.ref().child('animals');

  List<Animal> animalList = [];

  @override
  void initState() {
    super.initState();
    _listenForAnimalChanges();
  }

  void _listenForAnimalChanges() {
    _reference.onValue.listen((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      animalList.clear();
      Map<dynamic, dynamic>? animalsMap =
          snapshot.value as Map<dynamic, dynamic>?;
      if (animalsMap != null) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: animalList.length,
        itemBuilder: (context, index) {
          return AnimalCard(
            animal: animalList[index],
          );
        },
      ),
    );
  }
}

class Animal {
  final String id;
  final String image;
  final String name;
  final String description;
  final String breed;
  final String age;
  final String type;
  final String contact;
  final String user;

  Animal({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.breed,
    required this.age,
    required this.type,
    required this.contact,
    required this.user,
  });
}

class AnimalCard extends StatelessWidget {
  final Animal animal;

  AnimalCard({required this.animal});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
      child: InkWell(
        onTap: () {
          _openAnimalDetails(context);
        },
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: CachedNetworkImage(
                imageUrl: animal.image,
                width: 190,
                height: 150,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      animal.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      animal.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAnimalDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnimalDetailsScreen(animal: animal),
      ),
    );
  }
}

class AnimalDetailsScreen extends StatelessWidget {
  final Animal animal;

  AnimalDetailsScreen({required this.animal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.animal_details),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              alignment: Alignment.center,
              imageUrl: animal.image,
              width: 190,
              height: 150,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            SizedBox(height: 20.0),
            _buildDetailRow(
                AppLocalizations.of(context)!.animal_name, animal.name),
            _buildDetailRow(AppLocalizations.of(context)!.animal_description,
                animal.description),
            _buildDetailRow(
                AppLocalizations.of(context)!.animal_breed, animal.breed),
            _buildDetailRow(
                AppLocalizations.of(context)!.animal_age, animal.age),
            _buildDetailRow(
                AppLocalizations.of(context)!.animal_size, animal.type),
            _buildDetailRow(
                AppLocalizations.of(context)!.contact, animal.contact),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
