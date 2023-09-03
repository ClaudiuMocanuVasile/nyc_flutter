import 'package:flutter/material.dart';
import 'package:new_york_city/pages/page_home.dart';
import 'package:new_york_city/pages/page_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<bool>(
        future: isLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!) {
              return const PageHome();
            } else {
              return const PageLogin();
            }
          } else {
            return const CircularProgressIndicator(); 
          }
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
