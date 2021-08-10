import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/helper.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:mira_mira/UI/CourseDetailedScreen/CourseDetailScreen.dart';
import 'package:mira_mira/UI/QuizScreen/QuizListScreen.dart';
import 'package:mira_mira/UI/SignUp/LoginSignupScreen.dart';
import 'package:mira_mira/UI/Tabs/Results/resultDetails.dart';
import 'package:mira_mira/UI/UserProfileScreen/UserProfileScreen.dart';
import 'package:mira_mira/UI/home_screen/home_screen.dart';
import 'package:mira_mira/UI/home_screen/home_screen.dart' as h;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Results/ResultsListScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

ProgressDialog prKeep;
ProgressDialog prRemove;
AnimationController _controller;
Animation<Offset> _animation;
bool showAnimation = true;

bool showToolTipC = true;
var tmp;

class CourseListScreen extends StatefulWidget {
  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen>
    with TickerProviderStateMixin {

  SharedPreferences prefs;

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
      "userId" : isSignedIn,
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
        Fluttertoast.showToast(msg: "Course kept",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){
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
        Fluttertoast.showToast(msg: "Course removed",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){
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

  getString() async {
    prefs = await SharedPreferences.getInstance();
    tmp = prefs.getString("showToolTipC");
    print("showToolTipC ::::" + tmp);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getString();
    selectedCourseId = null;
    setState(() {
      showToolTipC = true;
      //courseIds = null;
      showAnimation = true;
    });
    Future.delayed(Duration(seconds: 8),(){
      setState(() {
        showAnimation = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getCourses(context);
    prKeep = ProgressDialog(context);
    prRemove = ProgressDialog(context);
//    prKeep.style(
//        message: 'Adding to wishlist...',
//        borderRadius: 10.0,
//        backgroundColor: Colors.white,
//        progressWidget: Padding(
//          padding: const EdgeInsets.only(bottom: 10),
//          child: JumpingDotsProgressIndicator(
//            fontSize: 40.0,color: Colors.black,
//          ),
//        ),
//        elevation: 10.0,
//        insetAnimCurve: Curves.easeInOut,
//        progress: 0.0,
//        maxProgress: 100.0,
//        progressTextStyle: TextStyle(
//            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
//        messageTextStyle: TextStyle(
//            color: Color(0xff1E73BE), fontSize: 19.0, fontWeight: FontWeight.w300)
//    );
//    prRemove.style(
//        message: 'Removing...',
//        borderRadius: 10.0,
//        backgroundColor: Colors.white,
//        progressWidget: Padding(
//          padding: const EdgeInsets.only(bottom: 10),
//          child: JumpingDotsProgressIndicator(
//            fontSize: 40.0,color: Colors.black,
//          ),
//        ),
//        elevation: 10.0,
//        insetAnimCurve: Curves.easeInOut,
//        progress: 0.0,
//        maxProgress: 100.0,
//        progressTextStyle: TextStyle(
//            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
//        messageTextStyle: TextStyle(
//            color: Color(0xff1E73BE), fontSize: 19.0, fontWeight: FontWeight.w300)
//    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
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
                                  "Hello "+h.userName.toString(),
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
                                  h.lvScore.toString()+"/10 LV Score | "+h.completedSprints.toString()+" Sprints",
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
                            Text(
                              "COURSES",
                              style: GoogleFonts.firaSans(
                                  color: Color(COLOR_ACCENT),
                                  fontSize: 16,letterSpacing: 1,
                                  fontWeight: FontWeight.w600),
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
//                          courseIds == null ? Container() : InkWell(
//                            onTap: (){
//                              Slidable.of(context)?.open();
//                              print("opening...");
//                            },
//                            child: Align(
//                                alignment: Alignment.centerRight,
//                                child: SvgPicture.asset("assets/iconSVG/filterButton.svg")),
//                          ),
                            SizedBox(
                              height: getProportionateScreenHeight(20),
                            ),
//                          showAnimation == true && courseIds != null ? SlideMenu2(
//                              menuItems: [
//                                InkWell(
//                                  onTap: (){
//
//                                  },
//                                  child: Padding(
//                                    padding: const EdgeInsets.only(top: 4, left: 5),
//                                    child: Container(
//                                      width: 50,
//                                      height: 60,
//                                      decoration: BoxDecoration(
//                                        borderRadius: BorderRadius.all(Radius.circular(6)),
//                                        border: Border.all(color: Color(0xff1E73BE)),
//                                        color: Colors.white,
//                                      ),
//                                      child: Center(
//                                        child: Column(
//                                          mainAxisAlignment: MainAxisAlignment.center,
//                                          crossAxisAlignment: CrossAxisAlignment.center,
//                                          children: [
//                                            SvgPicture.asset("assets/iconSVG/pin.svg",
//                                              color: Color(0xff1E73BE),
//                                            ),
//                                            SizedBox(height: 2,),
//                                            Text("KEEP",
//                                              style: GoogleFonts.firaSans(
//                                                  letterSpacing: 1,
//                                                  color: Color(0xff1E73BE),
//                                                  fontSize: 10
//                                              ),
//                                            ),
//                                          ],
//                                        ),
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                              ],
//                            child: Container(
//                              constraints: BoxConstraints.tightFor(width: double.infinity),
//                              child: Card(
//                                elevation: 0,
//                                semanticContainer: true,
//                                shape: RoundedRectangleBorder(
//                                  borderRadius: BorderRadius.circular(6),
//                                  side: BorderSide(color: Color(0xFFDAE7FF), width: 1),
//                                ),
//                                child: ExpansionTile(
//                                  title: Text(
//                                    "Swipe to keep",
//                                    textAlign: TextAlign.start,
//                                    style: GoogleFonts.firaSans(
//                                      fontSize: 18,
//                                      color: Color(0xFF383838),
//                                    ),
//                                  ),
//                                  childrenPadding:
//                                  EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(15)),
//                                  children: [
//
//                                  ],
//                                ),
//                              ),
//                            )
//                          ) : Container(),
                            SingleChildScrollView(
                              child: Container(
                                //height: courseIds == null ? 0 : 80*double.parse(courseIds.length.toString()),
                                child: ListView.builder(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: courseNames == null ? 0 : courseNames.length,
                                    itemBuilder: (context, i) =>
                                        CourseTile(
                                          index: i,
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
            showToolTipC == true && tmp != "false" && courseIds != null ?
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(0.6),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            onTap: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString("showToolTipC", "false");
                              setState(() {
                                showToolTipC = false;
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 30,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/20,),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Text("You can ‘keep’ a course on top of your list of courses for later use.",
                        textScaleFactor: 1,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.firaSans(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    InkWell(
                      onTap: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString("showToolTipC", "false");
                        setState(() {
                          showToolTipC = false;
                        });
                      },
                      child: Container(
                        height: 35,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.white)
                        ),
                        child: Center(
                            child: Text("GOT IT!",textScaleFactor: 1,
                              style: GoogleFonts.firaSans(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/10,),
//                      Padding(
//                        padding: EdgeInsets.only(top: 10),
//                        child: Align(
//                            alignment: Alignment.centerRight,
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.start,
//                              children: [
//                                SizedBox(width: getProportionateScreenWidth(50),),
//                                Image.asset("assets/images/circlehelp.png"),
//                                Padding(
//                                  padding: const EdgeInsets.only(bottom: 30),
//                                  child: Image.asset("assets/images/pathline.png"),
//                                ),
//                                SizedBox(width: 0,),
//                                Padding(
//                                  padding: EdgeInsets.only(left: getProportionateScreenWidth(20),
//                                    bottom: 40
//                                  ),
//                                  child: Text("You can tap this\nbutton to keep or…",
//                                    textScaleFactor: 1,
//                                    textAlign: TextAlign.left,
//                                    style: GoogleFonts.firaSans(
//                                      color: Colors.white,
//                                      fontSize: 16,
//                                    ),
//                                  ),
//                                ),
//                              ],
//                            )),
//                      ),
                    //Spacer(),
                    SizedBox(height: getProportionateScreenHeight(40),),
//                      Padding(
//                        padding: EdgeInsets.only(left: getProportionateScreenWidth(90)),
//                        child: Text("Swipe right to keep\nthe course on top",
//                          textScaleFactor: 1,
//                          textAlign: TextAlign.left,
//                          style: GoogleFonts.firaSans(
//                            color: Colors.white,
//                            fontSize: 16,
//                          ),
//                        ),
//                      ),
                    SizedBox(height: 0,),
                    Padding(
                      padding: EdgeInsets.only(right: 0),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 20,),
                              Image.asset("assets/images/patharrow.png"),
                              SizedBox(width: 20,),
                              Text("Right swipe to keep",
                                textScaleFactor: 1,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.firaSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )),
                    ),
                    //SizedBox(height: 50,),
                  ],
                ),
              ),
            ) : Container(),
          ],
        ),
      ),
    );
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
                "Start with the Quiz!",textScaleFactor: 1,
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
                "An easy sprint of questions will make\nMiraMira discover your aptitude",textScaleFactor: 1,
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
            Center(child: SvgPicture.asset("assets/iconSVG/robot.svg")),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Text(
              "Go ahead, start your journey now.",textScaleFactor: 1,
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

}

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
        Fluttertoast.showToast(msg: "Done",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){
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
        Fluttertoast.showToast(msg: "Course removed",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){
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

  List<bool> boolList = [];

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
    boolList = List.generate(courseIds.length, (index) => index==0?true:false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          actions: <Widget>[
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
                initiallyExpanded: false,
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
                        onPressed: (){
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
