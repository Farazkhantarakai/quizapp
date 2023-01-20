import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/models/quiz_structure.dart';
import 'package:quiz_app/providers/firebase_service.dart';
import 'package:quiz_app/providers/question_api.dart';
import 'package:quiz_app/screens/quiz_detail.dart';
import 'package:quiz_app/utils/global_variable.dart';
import 'package:quiz_app/widgets/list_view.dart';
import 'package:quiz_app/widgets/upgrade.dart';
import 'package:quiz_app/utils/colors.dart';
import 'package:quiz_app/widgets/question_rank.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const route = 'homeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  String image = '';
  bool imageLoading = true;

  FirebaseService firebaseService = FirebaseService();

  void isSet(QuizStructure structure, QuestionApi jsonResponse) async {
    setState(() {
      isLoading = true;
    });
    if (kDebugMode) {
      print('first ${structure.category}');
    }
    await jsonResponse.getQuizData(changeUrl(structure.category)).then((value) {
      setState(() {
        isLoading = false;
      });
      Navigator.pushNamed(
        context,
        QuizDetail.routName,
        arguments: structure.id,
      );
    });
  }

  // @override
  // void initState() {
  //   // FirebaseService().getCounter();
  //   super.initState();

  // }

  @override
  void didChangeDependencies() {
    FirebaseService().getUserImage().then((value) {
      setState(() {
        imageLoading = false;
        image = value;
      });
      if (kDebugMode) {
        print('inside $image');
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // print('here in the main function ${firebaseService.getQuizCount}');
    return SafeArea(
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white)),
            )
          : Scaffold(
              drawer: Drawer(
                backgroundColor: mobileBackgroundColor,
                child: Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints.expand(
                          width: double.infinity, height: 240),
                      decoration: const BoxDecoration(color: appBarColor),
                      child: const Center(
                          child: Text(
                        'Quiz App',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      )),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                      color: appBarColor,
                      child: ListTile(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) {
                            return const HomeScreen();
                          }), (route) => false);
                        },
                        leading: const Icon(
                          Icons.content_copy,
                          color: dataBackgroundColor,
                        ),
                        title: const Text(
                          'Contents',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        textColor: Colors.white,
                      ),
                    ),
                    Card(
                      color: appBarColor,
                      child: ListTile(
                        onTap: () {
                          SystemNavigator.pop();
                        },
                        leading: const Icon(
                          Icons.exit_to_app,
                          color: dataBackgroundColor,
                        ),
                        title: const Text(
                          'Log Out',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              appBar: AppBar(
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: appBarColor,
                  ),
                  leading: Builder(builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Image.asset('assets/icons/menu.png'),
                    );
                  }),
                  actions: [
                    PopupMenuButton(
                      color: appBarColor,
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                            onTap: () {
                              FirebaseService().logOut();
                            },
                            child: const Text(
                              'LogOut',
                              style: TextStyle(
                                  fontFamily: 'Poppins', color: Colors.white),
                            ))
                      ],
                      icon: imageLoading
                          ? const CircleAvatar(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : CircleAvatar(
                              maxRadius: 150,
                              backgroundImage: NetworkImage(image),
                            ),
                    )
                  ],
                  toolbarHeight: 100,
                  backgroundColor: appBarColor,
                  title: const Text(
                    'Quiz App',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 30),
                  ),
                  centerTitle: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ))),
              backgroundColor: mobileBackgroundColor,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // const CAppBar(),
                    const SizedBox(
                      height: 10,
                    ),
                    const QuestionAndRank(
                        // count: firebaseService.getQuiz,
                        ),
                    XList(
                      ontap: isSet,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Upgrade()
                  ],
                ),
              )),
    );
  }
}
