import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/models/quiz_structure.dart';
import 'package:quiz_app/providers/firebase_service.dart';
import 'package:quiz_app/providers/question_api.dart';
import 'package:quiz_app/providers/quizData.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/utils/colors.dart';
import 'package:quiz_app/widgets/quest_container.dart';
import 'package:quiz_app/widgets/quiz_app_bar.dart';

class QuizDetail extends StatefulWidget {
  const QuizDetail({super.key});

  static const routName = '/quizdetail';

  @override
  State<QuizDetail> createState() => _QuizDetailState();
}

class _QuizDetailState extends State<QuizDetail> {
  late QuizStructure originalData;
  late List<QuizModel> apiData;
  int index = 0;
  bool answerA = false;
  bool answerB = false;
  bool answerC = false;
  bool answerD = false;
  String saveAnswer = '';
  var data;
  String answer = '';
  bool onceFetched = true;
  int score = 0;
  var quizList = [];
  int remainingQuestion = 0;
  double timeLeft = 30;
  late Timer timer;
  final FirebaseService _firebaseService = FirebaseService();
  // this is an empty list and will the incorect answers and the correct answer
  var quizLists = [];
  bool indexTrue = false;
  int win = 0;
  bool isLoading = false;
  bool once = true;
  late var count;
  FirebaseService fs = FirebaseService();

  void changeBool(bool value) {
    //this will reset the values to false
    setState(() {
      answerA = value;
      answerB = value;
      answerC = value;
      answerD = value;
    });
  }

  @override
  void initState() {
    super.initState();
    setTimer();
  }

