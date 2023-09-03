import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PageGallery extends StatefulWidget {
  const PageGallery({super.key});

  @override
  State<PageGallery> createState() => _PageGalleryState();
}

class _PageGalleryState extends State<PageGallery> {
  List<String> galleryImages = [];

  _loadGallery() async {
    // await clearTable('attractions');
    // final db = await DatabaseHelper.instance.database;
    // var fetchedImages = await db.query('attractions');
    // setState(() {
    //   for (var image in fetchedImages) {
    //     galleryImages.add("assets/${image['imagePath']}");
    //   }
    // });
    final response =
        await http.get(Uri.parse('https://random-d.uk/api/v2/list'));

    dynamic jsonResponse;

    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }

    setState(() {
      for (int i = 0; i < 10; i++) {
      galleryImages
          .add('https://random-d.uk/api/v2/${jsonResponse['images'][i]}');
    }
    });
    log("$galleryImages");
  }

  @override
  void initState() {
    super.initState();
    _loadGallery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
           padding: const EdgeInsets.all(24.0),
        child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10, 
                  mainAxisSpacing: 10, 
                ),
                itemCount: galleryImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      border: Border.all(width: 3, color: Colors.grey),
                    ),
                    child: Image.network(galleryImages[index], fit: BoxFit.cover)
                  );
                },
              ),
      ),
    );
  }
}
