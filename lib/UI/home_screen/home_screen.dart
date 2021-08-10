import 'dart:io';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/helper.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:mira_mira/UI/CourseDetailedScreen/CourseDetailScreen.dart';
import 'package:mira_mira/UI/MessageCenter/messageCenter.dart';
import 'package:mira_mira/UI/QuizScreen/QuestionsPageViewer.dart';
import 'package:mira_mira/UI/Settings/settingsScreen.dart';
import 'package:mira_mira/UI/SignUp/LoginSignupScreen.dart';
import 'package:mira_mira/UI/Tabs/CourseListScreen.dart';
import 'package:mira_mira/UI/Tabs/Results/ResultsListScreen.dart';
import 'package:mira_mira/UI/Wishlist/wishListMainScreen.dart';
import 'package:mira_mira/UI/home_screen/components/bottom_tabs.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mira_mira/View%20Models/CustomViewModel.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'package:mira_mira/UI/Tabs/Results/resultDetails.dart';
import 'package:mira_mira/UI/UserProfileScreen/EditProfileScreen.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

bool viewResultsPressed = false;
bool viewCoursesPressed = false;

var completedSprints;
var userName;
var lvScore;

//Course Details
var courseIds;
var courseNames;
var courseNoOfInstitutions;
var courseDescription;
var courseLocation;
var courseHighlightText;
var courseFullDescription;
var courseStateList;

var courseIsKept;

//Result Details
var resultIds;
var resultDateTimes;
var resultHighlights;

var spiritResults;
var spiritQuadScore;
var spiritQuadDisplay;
var spiritBlurb;

var purposeResults;
var purposeQuadScore;
var purposeQuadDisplay;
var purposeBlurb;

var professionResults;
var professionQuadScore;
var professionQuadDisplay;
var professionBlurb;

var rewardResults;
var rewardQuadScore;
var rewardQuadDisplay;
var rewardBlurb;

var resultHeadPara;

//Sprint Details
var sprintNames;
var sprintIds;
var sprintStatus;
List<bool> sprintBools;

//WishList Details
var courseIdsW;
var courseNamesW;
var courseNoOfInstitutionsW;
var courseDescriptionW;
var courseDegreesW;

var instituteIdsW;
var instituteNamesW;
var instituteNoOfInstitutionsW;
var instituteDescriptionW;
var instituteDegreesW;
var instituteCityStateRateW;
var instituteCity;
var instituteState;
var instituteRate;
var instituteSatScore;
var instituteFullDescription;
var instituteRequestForInfoLink;
var instituteGetInTouchLink;
var countOfInstitutesInBrackets;

var courseCount;
var instituteCount;

bool showAnimation = true;

bool removeTakeQuizScreen = false;
bool removeMoreScreen = false;
int _selectedTab = 0;
var userType;

var resultPosition = "1";
var spIdForQuizStatus;
var quiz1Status;

PageController _tabPageController;
bool showLoading = false;

var myIdForCounsellors;
var counsellorId;
var counsellorName;
var counsellorEmail;
var counsellorStatus;

var guardianId;
var guardianName;
var guardianEmail;
var guardianStatus;

TextEditingController ccNameController = TextEditingController();
TextEditingController ccEmailController = TextEditingController();

TextEditingController ccGuardianNameController = TextEditingController();
TextEditingController ccGuardianEmailController = TextEditingController();

var base64photo;

class HomePage extends StatefulWidget {

  final String location;

  HomePage({this.location});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List _imageFile;

  Future<String> getCourses2(context) async {

    var tmp = resultIds[0].toString();

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getCourseList?resultId=$tmp";

    http.get(Uri.parse(url)).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseGetCourses = jsonDecode(response.body);
      print("responseGetCourses"+responseGetCourses.toString());

      setState(() {
        courseIds = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['courseId'].toString());
        courseNames = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['courseName'].toString());
        courseDescription = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['headlineTraits'].toString());

