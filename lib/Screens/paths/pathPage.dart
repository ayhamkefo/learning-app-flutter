import 'package:flutter/material.dart';
import 'package:flutter_learning_app/models/paths.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../api/ApiServic.dart';
import '../../widgets/CustomAppBar.dart';

class PathPage extends StatefulWidget {
  final int pathId;

  const PathPage({super.key, required this.pathId});

  @override
  _PathPageState createState() => _PathPageState();
}

class _PathPageState extends State<PathPage> {
  late Future<ProgrammingPath> futurePath;

  @override
  void initState() {
    super.initState();
    futurePath = ApiService().fetchPath(widget.pathId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Path Details",
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(226, 104, 129, 175),
              Color.fromARGB(255, 187, 187, 187),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<ProgrammingPath>(
          future: futurePath,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final path = snapshot.data!;
              return Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.swipe_left,
                          color: Colors.black,
                          size: 30,
                        ),
                        SizedBox(
                          width: 150,
                        ),
                        Icon(
                          Icons.swipe_right,
                          color: Colors.black,
                          size: 30,
                        ),
                      ]),
                  Expanded(
                    child: PageView(
                      children: [
                        _buildCard(
                            title: 'Description',
                            content: path.description!,
                            icon: Icons.label_important_outline),
                        _buildCard(
                          title: 'Roles',
                          content: path.roles!,
                          icon: Icons.join_inner_sharp,
                        ),
                        _buildCard(
                          title: 'Challenges',
                          content: path.challenges!,
                          icon: FontAwesomeIcons.faceAngry,
                        ),
                        _buildCard(
                          title: 'Interests',
                          content: path.interests!,
                          icon: FontAwesomeIcons.faceLaughBeam,
                        ),
                        _buildCard(
                          title: 'Frameworks',
                          content: path.frameworks!,
                          icon: FontAwesomeIcons.laptopCode,
                        ),
                        _buildCard(
                            title: 'Steps to Learn',
                            content: path.stepsToLearn!,
                            icon: Icons.stacked_bar_chart),
                        _buildCard(
                          title: 'Sources',
                          content: path.sources!,
                          icon: Icons.link_outlined,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildCard(
      {required String title,
      required String content,
      required IconData icon}) {
    print(content.length);
    bool needsExpanded =
        content.length > 500; // Adjust this threshold based on your needs

    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white70,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8.0,
              spreadRadius: 2.0,
              offset: const Offset(2, 2),
            ),
          ],
          // gradient: const LinearGradient(
          //   colors: [
          //     Color(0xff9fa8da), // A darker shade of light blue
          //     Color(0xffbdbdbd),
          //   ],
        ), // )),
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.black54, size: 27),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (needsExpanded)
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      content,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              else
                Text(
                  content,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
