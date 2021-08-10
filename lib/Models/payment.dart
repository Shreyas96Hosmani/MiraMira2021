
class PaymentList {
  PaymentList(this.payments);

  List<Payment> payments;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'answerOptions': payments,
  };
}

class Payment {
  Payment({this.optionId, this.optionVal, this.optionGrade});

  String optionId;
  String optionVal;
  String optionGrade;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'optionId': optionId,
    'optionVal': optionVal,
    'optionGrade': optionGrade,
  };
}