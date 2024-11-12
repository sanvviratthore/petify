// lib/main.dart
import 'package:flutter/material.dart';
import 'species_selection_page.dart';

void main() {
  runApp(PetifyApp());
}

class PetifyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogoPage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class LogoPage extends StatefulWidget {
  @override
  _LogoPageState createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _fadeOut();
  }

  void _fadeOut() {
    Future.delayed(Duration(seconds: 6), () {
      setState(() {
        _opacity = 0.0;
      });
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SpeciesSelectionPage()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 170, 170),
      body: Center(
        child: Opacity(
          opacity: _opacity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Petify-removebg-preview.png',
                width: 400,
                height: 400,
              ),
              const SizedBox(height: 20),
              const Text(
                'Caring for your pets, one paw at a time!',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'TimesNewRoman',
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

