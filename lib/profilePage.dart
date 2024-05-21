import 'package:flutter/material.dart';
import 'package:flutter_learning_app/widgets/bottomNavBar.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(
        select: "Profile",
      ),
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(child: Text('Proflie page')),
    );
  }
}
