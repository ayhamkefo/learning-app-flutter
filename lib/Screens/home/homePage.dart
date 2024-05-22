import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../widgets/CustomAppBar.dart';
import '../../widgets/bottomNavBar.dart';
import '../concepts/conceptsPage.dart';
import '../interview_questions/interviewQustionPage.dart';
import '../paths/PathsPage.dart';
import 'homePageSections.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(
          title: "Home",
        ),
        bottomNavigationBar: const CustomBottomNavBar(
          select: "Home",
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffE8EAF6), Color(0xffF5F5F5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView(
            children: [
              Body(),
            ],
          ),
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Column(children: [
      SizedBox(
        height: screenHeight * 0.05, // Adjust size relative to screen height
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 70),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                screenWidth < 600 ? 2 : 3, // Adjust grid based on screen width
            childAspectRatio: screenWidth < 600 ? 0.75 : 0.90,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: HomePageSection.sections.length,
          itemBuilder: (context, index) {
            HomePageSection section = HomePageSection.sections[index];
            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                if (index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PathsPage(),
                    ),
                  );
                } else if (index == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConceptsPage(),
                    ),
                  );
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InterviewQuestionsPage(),
                    ),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8.0,
                      spreadRadius: 2.0,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Flexible(
                      child: Image.asset(
                        section.imageSource,
                        height: screenHeight * 0.3,
                        width: screenWidth * 2,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        section.sectionTilte,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blueGrey[300],
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ]);
  }
}
