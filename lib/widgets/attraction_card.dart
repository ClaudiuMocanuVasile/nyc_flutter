import 'package:flutter/material.dart';
import 'package:new_york_city/models/attraction.dart';

class AttractionCard extends StatelessWidget {
  final Attraction attraction;

  const AttractionCard({super.key, required this.attraction});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner image with text overlay
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/${attraction.imagePath}',
                fit: BoxFit.cover,
                height: 150,
              ),
              Text(
                attraction.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.black54,
                ),
              ),
            ],
          ),
          // Description
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(attraction.description),
          ),
        ],
      ),
    );
  }
}
