import 'package:flutter/cupertino.dart';
import 'package:quiz_app/models/quiz_structure.dart';

class QuizData extends ChangeNotifier {
  List<QuizStructure> get getQuizData => quizData;

  List<QuizStructure> quizData = [
    QuizStructure(
        id: '1',
        imageUrl: 'assets/icons/pen.png',
        title: 'Arts & Literature',
        category: 'arts_and_literature'),
    QuizStructure(
        id: '2',
        imageUrl: 'assets/icons/movies.png',
        title: 'Film & TV',
        category: 'film_and_tv'),
    QuizStructure(
        id: '3',
        imageUrl: 'assets/icons/food.png',
        title: 'Food & Drink',
        category: 'food_and_drink'),
    QuizStructure(
        id: '4',
        imageUrl: 'assets/icons/scienceandnature.png',
        title: 'General Knowledge',
        category: 'general_knowledge'),
    QuizStructure(
        id: '5',
        imageUrl: 'assets/icons/globe.png',
        title: 'Geography',
        category: 'geography'),
    QuizStructure(
        id: '6',
        imageUrl: 'assets/icons/history.png',
        title: 'History',
        category: 'history'),
    QuizStructure(
        id: '7',
        imageUrl: 'assets/icons/music.png',
        title: 'Music',
        category: 'music'),
    QuizStructure(
        id: '8',
        imageUrl: 'assets/icons/atom.png',
        title: 'Science',
        category: 'science'),
    QuizStructure(
        id: '9',
        imageUrl: 'assets/icons/culture.png',
        title: 'Society & Culture',
        category: 'society_and_culture'),
    QuizStructure(
        id: '10',
        imageUrl: 'assets/icons/game.png',
        title: 'Sport & Leisure',
        category: 'sport_and_leisure'),
  ];
}
