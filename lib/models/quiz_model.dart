class Quiz {
  String quizType;
  int totalQuestions;
  int correctAnswers;
  DateTime date;

  Quiz({
    required this.quizType,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'quizType': quizType,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'date': date.toIso8601String(),
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    return Quiz(
      quizType: map['quizType'] ?? '',
      totalQuestions: map['totalQuestions'] ?? 0,
      correctAnswers: map['correctAnswers'] ?? 0,
      date: DateTime.parse(map['date']),
    );
  }
}
