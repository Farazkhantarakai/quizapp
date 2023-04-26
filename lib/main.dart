import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/change_layout.dart';
import 'package:quiz_app/providers/question_api.dart';
import 'package:quiz_app/providers/quizData.dart';
import 'package:quiz_app/screens/forgot_password.dart';
import 'package:quiz_app/screens/home_on.dart';
import 'package:quiz_app/screens/quiz_detail.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/screens/signin.dart';
import 'package:quiz_app/screens/signup.dart';
import 'package:quiz_app/utils/colors.dart';
import 'package:quiz_app/widgets/dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Connectivity _conectivity = Connectivity();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) {
            return QuizData();
          }),
          ChangeNotifierProvider(create: (context) {
            return QuestionApi();
          }),
          ChangeNotifierProvider(create: (context) {
            return ChangeLayout();
          })
        ],
        child: MaterialApp(
            theme: ThemeData(
                appBarTheme: const AppBarTheme(
                    iconTheme: IconThemeData(color: Colors.white),
                    systemOverlayStyle:
                        SystemUiOverlayStyle(statusBarColor: appBarColor))),
            routes: {
              QuizDetail.routName: (context) {
                return const QuizDetail();
              },
              ResultScreen.routName: (context) {
                return const ResultScreen();
              },
              SignUp.routName: (context) {
                return const SignUp();
              },
              SignIn.routName: (context) {
                return const SignIn();
              },
              ForgotPassword.rout: (context) {
                return const ForgotPassword();
              }
            },
            home: StreamBuilder<ConnectivityResult>(
              stream: _conectivity
                  .onConnectivityChanged, //this will check if the internet connection
              builder: ((context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                    final state = snapshot.data!;
                    switch (state) {
                      case ConnectivityResult.none:
                        return const SDialogue();
                      default:
                        return const Home();
                    }
                  default:
                    return Container(
                      decoration: const BoxDecoration(),
                      child: const SDialogue(),
                    );
                }
              }),
            )));
  }
}
