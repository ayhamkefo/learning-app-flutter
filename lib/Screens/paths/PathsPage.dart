import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../api/ApiServic.dart';
import '../../models/paths.dart';
import '../../widgets/CustomAppBar.dart';
import 'pathPage.dart';

class PathsPage extends StatefulWidget {
  const PathsPage({super.key});

  @override
  State<PathsPage> createState() => _PathsPageState();
}

class _PathsPageState extends State<PathsPage> {
  late Future<List<ProgrammingPath>> futurePaths;

  @override
  void initState() {
    super.initState();
    futurePaths = ApiService().fetchPaths();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Career Paths",
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffE8EAF6), Color(0xffF5F5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<ProgrammingPath>>(
          future: futurePaths,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final paths = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
                itemCount: paths.length,
                itemBuilder: (context, index) {
                  final path = paths[index];
                  return Column(
                    children: [
                      const SizedBox(height: 15),
                      InkWell(
                        borderRadius: BorderRadius.circular(20.0),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PathPage(
                                        pathId: path.id!,
                                      )));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: MediaQuery.of(context).size.height * 0.15,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4.0,
                                spreadRadius: 1.0,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              chooseIcon(path.title!),
                              const SizedBox(width: 25.0),
                              Expanded(
                                child: Text(
                                  path.title!,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blueGrey[400],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              return const Center(child: Text('No paths available'));
            }
          },
        ),
      ),
    );
  }
}

Icon chooseIcon(String title) {
  switch (title.toLowerCase()) {
    case 'backend web development':
    case 'backend':
      return const Icon(
        FontAwesomeIcons.laravel,
        color: Colors.red,
        size: 30,
      );
    case 'frontend web development':
    case 'frontend':
      return const Icon(
        FontAwesomeIcons.react,
        color: Colors.blue,
        size: 30,
      );
    case 'artificial intelligence':
    case 'ai':
      return const Icon(
        FontAwesomeIcons.robot,
        color: Colors.pinkAccent,
        size: 30,
      );
    case 'moblie app development':
    case 'moblie':
      return const Icon(
        FontAwesomeIcons.android,
        color: Colors.green,
        size: 30,
      );
    default:
      return const Icon(
        FontAwesomeIcons.code,
        color: Colors.grey,
        size: 30,
      );
  }
}
