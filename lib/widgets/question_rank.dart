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

  var count = 0;
  late int rank = 0;
  @override
  void didChangeDependencies() {
    FirebaseService().getScoreDocs().then((value) {
      setState(() {
        rank = value;
      });
    });
    fs.getAllQuizes().then((value) {
      setState(() {
        count = int.parse(value);
      });
    });
    super.didChangeDependencies();
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
              decoration: const BoxDecoration(),
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
                  Text(
                    '${count * 20}',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
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
                decoration: const BoxDecoration(),
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
                        children: [
                          Text(
                            '$rank',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                          const Icon(
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
