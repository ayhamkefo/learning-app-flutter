import 'package:flutter/material.dart';

import '../../api/ApiServic.dart';
import '../../models/concpt.dart';
import '../../widgets/CustomAppBar.dart';

class ConceptsPage extends StatefulWidget {
  const ConceptsPage({super.key});

  @override
  State<ConceptsPage> createState() => _ConceptsPageState();
}

class _ConceptsPageState extends State<ConceptsPage> {
  late Future<Map<String, List<Concept>>> futureConcept;
  @override
  void initState() {
    super.initState();
    futureConcept = ApiService().fetchAndGroupConcepts();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return Scaffold(
      appBar: CustomAppBar(title: 'Learn more'),
      body: FutureBuilder<Map<String, List<Concept>>>(
        future: futureConcept,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No concepts found'));
          } else {
            return ListView(
              children: snapshot.data!.entries.map((entry) {
                String topicName = entry.key;
                List<Concept> concepts = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '${topicName.capitalize()}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16.0),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth < 576
                            ? 2
                            : 3, // Adjust grid based on screen width
                        childAspectRatio: screenWidth < 576 ? 1.3 : 0.9,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: concepts.length,
                      itemBuilder: (context, index) {
                        return ConceptCard(concept: concepts[index]);
                      },
                    ),
                    SizedBox(height: 20), // Add some space between groups
                  ],
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}

class ConceptCard extends StatelessWidget {
  final Concept concept;

  ConceptCard({required this.concept});

  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(concept.title!),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Explanation: ${concept.explanation!}"),
              SizedBox(height: 10),
              Text("Sources: ${concept.sources!}"),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4.0,
              spreadRadius: 0.5,
            ),
          ],
        ),
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Text(
              concept.title!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.blue)),
              onPressed: () => _showDetails(context),
              child: Text(
                "Read More",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return this.length > 0
        ? '${this[0].toUpperCase()}${this.substring(1)}'
        : '';
  }
}