  bool setTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft = timeLeft - 1;
        } else {
          timer.cancel();
          timeLeft = 30;
          index++;
          remainingQuestion = remainingQuestion - 1;
          setTimer();
          getData();
        }
      });
    });
    return timer.isActive;
  }

  cancelTimer() {
    timer.cancel();
  }

  @override
  void dispose() {
    timer.cancel();
    apiData = [];
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (onceFetched == true) {
      apiData = Provider.of<QuestionApi>(context, listen: false).getQuiz;
      apiData.shuffle();
      var data = ModalRoute.of(context)!.settings.arguments as String;
//here we are getting the element from the data with the its id matches
      originalData = Provider.of<QuizData>(context)
          .getQuizData
          .firstWhere((element) => element.id == data);
      remainingQuestion = apiData.length;
      setState(() {
        onceFetched = false;
      });
    }
    getData();
  }

  void getData() {
    if (once) {
      quizList = [];
      quizList.add(apiData[index].incorrectAnswers![0]);
      quizList.add(apiData[index].incorrectAnswers![1]);
      quizList.add(apiData[index].incorrectAnswers![2]);
      quizList.add(apiData[index].correctAnswer);
      quizList.shuffle();
      once = false;
    } else {
      return;
    }
  }

  void submit() async {
    if (kDebugMode) {
      print('submit quizlist $quizList');
    }
    setState(() {
      try {
        if (index <= apiData.length - 2) {
          if (answer.isEmpty) {
            Fluttertoast.showToast(
              msg: 'Please select one of them',
              backgroundColor: Colors.white,
              textColor: mobileBackgroundColor,
            );

            setState(() {
              indexTrue = true;
            });
          } else {
            timeLeft = 30;
            if (answer == apiData[index].correctAnswer) {
              setState(() {
                score++;
                answer = '';
              });
              index++;
              once = true;
              getData();
            } else {
              score = score;
              answer = '';
              index++;
              once = true;
              getData();
            }
            answerA = false;
            answerB = false;
            answerC = false;
            answerD = false;
          }
        } else {
          double result = score / apiData.length * 100;
          FirebaseService().getAllQuizes().then((value) {
            FirebaseService().addQuiz(int.parse(value));
          });

          FirebaseService().addScore(score);
          FirebaseService().getAllQuizes();
          if (result > 75) {
            win++;
            index = 0;
            Navigator.of(context).pushNamedAndRemoveUntil(
                ResultScreen.routName, (route) => true, arguments: {
              'result': result,
              'length': apiData.length,
              'score': score
            });
          }
          index = 0;
          Navigator.pushNamed(context, ResultScreen.routName, arguments: {
            'result': result,
            'length': apiData.length,
            'score': score
          });
        }
      } catch (err) {
        log(err.toString());
      }
    });
  }

  void getAnswer(String saveAnswer) {
    setState(() {
      answer = saveAnswer;
    });
    if (kDebugMode) {
      print('save answer value is $answer');
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<QuestionApi>(context);
    var mdq = MediaQuery.of(context)
        .size
        .height; //this will set the height for the whole screen
    bool allQuestion = answerA ||
        answerB ||
        answerC ||
        answerD == false; //if all is false then nothing is selected yet
    return WillPopScope(
      onWillPop: () async {
        data.doEmptyList();
        return true;
      },
      child: isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : SafeArea(
              child: Scaffold(
                  backgroundColor: mobileBackgroundColor,
                  body: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        QuizAppBar(
                          title: originalData.title,
                          imageUrl: originalData.imageUrl,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Quiz:$remainingQuestion',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  const Spacer(),
                                  Text(
                                    ' ${timeLeft.toInt()} sec',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              LinearProgressIndicator(
                                value: timeLeft /
                                    30, //the whole time will be divided
                                backgroundColor: Colors.white,
                                color: appBarColor,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              LimitedBox(
                                child: Text(
                                  '${index + 1}.  ${apiData[index].question}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 17),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                constraints: BoxConstraints.expand(
                                    width: double.infinity, height: mdq * 0.45),
                                decoration: const BoxDecoration(
                                    // color: Colors.green
                                    ),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (allQuestion) {
                                            answerA = true;
                                          }

                                          if (answerB ||
                                              answerC ||
                                              answerD == true) {
                                            answerA = true;
                                            answerB = false;
                                            answerC = false;
                                            answerD = false;
                                          }
                                          // questionA = !questionA;

                                          if (answerA == true) {
                                            saveAnswer = quizList[0];
                                            getAnswer(saveAnswer);
                                          } else {
                                            saveAnswer = '';

                                            getAnswer(saveAnswer);
                                          }
                                        });
                                      },
                                      child: QuestContainer(
                                        key: UniqueKey(),
                                        indication: 'A',
                                        answer: quizList[0],
                                        cColor: answerA,
                                        function: changeBool,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (allQuestion) {
                                            answerB = true;
                                          }

                                          if (kDebugMode) {
                                            print(quizList[1].toString());
                                          }

                                          if (answerA ||
                                              answerC ||
                                              answerD == true) {
                                            answerB = true;
                                            answerA = false;
                                            answerC = false;
                                            answerD = false;
                                          }

                                          if (answerB == true) {
                                            saveAnswer = quizList[1];
                                            if (kDebugMode) {
                                              print(
                                                  'savedAnswer ${quizList[1]}');
                                            }
                                            getAnswer(saveAnswer);
                                          } else {
                                            saveAnswer = '';
                                            getAnswer(saveAnswer);
                                          }
                                        });
                                      },
                                      child: QuestContainer(
                                        key: UniqueKey(),
                                        indication: 'B',
                                        answer: quizList[1],
                                        cColor: answerB,
                                        function: changeBool,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (allQuestion) {
                                            answerC = true;
                                          }

                                          if (answerA ||
                                              answerB ||
                                              answerD == true) {
                                            answerC = true;
                                            answerA = false;
                                            answerB = false;
                                            answerD = false;
                                          }

                                          if (answerC == true) {
                                            saveAnswer = quizList[2];
                                            getAnswer(saveAnswer);
                                          } else {
                                            saveAnswer = '';
                                            getAnswer(saveAnswer);
                                          }
                                        });
                                      },
                                      child: QuestContainer(
                                        key: UniqueKey(),
                                        indication: 'C',
                                        answer: quizList[2],
                                        cColor: answerC,
                                        function: changeBool,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (allQuestion) {
                                            answerD = true;
                                          }

                                          if (answerA ||
                                              answerB ||
                                              answerC == true) {
                                            answerD =
                                                true; //will make answr d to true and will make the rest false
                                            answerA = false;
                                            answerB = false;
                                            answerC = false;
                                          }

                                          if (answerD == true) {
                                            saveAnswer = quizList[3].toString();
                                            getAnswer(saveAnswer);
                                          } else {
                                            saveAnswer = '';
                                            getAnswer(saveAnswer);
                                          }
                                        });
                                      },
                                      child: QuestContainer(
                                        key: UniqueKey(),
                                        indication: 'D',
                                        answer: quizList[3],
                                        cColor: answerD,
                                        function: changeBool,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              InkWell(
                                onTap: submit,
                                child: Container(
                                  constraints: const BoxConstraints.expand(
                                      width: double.infinity, height: 60),
                                  decoration: const BoxDecoration(
                                      color: dataBackgroundColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  child: const Center(
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
    );
  }
}
