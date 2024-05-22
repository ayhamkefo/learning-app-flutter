import 'package:flutter/material.dart';
import 'package:flutter_learning_app/Screens/interview_questions/quizzPage.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../api/ApiServic.dart';
import '../../models/interviewQuestion.dart';
import '../../widgets/CustomAppBar.dart';
import '../paths/PathsPage.dart';

class InterviewQuestionsPage extends StatefulWidget {
  @override
  _InterviewQuestionsPageState createState() => _InterviewQuestionsPageState();
}

class _InterviewQuestionsPageState extends State<InterviewQuestionsPage> {
  late Future<Map<String, List<InterviewQuestion>>> futureQuestions;

  @override
  void initState() {
    super.initState();
    futureQuestions = ApiService().fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Test Your Knowledge'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffE8EAF6), Color(0xffF5F5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<Map<String, List<InterviewQuestion>>>(
          future: futureQuestions,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView(
                padding: const EdgeInsets.all(20),
                children: snapshot.data!.entries.map((entry) {
                  String topicName = entry.key;
                  List<InterviewQuestion> questions = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: chooseIcon(topicName),
                        title: Text(
                          topicName,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.menu_book_outlined,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "${questions.length} Questions",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.alarm,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "${(questions.length * 1.5).toStringAsFixed(1)} min",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            SizedBox(height: 4),
                            Text(
                              "4.5",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          showTestExplanationBottomSheet(
                              context, topicName, questions);
                        },
                      ),
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}

void showTestExplanationBottomSheet(
    BuildContext context, String topicName, List<InterviewQuestion> questions) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Brief explanation about this test',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.menu_book, color: Colors.deepPurple),
                    ),
                    title: Text(
                      "${questions.length} Qustions",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: const Text(
                      '10 points for each question',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                      child: Icon(
                        Icons.alarm_outlined,
                        color: Colors.deepPurple,
                      ),
                    ),
                    title: const Text(
                      'Total Duration',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      '${(questions.length * 1.5).toStringAsFixed(1)} min',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.star_border_outlined,
                          color: Colors.deepPurple),
                    ),
                    title: Text(
                      'Win ${questions.length} Stars',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: const Text(
                      'Answer all the questions correctly',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Spacer(), // Pushes the button to the bottom
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        //padding: EdgeInsets.symmetric(vertical: 5.0),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  QuizzScreen(questions: questions),
                            ));
                        // Start the quiz logic here
                      },
                      child: const Text(
                        'Start Quiz',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          },
        );
      });
}
