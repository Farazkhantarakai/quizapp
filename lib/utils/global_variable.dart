//this will return that particular category with the same shit
String changeUrl(String category) {
  return 'https://the-trivia-api.com/api/questions?categories=$category&limit=20&difficulty=medium';
}
