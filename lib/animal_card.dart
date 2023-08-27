import 'package:flutter/material.dart';

class AnimalCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageAsset;

  AnimalCard({
    required this.title,
    required this.description,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
      child: Container(
        child: ListTile(
          contentPadding: EdgeInsets.all(14.0),
          leading: Image.asset(imageAsset),
          title: Text(
            title,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            description,
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }
}