        courseHighlightText = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['headline'].toString());
        courseFullDescription = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['appTextNextPage'].toString()+responseGetCourses['courses'][index]['appTextScanner'].toString()+responseGetCourses['courses'][index]['appTextReader'].toString());

        courseNoOfInstitutions = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['countOfInstitute'].toString());

        courseIsKept = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['isKeep'].toString());
      });

      print(courseIds.toList());
      print(courseNames.toList());
      print(courseDescription.toList());
      print(courseHighlightText.toList());
      print(courseFullDescription.toList());
      print(courseNoOfInstitutions.toList());
      print(courseIsKept.toList());

    });
  }

  Future<String> loadUserProfile(context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    isSignedIn = prefs.getString("userID").toString();

    print("isSignedIn : "+isSignedIn);

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/loadUserProfile?userId=$isSignedIn";

    http.get(Uri.parse(url)).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseLoadUserProfile = jsonDecode(response.body);
      print(responseLoadUserProfile);

      var msg = responseLoadUserProfile['status'].toString();
      if(msg == "SUCCESS"){
        setState(() {
          completedSprints = responseLoadUserProfile['numberOfCompletedSprints'].toString();
          userName = responseLoadUserProfile['userDetails']['name'].toString();
          lvScore = responseLoadUserProfile['userDetails']['lvScore'].toString() == "null" || responseLoadUserProfile['userDetails']['lvScore'].toString() == "" ? "0" : responseLoadUserProfile['userDetails']['lvScore'].toString();
          grade = responseLoadUserProfile['userDetails']['schoolGrade'].toString() == "" ? "" : responseLoadUserProfile['userDetails']['schoolGrade'].toString();
          schoolOrProfession = responseLoadUserProfile['userDetails']['schoolGrade'].toString() == "" ? "" : responseLoadUserProfile['userDetails']['school'].toString();
          state = responseLoadUserProfile['userDetails']['state'].toString() == "" ? "" : responseLoadUserProfile['userDetails']['state'].toString();
          county = responseLoadUserProfile['userDetails']['county'].toString() == "" ? "" : responseLoadUserProfile['userDetails']['county'].toString();
          isMentor = responseLoadUserProfile['userDetails']['isMentor'].toString();
          myId = responseLoadUserProfile['userDetails']['_id'].toString();
          if(responseLoadUserProfile['userDetails']['userPhoto'].toString() == photo.toString()){

          }else{
            photo = responseLoadUserProfile['userDetails']['userPhoto'].toString() == "" ? null : responseLoadUserProfile['userDetails']['userPhoto'].toString();
          }
          visited = responseLoadUserProfile['userDetails']['visits'].toString();
          userType = responseLoadUserProfile['userDetails']['userType'].toString();
        });
        print(completedSprints.toString());
        print(userName.toString());
        print(lvScore.toString());
        print(grade.toString());
        print(schoolOrProfession.toString());
        print(state.toString());
        print(county.toString());
        print(isMentor.toString());
        print(myId.toString());
        print(photo.toString());
        print(visited.toString());
        print("userType : "+userType.toString());

        if(photo == null){

        }else{
          setState(() {
            base64photo = base64Decode(photo);
          });
        }

        getSprints(context);
        getWishList(context);

      }

    });
  }
  Future<String> loadUserProfile2(context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    isSignedIn = prefs.getString("userID").toString();

    print(isSignedIn);

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getLVScore?userId=$isSignedIn";

    http.get(Uri.parse(url)).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseLoadUserProfile = jsonDecode(response.body);
      print(responseLoadUserProfile);

      var msg = responseLoadUserProfile['status'].toString();
      if(msg == "SUCCESS"){
        setState(() {
          completedSprints = responseLoadUserProfile['numberOfCompletedSprints'].toString();
          lvScore = responseLoadUserProfile['lvScore'].toString() == "null" || responseLoadUserProfile['lvScore'].toString() == "" ? "0" : responseLoadUserProfile['lvScore'].toString();
        });
        print(completedSprints.toString());
        print(lvScore.toString());
      }

    });
  }

  Future<String> getResults(context) async {

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getSprintResult";
    var body = jsonEncode({

      "userId" : isSignedIn.toString(),
    });

    http.post(Uri.parse(url), body: body).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseGetResults = jsonDecode(utf8.decode(response.bodyBytes));
      print("responseGetResults"+responseGetResults.toString());

      if(responseGetResults == [] || responseGetResults.isEmpty){
        print("empty");
        setState(() {
          resultIds = null;
        });
      }else{
          setState(() {
            resultIds = List.generate(responseGetResults.length, (index) => responseGetResults[index]['_id'].toString());
            resultDateTimes = List.generate(responseGetResults.length, (index) => responseGetResults[index]['resultDateTime'].toString());
            resultHighlights = List.generate(responseGetResults.length, (index) => responseGetResults[index]['resultHeadPara'].toString());

            spiritQuadScore = List.generate(responseGetResults.length, (index) => responseGetResults[index]['spiritResult']['quadscore'].toString());
            spiritQuadDisplay = List.generate(responseGetResults.length, (index) => responseGetResults[index]['spiritResult']['quadDisplay'].toString());
            spiritBlurb = List.generate(responseGetResults.length, (index) => responseGetResults[index]['spiritResult']['blurb'].toString());

            purposeQuadScore = List.generate(responseGetResults.length, (index) => responseGetResults[index]['purposeResult']['quadscore'].toString());
            purposeQuadDisplay = List.generate(responseGetResults.length, (index) => responseGetResults[index]['purposeResult']['quadDisplay'].toString());
            purposeBlurb = List.generate(responseGetResults.length, (index) => responseGetResults[index]['purposeResult']['blurb'].toString());

            professionQuadScore = List.generate(responseGetResults.length, (index) => responseGetResults[index]['professionResult']['quadscore'].toString());
            professionQuadDisplay = List.generate(responseGetResults.length, (index) => responseGetResults[index]['professionResult']['quadDisplay'].toString());
            professionBlurb = List.generate(responseGetResults.length, (index) => responseGetResults[index]['professionResult']['blurb'].toString());

            rewardQuadScore = List.generate(responseGetResults.length, (index) => responseGetResults[index]['rewardsResult']['quadscore'].toString());
            rewardQuadDisplay = List.generate(responseGetResults.length, (index) => responseGetResults[index]['rewardsResult']['quadDisplay'].toString());
            rewardBlurb = List.generate(responseGetResults.length, (index) => responseGetResults[index]['rewardsResult']['blurb'].toString());
          });

          print(resultIds.toList());
          print(resultDateTimes.toList());
          print(resultHighlights.toList());

          print(spiritQuadScore.toList());
          print(spiritQuadDisplay.toList());
          print(spiritBlurb.toList());

          print(purposeQuadScore.toList());
          print(purposeQuadDisplay.toList());
          print(purposeBlurb.toList());

          print(professionQuadScore.toList());
          print(professionQuadDisplay.toList());
          print(professionBlurb.toList());

          print(rewardQuadScore.toList());
          print(rewardQuadDisplay.toList());
          print(rewardBlurb.toList());

          getCourses2(context);

        }

    });
  }

  Future<String> getCourses(context) async {

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getCourseList?userId=$isSignedIn";

    http.get(Uri.parse(url)).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseGetCourses = jsonDecode(utf8.decode(response.bodyBytes));
      print("responseGetCourses"+responseGetCourses.toString());

      var msg = responseGetCourses['status'].toString();
      if(msg == "SUCCESS"){
        setState(() {
          courseIds = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['courseId'].toString());
          courseNames = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['courseName'].toString());
          courseDescription = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['headlineTraits'].toString());

          courseHighlightText = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['headline'].toString());
          courseFullDescription = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['appTextNextPage'].toString()+responseGetCourses['courses'][index]['appTextScanner'].toString()+responseGetCourses['courses'][index]['appTextReader'].toString());

          courseNoOfInstitutions = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['countOfInstitute'].toString());

          courseIsKept = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['isKeep'].toString());

          //courseStateList = List.generate(responseGetCourses['courses']['stateList'].length, (index) => responseGetCourses['courses'][index]['stateList'][index].toString());
        });

        print(courseIds.toList());
        print(courseNames.toList());
        print(courseDescription.toList());
        print(courseHighlightText.toList());
        print(courseFullDescription.toList());
        print(courseNoOfInstitutions.toList());
        print(courseIsKept.toList());
        //print(courseStateList.toList());
      }else{
        setState(() {
          courseIds = null;
        });
      }

    });
  }

  Future<String> getQuizStatusBySprintId(context) async {

    setState(() {
      spIdForQuizStatus = sprintIds[0].toString();
      print("spIdForQuizStatus : "+spIdForQuizStatus);
    });

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getQuizsBySprintId";

    var body = jsonEncode({
      "_id" : spIdForQuizStatus.toString(),
      "userId" : isSignedIn.toString(),
    });

    http.post(Uri.parse(url), body: body).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var getQuizStatusBySprintId = jsonDecode(response.body);
      print(getQuizStatusBySprintId);

      setState(() {
        quiz1Status = getQuizStatusBySprintId[0]['completedQuestionCount'].toString();
      });

      print("quiz1Status : " + quiz1Status);

    });
  }

  Future<String> getSprints(context) async {

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getUserSprints?userId=$isSignedIn";

    http.get(Uri.parse(url)).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseGetSprints = jsonDecode(response.body);
      print(responseGetSprints);

      setState(() {
        sprintIds = List.generate(responseGetSprints.length, (index) => responseGetSprints[index]['_id'].toString());
        sprintNames = List.generate(responseGetSprints.length, (index) => responseGetSprints[index]['sprintName'].toString());
        sprintStatus = List.generate(responseGetSprints.length, (index) => responseGetSprints[index]['sprintStatus'].toString());
        sprintBools = List.generate(sprintNames.length, (index) => false);
      });

      print(sprintIds.toList());
      print(sprintNames.toList());
      print(sprintStatus.toList());


      getQuizStatusBySprintId(context);

    });
  }

  Future<String> getWishList(context) async {

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getWishList?userId=$isSignedIn";//isSignedIn

    http.get(Uri.parse(url),).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseGetWishList = jsonDecode(utf8.decode(response.bodyBytes));
      print("responseGetWishList"+responseGetWishList.toString());

      if(responseGetWishList == []){
        print("empty");
        setState(() {
          resultIds = null;
        });
      }else{
        var msg = responseGetWishList['status'].toString();
        if(msg == "SUCCESS"){
          setState(() {
            courseIdsW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['courseId'].toString());
            //courseNamesW = List.generate(responseGetWishList['courses'].length, (index) => responseGetWishList['courses'][index]['courseName'].toString());
            courseDescriptionW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['courseName'].toString());
            //courseDegreesW = List.generate(responseGetWishList['courses'].length, (index) => responseGetWishList['courses'][index]['headlineTraits'].toString());

            instituteIdsW = [];//List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['id'].toString());
//            instituteNamesW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['universityName'].toString());
//            instituteDescriptionW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['courseDescription'].toString());
//            instituteDegreesW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['degreeDescription'].toString());
//            instituteCityStateRateW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['city'].toString()+" | "+responseGetWishList['wishList'][index]['institutes'][0]['state'].toString()+" | \$"+responseGetWishList['wishList'][index]['institutes'][0]['stateFee']['\$numberInt'].toString());
//            instituteCity= List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['city'].toString());
//            instituteState = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['state'].toString());
//            instituteRate = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['stateFee']['\$numberInt'].toString());
//            instituteSatScore = List.generate(responseGetWishList['wishList'].length, (index) => "1354");//responseGetWishList['wishList'][index]['institutes'][0]['satScore']['\$numberInt'].toString());
//            //instituteFullDescription = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['institutes'][index]['id'].toString());
//            instituteRequestForInfoLink = List.generate(responseGetWishList['wishList'].length, (index) => "null");
//            instituteGetInTouchLink = List.generate(responseGetWishList['wishList'].length, (index) => "null");

            countOfInstitutesInBrackets = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['countOfInstitutes'].toString());

            courseCount = responseGetWishList['grandCountOfCourses'].toString();
            instituteCount = responseGetWishList['grandCountOfInstitutes'].toString();
          });

          print(courseIdsW.toList());
          print(courseDescriptionW.toList());

          print(instituteIdsW.toList());

          print(courseCount.toString());
          print(instituteCount.toString());

          print("###########");
          print(countOfInstitutesInBrackets.toString());
          print("###########");
        }else{
          setState(() {
            courseIdsW = null;
          });
        }
      }

    });
  }

  Future InitTask() async {
    Provider.of<CustomViewModel>(context, listen: false)
        .GetProfileData()
        .then((value) {
      Provider.of<CustomViewModel>(context, listen: false)
          .GetSprints()
          .then((value) => {
      });
    });
  }

  Future<String> getCounsellors(context) async {

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getCounsellor?userId="+isSignedIn.toString();

    http.get(Uri.parse(url)).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responsegetCounsellors = jsonDecode(response.body);
      print(responsegetCounsellors);

      var msg = responsegetCounsellors['status'].toString();
      if(msg == "SUCCESS" && responsegetCounsellors['counsellor'] != []){
        setState(() {
          myIdForCounsellors = responsegetCounsellors['_id'].toString();
          counsellorId = List.generate(responsegetCounsellors['counsellor'].length, (index) => responsegetCounsellors['counsellor'][index]['_id'].toString());
          counsellorName = List.generate(responsegetCounsellors['counsellor'].length, (index) => responsegetCounsellors['counsellor'][index]['name'].toString());
          counsellorEmail = List.generate(responsegetCounsellors['counsellor'].length, (index) => responsegetCounsellors['counsellor'][index]['email'].toString());
          counsellorStatus = List.generate(responsegetCounsellors['counsellor'].length, (index) => responsegetCounsellors['counsellor'][index]['status'].toString());
        });
        print("myIdForCounsellors : "+myIdForCounsellors);
        print(counsellorId.toList());
        print(counsellorName.toList());
        print(counsellorEmail.toList());
        print(counsellorStatus.toList());
      }else{
        Fluttertoast.showToast(msg: "",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){

        });
      }

    });
  }

  Future<String> addCounsellor(context) async {

    setState(() {
      showLoading = true;
    });

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/addCounsellor";
    var body = jsonEncode({
      "_id": myIdForCounsellors.toString(),
      "counsellor": {
        "name": ccNameController.text.toString(),
        "email": ccEmailController.text.toString(),
        "photo": ""
      }
    });

    http.post(Uri.parse(url), body: body).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responsegetCounsellors = jsonDecode(response.body);
      print(responsegetCounsellors);

      var msg = responsegetCounsellors['status'].toString();
      if(msg == "SUCCESS"){
        //prAdd.hide();
        ccNameController.clear();
        ccEmailController.clear();
        Fluttertoast.showToast(msg: "Counselor added",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){
          getCounsellors(context);
        });
        setState(() {
          showLoading = false;
          counsellorId = List.generate(responsegetCounsellors['counsellor'].length, (index) => responsegetCounsellors['counsellor'][index]['_id'].toString());
          counsellorName = List.generate(responsegetCounsellors['counsellor'].length, (index) => responsegetCounsellors['counsellor'][index]['name'].toString());
          counsellorEmail = List.generate(responsegetCounsellors['counsellor'].length, (index) => responsegetCounsellors['counsellor'][index]['email'].toString());
          counsellorStatus = List.generate(responsegetCounsellors['counsellor'].length, (index) => responsegetCounsellors['counsellor'][index]['status'].toString());
        });
      }else{
        //prAdd.hide();
        Fluttertoast.showToast(msg: "Please check your network connection",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){

        });
        setState(() {
          showLoading = false;
        });
      }

    });
  }

  Future<String> getGuardians(context) async {

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getGuardians?userId="+isSignedIn.toString();

    http.get(Uri.parse(url)).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responsegetCounsellors = jsonDecode(response.body);
      print(responsegetCounsellors);

      var msg = responsegetCounsellors['status'].toString();
      if(msg == "SUCCESS" && responsegetCounsellors['guardian'] != []){
        setState(() {
          myIdForCounsellors = responsegetCounsellors['_id'].toString();
          guardianId = List.generate(responsegetCounsellors['guardian'].length, (index) => responsegetCounsellors['guardian'][index]['_id'].toString());
          guardianName = List.generate(responsegetCounsellors['guardian'].length, (index) => responsegetCounsellors['guardian'][index]['name'].toString());
          guardianEmail = List.generate(responsegetCounsellors['guardian'].length, (index) => responsegetCounsellors['guardian'][index]['email'].toString());
          guardianStatus = List.generate(responsegetCounsellors['guardian'].length, (index) => responsegetCounsellors['guardian'][index]['status'].toString());
        });
        print("myIdForCounsellors : "+myIdForCounsellors);
        print(guardianId.toList());
        print(guardianName.toList());
        print(guardianEmail.toList());
        print(guardianStatus.toList());
      }else{
        Fluttertoast.showToast(msg: "",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){

        });
      }

    });
  }

  Future<String> addGuardians(context) async {

    setState(() {
      showLoading = true;
    });

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/addGuardian";
    var body = jsonEncode({
      "_id": myIdForCounsellors.toString(),
      "guardian": {
        "name": ccGuardianNameController.text.toString(),
        "email": ccGuardianEmailController.text.toString(),
        "photo": ""
      }
    });

    http.post(Uri.parse(url), body: body).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responsegetCounsellors = jsonDecode(response.body);
      print(responsegetCounsellors);

      var msg = responsegetCounsellors['status'].toString();
      if(msg == "SUCCESS"){
        //prAdd.hide();
        ccGuardianNameController.clear();
        ccGuardianEmailController.clear();
        Fluttertoast.showToast(msg: "Guardian added",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){
          getGuardians(context);
        });
        setState(() {
          showLoading = false;
          guardianId = List.generate(responsegetCounsellors['guardian'].length, (index) => responsegetCounsellors['guardian'][index]['_id'].toString());
          guardianName = List.generate(responsegetCounsellors['guardian'].length, (index) => responsegetCounsellors['guardian'][index]['name'].toString());
          guardianEmail = List.generate(responsegetCounsellors['guardian'].length, (index) => responsegetCounsellors['guardian'][index]['email'].toString());
          guardianStatus = List.generate(responsegetCounsellors['guardian'].length, (index) => responsegetCounsellors['guardian'][index]['status'].toString());
        });
      }else{
        //prAdd.hide();
        Fluttertoast.showToast(msg: "",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){

        });
        setState(() {
          showLoading = false;
        });
      }

    });
  }

  @override
  void initState() {
    super.initState();
    _tabPageController = PageController();
    loadUserProfile(context);
    InitTask();
    setState(() {
      showLoading = false;
      quiz1Status = null;
      showAnimation = true;
      resultPosition = "1";
      removeTakeQuizScreen = false;
      removeMoreScreen = false;
    });
    getResults(context);
    instituteCount = "0"; courseCount = "0";

  }

  @override
  void dispose() {
    _tabPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);
    print(widget.location);
    if(viewResultsPressed == true){
      print("viewResultsPressed : "+viewResultsPressed.toString());
      _tabPageController.animateToPage(1,
          duration: Duration(milliseconds: 460), curve: Curves.easeOutCubic).whenComplete((){
            setState(() {
              viewResultsPressed = false;
            });
      });
    }else{
      print("viewResultsPressed : "+viewResultsPressed.toString());
    }
    if(viewCoursesPressed == true){
      print("viewCoursesPressed : "+viewCoursesPressed.toString());
      _tabPageController.animateToPage(2,
          duration: Duration(milliseconds: 460), curve: Curves.easeOutCubic).whenComplete((){
        setState(() {
          viewCoursesPressed = false;
        });
      });
    }else{
      print("viewCoursesPressed : "+viewCoursesPressed.toString());
    }
    Future.delayed(Duration(seconds: 3),(){
      loadUserProfile2(context);
    });
    return Scaffold(
        bottomNavigationBar: Bottomtabs(
          selectedTab: _selectedTab,
          tabPressed: (num) {
            _tabPageController.animateToPage(num,
                duration: Duration(milliseconds: 460), curve: Curves.easeOutCubic);
          },
        ),
        body: quiz1Status == null ? Center(
          child: new CircularProgressIndicator(
            strokeWidth: 1,
            backgroundColor: Color(COLOR_WHITE),
            valueColor:
            AlwaysStoppedAnimation<Color>(Color(COLOR_PRIMARY)),
          ),
        ) : WillPopScope(
          onWillPop: ()=> showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to exit the App'),
              actions: <Widget>[
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("No"),
                  ),
                ),
                SizedBox(height: 16),
                new GestureDetector(
                  onTap: () => exit(0),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("Yes"),
                  ),
                ),
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _tabPageController,
                  onPageChanged: (num) {
                    setState(() {
                      _selectedTab = num;
                    });
                    print(_selectedTab);
                    if(_selectedTab == 1){
                      getResults(context);
                    }else if(_selectedTab == 2){
                      getCourses(context);
                    }else if(_selectedTab == 3){
                      getWishList(context);
                    }else if(_selectedTab == 4){
                      getGuardians(context);
                      getCounsellors(context);
                      loadUserProfile(context);
                      getResults(context);
                    }
                  },
                  children: [
                    removeTakeQuizScreen == true //|| quiz1Status == "5"
                        ? QuizListScreen()
                        : FirstHomeScreen2(context),
                    resultsListScreen(context),
                    CourseListScreen(),
                    WishListMainScreen(),
                    removeMoreScreen == true ? SafeArea(
                      child: Scaffold(
                        body: WillPopScope(
                          onWillPop: ()=> back(),
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: getProportionateScreenHeight(96),
                                color: Color(COLOR_ACCENT),
                              ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.all(getProportionateScreenWidth(10)),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFFDAE7FF), width: 2),
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.white,
                                ),
                                height: getProportionateScreenHeight(910),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Screenshot(
                                        controller: screenshotController,
                                        child: Container(
                                          height: getProportionateScreenHeight(600),
                                          padding: EdgeInsets.all(
                                            getProportionateScreenWidth(22),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: Colors.white),
                                              color: Color(COLOR_ACCENT)),
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        back();
                                                        //Navigator.pop(context);
                                                      },
                                                      child: Icon(
                                                        Icons.arrow_back_ios_rounded,
                                                        size: getProportionateScreenWidth(25),
                                                        color: Colors.white,
                                                      )),
                                                  SizedBox(
                                                    width: getProportionateScreenWidth(12),
                                                  ),
                                                  Text(
                                                    "My Profile",
                                                    textScaleFactor: 1,
                                                    style: GoogleFonts.firaSans(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 18),
                                                  ),
                                                  Spacer(),
                                                  GestureDetector(
                                                      onTap: () {
                                                        back();
                                                      },
                                                      child: Icon(
                                                        Icons.close,
                                                        size: getProportionateScreenWidth(30),
                                                        color: Colors.white,
                                                      )),
                                                ],
                                              ),
                                              Spacer(),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: (){
                                                      Navigator.push(
                                                          context,
                                                          PageRouteBuilder(
                                                            pageBuilder: (c, a1, a2) => EditProfileScreen(myId, userName, isSignedIn, grade, schoolOrProfession, state, county, photo),
                                                            transitionsBuilder: (c, anim, a2, child) =>
                                                                FadeTransition(opacity: anim, child: child),
                                                            transitionDuration: Duration(milliseconds: 300),
                                                          )).whenComplete((){
                                                        loadUserProfile(context);
                                                      });
                                                    },
                                                    child: SvgPicture.asset(
                                                      "assets/iconSVG/editProfIcon.svg",
                                                      height: getProportionateScreenWidth(21),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: getProportionateScreenWidth(26),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List image) async {
                                                        if (image != null) {
                                                          final directory = await getApplicationDocumentsDirectory();
                                                          print(directory);

                                                          if(Platform.isIOS){
                                                            print("Platform : iOS");
                                                            final imagePath = await File('${directory.path}/image.png').create();
                                                            print(imagePath);

                                                            await imagePath.writeAsBytes(image);

                                                            /// Share Plugin
                                                            await Share.shareFiles([imagePath.path],text: 'Here\'s my Result on MiraMira!\nLV Score : $lvScore/10\nCompleted sprints : $completedSprints\nhttps://miramira.app');
                                                          }else{
                                                            print("Platform : Android");
                                                            final imagePath = await File('${directory.path}/image.png').create();
                                                            print(imagePath);

                                                            await imagePath.writeAsBytes(image);

                                                            /// Share Plugin
                                                            await Share.shareFiles([imagePath.path],text: 'Here\'s my profile card on MiraMira');
                                                          }
                                                        }
                                                      });
                                                    },
                                                    child: SvgPicture.asset(
                                                      "assets/iconSVG/shareOutlineWhite.svg",
                                                      height: getProportionateScreenWidth(21),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(100)),
                                                        boxShadow: [new BoxShadow(
                                                          color: Colors.black,
                                                          blurRadius: 7.0,
                                                        ),]
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.all(Radius.circular(100)),
                                                        color: Colors.white,
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(5.0),
                                                        child: CircleAvatar(
                                                          radius: getProportionateScreenWidth(49),
                                                          backgroundColor: Color(0xffFEC55F),//Color(0xFFDDDDDD),
                                                          backgroundImage: photo == "" || photo == null || photo == "null" ? null : Image.memory(base64photo).image,
                                                          child: Container(
                                                            //color: Color(0xffFEC55F),
                                                            margin: EdgeInsets.all(4),
                                                            child: Container(
                                                              child: photo == "" || photo == null || photo == "null" ? SvgPicture.asset(
                                                                "assets/imageSVG/miramira.svg",
                                                                height: getProportionateScreenHeight(20),
                                                                fit: BoxFit.fitHeight,
                                                              ) : null,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: getProportionateScreenWidth(16),
                                                  ),
                                                  Container(
                                                    //width: getProportionateScreenWidth(126),
                                                    height: getProportionateScreenHeight(82),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          width: getProportionateScreenWidth(126),
                                                          child: Text(
                                                            userName.toString(),textScaleFactor: 1,
                                                            style: GoogleFonts.firaSans(
                                                                fontSize: 22,
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.w500),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: getProportionateScreenWidth(10),
                                                        ),
                                                        Container(
                                                          width: getProportionateScreenWidth(156),
                                                          child: Text(
                                                            isSignedIn.toString(),textScaleFactor: 1,
                                                            style: GoogleFonts.firaSans(
                                                              fontSize: 14,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              Row(
                                                children: [
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        lvScore.toString()+"/10 LV Score | "+completedSprints.toString() +" Sprints",
                                                        style: GoogleFonts.firaSans(
                                                          fontSize: 12,letterSpacing: 0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: getProportionateScreenWidth(180),
                                                        child: ScoreAndProgressBar2(
                                                          lvScore: double.parse(lvScore.toString()),
                                                          numberOfCompletedSprints: int.parse(providerListener.userDetails.numberOfCompletedSprints??"0"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        userType.toString().contains('Student') ? "GRADE" : "JOB",
                                                        textScaleFactor: 1,
                                                        style: GoogleFonts.firaSans(
                                                            color: Colors.white,
                                                            letterSpacing: 2,
                                                            fontSize: 13),
                                                      ),
                                                      Text(
                                                        grade.toString(),textScaleFactor: 1,
                                                        style: GoogleFonts.firaSans(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 16),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Spacer(),
                                              Row(
                                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    width: getProportionateScreenWidth(180),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          userType.toString().contains('Student') ? "SCHOOL" : "FIRM",textScaleFactor: 1,
                                                          style: GoogleFonts.firaSans(
                                                              color: Colors.white,
                                                              letterSpacing: 2,
                                                              fontSize: 13),
                                                        ),
                                                        Text(
                                                          schoolOrProfession.toString(),textScaleFactor: 1,
                                                          style: GoogleFonts.firaSans(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w600,
                                                              fontSize: 16),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "STATE",textScaleFactor: 1,
                                                        style: GoogleFonts.firaSans(
                                                            color: Colors.white,
                                                            letterSpacing: 2,
                                                            fontSize: 13),
                                                      ),
                                                      Text(
                                                        state.toString(),textScaleFactor: 1,
                                                        style: GoogleFonts.firaSans(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 16),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      height: getProportionateScreenHeight(70),
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal:
                                                          getProportionateScreenWidth(18)),
                                                      decoration: BoxDecoration(
                                                          color: Color(COLOR_ACCENT),
                                                          borderRadius: BorderRadius.circular(12),
                                                          border: Border.all(
                                                              color: Colors.white, width: 1.3)),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            "VISITED",textScaleFactor: 1,
                                                            style: GoogleFonts.firaSans(
                                                                color: Colors.white,
                                                                letterSpacing: 2,
                                                                fontSize: 13),
                                                          ),
                                                          Text(
                                                            visited == null ? "0" : visited.toString(),textScaleFactor: 1,
                                                            style: GoogleFonts.firaSans(
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.w600,
                                                                fontSize: 22),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: getProportionateScreenWidth(20),
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: (){
                                                        _tabPageController.animateToPage(1,
                                                            duration: Duration(milliseconds: 460), curve: Curves.easeOutCubic);
                                                      },
                                                      child: Container(
                                                        height: getProportionateScreenHeight(70),
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal:
                                                            getProportionateScreenWidth(18)),
                                                        decoration: BoxDecoration(
                                                            color: Color(COLOR_ACCENT),
                                                            borderRadius: BorderRadius.circular(12),
                                                            border: Border.all(
                                                                color: Colors.white, width: 1.3)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  "RESULTS",textScaleFactor: 1,
                                                                  style: GoogleFonts.firaSans(
                                                                      color: Colors.white,
                                                                      letterSpacing: 2,
                                                                      fontSize: 13),
                                                                ),
                                                                Text(
                                                                  resultIds == null ? "0" : resultIds.toList().length.toString(),
                                                                  textScaleFactor: 1,
                                                                  style: GoogleFonts.firaSans(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.w600,
                                                                      fontSize: 22),
                                                                )
                                                              ],
                                                            ),
                                                            Icon(
                                                              Icons.arrow_forward_ios_rounded,
                                                              color: Colors.white,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Spacer(),
                                              resultIds == null ? Container() : Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: getProportionateScreenWidth(18),
                                                    vertical: getProportionateScreenHeight(13)),
                                                decoration: BoxDecoration(
                                                    color: Color(COLOR_ACCENT),
                                                    borderRadius: BorderRadius.circular(12),
                                                    border: Border.all(
                                                        color: Colors.white, width: 1.3)),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "LAST RESULT",textScaleFactor: 1,
                                                      style: GoogleFonts.firaSans(
                                                          color: Colors.white,
                                                          letterSpacing: 2,
                                                          fontSize: 13),
                                                    ),
                                                    InkWell(
                                                      onTap: (){
                                                        if(resultDateTimes.length > 1){
                                                          Navigator.push(
                                                              context,
                                                              PageRouteBuilder(
                                                                pageBuilder: (c, a1, a2) => ResultDetails("",DateFormat("dd/MM/yyyy HH:mm").parse(resultDateTimes[0],true).toLocal().toString().substring(0,16), spiritQuadScore[0], spiritQuadDisplay[0], spiritBlurb[0], purposeQuadScore[0], purposeQuadDisplay[0], purposeBlurb[0],  professionQuadScore[0], professionQuadDisplay[0], professionBlurb[0], rewardQuadScore[0], rewardQuadDisplay[0], rewardBlurb[0], resultHighlights[0], spiritQuadScore[1],professionQuadScore[1],rewardQuadScore[1],purposeQuadScore[1]),
                                                                transitionsBuilder: (c, anim, a2, child) =>
                                                                    FadeTransition(opacity: anim, child: child),
                                                                transitionDuration: Duration(milliseconds: 300),
                                                              )).whenComplete((){
                                                            if(viewCoursesPressed == true){
                                                              print("viewCoursesPressed : "+viewCoursesPressed.toString());
                                                              _tabPageController.animateToPage(2,
                                                                  duration: Duration(milliseconds: 460), curve: Curves.easeOutCubic).whenComplete((){
                                                                setState(() {
                                                                  viewCoursesPressed = false;
                                                                });
                                                              });
                                                            }else{
                                                              print("viewCoursesPressed : "+viewCoursesPressed.toString());
                                                            }
                                                          });
                                                        }else{
                                                          Navigator.push(
                                                              context,
                                                              PageRouteBuilder(
                                                                pageBuilder: (c, a1, a2) => ResultDetails(0,DateFormat("dd/MM/yyyy HH:mm").parse(resultDateTimes[0],true).toLocal().toString().substring(0,16), spiritQuadScore[0], spiritQuadDisplay[0], spiritBlurb[0], purposeQuadScore[0], purposeQuadDisplay[0], purposeBlurb[0],  professionQuadScore[0], professionQuadDisplay[0], professionBlurb[0], rewardQuadScore[0], rewardQuadDisplay[0], rewardBlurb[0], resultHighlights[0], "10","10","10","10"),
                                                                transitionsBuilder: (c, anim, a2, child) =>
                                                                    FadeTransition(opacity: anim, child: child),
                                                                transitionDuration: Duration(milliseconds: 300),
                                                              )).whenComplete((){
                                                            if(viewCoursesPressed == true){
                                                              print("viewCoursesPressed : "+viewCoursesPressed.toString());
                                                              _tabPageController.animateToPage(2,
                                                                  duration: Duration(milliseconds: 460), curve: Curves.easeOutCubic).whenComplete((){
                                                                setState(() {
                                                                  viewCoursesPressed = false;
                                                                });
                                                              });
                                                            }else{
                                                              print("viewCoursesPressed : "+viewCoursesPressed.toString());
                                                            }
                                                          });
                                                        }
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                DateFormat("dd/MM/yyyy HH:mm").parse(resultDateTimes[0],true).toLocal().toString().substring(0,16),textScaleFactor: 1,
                                                                style: GoogleFonts.firaSans(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 18),
                                                              ),
                                                              Text(
                                                                completedSprints.toString()+ " SPRINTS",textScaleFactor: 1,
                                                                style: GoogleFonts.firaSans(
                                                                    color: Colors.white,
                                                                    letterSpacing: 2,
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: 12),
                                                              ),
                                                            ],
                                                          ),
                                                          ConstrainedBox(
                                                            constraints: BoxConstraints.tightFor(
                                                              width: getProportionateScreenWidth(67),
                                                            ),
                                                            child: ElevatedButton(
                                                                onPressed: () {
                                                                  if(resultDateTimes.length > 1){
                                                                    push(context, ResultDetails("",resultDateTimes[resultDateTimes.length-1], spiritQuadScore[resultDateTimes.length-1], spiritQuadDisplay[resultDateTimes.length-1], spiritBlurb[resultDateTimes.length-1], purposeQuadScore[resultDateTimes.length-1], purposeQuadDisplay[resultDateTimes.length-1], purposeBlurb[resultDateTimes.length-1],  professionQuadScore[resultDateTimes.length-1], professionQuadDisplay[resultDateTimes.length-1], professionBlurb[resultDateTimes.length-1], rewardQuadScore[resultDateTimes.length-1], rewardQuadDisplay[resultDateTimes.length-1], rewardBlurb[resultDateTimes.length-1], resultHighlights[resultDateTimes.length-1], spiritQuadScore[resultDateTimes.length-2],professionQuadScore[resultDateTimes.length-2],rewardQuadScore[resultDateTimes.length-2],purposeQuadScore[resultDateTimes.length-2]));
                                                                  }else{
                                                                    push(context, ResultDetails(0,resultDateTimes[0], spiritQuadScore[0], spiritQuadDisplay[0], spiritBlurb[0], purposeQuadScore[0], purposeQuadDisplay[0], purposeBlurb[0],  professionQuadScore[0], professionQuadDisplay[0], professionBlurb[0], rewardQuadScore[0], rewardQuadDisplay[0], rewardBlurb[0], resultHighlights[0], "10","10","10","10"));
                                                                  }
                                                                },
                                                                style: ElevatedButton.styleFrom(
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                      BorderRadius.circular(100),
                                                                    ),
                                                                    primary: Colors.white,
                                                                    onPrimary: Color(COLOR_ACCENT),
                                                                    textStyle: GoogleFonts.firaSans(
                                                                        fontSize: 12,
                                                                        color: Color(COLOR_ACCENT))),
                                                                child: Text("VIEW",textScaleFactor: 1,)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints.tightFor(width: double.infinity),
                                        child: Card(
                                          elevation: 0,
                                          semanticContainer: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                            side: BorderSide(color: Color(0xFFDAE7FF), width: 1),
                                          ),
                                          child: ExpansionTile(
                                            title: Text("My Counselors",style: GoogleFonts.firaSans(
                                              fontSize: 18,
                                              color: Color(0xFF383838),
                                            ),),
                                            childrenPadding: EdgeInsets.symmetric(
                                                horizontal: getProportionateScreenWidth(10)),
                                            children: [
                                              Container(
                                                height: getProportionateScreenHeight(49),
                                                child: TextFormField(
                                                  textAlignVertical: TextAlignVertical.center,
                                                  controller: ccEmailController,
                                                  decoration: InputDecoration(
                                                      hintText: "Add counselor email",
                                                      hintStyle: GoogleFonts.firaSans(
                                                        fontSize: 14,
                                                        color: Color(0xFF989898),
                                                      ),
                                                      suffixIcon: showLoading == true ? JumpingDotsProgressIndicator(
                                                        fontSize: 25.0,color: Color(0xff1E73BE),
                                                      ) : InkWell(
                                                        onTap: (){
                                                          showDialog(context: context, builder: (BuildContext context) => Dialog(
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
                                                            child: Container(
                                                              height: 350.0,
                                                              width: 300.0,
                                                              child: Stack(
                                                                children: [
                                                                  Center(
                                                                    child: Container(
                                                                      height: 340.0,
                                                                      width: 300.0,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(left: 20, right: 20),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: <Widget>[
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                                                                              child: Text("Type in the name of the conselor...", style: GoogleFonts.firaSans(textStyle: TextStyle(fontSize: 16,height: 1.25, letterSpacing: 1,
                                                                                  fontWeight: FontWeight.w400
                                                                              ),)),
                                                                            ),
                                                                            SizedBox(height: 15,),
                                                                            Align(
                                                                              alignment: Alignment.centerRight,
                                                                              child: Container(
                                                                                  height: 80,
                                                                                  child: SvgPicture.asset("assets/iconSVG/robot.svg")),
                                                                            ),
                                                                            SizedBox(height: 20,),
                                                                            Container(
                                                                              height: getProportionateScreenHeight(49),
                                                                              child: TextFormField(
                                                                                textAlignVertical: TextAlignVertical.center,
                                                                                controller: ccNameController,
                                                                                decoration: InputDecoration(
                                                                                    hintText: "Add counselor name",
                                                                                    labelStyle: GoogleFonts.firaSans(
                                                                                      fontSize: 14,
                                                                                      color: Color(0xFF989898),
                                                                                    ),
                                                                                    hintStyle: GoogleFonts.firaSans(
                                                                                      fontSize: 14,
                                                                                      color: Color(0xFF989898),
                                                                                    ),
                                                                                    border: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(6),
                                                                                        borderSide: BorderSide(
                                                                                            color: Color(0xFFB5B5B5)))),
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 30,),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10, right: 10),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  GestureDetector(
                                                                                    onTap: (){
                                                                                      pop(context);
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 40,
                                                                                      width: 100,
                                                                                      decoration: BoxDecoration(
                                                                                          border: Border.all(color: Color(0xff1E73BE)),
                                                                                          borderRadius: BorderRadius.all(Radius.circular(25))
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Text("Cancel",
                                                                                            style: GoogleFonts.firaSans(textStyle: TextStyle(fontSize: 16, letterSpacing: 1,color: Color(0xff1E73BE)),)
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  GestureDetector(
                                                                                    onTap: (){
                                                                                      if(ccNameController.text.isEmpty){
                                                                                        Fluttertoast.showToast(msg: "Name is empty!",backgroundColor: Colors.white, textColor: Colors.red);
                                                                                      }else{
                                                                                        pop(context);
                                                                                        addCounsellor(context);
                                                                                      }
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 40,
                                                                                      width: 100,
                                                                                      decoration: BoxDecoration(
                                                                                          border: Border.all(color: Color(0xff1E73BE)),
                                                                                          borderRadius: BorderRadius.all(Radius.circular(25))
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Text("Add",
                                                                                            style: GoogleFonts.firaSans(textStyle: TextStyle(fontSize: 16, letterSpacing: 1,color: Color(0xff1E73BE)),)
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 25,),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                      alignment: Alignment.topCenter,
                                                                      child: Container(
                                                                        height: 20,
                                                                        width: 200,
                                                                        color: Color(0xff1E73BE),
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                          ));
                                                        },
                                                        child: Container(
                                                          child: Text("\n+ Add",
                                                              style: GoogleFonts.firaSans(
                                                                  color: Color(0xFF4C89F4), fontSize: 16),
                                                          ),
                                                        ),
                                                      ),
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(6),
                                                          borderSide: BorderSide(
                                                              color: Color(0xFFB5B5B5)))),
                                                ),
                                              ),SizedBox(height: 10,),
                                              Container(
                                                  height: 80*double.parse(counsellorId.length.toString()),
                                                child: ListView.builder(
                                                    itemCount: counsellorId == null ? 0 : counsellorId.length,
                                                    scrollDirection: Axis.vertical,
                                                    itemBuilder: (context, index) {
                                                      return Container(
                                                        height: 80,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Divider(color: Color(0xffDAE7FF),),
                                                            SizedBox(height: 5,),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                SizedBox(width: 10),
                                                                CircleAvatar(
                                                                  radius: 25,
                                                                  backgroundColor: Colors.grey[300],
                                                                  child: Icon(Icons.person, color: Colors.white,),
                                                                ),SizedBox(width: 20),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(counsellorName[index].toString(),
                                                                      textScaleFactor: 1,
                                                                      style: GoogleFonts.firaSans(
                                                                        letterSpacing: 1,
                                                                          color: Colors.black, fontSize: 15),
                                                                    ),SizedBox(height: 5),
                                                                    Text(counsellorEmail[index].toString(),
                                                                      textScaleFactor: 1,
                                                                      style: GoogleFonts.firaSans(
                                                                          letterSpacing: 1,
                                                                          color: Color(0xff727272), fontSize: 10),
                                                                    ),
                                                                  ],
                                                                ),Spacer(),
                                                                Text(counsellorStatus[index] == "Pending" ? "Pending" : "Remove",
                                                                  textScaleFactor: 1,
                                                                  style: GoogleFonts.firaSans(
                                                                      letterSpacing: 1,
                                                                      color: Colors.red, fontSize: 10),
                                                                ),SizedBox(width: 10),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              ),
                                              Divider(color: Color(0xffDAE7FF),),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        constraints: BoxConstraints.tightFor(width: double.infinity),
                                        child: Card(
                                          elevation: 0,
                                          semanticContainer: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6),
                                            side: BorderSide(color: Color(0xFFDAE7FF), width: 1),
                                          ),
                                          child: ExpansionTile(
                                            title: Text("My Guardians",style: GoogleFonts.firaSans(
                                              fontSize: 18,
                                              color: Color(0xFF383838),
                                            ),),
                                            childrenPadding: EdgeInsets.symmetric(
                                                horizontal: getProportionateScreenWidth(15)),
                                            children: [
                                              Container(
                                                height: getProportionateScreenHeight(49),
                                                child: TextFormField(
                                                  textAlignVertical: TextAlignVertical.center,
                                                  controller: ccGuardianEmailController,
                                                  decoration: InputDecoration(
                                                      hintText: "Add guardian email",
                                                      hintStyle: GoogleFonts.firaSans(
                                                        fontSize: 14,
                                                        color: Color(0xFF989898),
                                                      ),
                                                      suffixIcon: showLoading == true ? JumpingDotsProgressIndicator(
                                                        fontSize: 25.0,color: Color(0xff1E73BE),
                                                      ) : InkWell(
                                                        onTap: (){
                                                          showDialog(context: context, builder: (BuildContext context) => Dialog(
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
                                                            child: Container(
                                                              height: 350.0,
                                                              width: 300.0,
                                                              child: Stack(
                                                                children: [
                                                                  Center(
                                                                    child: Container(
                                                                      height: 340.0,
                                                                      width: 300.0,
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(left: 20, right: 20),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                          children: <Widget>[
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                                                                              child: Text("Type in the name of the guardian...", style: GoogleFonts.firaSans(textStyle: TextStyle(fontSize: 16,height: 1.25, letterSpacing: 1,
                                                                                  fontWeight: FontWeight.w400
                                                                              ),)),
                                                                            ),
                                                                            SizedBox(height: 15,),
                                                                            Align(
                                                                              alignment: Alignment.centerRight,
                                                                              child: Container(
                                                                                  height: 80,
                                                                                  child: SvgPicture.asset("assets/iconSVG/robot.svg")),
                                                                            ),
                                                                            SizedBox(height: 20,),
                                                                            Container(
                                                                              height: getProportionateScreenHeight(49),
                                                                              child: TextFormField(
                                                                                textAlignVertical: TextAlignVertical.center,
                                                                                controller: ccGuardianNameController,
                                                                                decoration: InputDecoration(
                                                                                    hintText: "Add guardian name",
                                                                                    labelStyle: GoogleFonts.firaSans(
                                                                                      fontSize: 14,
                                                                                      color: Color(0xFF989898),
                                                                                    ),
                                                                                    hintStyle: GoogleFonts.firaSans(
                                                                                      fontSize: 14,
                                                                                      color: Color(0xFF989898),
                                                                                    ),
                                                                                    border: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius.circular(6),
                                                                                        borderSide: BorderSide(
                                                                                            color: Color(0xFFB5B5B5)))),
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 30,),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 10, right: 10),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  GestureDetector(
                                                                                    onTap: (){
                                                                                      pop(context);
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 40,
                                                                                      width: 100,
                                                                                      decoration: BoxDecoration(
                                                                                          border: Border.all(color: Color(0xff1E73BE)),
                                                                                          borderRadius: BorderRadius.all(Radius.circular(25))
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Text("Cancel",
                                                                                            style: GoogleFonts.firaSans(textStyle: TextStyle(fontSize: 16, letterSpacing: 1,color: Color(0xff1E73BE)),)
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  GestureDetector(
                                                                                    onTap: (){
                                                                                      if(ccGuardianNameController.text.isEmpty){
                                                                                        Fluttertoast.showToast(msg: "Name is empty!",backgroundColor: Colors.white, textColor: Colors.red);
                                                                                      }else{
                                                                                        pop(context);
                                                                                        addGuardians(context);
                                                                                      }
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 40,
                                                                                      width: 100,
                                                                                      decoration: BoxDecoration(
                                                                                          border: Border.all(color: Color(0xff1E73BE)),
                                                                                          borderRadius: BorderRadius.all(Radius.circular(25))
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: Text("Add",
                                                                                            style: GoogleFonts.firaSans(textStyle: TextStyle(fontSize: 16, letterSpacing: 1,color: Color(0xff1E73BE)),)
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 25,),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Align(
                                                                      alignment: Alignment.topCenter,
                                                                      child: Container(
                                                                        height: 20,
                                                                        width: 200,
                                                                        color: Color(0xff1E73BE),
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                          ));
                                                        },
                                                        child: Container(
                                                          child: Text("\n+ Add",
                                                            style: GoogleFonts.firaSans(
                                                                color: Color(0xFF4C89F4), fontSize: 16),
                                                          ),
                                                        ),
                                                      ),
                                                      border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(6),
                                                          borderSide: BorderSide(
                                                              color: Color(0xFFB5B5B5)))),
                                                ),
                                              ),SizedBox(height: 10,),
                                              Container(
                                                height: 80*double.parse(guardianId.length.toString()),
                                                child: ListView.builder(
                                                    itemCount: guardianId == null ? 0 : guardianId.length,
                                                    scrollDirection: Axis.vertical,
                                                    itemBuilder: (context, index) {
                                                      return Container(
                                                        height: 80,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Divider(color: Color(0xffDAE7FF),),
                                                            SizedBox(height: 5,),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                SizedBox(width: 10),
                                                                CircleAvatar(
                                                                  radius: 25,
                                                                  backgroundColor: Colors.grey[300],
                                                                  child: Icon(Icons.person, color: Colors.white,),
                                                                ),SizedBox(width: 20),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(guardianName[index].toString(),
                                                                      textScaleFactor: 1,
                                                                      style: GoogleFonts.firaSans(
                                                                          letterSpacing: 1,
                                                                          color: Colors.black, fontSize: 15),
                                                                    ),SizedBox(height: 5),
                                                                    Text(guardianEmail[index].toString(),
                                                                      textScaleFactor: 1,
                                                                      style: GoogleFonts.firaSans(
                                                                          letterSpacing: 1,
                                                                          color: Color(0xff727272), fontSize: 10),
                                                                    ),
                                                                  ],
                                                                ),Spacer(),
                                                                Text(guardianStatus[index] == "Pending" ? "Pending" : "Remove",
                                                                  textScaleFactor: 1,
                                                                  style: GoogleFonts.firaSans(
                                                                      letterSpacing: 1,
                                                                      color: Colors.red, fontSize: 10),
                                                                ),SizedBox(width: 10),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              ),
                                              Divider(color: Color(0xffDAE7FF),),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ) : SafeArea(
                      child: Scaffold(
                        body: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: getProportionateScreenHeight(96),
                              color: Color(COLOR_ACCENT),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: SvgPicture.asset(
                                  "assets/imageSVG/HeaderSIdeDesign.svg",
                                  height: getProportionateScreenHeight(96),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(getProportionateScreenWidth(10)),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFDAE7FF), width: 2),
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.white,
                              ),
                              height: getProportionateScreenHeight(982),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: getProportionateScreenHeight(96),
                                    padding: EdgeInsets.all(
                                      getProportionateScreenWidth(22),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "More",
                                          style: GoogleFonts.firaSans(
                                              color: Color(0xFF383838),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18),
                                        ),
//                        GestureDetector(
//                            onTap: () {
//                              Navigator.pop(context);
//                            },
//                            child: Icon(
//                              Icons.close,
//                              size: getProportionateScreenWidth(30),
//                              color: Color(0xFF6C6C6C),
//                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: getProportionateScreenWidth(14)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints.tightFor(
                                              width: getProportionateScreenWidth(321),
                                              height: getProportionateScreenHeight(150)),
                                          child: ElevatedButton(
                                            onPressed: (){setState(() {
                                              removeMoreScreen = true;
                                            });},
                                            style: ElevatedButton.styleFrom(
                                              primary: Color(0xff1E73BE),
                                              elevation: 0,
                                              padding: EdgeInsets.all(getProportionateScreenWidth(16)),
                                              onPrimary: Color(0xff1E73BE),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                  side: BorderSide(color: Color(0xff1E73BE), width: 2)),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(100)),
                                                      boxShadow: [new BoxShadow(
                                                        color: Colors.black,
                                                        blurRadius: 7.0,
                                                      ),]
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(100)),
                                                      color: Colors.white,
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(5.0),
                                                      child: CircleAvatar(
                                                        radius: getProportionateScreenWidth(30),
                                                        backgroundColor: Color(0xffFEC55F),
                                                        backgroundImage: photo == "" || photo == null || photo == "null" ? null : Image.memory(base64photo).image,
                                                        child: Container(
                                                          //color: photo == "" || photo == null || photo == "null" ? Color(0xffFEC55F) : Colors.transparent,
                                                          margin: EdgeInsets.all(4),
                                                          child: Container(
                                                            child: photo == "" || photo == null || photo == "null" ? SvgPicture.asset(
                                                              "assets/imageSVG/miramira.svg",
                                                              height: getProportionateScreenHeight(20),
                                                              fit: BoxFit.fitHeight,
                                                            ) : null,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: getProportionateScreenWidth(21),
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "My Profile",
                                                      style: GoogleFonts.firaSans(
                                                          fontSize: 18, color: Colors.white),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      userName.toString(),//name,
                                                      style: GoogleFonts.firaSans(
                                                          fontSize: 15,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      isSignedIn.toString(),
                                                      style: GoogleFonts.firaSans(
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: getProportionateScreenHeight(14),
                                                    ),
                                                    Text(
                                                      lvScore.toString()+"/10 LV Score | "+completedSprints.toString() +" Sprints",
                                                      style: GoogleFonts.firaSans(
                                                        fontSize: 12,letterSpacing: 0,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    ScoreAndProgressBar2(
                                                      lvScore: lvScore == null || lvScore == "" ? 0.0 : double.parse(lvScore.toString()),
                                                      numberOfCompletedSprints: completedSprints == null || completedSprints == "" ? 0 : int.parse(completedSprints.toString()),
                                                    ),
//                ScoreAndProgressBar(
//                  percent: (double.parse(completedSprints)/14.0),
//                  sprints: double.parse(completedSprints.toString()),
//                  textColor: Colors.white,
//                )
                                                  ],
                                                ),
                                                Spacer(),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: getProportionateScreenHeight(10),
                                        ),
//                        SettingCustomButton(
//                          onTap: (){
//                            push(context, MessageCenter());
//                          },
//                          imgPath: "assets/iconSVG/conversation.svg",
//                          text: "Message Centre",
//                        ),
//                        SizedBox(
//                          height: getProportionateScreenHeight(10),
//                        ),
//                        SettingCustomButton(
//                          onTap: (){
//                            print("Settings pressed");
//                            push(context, SettingsScreen());
//                          },
//                          imgPath: "assets/iconSVG/settings.svg",
//                          text: "Settings",
//                        ),
//                        SizedBox(
//                          height: getProportionateScreenHeight(10),
//                        ),
                                        logoutButton(
//                          onPressed: (){
//                            Navigator.of(context).popUntil((route) => route.isFirst);
//                          },
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  back(){
    setState(() {
      removeMoreScreen = false;
    });
    print(removeMoreScreen);
    Future.delayed(Duration(seconds: 2), (){
      setState(() {

      });
    });
  }

  FirstHomeScreen2(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      width: screenWidth,
      height: screenHeight,
      child: quiz1Status == "5" ? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset(
              "assets/imageSVG/miramira.svg",
              height: getProportionateScreenHeight(60.66),
              color: Color(COLOR_ACCENT),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(40),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(
                width: getProportionateScreenWidth(321),
                height: getProportionateScreenHeight(150)),
            child: ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                primary: Color(0xff1E73BE),
                elevation: 0,
                padding: EdgeInsets.all(getProportionateScreenWidth(16)),
                onPrimary: Color(0xff1E73BE),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Color(0xff1E73BE), width: 2)),
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        boxShadow: [new BoxShadow(
                          color: Colors.black,
                          blurRadius: 7.0,
                        ),]
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: CircleAvatar(
                          radius: getProportionateScreenWidth(30),
                          backgroundColor: Color(0xffFEC55F),
                          backgroundImage: photo == "" || photo == null || photo == "null" ? null : Image.memory(base64photo).image,
                          child: Container(
                            //color: photo == "" || photo == null || photo == "null" ? Color(0xffFEC55F) : Colors.transparent,
                            margin: EdgeInsets.all(4),
                            child: Container(
                              child: photo == "" || photo == null || photo == "null" ? SvgPicture.asset(
                                "assets/imageSVG/miramira.svg",
                                height: getProportionateScreenHeight(20),
                                fit: BoxFit.fitHeight,
                              ) : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(21),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "My Profile",
                        style: GoogleFonts.firaSans(
                            fontSize: 18, color: Colors.white),
                      ),
                      Spacer(),
                      Text(
                        userName.toString() == "null" ? "Loading..." : userName.toString(),//name,
                        style: GoogleFonts.firaSans(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        isSignedIn.toString(),
                        style: GoogleFonts.firaSans(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(14),
                      ),
                      Text(
                        lvScore.toString()+"/10 LV Score | "+completedSprints.toString() +" Sprints",
                        style: GoogleFonts.firaSans(
                          fontSize: 12,letterSpacing: 0,
                          color: Colors.white,
                        ),
                      ),
                      ScoreAndProgressBar2(
                        lvScore: lvScore == null || lvScore == "" ? 0.0 : double.parse(lvScore.toString()),
                        numberOfCompletedSprints: completedSprints == null || completedSprints == "" ? 0 : int.parse(completedSprints),
                      ),
//                ScoreAndProgressBar(
//                  percent: (double.parse(completedSprints)/14.0),
//                  sprints: double.parse(completedSprints.toString()),
//                  textColor: Colors.white,
//                )
                    ],
                  ),
                ],
              ),
            ),
          ),
          //Center(child: SvgPicture.asset("assets/iconSVG/robot.svg")),
          SizedBox(
            height: getProportionateScreenHeight(40),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Text(
              "More sprints make your results sharper.\nTake the quiz.",
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: GoogleFonts.firaSans(
                  color: Color(0xFF3F4462),
                  letterSpacing: 1,
                  fontSize: getProportionateScreenHeight(15),
                  fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(40),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, bottom: 50),
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                  width: getProportionateScreenWidth(173),
                  height: getProportionateScreenHeight(41)),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      removeTakeQuizScreen = true;
                    });
                    print(removeTakeQuizScreen);
                    Future.delayed(Duration(seconds: 2), () {
                      setState(() {});
                    });
                    //push(context, QuizListScreen());
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color(COLOR_ACCENT),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      textStyle: GoogleFonts.firaSans(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.5,
                      )),
                  child: Text(
                    "CONTINUE",
                    textScaleFactor: 1,
                  )),
            ),
          )
        ],
      ) : Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Start with the Quiz!",
                textScaleFactor: 1,
                style: GoogleFonts.firaSans(
                    color: Color(COLOR_ACCENT),
                    fontSize: getProportionateScreenHeight(21),
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(40),
            ),
            Center(
              child: Text(
                "An easy sprint of questions will make\nMiraMira discover your aptitude",
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: GoogleFonts.firaSans(
                  color: Colors.black,
                  letterSpacing: 1,
                  fontSize: getProportionateScreenHeight(17),
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(40),
            ),
            Center(child: SvgPicture.asset("assets/iconSVG/robot.svg")),
            SizedBox(
              height: getProportionateScreenHeight(40),
            ),
            Text(
              "Go ahead, start your journey now.",
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: GoogleFonts.firaSans(
                  color: Color(0xFF3F4462),
                  letterSpacing: 1,
                  fontSize: getProportionateScreenHeight(15),
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: getProportionateScreenHeight(40),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50, bottom: 50),
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    width: getProportionateScreenWidth(173),
                    height: getProportionateScreenHeight(41)),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        removeTakeQuizScreen = true;
                      });
                      print(removeTakeQuizScreen);
                      Future.delayed(Duration(seconds: 2), () {
                        setState(() {});
                      });
                      //push(context, QuizListScreen());
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(COLOR_ACCENT),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        textStyle: GoogleFonts.firaSans(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                        )),
                    child: Text(
                      "TAKE THE QUIZ",
                      textScaleFactor: 1,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  moreScreen(BuildContext context){
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: getProportionateScreenHeight(96),
              color: Color(COLOR_ACCENT),
              child: Align(
                alignment: Alignment.topRight,
                child: SvgPicture.asset(
                  "assets/imageSVG/HeaderSIdeDesign.svg",
                  height: getProportionateScreenHeight(96),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(getProportionateScreenWidth(10)),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFDAE7FF), width: 2),
                borderRadius: BorderRadius.circular(7),
                color: Colors.white,
              ),
              height: getProportionateScreenHeight(982),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: getProportionateScreenHeight(96),
                    padding: EdgeInsets.all(
                      getProportionateScreenWidth(22),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "More",
                          style: GoogleFonts.firaSans(
                              color: Color(0xFF383838),
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                        ),
//                        GestureDetector(
//                            onTap: () {
//                              Navigator.pop(context);
//                            },
//                            child: Icon(
//                              Icons.close,
//                              size: getProportionateScreenWidth(30),
//                              color: Color(0xFF6C6C6C),
//                            )),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(14)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ProfileButton(
                          name: userName.toString(),
                          email: isSignedIn.toString(),
                          percentage: 40,
                          onPressed: () {
                            setState(() {
                              removeMoreScreen = true;
                            });
                            //push(context, UserProfileScreen());
                          },
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
//                        SettingCustomButton(
//                          onTap: (){
//                            push(context, MessageCenter());
//                          },
//                          imgPath: "assets/iconSVG/conversation.svg",
//                          text: "Message Centre",
//                        ),
//                        SizedBox(
//                          height: getProportionateScreenHeight(10),
//                        ),
//                        SettingCustomButton(
//                          onTap: (){
//                            print("Settings pressed");
//                            push(context, SettingsScreen());
//                          },
//                          imgPath: "assets/iconSVG/settings.svg",
//                          text: "Settings",
//                        ),
//                        SizedBox(
//                          height: getProportionateScreenHeight(10),
//                        ),
                        logoutButton(
//                          onPressed: (){
//                            Navigator.of(context).popUntil((route) => route.isFirst);
//                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  UserProfileScreen(BuildContext context){
    final providerListener = Provider.of<CustomViewModel>(context);
    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: ()=> back(),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: getProportionateScreenHeight(96),
                color: Color(COLOR_ACCENT),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(getProportionateScreenWidth(10)),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFDAE7FF), width: 2),
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.white,
                ),
                height: getProportionateScreenHeight(910),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Screenshot(
                        controller: screenshotController,
                        child: Container(
                          height: getProportionateScreenHeight(600),
                          padding: EdgeInsets.all(
                            getProportionateScreenWidth(22),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.white),
                              color: Color(COLOR_ACCENT)),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        back();
                                        //Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.arrow_back_ios_rounded,
                                        size: getProportionateScreenWidth(25),
                                        color: Colors.white,
                                      )),
                                  SizedBox(
                                    width: getProportionateScreenWidth(12),
                                  ),
                                  Text(
                                    "My Profile",
                                    textScaleFactor: 1,
                                    style: GoogleFonts.firaSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                      onTap: () {
                                        back();
                                      },
                                      child: Icon(
                                        Icons.close,
                                        size: getProportionateScreenWidth(30),
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (c, a1, a2) => EditProfileScreen(myId, userName, isSignedIn, grade, schoolOrProfession, state, county, photo),
                                            transitionsBuilder: (c, anim, a2, child) =>
                                                FadeTransition(opacity: anim, child: child),
                                            transitionDuration: Duration(milliseconds: 300),
                                          )).whenComplete((){
                                        loadUserProfile(context);
                                      });
                                    },
                                    child: SvgPicture.asset(
                                      "assets/iconSVG/editProfIcon.svg",
                                      height: getProportionateScreenWidth(21),
                                    ),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenWidth(26),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List image) async {
                                        if (image != null) {
                                          final directory = await getApplicationDocumentsDirectory();
                                          final imagePath = await File('${directory.path}/image.png').create();
                                          await imagePath.writeAsBytes(image);

                                          /// Share Plugin
                                          await Share.shareFiles([imagePath.path],text: 'Here\'s my profile card on MiraMira');
                                        }
                                      });
                                    },
                                    child: SvgPicture.asset(
                                      "assets/iconSVG/shareOutlineWhite.svg",
                                      height: getProportionateScreenWidth(21),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(100)),
                                        boxShadow: [new BoxShadow(
                                          color: Colors.black,
                                          blurRadius: 7.0,
                                        ),]
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(100)),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: CircleAvatar(
                                          radius: getProportionateScreenWidth(49),
                                          backgroundColor: Color(0xffFEC55F),//Color(0xFFDDDDDD),
                                          backgroundImage: photo == "" || photo == null || photo == "null" ? null : Image.memory(base64Decode(photo),).image,
                                          child: Container(
                                            //color: Color(0xffFEC55F),
                                            margin: EdgeInsets.all(4),
                                            child: Container(
                                              child: photo == "" || photo == null || photo == "null" ? SvgPicture.asset(
                                                "assets/imageSVG/miramira.svg",
                                                height: getProportionateScreenHeight(20),
                                                fit: BoxFit.fitHeight,
                                              ) : null,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenWidth(16),
                                  ),
                                  Container(
                                    //width: getProportionateScreenWidth(126),
                                    height: getProportionateScreenHeight(82),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: getProportionateScreenWidth(126),
                                          child: Text(
                                            userName.toString(),textScaleFactor: 1,
                                            style: GoogleFonts.firaSans(
                                                fontSize: 22,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        SizedBox(
                                          height: getProportionateScreenWidth(10),
                                        ),
                                        Container(
                                          width: getProportionateScreenWidth(156),
                                          child: Text(
                                            isSignedIn.toString(),textScaleFactor: 1,
                                            style: GoogleFonts.firaSans(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Container(
                                    width: getProportionateScreenWidth(200),
                                    child: ScoreAndProgressBar2(
                                      lvScore: double.parse(providerListener.userDetails.lvScore==""?"0":(providerListener.userDetails.lvScore??"0")),
                                      numberOfCompletedSprints: int.parse(providerListener.userDetails.numberOfCompletedSprints??"0"),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        userType.toString().contains('School') ? "GRADE" : "JOB",
                                        textScaleFactor: 1,
                                        style: GoogleFonts.firaSans(
                                            color: Colors.white,
                                            letterSpacing: 2,
                                            fontSize: 13),
                                      ),
                                      Text(
                                        grade.toString(),textScaleFactor: 1,
                                        style: GoogleFonts.firaSans(
                                            color: Colors.white,
                                            letterSpacing: 2,
                                            fontSize: 16),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Spacer(),
                              Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: getProportionateScreenWidth(200),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userType.toString().contains('School') ? "SCHOOL" : "FIRM",textScaleFactor: 1,
                                          style: GoogleFonts.firaSans(
                                              color: Colors.white,
                                              letterSpacing: 2,
                                              fontSize: 13),
                                        ),
                                        Text(
                                          schoolOrProfession.toString(),textScaleFactor: 1,
                                          style: GoogleFonts.firaSans(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        )
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "STATE",textScaleFactor: 1,
                                        style: GoogleFonts.firaSans(
                                            color: Colors.white,
                                            letterSpacing: 2,
                                            fontSize: 13),
                                      ),
                                      Text(
                                        state.toString(),textScaleFactor: 1,
                                        style: GoogleFonts.firaSans(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: getProportionateScreenHeight(70),
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                          getProportionateScreenWidth(18)),
                                      decoration: BoxDecoration(
                                          color: Color(COLOR_ACCENT),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.white, width: 1.3)),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "VISITED",textScaleFactor: 1,
                                            style: GoogleFonts.firaSans(
                                                color: Colors.white,
                                                letterSpacing: 2,
                                                fontSize: 13),
                                          ),
                                          Text(
                                            visited == null ? "0" : visited.toString(),textScaleFactor: 1,
                                            style: GoogleFonts.firaSans(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 22),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenWidth(20),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: (){
                                        _tabPageController.animateToPage(1,
                                            duration: Duration(milliseconds: 460), curve: Curves.easeOutCubic);
                                      },
                                      child: Container(
                                        height: getProportionateScreenHeight(70),
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                            getProportionateScreenWidth(18)),
                                        decoration: BoxDecoration(
                                            color: Color(COLOR_ACCENT),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Colors.white, width: 1.3)),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "RESULTS",textScaleFactor: 1,
                                                  style: GoogleFonts.firaSans(
                                                      color: Colors.white,
                                                      letterSpacing: 2,
                                                      fontSize: 13),
                                                ),
                                                Text(
                                                  resultIds == null ? "0" : resultIds.toList().length.toString(),
                                                  textScaleFactor: 1,
                                                  style: GoogleFonts.firaSans(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 22),
                                                )
                                              ],
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Spacer(),
                              resultIds == null ? Container() : Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(18),
                                    vertical: getProportionateScreenHeight(13)),
                                decoration: BoxDecoration(
                                    color: Color(COLOR_ACCENT),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.white, width: 1.3)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "LAST RESULT",textScaleFactor: 1,
                                      style: GoogleFonts.firaSans(
                                          color: Colors.white,
                                          letterSpacing: 2,
                                          fontSize: 13),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        if(resultDateTimes.length > 1){
                                          push(context, ResultDetails("",resultDateTimes[resultDateTimes.length-1], spiritQuadScore[resultDateTimes.length-1], spiritQuadDisplay[resultDateTimes.length-1], spiritBlurb[resultDateTimes.length-1], purposeQuadScore[resultDateTimes.length-1], purposeQuadDisplay[resultDateTimes.length-1], purposeBlurb[resultDateTimes.length-1],  professionQuadScore[resultDateTimes.length-1], professionQuadDisplay[resultDateTimes.length-1], professionBlurb[resultDateTimes.length-1], rewardQuadScore[resultDateTimes.length-1], rewardQuadDisplay[resultDateTimes.length-1], rewardBlurb[resultDateTimes.length-1], resultHighlights[resultDateTimes.length-1], spiritQuadScore[resultDateTimes.length-2],professionQuadScore[resultDateTimes.length-2],rewardQuadScore[resultDateTimes.length-2],purposeQuadScore[resultDateTimes.length-2]));
                                        }else{
                                          push(context, ResultDetails(0,resultDateTimes[0], spiritQuadScore[0], spiritQuadDisplay[0], spiritBlurb[0], purposeQuadScore[0], purposeQuadDisplay[0], purposeBlurb[0],  professionQuadScore[0], professionQuadDisplay[0], professionBlurb[0], rewardQuadScore[0], rewardQuadDisplay[0], rewardBlurb[0], resultHighlights[0], "10","10","10","10"));
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                resultDateTimes[resultDateTimes.length-1],textScaleFactor: 1,
                                                style: GoogleFonts.firaSans(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                completedSprints.toString()+ " SPRINTS",textScaleFactor: 1,
                                                style: GoogleFonts.firaSans(
                                                    color: Colors.white,
                                                    letterSpacing: 2,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          ConstrainedBox(
                                            constraints: BoxConstraints.tightFor(
                                              width: getProportionateScreenWidth(67),
                                            ),
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  if(resultDateTimes.length > 1){
                                                    push(context, ResultDetails("",resultDateTimes[resultDateTimes.length-1], spiritQuadScore[resultDateTimes.length-1], spiritQuadDisplay[resultDateTimes.length-1], spiritBlurb[resultDateTimes.length-1], purposeQuadScore[resultDateTimes.length-1], purposeQuadDisplay[resultDateTimes.length-1], purposeBlurb[resultDateTimes.length-1],  professionQuadScore[resultDateTimes.length-1], professionQuadDisplay[resultDateTimes.length-1], professionBlurb[resultDateTimes.length-1], rewardQuadScore[resultDateTimes.length-1], rewardQuadDisplay[resultDateTimes.length-1], rewardBlurb[resultDateTimes.length-1], resultHighlights[resultDateTimes.length-1], spiritQuadScore[resultDateTimes.length-2],professionQuadScore[resultDateTimes.length-2],rewardQuadScore[resultDateTimes.length-2],purposeQuadScore[resultDateTimes.length-2]));
                                                  }else{
                                                    push(context, ResultDetails(0,resultDateTimes[0], spiritQuadScore[0], spiritQuadDisplay[0], spiritBlurb[0], purposeQuadScore[0], purposeQuadDisplay[0], purposeBlurb[0],  professionQuadScore[0], professionQuadDisplay[0], professionBlurb[0], rewardQuadScore[0], rewardQuadDisplay[0], rewardBlurb[0], resultHighlights[0], "10","10","10","10"));
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(100),
                                                    ),
                                                    primary: Colors.white,
                                                    onPrimary: Color(COLOR_ACCENT),
                                                    textStyle: GoogleFonts.firaSans(
                                                        fontSize: 12,
                                                        color: Color(COLOR_ACCENT))),
                                                child: Text("VIEW",textScaleFactor: 1,)),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints.tightFor(width: double.infinity),
                        child: Card(
                          elevation: 0,
                          semanticContainer: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                            side: BorderSide(color: Color(0xFFDAE7FF), width: 1),
                          ),
                          child: ExpansionTile(
                            title: Text("My Counselors",style: GoogleFonts.firaSans(
                              fontSize: 18,
                              color: Color(0xFF383838),
                            ),),
                            childrenPadding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(15)),
                            children: [

                            ],
                          ),
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints.tightFor(width: double.infinity),
                        child: Card(
                          elevation: 0,
                          semanticContainer: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                            side: BorderSide(color: Color(0xFFDAE7FF), width: 1),
                          ),
                          child: ExpansionTile(
                            title: Text("My Guardians",style: GoogleFonts.firaSans(
                              fontSize: 18,
                              color: Color(0xFF383838),
                            ),),
                            childrenPadding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(15)),
                            children: [
                              /*
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xffC4C4C4))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                                  child: SearchableDropdown.single(
                                    items: ['Alabama','Alaska','American Samoa','Arizona','Arkansas','California','Colorado','Connecticut','Delaware','District Of Columbia',
                                      'Federated States Of Micronesia','Florida','Georgia','Guam','Hawaii','Idaho','Illinois','Indiana','Iowa','Kansas',
                                      'Kentucky','Louisiana','Maine','Marshall Islands','Maryland','Massachusetts','Michigan','Minnesota','Mississippi','Missouri',
                                      'Montana','Nebraska','Nevada','New Hampshire','New Jersey','New Mexico','New York','North Carolina','North Dakota','Northern Mariana Islands',
                                      'Ohio','Oklahoma','Oregon','Palau','Pennsylvania','Puerto Rico','Rhode Island','South Carolina','South Dakota','Tennessee',
                                      'Texas','Utah','Vermont','Virgin Islands','Virginia','Washington','West Virginia','Wisconsin','Wyoming',
                                    ].map((String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(
                                          value,
                                          textScaleFactor: 1,
                                        ),
                                      );
                                    }).toList(),
                                    value: "Add guardians",
                                    hint: "Add guardians",
                                    searchHint: "Add guardians",
                                    closeButton: SizedBox.shrink(),
                                    onChanged: (value) {
                                      setState(() {
                                        //selectedValue = value;
                                      });
                                    },
                                    isExpanded: true,
                                  ),
                                ),
                              ),

                               */
                            ],
                          ),
                        ),
                      ),
                      /*
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(33),
                            vertical: getProportionateScreenHeight(11)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 2,
                              color: Color(0xFFDAE7FF),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                SizedBox(height: 10,),
                                Text(
                                  "My Counselors",textScaleFactor: 1,
                                  style: GoogleFonts.firaSans(
                                      fontSize: 18, color: Color(0xFF383838)),
                                ),
                                SizedBox(height: 10,),
                                Spacer(),
                                SizedBox(width: getProportionateScreenWidth(31)),
                                Icon(Icons.keyboard_arrow_down)
                              ],
                            ),SizedBox(height: 10,),
                            SizedBox(
                              height: getProportionateScreenHeight(13),
                            ),
                            Container(
                              height: getProportionateScreenHeight(49),
                              child: TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    hintText: "Add counselor email",
                                    hintStyle: GoogleFonts.firaSans(
                                      fontSize: 14,
                                      color: Color(0xFF989898),
                                    ),
                                    suffixText: "+ Add",
                                    suffixStyle: GoogleFonts.firaSans(
                                        color: Color(0xFF4C89F4), fontSize: 14),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                            color: Color(0xFFB5B5B5)))),
                              ),
                            ),SizedBox(height: 10,),
                            SizedBox(
                              height: getProportionateScreenHeight(13),
                            ),
                            Container(
                              height: 2,
                              color: Color(0xFFDAE7FF),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(11),
                            ),
                            CounsellorsTile(),
                            SizedBox(
                              height: getProportionateScreenHeight(11),
                            ),
                            Container(
                              height: 2,
                              color: Color(0xFFDAE7FF),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(11),
                            ),
                            CounsellorsTile(),
                            Divider(
                              color: Color(COLOR_ACCENT),
                              thickness: 2,
                              height: 30,
                            ),
                            Container(
                              height: 2,
                              color: Color(0xFFDAE7FF),
                            ),
                            TextButton(
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "My Guardians",textScaleFactor: 1,
                                      style: GoogleFonts.firaSans(
                                          color: Color(0xFF383838), fontSize: 18),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xFF8B8B8B),
                                      size: 22,
                                    )
                                  ],
                                )),
//                            Container(
//                              height: 2,
//                              color: Color(0xFFDAE7FF),
//                            ),
//                            TextButton(
//                                onPressed: () {},
//                                child: Row(
//                                  mainAxisAlignment:
//                                  MainAxisAlignment.spaceBetween,
//                                  children: [
//                                    Text(
//                                      "Social Media",textScaleFactor: 1,
//                                      style: GoogleFonts.firaSans(
//                                          color: Color(0xFF383838), fontSize: 18),
//                                    ),
//                                    Icon(
//                                      Icons.arrow_forward_ios_rounded,
//                                      color: Color(0xFF8B8B8B),
//                                      size: 22,
//                                    )
//                                  ],
//                                ))
                          ],
                        ),
                      )

                       */
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  resultsListScreen(BuildContext context){
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            child: Column(
              children: [
                //Top Profile
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: getProportionateScreenHeight(96),
                      color: Color(COLOR_ACCENT),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: SvgPicture.asset(
                          "assets/imageSVG/HeaderSIdeDesign.svg",
                          height: getProportionateScreenHeight(96),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 60),
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: SvgPicture.asset("assets/iconSVG/square.svg")),
                    ),
                    Container(
                      height: getProportionateScreenHeight(96),
                      width: MediaQuery.of(context).size.width/1.2,
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20)),
                      color: Color(COLOR_ACCENT),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                boxShadow: [new BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 7.0,
                                ),]
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(100)),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CircleAvatar(
                                  radius: getProportionateScreenWidth(30),
                                  backgroundColor: Color(0xffFEC55F),//Color(0xFFDDDDDD),
                                  backgroundImage: photo == "" || photo == null || photo == "null" ? null : Image.memory(base64photo).image,
                                  child: Container(
                                    //color: Color(0xffFEC55F),
                                    margin: EdgeInsets.all(4),
                                    child: Container(
                                      child: photo == "" || photo == null || photo == "null" ? SvgPicture.asset(
                                        "assets/imageSVG/miramira.svg",
                                        height: getProportionateScreenHeight(20),
                                        fit: BoxFit.fitHeight,
                                      ) : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: getProportionateScreenWidth(16),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Text(
                                "Hello "+userName.toString(),
                                style: GoogleFonts.firaSans(
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              Text(
                                lvScore.toString()+"/10 LV Score | "+completedSprints.toString() +" Sprints",
                                style: GoogleFonts.firaSans(
                                  fontSize: 12,letterSpacing: 0,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(30),
                        vertical: getProportionateScreenHeight(15)),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              "RESULTS",
                              style: GoogleFonts.firaSans(
                                  color: Color(COLOR_ACCENT),
                                  fontSize: 16,letterSpacing: 1,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              "You can see all your results right here. The results over time will show your progress and help MiraMira refine your suggestions",
                              textScaleFactor: 1,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.firaSans(
                                  color: Colors.black,
                                  fontSize: 14,letterSpacing: 1,
                                  height: 1.35,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(20),),
                          ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: resultIds == null ? 0 : resultIds.length,
                            itemBuilder: (context, i) =>
                                Container(
                                  constraints: BoxConstraints.tightFor(width: double.infinity),
                                  child: Card(
                                    elevation: 0,
                                    semanticContainer: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      side: BorderSide(color: Color(0xFFDAE7FF), width: 1),
                                    ),
                                    child: ExpansionTile(
                                      title: Text("Result "+DateFormat("dd/MM/yyyy HH:mm").parse(resultDateTimes[i],true).toLocal().toString().substring(0,16),style: GoogleFonts.firaSans(
                                        fontSize: 18,
                                        color: Color(0xFF383838),
                                      ),),
                                      childrenPadding: EdgeInsets.symmetric(
                                          horizontal: getProportionateScreenWidth(15)),
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            completedSprints.toString()+" SPRINTS",
                                            style: GoogleFonts.firaSans(
                                              fontSize: 14,letterSpacing: 1,
                                              color: Color(0xFF383838),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 15,),
                                        Container(
                                          height: 1,
                                          color: Color(COLOR_ACCENT),
                                        ),
                                        SizedBox(height: 15,),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text("You are "+resultHighlights[i]+" person. Read on.",
                                            textAlign: TextAlign.left,
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.firaSans(
                                              fontSize: 18,letterSpacing: 1,
                                              color: Colors.blue[700],
                                            ),),
                                        ),
                                        SizedBox(height: 40,),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: GestureDetector(
                                            onTap: (){
                                              print("i : "+i.toString());
                                              if(resultDateTimes.length > 0 && i != resultDateTimes.length-1){
                                                print("true");
                                                Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                      pageBuilder: (c, a1, a2) => ResultDetails("", DateFormat("dd/MM/yyyy HH:mm").parse(resultDateTimes[i],true).toLocal().toString().substring(0,16), spiritQuadScore[i], spiritQuadDisplay[i], spiritBlurb[i], purposeQuadScore[i], purposeQuadDisplay[i], purposeBlurb[i],  professionQuadScore[i], professionQuadDisplay[i], professionBlurb[i], rewardQuadScore[i], rewardQuadDisplay[i], rewardBlurb[i], resultHighlights[i], spiritQuadScore[i+1], professionQuadScore[i+1], rewardQuadScore[i+1], purposeQuadScore[i+1]),
                                                      transitionsBuilder: (c, anim, a2, child) =>
                                                          FadeTransition(opacity: anim, child: child),
                                                      transitionDuration: Duration(milliseconds: 300),
                                                    )).whenComplete((){
                                                  if(viewCoursesPressed == true){
                                                    _tabPageController.animateToPage(2,
                                                        duration: Duration(milliseconds: 460), curve: Curves.easeOutCubic);
                                                  }else{

                                                  }
                                                });
                                              }else{
                                                Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                      pageBuilder: (c, a1, a2) => ResultDetails(0, DateFormat("dd/MM/yyyy HH:mm").parse(resultDateTimes[i],true).toLocal().toString().substring(0,16), spiritQuadScore[i], spiritQuadDisplay[i], spiritBlurb[i], purposeQuadScore[i], purposeQuadDisplay[i], purposeBlurb[i],  professionQuadScore[i], professionQuadDisplay[i], professionBlurb[i], rewardQuadScore[i], rewardQuadDisplay[i], rewardBlurb[i], resultHighlights[i], "10", "10", "10", "10"),
                                                      transitionsBuilder: (c, anim, a2, child) =>
                                                          FadeTransition(opacity: anim, child: child),
                                                      transitionDuration: Duration(milliseconds: 300),
                                                    )).whenComplete((){
                                                  if(viewCoursesPressed == true){
                                                    _tabPageController.animateToPage(2,
                                                        duration: Duration(milliseconds: 460), curve: Curves.easeOutCubic);
                                                  }else{

                                                  }
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: 150,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  border: Border.all(color: Colors.blue[700])
                                              ),
                                              child: Center(
                                                child: Text("VIEW DETAILS",style: GoogleFonts.firaSans(
                                                  fontSize: 18,
                                                  color: Colors.blue[700],
                                                  fontWeight: FontWeight.w500,
                                                ),),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 40,),
                                      ],
                                    ),
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  FirstHomeScreen(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      height: screenHeight/2,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Start with the Quiz!",
                textScaleFactor: 1,
                style: GoogleFonts.firaSans(
                    color: Color(COLOR_ACCENT),
                    fontSize: getProportionateScreenHeight(21),
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Center(
              child: Text(
                "An easy sprint of questions will make\nMiraMira discover your aptitude",
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: GoogleFonts.firaSans(
                  color: Colors.black,
                  letterSpacing: 1,
                  fontSize: getProportionateScreenHeight(17),
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Center(child: SvgPicture.asset("assets/iconSVG/robotupsidedown.svg")),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Text(
              "Go ahead, start your journey now.",
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: GoogleFonts.firaSans(
                  color: Color(0xFF3F4462),
                  letterSpacing: 1,
                  fontSize: getProportionateScreenHeight(15),
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50, bottom: 0),
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    width: getProportionateScreenWidth(173),
                    height: getProportionateScreenHeight(41)),
                child: ElevatedButton(
                    onPressed: () {
//                      setState(() {
//                        removeTakeQuizScreen = true;
//                      });
//                      print(removeTakeQuizScreen);
//                      Future.delayed(Duration(seconds: 2), () {
//                        setState(() {});
//                      });
                      push(context, QuizListScreen());
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(COLOR_ACCENT),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        textStyle: GoogleFonts.firaSans(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                        )),
                    child: Text(
                      "TAKE THE QUIZ",
                      textScaleFactor: 1,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  courseListScreenForResults(BuildContext context){
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: getProportionateScreenHeight(96),
                          color: Color(COLOR_ACCENT),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SvgPicture.asset(
                              "assets/imageSVG/HeaderSIdeDesign.svg",
                              height: getProportionateScreenHeight(96),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10, top: 60),
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: SvgPicture.asset("assets/iconSVG/square.svg")),
                        ),
                        Container(
                          height: getProportionateScreenHeight(96),
                          width: MediaQuery.of(context).size.width/1.2,
                          padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(20)),
                          color: Color(COLOR_ACCENT),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(100)),
                                    boxShadow: [new BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 7.0,
                                    ),]
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(100)),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CircleAvatar(
                                      radius: getProportionateScreenWidth(30),
                                      backgroundColor: Color(0xffFEC55F),//Color(0xFFDDDDDD),
                                      backgroundImage: photo == "" || photo == null || photo == "null" ? null : Image.memory(base64Decode(photo),).image,
                                      child: Container(
                                        //color: Color(0xffFEC55F),
                                        margin: EdgeInsets.all(4),
                                        child: Container(
                                          child: photo == "" || photo == null || photo == "null" ? SvgPicture.asset(
                                            "assets/imageSVG/miramira.svg",
                                            height: getProportionateScreenHeight(20),
                                            fit: BoxFit.fitHeight,
                                          ) : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: getProportionateScreenWidth(16),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Spacer(),
                                  Text(
                                    "Hello "+userName.toString(),
                                    style: GoogleFonts.firaSans(
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(10),
                                  ),
                                  Text(
                                    lvScore.toString()+"/10 LV Score | "+completedSprints.toString()+" Sprints",
                                    style: GoogleFonts.firaSans(
                                      fontSize: 12,letterSpacing: 0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(24),
                            vertical: getProportionateScreenHeight(15)),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              InkWell(
                                onTap: (){

                                },
                                child: Text(
                                  "COURSES",
                                  style: GoogleFonts.firaSans(
                                      color: Color(COLOR_ACCENT),
                                      fontSize: 16,letterSpacing: 1,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(10),
                              ),
                              Text(
                                "You can see all your course suggestions right here. You can decide to keep or discard the courses and that will help MiraMira sharpen your suggestions.",
                                textScaleFactor: 1,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.firaSans(
                                    color: Colors.black,height: 1.35,
                                    fontSize: 14,letterSpacing: 1,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: getProportionateScreenHeight(20),
                              ),
                              showAnimation == true && courseIds != null ? SlideMenu2(
                                  menuItems: [
                                    InkWell(
                                      onTap: (){

                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 4, left: 5),
                                        child: Container(
                                          width: 50,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(6)),
                                            border: Border.all(color: Color(0xff1E73BE)),
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset("assets/iconSVG/pin.svg",
                                                  color: Color(0xff1E73BE),
                                                ),
                                                SizedBox(height: 2,),
                                                Text("KEEP",
                                                  style: GoogleFonts.firaSans(
                                                      letterSpacing: 1,
                                                      color: Color(0xff1E73BE),
                                                      fontSize: 10
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  child: Container(
                                    constraints: BoxConstraints.tightFor(width: double.infinity),
                                    child: Card(
                                      elevation: 0,
                                      semanticContainer: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        side: BorderSide(color: Color(0xFFDAE7FF), width: 1),
                                      ),
                                      child: ExpansionTile(
                                        title: Text(
                                          "Swipe to keep",
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.firaSans(
                                            fontSize: 18,
                                            color: Color(0xFF383838),
                                          ),
                                        ),
                                        childrenPadding:
                                        EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
                                        children: [

                                        ],
                                      ),
                                    ),
                                  )
                              ) : Container(),
                              ListView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: courseNames == null ? 0 : courseNames.length,
                                itemBuilder: (context, i) =>
                                    CourseTile(
                                      index: i,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/1.32, right: 20),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        resultPosition = "1";
                      });
                    },
                    child: Container(
                      height: 45,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Color(COLOR_ACCENT),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text("< Results",
                          textScaleFactor: 1,
                          style: GoogleFonts.firaSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            letterSpacing: 1,
                            fontSize: 14
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class QuizListScreen extends StatefulWidget {
  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  bool _isloaded = false;

  Future InitTask() async {
    Provider.of<CustomViewModel>(context, listen: false)
        .GetProfileData()
        .then((value) {
      Provider.of<CustomViewModel>(context, listen: false)
          .GetSprints()
          .then((value) => {
        setState(() {
          _isloaded = true;
        })
      });
    });
  }

  back(){
    setState(() {
      removeTakeQuizScreen = false;
    });
    print(removeTakeQuizScreen);
    Future.delayed(Duration(seconds: 2), (){
      setState(() {

      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InitTask();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: _isloaded == false
              ? Center(
            child: Center(
              child: new CircularProgressIndicator(
                strokeWidth: 1,
                backgroundColor: Color(COLOR_WHITE),
                valueColor:
                AlwaysStoppedAnimation<Color>(Color(COLOR_PRIMARY)),
              ),
            ),
          )
              : WillPopScope(
            onWillPop: ()=> back(),
            child: Container(
              child: Column(
                children: [
                  //Top Profile
                  Container(
                    height: getProportionateScreenHeight(110),
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20)),
                    color: Color(COLOR_ACCENT),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                              boxShadow: [new BoxShadow(
                                color: Colors.black,
                                blurRadius: 7.0,
                              ),]
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(100)),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CircleAvatar(
                                radius: getProportionateScreenWidth(30),
                                backgroundColor: Color(0xffFEC55F),//Color(0xFFDDDDDD),
                                backgroundImage: photo == "" || photo == null || photo == "null" ? null : Image.memory(base64photo).image,
                                child: Container(
                                  //color: Color(0xffFEC55F),
                                  margin: EdgeInsets.all(4),
                                  child: Container(
                                    child: photo == "" || photo == null || photo == "null" ? SvgPicture.asset(
                                      "assets/imageSVG/miramira.svg",
                                      height: getProportionateScreenHeight(20),
                                      fit: BoxFit.fitHeight,
                                    ) : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: getProportionateScreenWidth(16),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Text(
                              "Hello " +
                                  (providerListener.userDetails.name ??
                                      ""), //userName.toString(),
                              style: GoogleFonts.firaSans(
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lvScore.toString()+"/10 LV Score | "+completedSprints.toString() +" Sprints",
                                  style: GoogleFonts.firaSans(
                                    fontSize: 12,letterSpacing: 0,
                                    color: Colors.white,
                                  ),
                                ),
                                ScoreAndProgressBar2(
                                  lvScore: double.parse(lvScore.toString()),
                                  numberOfCompletedSprints: int.parse(providerListener.userDetails.numberOfCompletedSprints??"0"),
                                ),
                              ],
                            ),
                            Spacer(),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20),
                          vertical: getProportionateScreenHeight(15)),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Text(
                                "QUIZ",textScaleFactor: 1,
                                style: GoogleFonts.firaSans(
                                    color: Color(COLOR_ACCENT),
                                    fontSize: 16,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Text(
                                "Attempt as many sprints and get accurate results and suggestions. As you go try to get a stronger life vector score for better accuracy. Have fun!",
                                textScaleFactor: 1,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.firaSans(
                                    color: Colors.black,
                                    height: 1.35,
                                    fontSize: 14,letterSpacing: 1,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
                            providerListener.sprintList.length > 0
                                ? ListView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:
                                providerListener.sprintList.length,
                                itemBuilder: (context, sprintIndex) {
                                  return Card(
                                    elevation: 0,
                                    shape: new RoundedRectangleBorder(
                                        side: new BorderSide(
                                            color: Color(0xFFDAE7FF),
                                            width: 2.0),
                                        borderRadius:
                                        BorderRadius.circular(4.0)),
                                    child: ExpansionPanelList(
                                        elevation: 0,
                                        animationDuration:
                                        const Duration(seconds: 2),
                                        expandedHeaderPadding:
                                        EdgeInsets.all(10),
                                        dividerColor: Color(0xFFDAE7FF),
                                        expansionCallback:
                                            (int item, bool isExpanded) {
                                          setState(() {
                                            print(providerListener
                                                .tempattendingSprintIndex);
                                            print(sprintIndex);
                                            if (providerListener
                                                .tempattendingSprintIndex ==
                                                -1) {
                                              if (sprintIndex <=
                                                  providerListener
                                                      .attendingSprintIndex) {
                                                if (providerListener
                                                    .tempattendingSprintIndex ==
                                                    sprintIndex) {
                                                  providerListener
                                                      .tempattendingSprintIndex = -1;
                                                } else {
                                                  providerListener
                                                      .ListOfQuizList[
                                                  sprintIndex]
                                                      .clear();
                                                  Provider.of<CustomViewModel>(
                                                      context,
                                                      listen: false)
                                                      .GetQuizBySprintsId(
                                                      providerListener
                                                          .sprintList[
                                                      sprintIndex]
                                                          .id,
                                                      sprintIndex);
                                                  providerListener
                                                      .tempattendingSprintIndex =
                                                      sprintIndex;
                                                }
                                              } else {
                                                toastCommon(context,
                                                    "Please complete previous sprints!");
                                              }
                                            } else if (sprintIndex <=
                                                providerListener
                                                    .attendingSprintIndex) {
                                              if (providerListener
                                                  .tempattendingSprintIndex ==
                                                  sprintIndex) {
                                                providerListener
                                                    .tempattendingSprintIndex = -1;
                                              } else {
                                                providerListener
                                                    .ListOfQuizList[
                                                sprintIndex]
                                                    .clear();
                                                Provider.of<CustomViewModel>(
                                                    context,
                                                    listen: false)
                                                    .GetQuizBySprintsId(
                                                    providerListener
                                                        .sprintList[
                                                    sprintIndex]
                                                        .id,
                                                    sprintIndex);
                                                providerListener
                                                    .tempattendingSprintIndex =
                                                    sprintIndex;
                                              }
                                            } else {
                                              toastCommon(context,
                                                  "Please complete previous sprints!");
                                            }
                                          });
                                        },
                                        children: [
                                          ExpansionPanel(
                                              isExpanded: sprintIndex ==
                                                  providerListener
                                                      .tempattendingSprintIndex,
                                              canTapOnHeader: true,
                                              headerBuilder:
                                                  (BuildContext context,
                                                  bool isExpanded) {
                                                return Container(
                                                  padding: EdgeInsets.only(
                                                      left: 12,
                                                      right: 20,
                                                      bottom: 10,
                                                      top: 10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            providerListener
                                                                .sprintList[
                                                            sprintIndex]
                                                                .sprintName,
                                                            style: GoogleFonts
                                                                .firaSans(
                                                              fontSize: 18,
                                                              color: Color(
                                                                  0xFF383838),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          sprintIndex ==
                                                              providerListener
                                                                  .tempattendingSprintIndex
                                                              ? Align(
                                                            alignment:
                                                            Alignment
                                                                .topLeft,
                                                            child:
                                                            Text(
                                                              "5 QUIZES OF 5 QUESTIONS",
                                                              style: GoogleFonts
                                                                  .firaSans(
                                                                fontSize:
                                                                14,
                                                                color:
                                                                Color(0xFF383838),
                                                              ),
                                                            ),
                                                          )
                                                              : SizedBox(
                                                            height: 1,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              body: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                    getProportionateScreenWidth(
                                                        15)),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Container(
                                                      height: 1,
                                                      color: Color(
                                                          COLOR_ACCENT),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Container(
                                                        height:
                                                        getProportionateScreenHeight(
                                                            240),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                            vertical:
                                                            10),
                                                        child:
                                                        GridView.count(
                                                          shrinkWrap: true,
                                                          crossAxisCount: 3,
                                                          crossAxisSpacing:
                                                          2.5,
                                                          mainAxisSpacing:
                                                          2.5,
                                                          physics:
                                                          NeverScrollableScrollPhysics(),
                                                          children: List.generate(
                                                              providerListener
                                                                  .ListOfQuizList[
                                                              sprintIndex]
                                                                  .length,
                                                                  (quizIndex) {
                                                                return QuizCircularIndicator(
                                                                    index:
                                                                    quizIndex,
                                                                    sprintIndex:
                                                                    sprintIndex,
                                                                    sprintId: providerListener
                                                                        .sprintList[
                                                                    sprintIndex]
                                                                        .sprintId);
                                                              }),
                                                        )),
                                                  ],
                                                ),
                                              )),
                                        ]),
                                  );
                                })

                            /*ListView.builder(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          providerListener.sprintList.length,
                                      itemBuilder: (context, i) => SpritList(
                                            index: i,
                                            id: providerListener.sprintList[i].id,
                                          ))*/
                                : SizedBox(
                              height: getProportionateScreenHeight(1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class SpritList extends StatefulWidget {
  const SpritList({
    Key key,
    this.id,
    this.index,
  }) : super(key: key);

  final int index;
  final String id;

  @override
  _SpritListState createState() => _SpritListState();
}

class _SpritListState extends State<SpritList> {
  PageStorageKey _key;

  @override
  Widget build(BuildContext context) {
    _key = new PageStorageKey('${widget.index}');
    final providerListener = Provider.of<CustomViewModel>(context);

    return Container(
      constraints: BoxConstraints.tightFor(width: double.infinity),
      child: Card(
          elevation: 0,
          semanticContainer: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: Color(0xFFDAE7FF), width: 1),
          ),
          child: (providerListener.sprintList[widget.index].sprintStatus ==
              "COMPLETED" ||
              widget.index == providerListener.attendingSprintIndex)
              ? ExpansionTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  providerListener.sprintList[widget.index].sprintName,
                  style: GoogleFonts.firaSans(
                    fontSize: 18,
                    color: Color(0xFF383838),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "5 QUIZZES OF 5 QUESTIONS",
                    style: GoogleFonts.firaSans(
                      fontSize: 14,
                      color: Color(0xFF383838),
                    ),
                  ),
                ),
              ],
            ),
            initiallyExpanded:
            widget.index == providerListener.attendingSprintIndex,
            onExpansionChanged: (val) {
              print(val);
              if (val == true) {
                Provider.of<CustomViewModel>(context, listen: false)
                    .GetQuizBySprintsId(widget.id, widget.index);
              }
            },
            childrenPadding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(15)),
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 1,
                    color: Color(COLOR_ACCENT),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: getProportionateScreenHeight(300),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: GridView.count(
                        shrinkWrap: true,
                        key: ValueKey(widget.index),
                        crossAxisCount: 3,
                        crossAxisSpacing: 2.5,
                        mainAxisSpacing: 2.5,
                        physics: NeverScrollableScrollPhysics(),
                        children: List.generate(
                            providerListener.ListOfQuizList[widget.index]
                                .length, (index) {
                          return QuizCircularIndicator(
                              index: index,
                              sprintIndex: widget.index,
                              sprintId: widget.id);
                        }),
                      )),
                ],
              )
            ],
          )
              : Container(
            padding:
            EdgeInsets.only(left: 12, right: 20, bottom: 10, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      providerListener
                          .sprintList[widget.index].sprintName,
                      style: GoogleFonts.firaSans(
                        fontSize: 18,
                        color: Color(0xFF383838),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: getProportionateScreenWidth(15),
                  color: Color(0xFF6C6C6C),
                ),
              ],
            ),
          )),
    );
  }
}

class QuizCircularIndicator extends StatefulWidget {
  const QuizCircularIndicator({
    Key key,
    this.index,
    this.sprintIndex,
    this.sprintId,
  }) : super(key: key);

  final int index;
  final int sprintIndex;
  final String sprintId;

  @override
  _QuizCircularIndicatorState createState() => _QuizCircularIndicatorState();
}

class _QuizCircularIndicatorState extends State<QuizCircularIndicator> {

  Future<String> loadUserProfile(context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    isSignedIn = prefs.getString("userID").toString();

    print(isSignedIn);

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/loadUserProfile?userId=$isSignedIn";

    http.get(Uri.parse(url)).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseLoadUserProfile = jsonDecode(response.body);
      print(responseLoadUserProfile);

      var msg = responseLoadUserProfile['status'].toString();
      if(msg == "SUCCESS"){
        setState(() {
          completedSprints = responseLoadUserProfile['numberOfCompletedSprints'].toString();
          userName = responseLoadUserProfile['userDetails']['name'].toString();
          lvScore = responseLoadUserProfile['userDetails']['lvScore'].toString() == "null" || responseLoadUserProfile['userDetails']['lvScore'].toString() == "" ? "0" : responseLoadUserProfile['userDetails']['lvScore'].toString();
          grade = responseLoadUserProfile['userDetails']['schoolGrade'].toString() == "" ? "" : responseLoadUserProfile['userDetails']['schoolGrade'].toString();
          schoolOrProfession = responseLoadUserProfile['userDetails']['schoolGrade'].toString() == "" ? "" : responseLoadUserProfile['userDetails']['school'].toString();
          state = responseLoadUserProfile['userDetails']['state'].toString() == "" ? "" : responseLoadUserProfile['userDetails']['state'].toString();
          county = responseLoadUserProfile['userDetails']['county'].toString() == "" ? "" : responseLoadUserProfile['userDetails']['county'].toString();
          isMentor = responseLoadUserProfile['userDetails']['isMentor'].toString();
          myId = responseLoadUserProfile['userDetails']['_id'].toString();
          if(responseLoadUserProfile['userDetails']['userPhoto'].toString() == photo.toString()){

          }else{
            photo = responseLoadUserProfile['userDetails']['userPhoto'].toString() == "" ? null : responseLoadUserProfile['userDetails']['userPhoto'].toString();
          }
          visited = responseLoadUserProfile['userDetails']['visits'].toString();
          userType = responseLoadUserProfile['userDetails']['userType'].toString();
        });
        print(completedSprints.toString());
        print(userName.toString());
        print(lvScore.toString());
        print(grade.toString());
        print(schoolOrProfession.toString());
        print(state.toString());
        print(county.toString());
        print(isMentor.toString());
        print(myId.toString());
        print(photo.toString());
        print(visited.toString());
        print("userType : "+userType.toString());

        setState(() {
          base64photo = base64Decode(photo);
        });

      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return GestureDetector(
      onTap: () {
        if (int.parse(providerListener
            .ListOfQuizList[widget.sprintIndex][widget.index]
            .totalQuestionCount) <=
            (int.parse(providerListener
                .ListOfQuizList[widget.sprintIndex][widget.index]
                .completedQuestionCount) +
                int.parse(providerListener
                    .ListOfQuizList[widget.sprintIndex][widget.index]
                    .skippedQuestionCount))) {
          toastCommon(
              context,
              "You have completed " +
                  providerListener
                      .ListOfQuizList[widget.sprintIndex][widget.index]
                      .quizName ??
                  "");
        } else {
          print(providerListener
              .ListOfQuizList[widget.sprintIndex][widget.index].id);

          if (widget.index == 0) {
            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => QuestionsPageViewBuilder(
                      widget.sprintId,
                      widget.sprintIndex,
                      providerListener
                          .ListOfQuizList[widget.sprintIndex][widget.index].id,
                      providerListener
                          .ListOfQuizList[widget.sprintIndex][widget.index]
                          .quizId,
                      widget.index,
                      providerListener
                          .ListOfQuizList[widget.sprintIndex][widget.index]
                          .totalQuestionCount,
                      providerListener
                          .ListOfQuizList[widget.sprintIndex][widget.index]
                          .completedQuestionCount),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 300),
                )).whenComplete((){
                  if(viewResultsPressed == true){
                    print("viewResultsPressed : "+viewResultsPressed.toString());
                    _tabPageController.animateToPage(1,
                        duration: Duration(milliseconds: 460), curve: Curves.easeOutCubic);
                    loadUserProfile(context);
                  }else{
                    print("viewResultsPressed : "+viewResultsPressed.toString());
                    loadUserProfile(context);
                  }
            });
          } else if ((int.parse(providerListener
              .ListOfQuizList[widget.sprintIndex][widget.index - 1]
              .completedQuestionCount) +
              int.parse(providerListener
                  .ListOfQuizList[widget.sprintIndex][widget.index - 1]
                  .skippedQuestionCount)) ==
              int.parse(providerListener
                  .ListOfQuizList[widget.sprintIndex][widget.index - 1]
                  .totalQuestionCount)) {
            Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => QuestionsPageViewBuilder(
                      widget.sprintId,
                      widget.sprintIndex,
                      providerListener
                          .ListOfQuizList[widget.sprintIndex][widget.index].id,
                      providerListener
                          .ListOfQuizList[widget.sprintIndex][widget.index]
                          .quizId,
                      widget.index,
                      providerListener
                          .ListOfQuizList[widget.sprintIndex][widget.index]
                          .totalQuestionCount,
                      providerListener
                          .ListOfQuizList[widget.sprintIndex][widget.index]
                          .completedQuestionCount),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 300),
                )).whenComplete((){
              if(viewResultsPressed == true){
                print("viewResultsPressed : "+viewResultsPressed.toString());
                _tabPageController.animateToPage(1,
                    duration: Duration(milliseconds: 460), curve: Curves.easeOutCubic);
                loadUserProfile(context);
              }else{
                print("viewResultsPressed : "+viewResultsPressed.toString());
                loadUserProfile(context);
              }
            });
          }else{
            toastCommon(context,
                "Please complete previous quiz!");
          }
        }

        /*push(context, MyHomePage("test"));*/
      },
      child: CircularPercentIndicator(
        radius: 95,
        lineWidth: getProportionateScreenWidth(8),
        percent: ((int.parse(providerListener.ListOfQuizList[widget.sprintIndex][widget.index].completedQuestionCount) +
            int.parse(providerListener
                .ListOfQuizList[widget.sprintIndex]
            [widget.index]
                .skippedQuestionCount)) /
            int.parse(providerListener
                .ListOfQuizList[widget.sprintIndex][widget.index]
                .totalQuestionCount))
            .toDouble() >
            1.0
            ? 1.0
            : (int.parse(providerListener
            .ListOfQuizList[widget.sprintIndex][widget.index]
            .completedQuestionCount) +
            int.parse(providerListener
                .ListOfQuizList[widget.sprintIndex][widget.index]
                .skippedQuestionCount)) /
            int.parse(providerListener.ListOfQuizList[widget.sprintIndex][widget.index].totalQuestionCount).toDouble(),
        backgroundColor: Colors.white,
        center: CircleAvatar(
          radius: 40,
          backgroundColor: Color(0xFFEDF3FE),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                providerListener
                    .ListOfQuizList[widget.sprintIndex][widget.index].quizName,
                style: GoogleFonts.firaSans(
                    color: Color(0xFF3F4462),
                    fontWeight: FontWeight.w500,
                    fontSize: 16),
              ),
              SizedBox(
                height: getProportionateScreenHeight(3),
              ),
              int.parse(providerListener
                  .ListOfQuizList[widget.sprintIndex][widget.index]
                  .totalQuestionCount) <=
                  (int.parse(providerListener
                      .ListOfQuizList[widget.sprintIndex][widget.index]
                      .completedQuestionCount))
                  ? SizedBox(
                height: 0,
              )
                  : Text(
                providerListener
                    .ListOfQuizList[widget.sprintIndex][widget.index]
                    .completedQuestionCount
                    .toString() +
                    "/" +
                    providerListener
                        .ListOfQuizList[widget.sprintIndex][widget.index]
                        .totalQuestionCount,
                style: GoogleFonts.firaSans(
                    color: Color(COLOR_ACCENT),
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
              SizedBox(
                height: getProportionateScreenHeight(3),
              ),
              int.parse(providerListener
                  .ListOfQuizList[widget.sprintIndex][widget.index]
                  .totalQuestionCount) <=
                  (int.parse(providerListener
                      .ListOfQuizList[widget.sprintIndex][widget.index]
                      .completedQuestionCount))
                  ? Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 15,
                ),
              )
                  : SizedBox(
                height: 0,
              )
            ],
          ),
        ),
        progressColor: int.parse(providerListener
            .ListOfQuizList[widget.sprintIndex][widget.index]
            .totalQuestionCount) <=
            (int.parse(providerListener
                .ListOfQuizList[widget.sprintIndex][widget.index]
                .completedQuestionCount))
            ? Colors.grey[300]
            : Color(0xFFC0D6FF),
      ),
    );
  }
}

class logoutButton extends StatelessWidget {
  const logoutButton({
    Key key, this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
          width: getProportionateScreenWidth(321),
          height: getProportionateScreenHeight(55)),
      child: ElevatedButton(
        onPressed: () async {
          _tabPageController.animateToPage(0,
              duration: Duration(milliseconds: 460), curve: Curves.easeOutCubic);
          print("enfjwehf");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.clear().whenComplete((){
            googleSignIn.disconnect();
            Fluttertoast.showToast(msg: "Logged out", backgroundColor: Color(COLOR_ACCENT), textColor: Colors.white);
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => LoginScreen(),
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 300),
                ));
          });
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(16)),
          onPrimary: Color(COLOR_ACCENT),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                  color: Color(0xFFC14444), width: 2)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/iconSVG/logout.svg",
              height: getProportionateScreenWidth(25),
            ),
            SizedBox(
              width: getProportionateScreenWidth(21),
            ),
            Text(
              "Logout",
              style: GoogleFonts.firaSans(
                  fontSize: 18,
                  color: Color(0xFFC14444),
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingCustomButton extends StatelessWidget {
  const SettingCustomButton({
    Key key, this.text, this.imgPath, this.onTap,
  }) : super(key: key);
  final String text,imgPath;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
          width: getProportionateScreenWidth(321),
          height: getProportionateScreenHeight(55)),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(16)),
          onPrimary: Color(COLOR_ACCENT),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                  color: Color(0xFFDAE7FF), width: 2)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              imgPath,
              height: getProportionateScreenWidth(25),
            ),
            SizedBox(
              width: getProportionateScreenWidth(21),
            ),
            Text(
              text,
              style: GoogleFonts.firaSans(
                  fontSize: 18,
                  color: Color(0xFF383838),
                  fontWeight: FontWeight.normal),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF8B8B8B),
            )
          ],
        ),
      ),
    );
  }
}

class ProfileButton extends StatefulWidget {
  const ProfileButton({
    Key key,
    this.name,
    this.email,
    this.profileImg,
    this.percentage,
    this.onPressed,
  }) : super(key: key);

  final String name, email, profileImg;
  final double percentage;
  final Function onPressed;

  @override
  _ProfileButtonState createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {

  bool _isloaded = false;
  Future InitTask() async {
    Provider.of<CustomViewModel>(context, listen: false)
        .GetProfileData()
        .then((value) {
      Provider.of<CustomViewModel>(context, listen: false)
          .GetSprints()
          .then((value) => {
        setState(() {
          _isloaded = true;
        })
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InitTask();
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);
    return
//      _isloaded == false
//        ? Shimmer.fromColors(
//          baseColor: Colors.white,
//          highlightColor: Colors.grey.shade300,
//          child: ConstrainedBox(
//      constraints: BoxConstraints.tightFor(
//            width: getProportionateScreenWidth(321),
//            height: getProportionateScreenHeight(150)),
//      child: ElevatedButton(
//          onPressed: widget.onPressed,
//          style: ElevatedButton.styleFrom(
//            primary: Color(0xff1E73BE),
//            elevation: 0,
//            padding: EdgeInsets.all(getProportionateScreenWidth(16)),
//            onPrimary: Color(0xff1E73BE),
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.circular(8),
//                side: BorderSide(color: Color(0xff1E73BE), width: 2)),
//          ),
//          child: Row(
//            children: [
//              Container(
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.all(Radius.circular(100)),
//                    boxShadow: [new BoxShadow(
//                      color: Colors.black,
//                      blurRadius: 7.0,
//                    ),]
//                ),
//                child: Container(
//                  decoration: BoxDecoration(
//                    borderRadius: BorderRadius.all(Radius.circular(100)),
//                    color: Colors.white,
//                  ),
//                  child: Padding(
//                    padding: const EdgeInsets.all(5.0),
//                    child: CircleAvatar(
//                      radius: getProportionateScreenWidth(30),
//                      backgroundColor: Color(0xffFEC55F),
//                      backgroundImage: photo == "" || photo == null || photo == "null" ? null : Image.memory(base64photo).image,
//                      child: Container(
//                        //color: photo == "" || photo == null || photo == "null" ? Color(0xffFEC55F) : Colors.transparent,
//                        margin: EdgeInsets.all(4),
//                        child: Container(
//                          child: photo == "" || photo == null || photo == "null" ? SvgPicture.asset(
//                            "assets/imageSVG/miramira.svg",
//                            height: getProportionateScreenHeight(20),
//                            fit: BoxFit.fitHeight,
//                          ) : null,
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//              SizedBox(
//                width: getProportionateScreenWidth(21),
//              ),
//              Column(
//                mainAxisAlignment: MainAxisAlignment.start,
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: [
//                  Text(
//                    "My Profile",
//                    style: GoogleFonts.firaSans(
//                        fontSize: 18, color: Colors.white),
//                  ),
//                  Spacer(),
//                  Text(
//                    userName.toString(),//name,
//                    style: GoogleFonts.firaSans(
//                        fontSize: 15,
//                        color: Colors.white,
//                        fontWeight: FontWeight.bold),
//                  ),
//                  Spacer(),
//                  Text(
//                    isSignedIn.toString(),
//                    style: GoogleFonts.firaSans(
//                      fontSize: 14,
//                      color: Colors.white,
//                    ),
//                  ),
//                  SizedBox(
//                    height: getProportionateScreenHeight(14),
//                  ),
//                  ScoreAndProgressBar2(
//                    lvScore: double.parse(lvScore.toString()),
//                    numberOfCompletedSprints: int.parse(providerListener.userDetails.numberOfCompletedSprints??"0"),
//                  ),
////                ScoreAndProgressBar(
////                  percent: (double.parse(completedSprints)/14.0),
////                  sprints: double.parse(completedSprints.toString()),
////                  textColor: Colors.white,
////                ),
//                ],
//              ),
//              Spacer(),
//              Icon(
//                Icons.arrow_forward_ios,
//                color: Colors.white,
//              ),
//            ],
//          ),
//      ),
//    ),
//        ) :
    ConstrainedBox(
      constraints: BoxConstraints.tightFor(
          width: getProportionateScreenWidth(321),
          height: getProportionateScreenHeight(150)),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          primary: Color(0xff1E73BE),
          elevation: 0,
          padding: EdgeInsets.all(getProportionateScreenWidth(16)),
          onPrimary: Color(0xff1E73BE),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Color(0xff1E73BE), width: 2)),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  boxShadow: [new BoxShadow(
                    color: Colors.black,
                    blurRadius: 7.0,
                  ),]
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(
                    radius: getProportionateScreenWidth(30),
                    backgroundColor: Color(0xffFEC55F),
                    backgroundImage: photo == "" || photo == null || photo == "null" ? null : Image.memory(base64photo).image,
                    child: Container(
                      //color: photo == "" || photo == null || photo == "null" ? Color(0xffFEC55F) : Colors.transparent,
                      margin: EdgeInsets.all(4),
                      child: Container(
                        child: photo == "" || photo == null || photo == "null" ? SvgPicture.asset(
                          "assets/imageSVG/miramira.svg",
                          height: getProportionateScreenHeight(20),
                          fit: BoxFit.fitHeight,
                        ) : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: getProportionateScreenWidth(21),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My Profile",
                  style: GoogleFonts.firaSans(
                      fontSize: 18, color: Colors.white),
                ),
                Spacer(),
                Text(
                  userName.toString(),//name,
                  style: GoogleFonts.firaSans(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  isSignedIn.toString(),
                  style: GoogleFonts.firaSans(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(14),
                ),
                ScoreAndProgressBar2(
                  lvScore: double.parse(providerListener.userDetails.lvScore==""?"0":(providerListener.userDetails.lvScore??"0")),
                  numberOfCompletedSprints: int.parse(providerListener.userDetails.numberOfCompletedSprints??"0"),
                ),
//                ScoreAndProgressBar(
//                  percent: (double.parse(completedSprints)/14.0),
//                  sprints: double.parse(completedSprints.toString()),
//                  textColor: Colors.white,
//                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

var tmp;

class ScoreAndProgressBar extends StatelessWidget {
  ScoreAndProgressBar({
    Key key,
    this.percent,
    this.sprints, this.textColor,
  }) : super(key: key);
  final double percent, sprints;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    double _progPercent = percent / 100;
    double _progtextPercent = percent / 10;
    if(_progtextPercent.toString().length > 6){
      tmp = _progtextPercent.toString().substring(0,5);
    }else{
      tmp = _progtextPercent.toString();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$tmp/10 LV Score | $sprints Sprints",
          style: GoogleFonts.firaSans(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 10),
        ),
        SizedBox(
          height: getProportionateScreenHeight(10),
        ),
        LinearPercentIndicator(
            backgroundColor: Colors.grey[500],
            progressColor: Colors.yellow[700],
            padding: EdgeInsets.zero,
            animation: true,
            width: getProportionateScreenWidth(144),
            lineHeight: getProportionateScreenHeight(4),
            percent: _progPercent),
      ],
    );
  }
}

class ScoreAndProgressBar2 extends StatelessWidget {
  ScoreAndProgressBar2({
    Key key,
    this.lvScore,
    this.numberOfCompletedSprints,
  }) : super(key: key);
  final double lvScore;
  final int numberOfCompletedSprints;

  @override
  Widget build(BuildContext context) {
    double _progPercent = lvScore / 10;
    double _progPercentText = (lvScore);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: getProportionateScreenHeight(14),
        ),
        LinearPercentIndicator(
            backgroundColor: Colors.grey[200],
            progressColor: Color(0xFFFEC55F),
            padding: EdgeInsets.zero,
            animation: true,
            width: getProportionateScreenWidth(144),
            lineHeight: getProportionateScreenHeight(4),
            percent: _progPercent),
      ],
    );
  }
}

var grade;
var schoolOrProfession;
var state;
var county;
var isMentor;
var myId;
var photo;
var visited;

/*
class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  back(){
    setState(() {
      removeMoreScreen = false;
    });
    print(removeMoreScreen);
    Future.delayed(Duration(seconds: 2), (){
      setState(() {

      });
    });
  }

  Future<String> loadUserProfile(context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    isSignedIn = prefs.getString("userID").toString();

    print(isSignedIn);

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/loadUserProfile?userId=$isSignedIn";

    http.get(Uri.parse(url)).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseLoadUserProfile = jsonDecode(response.body);
      print(responseLoadUserProfile);

      var msg = responseLoadUserProfile['status'].toString();
      if(msg == "SUCCESS"){
        setState(() {
          completedSprints = responseLoadUserProfile['numberOfCompletedSprints'].toString();
          userName = responseLoadUserProfile['userDetails']['name'].toString();
          lvScore = responseLoadUserProfile['userDetails']['lvScore'].toString() == "null" || responseLoadUserProfile['userDetails']['lvScore'].toString() == "" ? "0" : responseLoadUserProfile['userDetails']['lvScore'].toString();
          grade = responseLoadUserProfile['userDetails']['schoolGrade'].toString() == "" ? "" : responseLoadUserProfile['userDetails']['schoolGrade'].toString();
          schoolOrProfession = responseLoadUserProfile['userDetails']['schoolGrade'].toString() == "" ? "" : responseLoadUserProfile['userDetails']['schoolGrade'].toString();
          state = responseLoadUserProfile['userDetails']['location'].toString() == "" ? "" : responseLoadUserProfile['userDetails']['location'].toString();
          county = responseLoadUserProfile['userDetails']['county'].toString() == "" ? "" : responseLoadUserProfile['userDetails']['county'].toString();
          isMentor = responseLoadUserProfile['userDetails']['isMentor'].toString();
          myId = responseLoadUserProfile['userDetails']['_id'].toString();
          photo = responseLoadUserProfile['userDetails']['userPhoto'].toString();
          visited = responseLoadUserProfile['userDetails']['visits'].toString();
        });
        print(completedSprints.toString());
        print(userName.toString());
        print(lvScore.toString());
        print(grade.toString());
        print(schoolOrProfession.toString());
        print(state.toString());
        print(county.toString());
        print(isMentor.toString());
        print(myId.toString());
        print(photo.toString());
        print(visited.toString());
      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserProfile(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: ()=> back(),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: getProportionateScreenHeight(96),
                color: Color(COLOR_ACCENT),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(getProportionateScreenWidth(10)),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFDAE7FF), width: 2),
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.white,
                ),
                height: getProportionateScreenHeight(910),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Screenshot(
                        controller: screenshotController,
                        child: Container(
                          height: getProportionateScreenHeight(500),
                          padding: EdgeInsets.all(
                            getProportionateScreenWidth(22),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.white),
                              color: Color(COLOR_ACCENT)),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        back();
                                        //Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.arrow_back_ios_rounded,
                                        size: getProportionateScreenWidth(25),
                                        color: Colors.white,
                                      )),
                                  SizedBox(
                                    width: getProportionateScreenWidth(12),
                                  ),
                                  Text(
                                    "My Profile",
                                    textScaleFactor: 1,
                                    style: GoogleFonts.firaSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                      onTap: () {
                                        back();
                                      },
                                      child: Icon(
                                        Icons.close,
                                        size: getProportionateScreenWidth(30),
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (c, a1, a2) => EditProfileScreen(myId, userName, isSignedIn, grade, schoolOrProfession, state, county),
                                            transitionsBuilder: (c, anim, a2, child) =>
                                                FadeTransition(opacity: anim, child: child),
                                            transitionDuration: Duration(milliseconds: 300),
                                          )).whenComplete((){
                                        loadUserProfile(context);
                                      });
                                    },
                                    child: SvgPicture.asset(
                                      "assets/iconSVG/editProfIcon.svg",
                                      height: getProportionateScreenWidth(21),
                                    ),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenWidth(26),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List image) async {
                                        if (image != null) {
                                          final directory = await getApplicationDocumentsDirectory();
                                          final imagePath = await File('${directory.path}/image.png').create();
                                          await imagePath.writeAsBytes(image);

                                          /// Share Plugin
                                          await Share.shareFiles([imagePath.path],text: 'Here\'s my profile card on MiraMira');
                                        }
                                      });
                                    },
                                    child: SvgPicture.asset(
                                      "assets/iconSVG/shareOutlineWhite.svg",
                                      height: getProportionateScreenWidth(21),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(100)),
                                        boxShadow: [new BoxShadow(
                                          color: Colors.black,
                                          blurRadius: 7.0,
                                        ),]
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(100)),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: CircleAvatar(
                                          radius: getProportionateScreenWidth(49),
                                          backgroundColor: Color(0xffFEC55F),//Color(0xFFDDDDDD),
                                          backgroundImage: photo == "" || photo == null || photo == "null" ? null : Image.memory(base64Decode(photo),).image,
                                          child: Container(
                                            //color: Color(0xffFEC55F),
                                            margin: EdgeInsets.all(4),
                                            child: Container(
                                              child: photo == "" || photo == null || photo == "null" ? SvgPicture.asset(
                                                "assets/imageSVG/miramira.svg",
                                                height: getProportionateScreenHeight(20),
                                                fit: BoxFit.fitHeight,
                                              ) : null,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenWidth(16),
                                  ),
                                  Container(
                                    //width: getProportionateScreenWidth(126),
                                    height: getProportionateScreenHeight(82),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: getProportionateScreenWidth(126),
                                          child: Text(
                                            userName.toString(),textScaleFactor: 1,
                                            style: GoogleFonts.firaSans(
                                                fontSize: 22,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        SizedBox(
                                          height: getProportionateScreenWidth(10),
                                        ),
                                        Container(
                                          width: getProportionateScreenWidth(156),
                                          child: Text(
                                            isSignedIn.toString(),textScaleFactor: 1,
                                            style: GoogleFonts.firaSans(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ScoreAndProgressBar3(
                                    percent: double.parse(completedSprints)/double.parse(sprintNames.length.toString()),
                                    sprints: double.parse(completedSprints.toString()),
                                    textColor: Colors.white,
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenWidth(49),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "GRADE",textScaleFactor: 1,
                                        style: GoogleFonts.firaSans(
                                            color: Colors.white,
                                            letterSpacing: 2,
                                            fontSize: 13),
                                      ),
                                      Text(
                                        grade.toString(),textScaleFactor: 1,
                                        style: GoogleFonts.firaSans(
                                            color: Colors.white,
                                            letterSpacing: 2,
                                            fontSize: 16),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "SCHOOL",textScaleFactor: 1,
                                        style: GoogleFonts.firaSans(
                                            color: Colors.white,
                                            letterSpacing: 2,
                                            fontSize: 13),
                                      ),
                                      Text(
                                        schoolOrProfession.toString(),textScaleFactor: 1,
                                        style: GoogleFonts.firaSans(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "STATE",textScaleFactor: 1,
                                        style: GoogleFonts.firaSans(
                                            color: Colors.white,
                                            letterSpacing: 2,
                                            fontSize: 13),
                                      ),
                                      Text(
                                        state.toString(),textScaleFactor: 1,
                                        style: GoogleFonts.firaSans(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "IS MENTOR",textScaleFactor: 1,
                                        style: GoogleFonts.firaSans(
                                            color: Colors.white,
                                            letterSpacing: 2,
                                            fontSize: 13),
                                      ),
                                      Text(
                                        isMentor.toString(),textScaleFactor: 1,
                                        style: GoogleFonts.firaSans(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: getProportionateScreenHeight(70),
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                          getProportionateScreenWidth(18)),
                                      decoration: BoxDecoration(
                                          color: Color(COLOR_ACCENT),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.white, width: 1.3)),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "VISITED",textScaleFactor: 1,
                                            style: GoogleFonts.firaSans(
                                                color: Colors.white,
                                                letterSpacing: 2,
                                                fontSize: 13),
                                          ),
                                          Text(
                                            visited == null ? "0" : visited.toString(),textScaleFactor: 1,
                                            style: GoogleFonts.firaSans(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 22),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: getProportionateScreenWidth(20),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: (){
                                        print("View Results pressed");
                                        push(context, ResultListScreen());
                                      },
                                      child: Container(
                                        height: getProportionateScreenHeight(70),
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                            getProportionateScreenWidth(18)),
                                        decoration: BoxDecoration(
                                            color: Color(COLOR_ACCENT),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Colors.white, width: 1.3)),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "RESULTS",textScaleFactor: 1,
                                                  style: GoogleFonts.firaSans(
                                                      color: Colors.white,
                                                      letterSpacing: 2,
                                                      fontSize: 13),
                                                ),
                                                Text(
                                                  resultIds == null ? "0" : resultIds.toList().length.toString(),
                                                  textScaleFactor: 1,
                                                  style: GoogleFonts.firaSans(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 22),
                                                )
                                              ],
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Spacer(),
                              resultIds == null ? Container() : Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(18),
                                    vertical: getProportionateScreenHeight(13)),
                                decoration: BoxDecoration(
                                    color: Color(COLOR_ACCENT),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.white, width: 1.3)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "LAST RESULT",textScaleFactor: 1,
                                      style: GoogleFonts.firaSans(
                                          color: Colors.white,
                                          letterSpacing: 2,
                                          fontSize: 13),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        push(context, ResultDetails("",resultDateTimes[0], spiritQuadScore[0], spiritQuadDisplay[0], spiritBlurb[0], purposeQuadScore[0], purposeQuadDisplay[0], purposeBlurb[0],  professionQuadScore[0], professionQuadDisplay[0], professionBlurb[0], rewardQuadScore[0], rewardQuadDisplay[0], rewardBlurb[0], resultHighlights[0]));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                resultDateTimes[0],textScaleFactor: 1,
                                                style: GoogleFonts.firaSans(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                completedSprints.toString()+ " SPRINTS",textScaleFactor: 1,
                                                style: GoogleFonts.firaSans(
                                                    color: Colors.white,
                                                    letterSpacing: 2,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          ConstrainedBox(
                                            constraints: BoxConstraints.tightFor(
                                              width: getProportionateScreenWidth(67),
                                            ),
                                            child: ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(100),
                                                    ),
                                                    primary: Colors.white,
                                                    onPrimary: Color(COLOR_ACCENT),
                                                    textStyle: GoogleFonts.firaSans(
                                                        fontSize: 12,
                                                        color: Color(COLOR_ACCENT))),
                                                child: Text("VIEW",textScaleFactor: 1,)),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(33),
                            vertical: getProportionateScreenHeight(11)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 2,
                              color: Color(0xFFDAE7FF),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                SizedBox(height: 10,),
                                Text(
                                  "My Counselors",textScaleFactor: 1,
                                  style: GoogleFonts.firaSans(
                                      fontSize: 18, color: Color(0xFF383838)),
                                ),
                                SizedBox(height: 10,),
                                Spacer(),
                                SizedBox(width: getProportionateScreenWidth(31)),
                                Icon(Icons.keyboard_arrow_down)
                              ],
                            ),SizedBox(height: 10,),
                            SizedBox(
                              height: getProportionateScreenHeight(13),
                            ),
                            Container(
                              height: getProportionateScreenHeight(49),
                              child: TextFormField(
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                    hintText: "Add counselor email",
                                    hintStyle: GoogleFonts.firaSans(
                                      fontSize: 14,
                                      color: Color(0xFF989898),
                                    ),
                                    suffixText: "+ Add",
                                    suffixStyle: GoogleFonts.firaSans(
                                        color: Color(0xFF4C89F4), fontSize: 14),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(
                                            color: Color(0xFFB5B5B5)))),
                              ),
                            ),SizedBox(height: 10,),
                            SizedBox(
                              height: getProportionateScreenHeight(13),
                            ),
                            Container(
                              height: 2,
                              color: Color(0xFFDAE7FF),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(11),
                            ),
                            CounsellorsTile(),
                            SizedBox(
                              height: getProportionateScreenHeight(11),
                            ),
                            Container(
                              height: 2,
                              color: Color(0xFFDAE7FF),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(11),
                            ),
                            CounsellorsTile(),
                            Divider(
                              color: Color(COLOR_ACCENT),
                              thickness: 2,
                              height: 30,
                            ),
                            Container(
                              height: 2,
                              color: Color(0xFFDAE7FF),
                            ),
                            TextButton(
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "My Guardians",textScaleFactor: 1,
                                      style: GoogleFonts.firaSans(
                                          color: Color(0xFF383838), fontSize: 18),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xFF8B8B8B),
                                      size: 22,
                                    )
                                  ],
                                )),
//                            Container(
//                              height: 2,
//                              color: Color(0xFFDAE7FF),
//                            ),
//                            TextButton(
//                                onPressed: () {},
//                                child: Row(
//                                  mainAxisAlignment:
//                                  MainAxisAlignment.spaceBetween,
//                                  children: [
//                                    Text(
//                                      "Social Media",textScaleFactor: 1,
//                                      style: GoogleFonts.firaSans(
//                                          color: Color(0xFF383838), fontSize: 18),
//                                    ),
//                                    Icon(
//                                      Icons.arrow_forward_ios_rounded,
//                                      color: Color(0xFF8B8B8B),
//                                      size: 22,
//                                    )
//                                  ],
//                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

 */

class ScoreAndProgressBar3 extends StatelessWidget {
  ScoreAndProgressBar3({
    Key key,
    this.percent,
    this.sprints, this.textColor,
  }) : super(key: key);
  final double percent, sprints;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    double _progPercent = percent / 100;
    double _progtextPercent = percent / 10;
    if(_progtextPercent.toString().length > 6){
      tmp = _progtextPercent.toString().substring(0,5);
    }else{
      tmp = _progtextPercent.toString();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$tmp/10 LV Score | $sprints Sprints",
          style: GoogleFonts.firaSans(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 10),
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
//        completedSprints.toString() == "0" ? Container() :
//        LinearPercentIndicator(
//            backgroundColor: Colors.grey[500],
//            progressColor: Colors.yellow[700],
//            padding: EdgeInsets.zero,
//            animation: true,
//            width: getProportionateScreenWidth(144),
//            lineHeight: getProportionateScreenHeight(4),
//            percent: _progPercent),
      ],
    );
  }
}

class CounsellorsTile extends StatelessWidget {
  const CounsellorsTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: getProportionateScreenWidth(25),
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage("assets/images/sampleProf.png"),
        ),
        SizedBox(
          width: getProportionateScreenWidth(16),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sameer Ranjan",
              style: GoogleFonts.firaSans(
                  fontSize: 18,
                  color: Color(0xFF383838),
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: getProportionateScreenWidth(10),
            ),
            Text(
              "sameer@catenate.io",
              style: GoogleFonts.firaSans(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF727272),
              ),
            ),
          ],
        ),
        Spacer(),
        TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(),
            child: Text(
              "REMOVE",
              style: GoogleFonts.firaSans(
                color: Color(0xFFEB1851),
                fontSize: 12,
              ),
            ))
      ],
    );
  }
}

ProgressDialog prKeep;
ProgressDialog prRemove;

class CourseTile extends StatefulWidget {
  const CourseTile({
    Key key,
    this.index,
  }) : super(key: key);

  final int index;

  @override
  _CourseTileState createState() => _CourseTileState();
}

class _CourseTileState extends State<CourseTile> {

  SlidableController slidableController = SlidableController();

  Future<String> getCourses(context) async {

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getCourseList?userId=$isSignedIn";

    http.get(Uri.parse(url)).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseGetCourses = jsonDecode(response.body);
      print("responseGetCourses"+responseGetCourses.toString());

      setState(() {
        courseIds = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['courseId'].toString());
        courseNames = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['courseName'].toString());
        courseDescription = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['headlineTraits'].toString());

        courseHighlightText = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['headline'].toString());
        courseFullDescription = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['appTextNextPage'].toString()+responseGetCourses['courses'][index]['appTextScanner'].toString()+responseGetCourses['courses'][index]['appTextReader'].toString());

        courseNoOfInstitutions = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['countOfInstitute'].toString());

        courseIsKept = List.generate(responseGetCourses['courses'].length, (index) => responseGetCourses['courses'][index]['isKeep'].toString());
      });

      print(courseIds.toList());
      print(courseNames.toList());
      print(courseDescription.toList());
      print(courseHighlightText.toList());
      print(courseFullDescription.toList());
      print(courseNoOfInstitutions.toList());
      print(courseIsKept.toList());

    });
  }

  Future<String> addToWishlist(context) async {

    prKeep.show();

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/addToKeepList?courseId="+selectedCourseId.toString();
    var body = jsonEncode({
      "userId" : "bhavya.d03@gmail.com",
    });

    http.get(Uri.parse(url)).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseAddToWishList = jsonDecode(response.body);
      print(responseAddToWishList);

      var msg = responseAddToWishList['status'].toString();
      if(msg == "SUCCESS"){
        prKeep.hide();
        Fluttertoast.showToast(msg: "Added to wishlist",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){
          getCourses(context);
        });
      }else{
        prKeep.hide();
        Fluttertoast.showToast(msg: "Please check your network connection",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){
          getCourses(context);
        });
      }

    });
  }

  Future<String> removeFromWishList(context) async {

    prRemove.show();

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/removeFromKeepList?courseId="+selectedCourseId.toString();

    http.get(Uri.parse(url)).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseAddToWishList = jsonDecode(response.body);
      print(responseAddToWishList);

      var msg = responseAddToWishList['status'].toString();
      if(msg == "SUCCESS"){
        prRemove.hide();
        Fluttertoast.showToast(msg: "Removed from wishlist",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){
          getCourses(context);
        });
      }else{
        prRemove.hide();
        Fluttertoast.showToast(msg: "Please check your network connection",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){
          getCourses(context);
        });
      }

    });
  }

  openSlidable(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1),(){
      //slidableController.activeState.open();
      Slidable.of(context).open(actionType: SlideActionType.secondary);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openSlidable(context);
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 8),(){
      setState(() {
        showAnimation = false;
      });
    });
    return Stack(
      children: [
        SlideMenu(
          menuItems: [
            InkWell(
              onTap: (){
                if(courseIsKept[widget.index].toString() == "1"){
                  showDialog(context: context, builder: (BuildContext context) => Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
                    child: Container(
                      height: 310.0,
                      width: 300.0,
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              height: 300.0,
                              width: 300.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                                      child: Text("Are you sure you want to remove this course? You can always add it later.", style: GoogleFonts.firaSans(textStyle: TextStyle(fontSize: 16,height: 1.25, letterSpacing: 1,
                                          fontWeight: FontWeight.w400
                                      ),)),
                                    ),
                                    SizedBox(height: 15,),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                          height: 80,
                                          child: SvgPicture.asset("assets/iconSVG/robot.svg")),
                                    ),
                                    SizedBox(height: 20,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              pop(context);
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Color(0xff1E73BE)),
                                                  borderRadius: BorderRadius.all(Radius.circular(25))
                                              ),
                                              child: Center(
                                                child: Text("No",
                                                    style: GoogleFonts.firaSans(textStyle: TextStyle(fontSize: 16, letterSpacing: 1,color: Color(0xff1E73BE)),)
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              pop(context);
                                              if(courseIsKept[widget.index].toString() == "1"){
                                                setState(() {
                                                  selectedCourseId = courseIds[widget.index].toString();
                                                  print(selectedCourseId);
                                                });
                                                removeFromWishList(context);
                                              }else{
                                                setState(() {
                                                  selectedCourseId = courseIds[widget.index].toString();
                                                  print(selectedCourseId);
                                                });
                                                addToWishlist(context);
                                              }
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Color(0xff1E73BE)),
                                                  borderRadius: BorderRadius.all(Radius.circular(25))
                                              ),
                                              child: Center(
                                                child: Text("Yes",
                                                    style: GoogleFonts.firaSans(textStyle: TextStyle(fontSize: 16, letterSpacing: 1,color: Color(0xff1E73BE)),)
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 25,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 20,
                                width: 200,
                                color: Color(0xff1E73BE),
                              )),
                        ],
                      ),
                    ),
                  ));
                }else{
                  showDialog(context: context, builder: (BuildContext context) => Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
                    child: Container(
                      height: 310.0,
                      width: 300.0,
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              height: 300.0,
                              width: 300.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                                      child: Text("Are you sure you want to keep this course? You can always remove it later.", style: GoogleFonts.firaSans(textStyle: TextStyle(fontSize: 16,height: 1.25, letterSpacing: 1,
                                          fontWeight: FontWeight.w400
                                      ),)),
                                    ),
                                    SizedBox(height: 15,),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                          height: 80,
                                          child: SvgPicture.asset("assets/iconSVG/robot.svg")),
                                    ),
                                    SizedBox(height: 20,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              pop(context);
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Color(0xff1E73BE)),
                                                  borderRadius: BorderRadius.all(Radius.circular(25))
                                              ),
                                              child: Center(
                                                child: Text("No",
                                                    style: GoogleFonts.firaSans(textStyle: TextStyle(fontSize: 16, letterSpacing: 1,color: Color(0xff1E73BE)),)
                                                ),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              pop(context);
                                              if(courseIsKept[widget.index].toString() == "1"){
                                                setState(() {
                                                  selectedCourseId = courseIds[widget.index].toString();
                                                  print(selectedCourseId);
                                                });
                                                removeFromWishList(context);
                                              }else{
                                                setState(() {
                                                  selectedCourseId = courseIds[widget.index].toString();
                                                  print(selectedCourseId);
                                                });
                                                addToWishlist(context);
                                              }
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Color(0xff1E73BE)),
                                                  borderRadius: BorderRadius.all(Radius.circular(25))
                                              ),
                                              child: Center(
                                                child: Text("Yes",
                                                    style: GoogleFonts.firaSans(textStyle: TextStyle(fontSize: 16, letterSpacing: 1,color: Color(0xff1E73BE)),)
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 25,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: 20,
                                width: 200,
                                color: Color(0xff1E73BE),
                              )),
                        ],
                      ),
                    ),
                  ));
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 4, left: 5),
                child: Container(
                  width: 50,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    border: Border.all(color: Color(0xff1E73BE)),
                    color: courseIsKept[widget.index].toString() == "1" ? Color(0xff1E73BE) : Colors.white,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/iconSVG/pin.svg",
                          color: courseIsKept[widget.index].toString() == "1" ? Colors.white : Color(0xff1E73BE),
                        ),
                        SizedBox(height: 2,),
                        Text(courseIsKept[widget.index].toString() == "1" ? "REMOVE" : "KEEP",
                          style: GoogleFonts.firaSans(
                              letterSpacing: 1,
                              color: courseIsKept[widget.index].toString() == "1" ? Colors.white : Color(0xff1E73BE),
                              fontSize: 10
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
          child: Container(
            constraints: BoxConstraints.tightFor(width: double.infinity),
            child: Card(
              elevation: 0,
              semanticContainer: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(color: Color(0xFFDAE7FF), width: 1),
              ),
              child: ExpansionTile(
                title: Text(
                  courseNames[widget.index],
                  textAlign: TextAlign.start,
                  style: GoogleFonts.firaSans(
                    fontSize: 18,
                    color: Color(0xFF383838),
                  ),
                ),
                childrenPadding:
                EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        courseNoOfInstitutions[widget.index].toString()+" INSTITUTIONS",
                        style: GoogleFonts.firaSans(
                          fontSize: 13,letterSpacing: 1,
                          color: Color(0xFF383838),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 1,
                    color: Color(COLOR_ACCENT),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    courseHighlightText[widget.index],
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.firaSans(
                      fontSize: 18,letterSpacing: 1,
                      color: Color(0xFF3F4462),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CourseButton(
                        text: courseIsKept[widget.index].toString() == "1" ? "REMOVE" : "KEEP",
                        onPressed: () {
                          slidableController.activeState.close();
//                          if(courseIsKept[widget.index].toString() == "1"){
//                            setState(() {
//                              selectedCourseId = courseIds[widget.index].toString();
//                              print(selectedCourseId);
//                            });
//                            removeFromWishList(context);
//                          }else{
//                            setState(() {
//                              selectedCourseId = courseIds[widget.index].toString();
//                              print(selectedCourseId);
//                            });
//                            addToWishlist(context);
//                          }
                          //push(context, CourseDetailedScreen());
                        },
                      ),
                      CourseButton2(
                          text: "VIEW DETAILS",
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) => CourseDetailedScreen(courseNoOfInstitutions[widget.index], courseNames[widget.index], courseHighlightText[widget.index], courseFullDescription[widget.index], courseIds[widget.index], courseIsKept[widget.index]),
                                  transitionsBuilder: (c, anim, a2, child) =>
                                      FadeTransition(opacity: anim, child: child),
                                  transitionDuration: Duration(milliseconds: 300),
                                )).whenComplete((){
                              getCourses(context);
                            });
                          })
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
        courseIsKept[widget.index].toString() == "1" ? Padding(
          padding: const EdgeInsets.only(left: 15, top: 13),
          child: Container(
            height: 5, width: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              color: Color(0xff1E73BE),
            ),
          ),
        ) : Container(),
      ],
    );
  }
}

