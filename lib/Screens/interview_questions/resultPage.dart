import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home/homePage.dart';

// ignore: must_be_immutable
class ResultScreen extends StatefulWidget {
  int score;
  ResultScreen(this.score, {Key? key}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF252c4a),
              Color.fromARGB(224, 166, 168, 175),
              Color(0xFF252c4a),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            const SizedBox(
              height: 45.0,
            ),
            const Text(
              "Your Score is",
              style: TextStyle(
                  color: Color(0xFF252c4a),
                  fontSize: 34.0,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              "${widget.score}",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 85.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            RawMaterialButton(
              shape: const StadiumBorder(),
              fillColor: Color(0xFF252c4a),
              padding: const EdgeInsets.all(18.0),
              elevation: 1,
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ));
              },
              child: const Text(
                "Go to Home Page",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
