import 'package:flutter/material.dart';
import 'package:flutter_learning_app/widgets/bottom_nav_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(
        select: "Profile",
      ),
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(child: Text('Proflie page')),
    );
  }
}
