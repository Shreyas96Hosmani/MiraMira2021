class InstituesListParser {
  String id;
  String universityName;
  String courseDescription;
  String degreeDescription;
  String city;
  String state;
  StateFee stateFee;
  StateFee tutionFee;
  StateFee satScore;
  String isWishListed;
  StateFee satScoreMin;
  StateFee satScoreMax;

  InstituesListParser(
      {this.id,
        this.universityName,
        this.courseDescription,
        this.degreeDescription,
        this.city,
        this.state,
        this.stateFee,
        this.tutionFee,
        this.satScore,
        this.isWishListed,
        this.satScoreMin,
        this.satScoreMax});

  InstituesListParser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    universityName = json['universityName'];
    courseDescription = json['courseDescription'];
    degreeDescription = json['degreeDescription'];
    city = json['city'];
    state = json['state'];
    stateFee = json['stateFee'] != null
        ? new StateFee.fromJson(json['stateFee'])
        : null;
    tutionFee = json['tutionFee'] != null
        ? new StateFee.fromJson(json['tutionFee'])
        : null;
    satScore = json['satScore'] != null
        ? new StateFee.fromJson(json['satScore'])
        : null;
    isWishListed = json['isWishListed'];
    satScoreMin = json['satScoreMin'] != null
        ? new StateFee.fromJson(json['satScoreMin'])
        : null;
    satScoreMax = json['satScoreMax'] != null
        ? new StateFee.fromJson(json['satScoreMax'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['universityName'] = this.universityName;
    data['courseDescription'] = this.courseDescription;
    data['degreeDescription'] = this.degreeDescription;
    data['city'] = this.city;
    data['state'] = this.state;
    if (this.stateFee != null) {
      data['stateFee'] = this.stateFee.toJson();
    }
    if (this.tutionFee != null) {
      data['tutionFee'] = this.tutionFee.toJson();
    }
    if (this.satScore != null) {
      data['satScore'] = this.satScore.toJson();
    }
    data['isWishListed'] = this.isWishListed;
    if (this.satScoreMin != null) {
      data['satScoreMin'] = this.satScoreMin.toJson();
    }
    if (this.satScoreMax != null) {
      data['satScoreMax'] = this.satScoreMax.toJson();
    }
    return data;
  }
}

class StateFee {
  String numberInt;

  StateFee({this.numberInt});

  StateFee.fromJson(Map<String, dynamic> json) {
    numberInt = json['\$numberInt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['\$numberInt'] = this.numberInt;
    return data;
  }
}