class CourseButton extends StatelessWidget {
  const CourseButton({
    Key key,
    this.text,
    this.onPressed,
  }) : super(key: key);

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: getProportionateScreenWidth(132),
        height: getProportionateScreenHeight(33),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            side: BorderSide(color: Color(COLOR_ACCENT)),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
            elevation: 0,
            primary: Colors.white,
            onPrimary: Color(COLOR_ACCENT),
            textStyle: GoogleFonts.firaSans(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/iconSVG/pin.svg"),
            SizedBox(width: 10,),
            Text(text),
          ],
        ),
      ),
    );
  }
}

class CourseButton2 extends StatelessWidget {
  const CourseButton2({
    Key key,
    this.text,
    this.onPressed,
  }) : super(key: key);

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: getProportionateScreenWidth(132),
        height: getProportionateScreenHeight(33),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            side: BorderSide(color: Color(COLOR_ACCENT)),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
            elevation: 0,
            primary: Colors.white,
            onPrimary: Color(COLOR_ACCENT),
            textStyle: GoogleFonts.firaSans(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            )),
        child: Text(text),
      ),
    );
  }
}

var selectedCourseId;

class SlideMenu extends StatefulWidget {
  final Widget child;
  final List<Widget> menuItems;

  SlideMenu({this.child, this.menuItems});

