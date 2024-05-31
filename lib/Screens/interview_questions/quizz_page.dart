import 'package:flutter/material.dart';
import '../../models/interviewQuestion.dart';
import 'result_page.dart';

class QuizzScreen extends StatefulWidget {
  final List<InterviewQuestion> questions;
  const QuizzScreen({super.key, required this.questions});

  @override
  _QuizzScreenState createState() => _QuizzScreenState();
}

class _QuizzScreenState extends State<QuizzScreen> {
  int question_pos = 0;
  int score = 0;
  bool btnPressed = false;
  PageController? _controller;
  String btnText = "Next Question";
  bool answered = false;
  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF252c4a),
              Color.fromARGB(224, 166, 168, 175),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: PageView.builder(
              controller: _controller!,
              onPageChanged: (page) {
                if (page == widget.questions.length - 1) {
                  setState(() {
                    btnText = "See Results";
                  });
                }
                setState(() {
                  answered = false;
                });
              },
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Question ${index + 1}/${widget.questions.length}",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: widget.questions[index].questionText.length * 2,
                      child: Text(
                        widget.questions[index].questionText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    for (int i = 0;
                        i < widget.questions[index].choices.length;
                        i++)
                      Container(
                        width: MediaQuery.of(context).size.width * 2,
                        height: MediaQuery.of(context).size.width * 0.2,
                        margin: const EdgeInsets.only(
                            bottom: 20.0, left: 12.0, right: 12.0),
                        child: RawMaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          fillColor: btnPressed
                              ? widget.questions[index].choices[i].isCorrect ==
                                      1
                                  ? Colors.green[600]
                                  : Colors.red[600]
                              : const Color.fromARGB(
                                  223, 37, 44, 74), // : Color(0xFF117eeb),
                          onPressed: !answered
                              ? () {
                                  if (widget.questions[index].choices[i]
                                          .isCorrect ==
                                      1) {
                                    score++;
                                    print("yes");
                                  } else {
                                    print("no");
                                  }
                                  setState(() {
                                    btnPressed = true;
                                    answered = true;
                                  });
                                }
                              : null,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10, top: 5),
                              child: Text(
                                  widget.questions[index].choices[i].choiceText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                  )),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    RawMaterialButton(
                      onPressed: () {
                        if (_controller!.page?.toInt() ==
                            widget.questions.length - 1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultScreen(score)));
                        } else {
                          _controller!.nextPage(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInExpo);

                          setState(() {
                            btnPressed = false;
                          });
                        }
                      },
                      shape: const StadiumBorder(),
                      fillColor: const Color(0xFF252c4a),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      elevation: 0.0,
                      child: Text(
                        btnText,
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                );
              },
              itemCount: widget.questions.length,
            )),
      ),
    );
  }
}
