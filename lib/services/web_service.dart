import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Models/AnswerOptions.dart';
import 'package:mira_mira/Models/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Helper/helper.dart';

class WebService {
  Future GetProfileData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.get(
        Uri.parse(
            apiUrl + "loadUserProfile?userId=" + prefs.getString('userID')),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetSprints() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.get(
        Uri.parse(
            apiUrl + "getUserSprints?userId=" + prefs.getString('userID')),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetQuizBySprintsId(String _id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {"_id": _id, "userId": prefs.getString('userID')};

      var body = json.encode(data);

      final response =
      await http.post(Uri.parse(apiUrl + "getQuizsBySprintId"), body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future GetQuestionsByQuizId(String _id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {"_id": _id, "userId": prefs.getString('userID')};

      var body = json.encode(data);

      final response = await http
          .post(Uri.parse(apiUrl + "getQuestionsByQuizId"), body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future updateQuestion(
      String quizId,
      String questionId,
      String questionStatus,
      bool isFirstQuestion,
      List<AnswerOptions> answerOptions,
      int numberOfMoves) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final PaymentList paymentList =
      PaymentList(List<Payment>.generate(answerOptions.length, (int index) {
        return Payment(
            optionId: answerOptions[index].optionId,
            optionVal: answerOptions[index].optionVal,
            optionGrade: answerOptions[index].optionGrade);
      }));
      final String requestBody = json.encoder.convert(paymentList);

      Map data = {
        "quizId": quizId,
        "questionId": questionId,
        "userId": prefs.getString('userID'),
        "questionStatus": questionStatus,
        "isFirstQuestion": isFirstQuestion
      };

      data.addAll(paymentList.toJson());

      data["numberOfMoves"] = numberOfMoves;

      var body = json.encode(data);

      final response =
      await http.post(Uri.parse(apiUrl + "updateQuestion"), body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future updateQuiz(String quizId, String quizStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "quizId": quizId,
        "userId": prefs.getString('userID'),
        "quizStatus": quizStatus
      };

      var body = json.encode(data);

      final response =
      await http.post(Uri.parse(apiUrl + "updateQuiz"), body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future updateSprint(String sprintId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map data = {
        "sprintId": sprintId,
        "userId": prefs.getString('userID'),
        "sprintStatus": "COMPLETED"
      };

      var body = json.encode(data);

      final response =
      await http.post(Uri.parse(apiUrl + "updateSprint"), body: body);

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }
  }

  Future getInstitues(String courseId) async {

    try {
      final response = await http.get(
        Uri.parse(apiUrl + "getDetailsAndInstitutionListOfCourse?courseId=" + courseId),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        return "error";
      }
    } catch (Exception) {
      print("exception" + Exception.toString());
    }

  }
}