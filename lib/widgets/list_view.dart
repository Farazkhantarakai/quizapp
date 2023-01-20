import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/quiz_structure.dart';

import 'package:quiz_app/providers/question_api.dart';
import 'package:quiz_app/providers/quizData.dart';

import 'package:quiz_app/widgets/list_container.dart';

class XList extends StatefulWidget {
  XList({super.key, required this.ontap});

  Function ontap;

  @override
  State<XList> createState() => _ListState();
}

class _ListState extends State<XList> {
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<QuizData>(context, listen: false).getQuizData;
    var jsonResponse = Provider.of<QuestionApi>(context, listen: false);
    var mdq = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.all(10),
      constraints: BoxConstraints.expand(
          width: double.infinity, height: mdq.height * 0.56),
      decoration: const BoxDecoration(),
      child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return ChangeNotifierProvider<QuizStructure>.value(
                value: data[index],
                child: GestureDetector(
                    onTap: () => widget.ontap(data[index], jsonResponse),
                    child: const ListContainer()));
          }),
    );
  }
}
