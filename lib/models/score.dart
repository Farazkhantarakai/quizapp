class Score {
  String userId;
  String userName;
  String userEmail;
  int score;
  Score(
      {required this.userId,
      required this.userEmail,
      required this.userName,
      required this.score});

  toMap() {
    return {
      "userId": userId,
      "userName": userName,
      "userEmail": userEmail,
      "score": score,
    };
  }

  fromJson(Map<String, dynamic> data) {
    return Score(
        userId: data['userId'],
        userEmail: data['userEmail'],
        userName: data['userName'],
        score: data['score']);
  }
}
