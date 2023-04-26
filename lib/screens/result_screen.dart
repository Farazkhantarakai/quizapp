import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/screens/home_screen.dart';
import 'package:quiz_app/utils/colors.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/question_api.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});
  static const routName = '/resultScreen';

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // late Map<String, dynamic>? result;
  var result;
  @override
  void didChangeDependencies() {
    result = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final mdq = MediaQuery.of(context).size.height;
    var data = Provider.of<QuestionApi>(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: mobileBackgroundColor,
          body: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: mdq * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          data.doEmptyList();
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) {
                            return const HomeScreen();
                          }), (route) => false);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                    SizedBox(
                      height: mdq * 0.1,
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(15),
                  constraints: BoxConstraints.expand(
                      width: double.infinity,
                      height: mdq *
                          0.65), //this gona assign 50 % height of the total screen
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 198, 214, 219),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          (result!['result'] > 75)
                              ? Container(
                                  constraints: const BoxConstraints.expand(
                                    width: 100,
                                    height: 100,
                                  ),
                                  child: Image.asset(
                                    'assets/icons/trophy.png',
                                  ),
                                )
                              : Container(
                                  constraints: const BoxConstraints.expand(
                                      width: 100, height: 100),
                                  child: Image.asset('assets/icons/sad.png'),
                                ),
                          const SizedBox(
                            height: 2,
                          ),
                          (result!['result'] > 75)
                              ? const Text(
                                  'Congrates!',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )
                              : const Text('Better luck next time',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        '${result!['result']}% Score',
                        style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'Quiz Completed Succefully',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: 'You attempt ',
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: '${result!['length']} question ',
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(
                                    text: 'and from that ',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: '${result!['score']} answers ',
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold)),
                                const TextSpan(
                                    text: 'is correct ',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold))
                              ])),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Share with us :',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              Share.share('$result');
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 5),
                              constraints: const BoxConstraints.expand(
                                  width: 30, height: 30),
                              child: Image.asset('assets/icons/instagram.png'),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Share.share('$result');
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 5),
                              constraints: const BoxConstraints.expand(
                                  width: 30, height: 30),
                              child: Image.asset('assets/icons/facebook.png'),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Share.share('$result');
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 5),
                              constraints: const BoxConstraints.expand(
                                  width: 30, height: 30),
                              child: Image.asset('assets/icons/whatsapp.png'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
