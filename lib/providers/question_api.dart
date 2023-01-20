import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/models/quiz_model.dart';

class QuestionApi extends ChangeNotifier {
  List<QuizModel> list = [];
  get getQuiz => list;

  Future<void> getQuizData(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    var result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      for (var i in result) {
        var singleItem = QuizModel.fromJson(i);
        list.add(singleItem);
      }
    }
    notifyListeners();
  }

  void doEmptyList() {
    list = [];
    notifyListeners();
  }
}
