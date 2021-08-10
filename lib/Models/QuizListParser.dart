class QuizListParser {
  String id,
      quizId,
      quizNumber,
      quizName,
      totalQuestionCount,
      completedQuestionCount,
      skippedQuestionCount;

  QuizListParser(
      {this.id,
        this.quizId,
        this.quizNumber,
        this.quizName,
        this.totalQuestionCount,
        this.completedQuestionCount,
        this.skippedQuestionCount});

  factory QuizListParser.fromJson(Map<String, dynamic> json) => QuizListParser(
      id: json["_id"],
      quizId: json["quizId"],
      quizNumber: json["quizNumber"],
      quizName: json["quizName"],
      totalQuestionCount: json["totalQuestionCount"],
      completedQuestionCount: json["completedQuestionCount"],
      skippedQuestionCount: json["skippedQuestionCount"]);
}
