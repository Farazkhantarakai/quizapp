import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/quiz_structure.dart';

import 'package:quiz_app/utils/colors.dart';

class ListContainer extends StatelessWidget {
  const ListContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<QuizStructure>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: appBarColor,
      ),
      constraints:
          const BoxConstraints.expand(width: double.infinity, height: 70),
      child: Row(
        children: [
          Image.asset(
            data.imageUrl.toString(),
            height: 30,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            data.title,
            style: const TextStyle(color: Colors.white, fontSize: 17),
          )
        ],
      ),
    );
  }
}
