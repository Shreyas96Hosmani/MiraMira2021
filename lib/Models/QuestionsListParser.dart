class QuestionsListParser {
  String sId;
  String questionId;
  String questionNumber;
  String questionText;
  List<QuestionOptions> questionOptions;
  String questionStatus;
  String category;

  QuestionsListParser(
      {this.sId,
        this.questionId,
        this.questionNumber,
        this.questionText,
        this.questionOptions,
        this.questionStatus,
        this.category});

  QuestionsListParser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    questionId = json['questionId'];
    questionNumber = json['questionNumber'];
    questionText = json['questionText'];
    if (json['questionOptions'] != null) {
      questionOptions = new List<QuestionOptions>();
      json['questionOptions'].forEach((v) {
        questionOptions.add(new QuestionOptions.fromJson(v));
      });
    }
    questionStatus = json['questionStatus'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['questionId'] = this.questionId;
    data['questionNumber'] = this.questionNumber;
    data['questionText'] = this.questionText;
    if (this.questionOptions != null) {
      data['questionOptions'] =
          this.questionOptions.map((v) => v.toJson()).toList();
    }
    data['questionStatus'] = this.questionStatus;
    data['category'] = this.category;
    return data;
  }
}

class QuestionOptions {
  String optionId;
  String optionVal;
  String optionGrade;

  QuestionOptions({this.optionId, this.optionVal, this.optionGrade});

  QuestionOptions.fromJson(Map<String, dynamic> json) {
    optionId = json['optionId'];
    optionVal = json['optionVal'];
    optionGrade = json['optionGrade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['optionId'] = this.optionId;
    data['optionVal'] = this.optionVal;
    data['optionGrade'] = this.optionGrade;
    return data;
  }
}