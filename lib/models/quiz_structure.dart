import 'package:flutter/cupertino.dart';

class QuizStructure extends ChangeNotifier {
  final String id;
  final String imageUrl;
  final String title;
  final String category;
  QuizStructure(
      {required this.id,
      required this.imageUrl,
      required this.title,
      required this.category});
}
