import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                    ListView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                      shrinkWrap: true,
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
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4.0,
              spreadRadius: 0.5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(concept.title!),
        ),
      ),
      //   child: SvgPicture.asset(
      //     "assets/icons/api.svg",
      //   ),
      // ),
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
