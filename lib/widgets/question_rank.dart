import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/providers/firebase_service.dart';
import 'package:quiz_app/utils/colors.dart';

class QuestionAndRank extends StatefulWidget {
  const QuestionAndRank({super.key});

  @override
  State<QuestionAndRank> createState() => _QuestionAndRankState();
}

class _QuestionAndRankState extends State<QuestionAndRank> {
  FirebaseService fs = FirebaseService();
  bool isLoading = false;
  late var count;
  @override
  void didChangeDependencies() {
    getData();
    super.didChangeDependencies();
  }

  getData() async {
    isLoading = true;
    await fs.getQuestionCountAndRank().then((value) {
      setState(() {
        isLoading = false;
      });
      count = value.data()!['count'];
      if (kDebugMode) {
        print('question count $count');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      constraints:
          const BoxConstraints.expand(width: double.infinity, height: 100),
      decoration: const BoxDecoration(
          color: dataBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'QuestionCount',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 15),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          '$count',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            constraints:
                const BoxConstraints.expand(width: 2, height: double.infinity),
            decoration: const BoxDecoration(color: Colors.white),
          ),
          Expanded(
            flex: 4,
            child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  const Text(
                    'World Rankings',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 15),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        '0',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ])),
          )
        ],
      ),
    );
  }
}

// Container(
//       margin: const EdgeInsets.all(10),
//       constraints: const BoxConstraints.expand(
//         width: double.infinity,
//         height: 70,
//       ),
//       decoration: const BoxDecoration(
//           color: dataBackgroundColor,
//           borderRadius: BorderRadius.all(Radius.circular(10))),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(right: 20),
//                 decoration: const BoxDecoration(
//                     border: Border(
//                         right: BorderSide(color: Colors.white, width: 2))),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     Text(
//                       '$questionCount',
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontFamily: 'Poppins',
//                           fontSize: 12),
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     const Text(
//                       '230',
//                       style: TextStyle(fontSize: 20, color: Colors.white),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Container(
//                 padding: const EdgeInsets.only(right: 10),
//                 decoration: const BoxDecoration(),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     const Text(
//                       'World Rankings',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontFamily: 'Poppins',
//                           fontSize: 12),
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     Row(
//                       children: const [
//                         Text(
//                           '1250',
//                           style: TextStyle(fontSize: 20, color: Colors.white),
//                         ),
//                         Icon(
//                           Icons.person,
//                           color: Colors.white,
//                           size: 15,
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               )
//             ],
//           )
//         ],
//       ),
//     );