  @override
  _SlideMenuState createState() => new _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = new AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = new Tween(
        begin: const Offset(0.0, 0.0),
        end: const Offset(-0.2, 0.0)
    ).animate(new CurveTween(curve: Curves.decelerate).animate(_controller));

    return new GestureDetector(
      onHorizontalDragUpdate: (data) {
        // we can access context.size here
        setState(() {
          _controller.value -= data.primaryDelta / context.size.width;
        });
      },
      onHorizontalDragEnd: (data) {
        if (data.primaryVelocity > 2500)
          _controller.animateTo(.0); //close menu on fast swipe in the right direction
        else if (_controller.value >= .5 || data.primaryVelocity < -2500) // fully open if dragged a lot to left or on fast swipe to left
          _controller.animateTo(1.0);
        else // close if none of above
          _controller.animateTo(.0);
      },
      child: new Stack(
        children: <Widget>[
          new SlideTransition(position: animation, child: widget.child),
          new Positioned.fill(
            child: new LayoutBuilder(
              builder: (context, constraint) {
                return new AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return new Stack(
                      children: <Widget>[
                        new Positioned(
                          right: .0,
                          top: .0,
                          bottom: .0,
                          width: constraint.maxWidth * animation.value.dx * -1,
                          child: new Container(
                            //color: Colors.black26,
                            child: new Row(
                              children: widget.menuItems.map((child) {
                                return new Expanded(
                                  child: child,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class SlideMenu2 extends StatefulWidget {
  final Widget child;
  final List<Widget> menuItems;

  SlideMenu2({this.child, this.menuItems});

  @override
  _SlideMenu2State createState() => new _SlideMenu2State();
}

class _SlideMenu2State extends State<SlideMenu2> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = new AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _controller.repeat();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = new Tween(
        begin: const Offset(0.0, 0.0),
        end: const Offset(-0.2, 0.0)
    ).animate(new CurveTween(curve: Curves.decelerate).animate(_controller));

    return new GestureDetector(
      onHorizontalDragUpdate: (data) {
        // we can access context.size here
        setState(() {
          _controller.value -= data.primaryDelta / context.size.width;
        });
      },
      onHorizontalDragEnd: (data) {
        if (data.primaryVelocity > 2500)
          _controller.animateTo(.0); //close menu on fast swipe in the right direction
        else if (_controller.value >= .5 || data.primaryVelocity < -2500) // fully open if dragged a lot to left or on fast swipe to left
          _controller.animateTo(1.0);
        else // close if none of above
          _controller.animateTo(.0);
      },
      child: new Stack(
        children: <Widget>[
          new SlideTransition(position: animation, child: widget.child),
          new Positioned.fill(
            child: new LayoutBuilder(
              builder: (context, constraint) {
                return new AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return new Stack(
                      children: <Widget>[
                        new Positioned(
                          right: .0,
                          top: .0,
                          bottom: .0,
                          width: constraint.maxWidth * animation.value.dx * -1,
                          child: new Container(
                            //color: Colors.black26,
                            child: new Row(
                              children: widget.menuItems.map((child) {
                                return new Expanded(
                                  child: child,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

//onWillPop: () => showDialog(
//context: context,
//builder: (context) => new AlertDialog(
//title: new Text('Are you sure?'),
//content: new Text('Do you want to exit the App'),
//actions: <Widget>[
//new GestureDetector(
//onTap: () => Navigator.of(context).pop(false),
//child: Padding(
//padding: const EdgeInsets.all(15.0),
//child: Text("No"),
//),
//),
//SizedBox(height: 16),
//new GestureDetector(
//onTap: () => exit(0),
//child: Padding(
//padding: const EdgeInsets.all(15.0),
//child: Text("Yes"),
//),
//),
//],
//),
//),
