import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:new_york_city/database/database_helper.dart';
import 'package:new_york_city/models/attraction.dart';
import 'package:new_york_city/pages/page_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PageWelcome extends StatefulWidget {
  const PageWelcome({super.key});

  @override
  State<PageWelcome> createState() => _PageWelcomeState();
}

class _PageWelcomeState extends State<PageWelcome> {
  final _formKey = GlobalKey<FormState>();
  String username = "Test";
  int attractionId = 1;
  // ignore: non_constant_identifier_names
  int user_id = 0;
  late String bookingTime;
  List<Attraction> attractions = [
    Attraction(id: 1, name: 'placeholder', description: '', imagePath: ''),
  ];
  TextEditingController usernameController = TextEditingController();
  late YoutubePlayerController _controller;

  _loadAttractions() async {
    // await clearTable('attractions');
    final db = await DatabaseHelper.instance.database;
    var fetchedAttractions = await db.query('attractions');
    attractions = [];
    setState(() {
      for (var attraction in fetchedAttractions) {
        attractions.add(Attraction.fromMap(attraction));
      }
    });
  }

  Future<void> _loadUsername() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    username = sharedPreferences.getString('username') ?? '';
    log(username);

    usernameController.text = username;
  }

  Future<void> addBookingToDb() async {
    final db = await DatabaseHelper.instance.database;

    List<Map> results = await db.query(
      'users',
      columns: ['id'],
      where: 'name = ?',
      whereArgs: [username],
    );

    if (results.isEmpty) {
      log('No user found with the given username');
      return;
    }

    int userId = results.first['id'];

    Map<String, dynamic> bookingData = {
      'user_id': userId,
      'attraction_id': attractionId,
      'booking_time': bookingTime
    };

    await db.insert('bookings', bookingData);

    log('Booking added successfully!');
  }

  @override
  void initState() {
    super.initState();
    _loadUsername().then((_) => _loadAttractions());
    _controller = YoutubePlayerController(
      initialVideoId: 'WLSnrXEtrT4',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  _logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('isLoggedIn');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PageLogin(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Banner image with overlay text
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/banner_image.jpg', // Assuming you have an image named 'new_york.jpg' in your assets folder.
                  fit: BoxFit.cover,
                  height: 250.0,
                  width: double.infinity,
                ),
                Container(
                  height: 250.0,
                  color: Colors
                      .black38, // Semi-transparent overlay for better text visibility.
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                  ),
                ),
              ],
            ),
            // Sample text below image
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Welcome to the best booking agency ever! Book your adventure with us and experience the city like never before. Our expertise ensures that your journey will be unforgettable. Your satisfaction is our top priority - if you're not satisfied, it's money back guaranteed!",
                style: TextStyle(
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      enabled: false,
                      controller: usernameController,
                      decoration: const InputDecoration(labelText: "Username"),
                      onChanged: (value) {
                        setState(() {
                          username = value;
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<int>(
                      value: attractionId,
                      items: attractions.map((Attraction attraction) {
                        return DropdownMenuItem<int>(
                          value: attraction.id,
                          child: Text(attraction.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          attractionId = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select an attraction';
                        }
                        return null;
                      },
                      decoration:
                          const InputDecoration(labelText: "Attraction"),
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Booking Time"),
                      onSaved: (value) => bookingTime = value!,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a booking time';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Here, you can save the data to the 'bookings' table.
                          await addBookingToDb();
                        }
                      },
                      child: const Text("Make Booking"),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  await _logout();
                },
                child: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
