import 'package:flutter/material.dart';

import '../../api/ApiServic.dart';
import '../../models/concpt.dart';
import '../../widgets/custom_app_bar.dart';

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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No concepts found'));
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
                        topicName.capitalize(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 10),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: concepts.length,
                      itemBuilder: (context, index) {
                        return ConceptCard(concept: concepts[index]);
                      },
                    ),
                    const SizedBox(height: 20),
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

  const ConceptCard({super.key, required this.concept});

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
              const SizedBox(height: 10),
              Text("Sources: ${concept.sources!}"),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
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
        margin: const EdgeInsets.all(10),
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
    return length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
  }
}
