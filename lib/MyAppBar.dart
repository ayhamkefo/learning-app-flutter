import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5],
          colors: [
            // Color.fromARGB(237, 37, 44, 74),
            // Color.fromARGB(218, 71, 89, 167),
            Color(0xff886ff2),
            Color(0xff6849ef),
          ],
        ),
      ),
      child: const Text(
        "Welcome To \n Home Page",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
