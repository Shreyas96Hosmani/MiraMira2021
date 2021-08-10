class SprintListParser {
  String sprintId, sprintName, sprintStatus, id;

  SprintListParser(
      {this.sprintId, this.sprintName, this.sprintStatus, this.id});

  factory SprintListParser.fromJson(Map<String, dynamic> json) =>
      SprintListParser(
          sprintId: json["sprintId"],
          sprintName: json["sprintName"],
          sprintStatus: json["sprintStatus"],
          id: json["_id"]);
}
