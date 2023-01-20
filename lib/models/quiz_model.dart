class QuizModel {
  String? category;
  String? id;
  String? correctAnswer;
  List<String>? incorrectAnswers;
  String? question;
  List<String>? tags;
  String? type;
  String? difficulty;
  List? region;

  QuizModel(
      {this.category,
      this.id,
      this.correctAnswer,
      this.incorrectAnswers,
      this.question,
      this.tags,
      this.type,
      this.difficulty,
      this.region});

  QuizModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    id = json['id'];
    correctAnswer = json['correctAnswer'];
    incorrectAnswers = json['incorrectAnswers'].cast<String>();
    question = json['question'];
    tags = json['tags'].cast<String>();
    type = json['type'];
    difficulty = json['difficulty'];
    region = json['region'];
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'id': id,
      'correctAnswer': correctAnswer,
      'incorrectAnswers': incorrectAnswers,
      'question': question,
      'tags': tags,
      'type': type,
      'difficulty': difficulty,
      'region': region
    };
  }
}
