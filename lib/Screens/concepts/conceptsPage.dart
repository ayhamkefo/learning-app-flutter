import 'package:flutter/material.dart';
import 'package:flutter_learning_app/api/ApiServic.dart';
import 'package:flutter_learning_app/widgets/CustomAppBar.dart';

import '../../models/concpt.dart';

class ConceptsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    return Scaffold(
      appBar: CustomAppBar(title: 'Learn more'),
      body: FutureBuilder<Map<String, List<Concept>>>(
        future: ApiService().fetchAndGroupConcepts(),
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
                        'Learn About ${topicName.capitalize()}',
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
                        childAspectRatio: screenWidth < 576 ? 0.80 : 0.9,
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
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4.0,
              spreadRadius: 0.5,
            ),
          ],
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.code_rounded, size: 40, color: Colors.blueGrey),
            SizedBox(height: 10),
            Text(
              concept.title!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 5),
            TextButton(
              onPressed: () => _showDetails(context),
              child: Text("Read More"),
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
