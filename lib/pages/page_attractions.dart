
import 'package:flutter/material.dart';
import 'package:new_york_city/database/database_helper.dart';
import 'package:new_york_city/models/attraction.dart';
import 'package:new_york_city/widgets/attraction_card.dart';
import 'package:sqflite/sqflite.dart';

class PageAttractions extends StatefulWidget {
  const PageAttractions({super.key});

  @override
  State<PageAttractions> createState() => _PageAttractionsState();
}

class _PageAttractionsState extends State<PageAttractions> {
  
  List<Attraction> attractions = [];

  Future<void> clearTable(String tableName) async {
    var db = await openDatabase('db.db');

    // Delete all rows in the table
    await db.rawDelete('DELETE FROM attractions');
  }

  _loadAttractions() async {
    // await clearTable('attractions');
    final db = await DatabaseHelper.instance.database;
    var fetchedAttractions = await db.query('attractions');
    setState(() {
      for (var attraction in fetchedAttractions) {
        attractions.add(Attraction.fromMap(attraction));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAttractions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Column(
          // You can define a specific height or make it dynamic based on content
          children: [
            ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: attractions.length,
            itemBuilder: (context, index) {
              return AttractionCard(attraction: attractions[index]);
            },
          ),
          ]
        ),
        
      ],
    ));
  }
}
