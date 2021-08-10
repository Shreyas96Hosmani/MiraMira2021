import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mira_mira/Helper/helper.dart';
import 'package:mira_mira/Models/QuestionsListParser.dart';
import 'package:mira_mira/Models/QuizListParser.dart';
import 'package:mira_mira/Models/SprintListParser.dart';
import 'package:mira_mira/Models/InstituesListParser.dart';
import 'package:mira_mira/Models/AnswerOptions.dart';
import 'package:mira_mira/Models/userDetails.dart';
import 'package:mira_mira/services/web_service.dart';

class CustomViewModel extends ChangeNotifier {
  bool isIntituesLoaded = false;
  bool isFilterPressed = false;

  UserDetails userDetails;
  List<SprintListParser> sprintList = [];
  List<QuizListParser> quizList = [];
  List<InstituesListParser> instituesList = [];
  List<InstituesListParser> filteredInstituesList = [];
  List<List<QuizListParser>> ListOfQuizList = [];
  int attendingSprintIndex = 0;
  int tempattendingSprintIndex = 0;
  List<QuestionsListParser> questionsList = [];

  //if user cmplete atleast 1 question quizStatus=COMPLETED else SKIPPED
  String quizStatus = "SKIPPED";

  Future GetProfileData() async {
    final response = await WebService().GetProfileData();

    print("******");
    print(response.body);
    if (response != "error") {
      print("GetProfileData");
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      userDetails = new UserDetails(
          responseDecoded['userDetails']['name'],
          responseDecoded['userDetails']['userId'],
          responseDecoded['userDetails']['email'],
          responseDecoded['userDetails']['location'],
          responseDecoded['userDetails']['deviceType'],
          responseDecoded['userDetails']['deviceId'],
          responseDecoded['userDetails']['dateOfBirth'],
          responseDecoded['userDetails']['gender'],
          responseDecoded['userDetails']['age'],
          responseDecoded['userDetails']['userPhoto'],
          responseDecoded['userDetails']['lvScore'],
          responseDecoded['userDetails']['county'],
          responseDecoded['userDetails']['state'],
          responseDecoded['userDetails']['school'],
          responseDecoded['userDetails']['schoolGrade'],
          responseDecoded['userDetails']['_id'],
          responseDecoded['userDetails']['loginTime'],
          responseDecoded['userDetails']['visits'],
          responseDecoded['countOfResults'],
          responseDecoded['numberOfCompletedSprints']);

      notifyListeners();
      return "success";
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetSprints() async {
    final response = await WebService().GetSprints();

    if (response != "error") {
      this.sprintList.clear();
      this.ListOfQuizList.clear();
      this.attendingSprintIndex = 0;
      this.tempattendingSprintIndex = 0;

      var responseDecoded = jsonDecode(response.body);

      print(responseDecoded);
      final data = responseDecoded;

      int x = 0;
      bool flag = false;
      for (Map i in data) {
        sprintList.add(SprintListParser.fromJson(i));
        ListOfQuizList.add([]);
        if (flag == false &&
            (SprintListParser.fromJson(i).sprintStatus == "NOTSTARTED" ||
                SprintListParser.fromJson(i).sprintStatus == "INPROGRESS")) {
          attendingSprintIndex = x;
          tempattendingSprintIndex = x;
          flag = true;
        }
        x++;
      }
      GetQuizBySprintsId(
          sprintList[attendingSprintIndex].id, attendingSprintIndex);

      notifyListeners();
      return "success";
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future GetQuizBySprintsId(String _id, int index) async {
    final response = await WebService().GetQuizBySprintsId(_id);

    if (response != "error") {
      this.quizList.clear();
      var responseDecoded = jsonDecode(response.body);

      print(responseDecoded);
      final data = responseDecoded;

      for (Map i in data) {
        await quizList.add(QuizListParser.fromJson(i));
      }

      ListOfQuizList[index] = quizList;

      notifyListeners();
      return "success";
    } else {
      print("***erroraaaaaaaaaaaa");
      notifyListeners();
      return "error";
    }
  }

  Future GetQuestionsByQuizId(String _id) async {
    final response = await WebService().GetQuestionsByQuizId(_id);

    if (response != "error") {
      this.questionsList.clear();
      this.quizStatus = "SKIPPED";
      var responseDecoded = jsonDecode(utf8.decode(response.bodyBytes));

      logLongString("responseDecoded");
      logLongString(responseDecoded.toString());
      final data = responseDecoded;

      for (Map i in data) {
        if (QuestionsListParser.fromJson(i).questionStatus != "COMPLETED" &&
            QuestionsListParser.fromJson(i).questionStatus != "SKIPPED") {
          questionsList.add(QuestionsListParser.fromJson(i));
        } else {
          if (QuestionsListParser.fromJson(i).questionStatus == "COMPLETED") {
            this.quizStatus = "COMPLETED";
          }
        }
      }

      notifyListeners();
      return "success";
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future updateQuestion(
      String quizId,
      String questionId,
      String questionStatus,
      bool isFirstQuestion,
      List<AnswerOptions> answerOptions,
      int numberOfMoves) async {
    final response = await WebService().updateQuestion(quizId, questionId,
        questionStatus, isFirstQuestion, answerOptions, numberOfMoves);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);
      if (responseDecoded["status"] == "SUCCESS") {
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future updateQuiz(String quizId) async {
    final response = await WebService().updateQuiz(quizId, quizStatus);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);

      print(responseDecoded);

      if (responseDecoded["status"] == "SUCCESS") {
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future updateSprint(String sprintId) async {
    final response = await WebService().updateSprint(sprintId);

    if (response != "error") {
      var responseDecoded = jsonDecode(response.body);

      print(responseDecoded);

      if (responseDecoded["status"] == "SUCCESS") {
        notifyListeners();
        return "success";
      } else {
        notifyListeners();
        return "error";
      }
    } else {
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future getInstitues(String courseId) async {
    isIntituesLoaded = false;
    final response = await WebService().getInstitues(courseId);

    if (response != "error") {
      this.instituesList.clear();
      this.filteredInstituesList.clear();
      var responseDecoded = jsonDecode(response.body);

      if (responseDecoded["status"] == "SUCCESS") {
        final data = responseDecoded['institutions'];

        for (Map i in data) {
          await instituesList.add(InstituesListParser.fromJson(i));
          await filteredInstituesList.add(InstituesListParser.fromJson(i));
        }

        isIntituesLoaded = true;
        notifyListeners();
        return "success";
      } else {
        isIntituesLoaded = true;
        notifyListeners();
        return "error";
      }
    } else {
      isIntituesLoaded = true;
      print("***error");
      notifyListeners();
      return "error";
    }
  }

  Future resetInstitues() async {
    isIntituesLoaded = false;

    for (int i = 0; i < instituesList.length; i++) {
      filteredInstituesList.add(instituesList[i]);
    }
    isFilterPressed = false;
    isIntituesLoaded = true;
    notifyListeners();
  }

  Future applyFiltersInstitues(String state, String stateFeeMin,
      String stateFeeMax, String satScoreMin, String satScoreMax) async {


    isIntituesLoaded = false;

    this.filteredInstituesList.clear();

    for (int i = 0; i < instituesList.length; i++) {

      if(state=="" || state==null){
        if (((double.parse(stateFeeMin) <=
                double.parse(instituesList[i].stateFee.numberInt) &&
                double.parse(instituesList[i].stateFee.numberInt) <=
                    double.parse(stateFeeMax))  && (double.parse(satScoreMin) <
                double.parse(instituesList[i].satScore.numberInt) &&
                double.parse(instituesList[i].satScoreMax.numberInt)<double.parse(satScoreMax)))) {

          filteredInstituesList.add(instituesList[i]);

        }
      }else{
        if (instituesList[i].state == state &&
            ((double.parse(stateFeeMin) <=
                double.parse(instituesList[i].stateFee.numberInt) &&
                double.parse(instituesList[i].stateFee.numberInt) <=
                    double.parse(stateFeeMax))  && (double.parse(satScoreMin) <
                double.parse(instituesList[i].satScore.numberInt) &&
                double.parse(instituesList[i].satScoreMax.numberInt)<double.parse(satScoreMax)))) {

          filteredInstituesList.add(instituesList[i]);

        }
      }





    }
    isFilterPressed = false;
    isIntituesLoaded = true;
    notifyListeners();
  }
}