import 'package:flutter/material.dart';
import 'package:flutter_learning_app/widgets/bottomNavBar.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(
        select: 'Settings',
      ),
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(child: Text('Settings page')),
    );
  }
}
