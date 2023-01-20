import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/question_api.dart';
import 'package:quiz_app/utils/colors.dart';

class QuizAppBar extends StatefulWidget {
  const QuizAppBar({super.key, required this.title, required this.imageUrl});

  final String title;
  final String imageUrl;

  @override
  State<QuizAppBar> createState() => _QuizAppBarState();
}

class _QuizAppBarState extends State<QuizAppBar> {
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<QuestionApi>(context);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints.expand(height: 60),
        decoration: const BoxDecoration(color: appBarColor),
        child: Row(
          children: [
            Image.asset(
              widget.imageUrl,
              width: 30,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  data.doEmptyList();
                },
                icon: const Icon(
                  Icons.close,
                  size: 25,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }
}
