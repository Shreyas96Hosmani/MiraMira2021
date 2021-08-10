import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/helper.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:mira_mira/UI/CourseDetailedScreen/CourseDetailScreen.dart';
import 'package:mira_mira/UI/Tabs/Results/resultDetails.dart';
import 'package:mira_mira/UI/home_screen/components/bottom_tabs.dart';
import 'package:mira_mira/UI/home_screen/home_screen.dart';
import 'package:mira_mira/UI/home_screen/home_screen.dart' as h;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

ProgressDialog prKeep;
ProgressDialog prRemove;
int _selectedTab = 2;
SlidableController slidableController = SlidableController();

class CourseListScreenForResults extends StatefulWidget {
  @override
  _CourseListScreenForResultsState createState() => _CourseListScreenForResultsState();
}

class _CourseListScreenForResultsState extends State<CourseListScreenForResults> {

  openSlidable(){
    //Slidable.of(context).open();
    print("******");
    //Slidable.of(context)?.open();
    Slidable.of(context)?.renderingMode == SlidableRenderingMode.none
        ? Slidable.of(context)?.open()
        : Slidable.of(context)?.close();
    //slidableController.activeState.open();
    print("******");
  }

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

  Future<String> addToWishlist2(context) async {

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
          getCourses2(context);
        });
      }else{
        prKeep.hide();
        Fluttertoast.showToast(msg: "Please check your network connection",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){
          getCourses2(context);
        });
      }

    });
  }

  Future<String> removeFromWishList2(context) async {

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
          getCourses2(context);
        });
      }else{
        prRemove.hide();
        Fluttertoast.showToast(msg: "Please check your network connection",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){
          getCourses2(context);
        });
      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedCourseId = null;
    slidableController = SlidableController();
    getCourses2(context);
    setState(() {
      _selectedTab = 2;
    });
    Future.delayed(Duration(seconds: 2), (){
      openSlidable();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(COLOR_ACCENT)
    ));
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
        body: SingleChildScrollView(
          child: Container(
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
                          InkWell(
                            onTap: (){
                              Slidable.of(context).open();
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

  Future<String> getCourses(context) async {

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getCourseList?userId=bhavya.d03@gmail.com";

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

  openSlidable(BuildContext context){
    //Slidable.of(context).open();
    print("******");
    //Slidable.of(context)?.open();
    Slidable.of(context).open(actionType: SlideActionType.secondary);
    //slidableController.activeState.open();
    print("******");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
