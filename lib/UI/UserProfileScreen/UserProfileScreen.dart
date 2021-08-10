//import 'dart:io';
//import 'dart:typed_data';
//
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_share/flutter_share.dart';
//import 'package:flutter_svg/flutter_svg.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:mira_mira/Helper/constants.dart';
//import 'package:mira_mira/Helper/helper.dart';
//import 'package:mira_mira/Helper/sizeconfig.dart';
//import 'package:mira_mira/UI/SignUp/LoginSignupScreen.dart';
//import 'package:mira_mira/UI/Tabs/MoreScreen.dart';
//import 'package:mira_mira/UI/Tabs/Results/ResultsListScreen.dart';
//import 'package:mira_mira/UI/Tabs/Results/resultDetails.dart';
//import 'package:mira_mira/UI/UserProfileScreen/EditProfileScreen.dart';
//import 'package:mira_mira/UI/home_screen/home_screen.dart';
//import 'package:percent_indicator/linear_percent_indicator.dart';
//import 'package:screenshot/screenshot.dart';
//import 'package:share/share.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
//
//var grade;
//var schoolOrProfession;
//var state;
//var county;
//var isMentor;
//var myId;
//var photo;
//var visited;
//
//class UserProfileScreen extends StatefulWidget {
//  @override
//  _UserProfileScreenState createState() => _UserProfileScreenState();
//}
//
//class _UserProfileScreenState extends State<UserProfileScreen> {
//
//  ScreenshotController screenshotController = ScreenshotController();
//  Uint8List _imageFile;
//
//  back(){
//    setState(() {
//      removeMoreScreen = false;
//    });
//    print(removeMoreScreen);
//    Future.delayed(Duration(seconds: 2), (){
//      setState(() {
//
//      });
//    });
//  }
//
//  Future<String> loadUserProfile(context) async {
//
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    isSignedIn = prefs.getString("userID").toString();
//
//    print(isSignedIn);
//
//    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-lacxv/service/miramira/incoming_webhook/loadUserProfile?userId=$isSignedIn";
//
//    http.get(Uri.parse(url)).then((http.Response response) async {
//      final int statusCode = response.statusCode;
//
//      if (statusCode < 200 || statusCode > 400 || json == null) {
//        throw new Exception("Error fetching data");
//      }
//
//      var responseLoadUserProfile = jsonDecode(response.body);
//      print(responseLoadUserProfile);
//
//      var msg = responseLoadUserProfile['status'].toString();
//      if(msg == "SUCCESS"){
//        setState(() {
//          completedSprints = responseLoadUserProfile['numberOfCompletedSprints'].toString();
//          userName = responseLoadUserProfile['userDetails']['name'].toString();
//          lvScore = responseLoadUserProfile['userDetails']['lvScore'].toString() == "null" || responseLoadUserProfile['userDetails']['lvScore'].toString() == "" ? "0" : responseLoadUserProfile['userDetails']['lvScore'].toString();
//          grade = responseLoadUserProfile['userDetails']['schoolGrade'].toString() == "" ? "nil" : responseLoadUserProfile['userDetails']['schoolGrade'].toString();
//          schoolOrProfession = responseLoadUserProfile['userDetails']['schoolGrade'].toString() == "" ? "nil" : responseLoadUserProfile['userDetails']['schoolGrade'].toString();
//          state = responseLoadUserProfile['userDetails']['state'].toString() == "" ? "nil" : responseLoadUserProfile['userDetails']['state'].toString();
//          county = responseLoadUserProfile['userDetails']['county'].toString() == "" ? "nil" : responseLoadUserProfile['userDetails']['county'].toString();
//          isMentor = responseLoadUserProfile['userDetails']['isMentor'].toString();
//          myId = responseLoadUserProfile['userDetails']['_id'].toString();
//          photo = responseLoadUserProfile['userDetails']['userPhoto'].toString();
//          visited = responseLoadUserProfile['userDetails']['visits'].toString();
//        });
//        print(completedSprints.toString());
//        print(userName.toString());
//        print(lvScore.toString());
//        print(grade.toString());
//        print(schoolOrProfession.toString());
//        print(state.toString());
//        print(county.toString());
//        print(isMentor.toString());
//        print(myId.toString());
//        print(photo.toString());
//        print(visited.toString());
//      }
//
//    });
//  }
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    loadUserProfile(context);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return SafeArea(
//      child: Scaffold(
//        body: WillPopScope(
//          onWillPop: ()=> back(),
//          child: Stack(
//            children: [
//              Container(
//                width: double.infinity,
//                height: getProportionateScreenHeight(96),
//                color: Color(COLOR_ACCENT),
//              ),
//              Container(
//                width: double.infinity,
//                margin: EdgeInsets.all(getProportionateScreenWidth(10)),
//                decoration: BoxDecoration(
//                  border: Border.all(color: Color(0xFFDAE7FF), width: 2),
//                  borderRadius: BorderRadius.circular(7),
//                  color: Colors.white,
//                ),
//                height: getProportionateScreenHeight(910),
//                child: SingleChildScrollView(
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: [
//                      Screenshot(
//                        controller: screenshotController,
//                        child: Container(
//                          height: getProportionateScreenHeight(550),
//                          padding: EdgeInsets.all(
//                            getProportionateScreenWidth(22),
//                          ),
//                          decoration: BoxDecoration(
//                              borderRadius: BorderRadius.circular(6),
//                              border: Border.all(color: Colors.white),
//                              color: Color(COLOR_ACCENT)),
//                          child: Column(
//                            children: [
//                              Row(
//                                crossAxisAlignment: CrossAxisAlignment.center,
//                                children: [
//                                  GestureDetector(
//                                      onTap: () {
//                                        back();
//                                        //Navigator.pop(context);
//                                      },
//                                      child: Icon(
//                                        Icons.arrow_back_ios_rounded,
//                                        size: getProportionateScreenWidth(25),
//                                        color: Colors.white,
//                                      )),
//                                  SizedBox(
//                                    width: getProportionateScreenWidth(12),
//                                  ),
//                                  Text(
//                                    "My Profile",
//                                    style: GoogleFonts.firaSans(
//                                        color: Colors.white,
//                                        fontWeight: FontWeight.w400,
//                                        fontSize: 18),
//                                  ),
//                                  Spacer(),
//                                  GestureDetector(
//                                      onTap: () {
//                                        back();
//                                      },
//                                      child: Icon(
//                                        Icons.close,
//                                        size: getProportionateScreenWidth(30),
//                                        color: Colors.white,
//                                      )),
//                                ],
//                              ),
//                              Spacer(),
//                              Row(
//                                mainAxisAlignment: MainAxisAlignment.end,
//                                crossAxisAlignment: CrossAxisAlignment.center,
//                                children: [
//                                  InkWell(
//                                    onTap: (){
//                                      Navigator.push(
//                                          context,
//                                          PageRouteBuilder(
//                                            pageBuilder: (c, a1, a2) => EditProfileScreen(myId, userName, isSignedIn, grade, schoolOrProfession, state, county),
//                                            transitionsBuilder: (c, anim, a2, child) =>
//                                                FadeTransition(opacity: anim, child: child),
//                                            transitionDuration: Duration(milliseconds: 300),
//                                          )).whenComplete((){
//                                            loadUserProfile(context);
//                                      });
//                                    },
//                                    child: SvgPicture.asset(
//                                      "assets/iconSVG/editProfIcon.svg",
//                                      height: getProportionateScreenWidth(21),
//                                    ),
//                                  ),
//                                  SizedBox(
//                                    width: getProportionateScreenWidth(26),
//                                  ),
//                                  InkWell(
//                                    onTap: () async {
//                                      await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List image) async {
//                                        if (image != null) {
//                                          final directory = await getApplicationDocumentsDirectory();
//                                          final imagePath = await File('${directory.path}/image.png').create();
//                                          await imagePath.writeAsBytes(image);
//
//                                          /// Share Plugin
//                                          await Share.shareFiles([imagePath.path],text: 'Here\'s my profile card on MiraMira');
//                                        }
//                                      });
//                                    },
//                                    child: SvgPicture.asset(
//                                      "assets/iconSVG/shareOutlineWhite.svg",
//                                      height: getProportionateScreenWidth(21),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                              Spacer(),
//                              Row(
//                                mainAxisAlignment: MainAxisAlignment.start,
//                                crossAxisAlignment: CrossAxisAlignment.center,
//                                children: [
//                                  Container(
//                                    decoration: BoxDecoration(
//                                        borderRadius: BorderRadius.all(Radius.circular(100)),
//                                        boxShadow: [new BoxShadow(
//                                          color: Colors.black,
//                                          blurRadius: 7.0,
//                                        ),]
//                                    ),
//                                    child: Container(
//                                      decoration: BoxDecoration(
//                                        borderRadius: BorderRadius.all(Radius.circular(100)),
//                                        color: Colors.white,
//                                      ),
//                                      child: Padding(
//                                        padding: const EdgeInsets.all(5.0),
//                                        child: CircleAvatar(
//                                          radius: getProportionateScreenWidth(49),
//                                          backgroundColor: Color(0xffFEC55F),//Color(0xFFDDDDDD),
//                                          child: Container(
//                                            color: Color(0xffFEC55F),
//                                            margin: EdgeInsets.all(4),
//                                            child: Container(
//                                              child: SvgPicture.asset(
//                                                "assets/imageSVG/miramira.svg",
//                                                height: getProportionateScreenHeight(20),
//                                                fit: BoxFit.fitHeight,
//                                              ),
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                    ),
//                                  ),
//                                  SizedBox(
//                                    width: getProportionateScreenWidth(16),
//                                  ),
//                                  Container(
//                                    //width: getProportionateScreenWidth(126),
//                                    height: getProportionateScreenHeight(82),
//                                    child: Column(
//                                      crossAxisAlignment: CrossAxisAlignment.start,
//                                      children: [
//                                        Container(
//                                          width: getProportionateScreenWidth(126),
//                                          child: Text(
//                                            userName.toString(),
//                                            style: GoogleFonts.firaSans(
//                                                fontSize: 22,
//                                                color: Colors.white,
//                                                fontWeight: FontWeight.w500),
//                                          ),
//                                        ),
//                                        SizedBox(
//                                          height: getProportionateScreenWidth(10),
//                                        ),
//                                        Container(
//                                          width: getProportionateScreenWidth(156),
//                                          child: Text(
//                                            isSignedIn.toString(),
//                                            style: GoogleFonts.firaSans(
//                                              fontSize: 14,
//                                              color: Colors.white,
//                                            ),
//                                          ),
//                                        ),
//                                      ],
//                                    ),
//                                  ),
//                                ],
//                              ),
//                              Spacer(),
//                              Row(
//                                crossAxisAlignment: CrossAxisAlignment.center,
//                                children: [
//                                  ScoreAndProgressBar(
//                                    percent: double.parse(completedSprints)/double.parse(sprintNames.length.toString()),
//                                    sprints: double.parse(completedSprints.toString()),
//                                    textColor: Colors.white,
//                                  ),
//                                  SizedBox(
//                                    width: getProportionateScreenWidth(49),
//                                  ),
//                                  Column(
//                                    children: [
//                                      Text(
//                                        "GRADE",
//                                        style: GoogleFonts.firaSans(
//                                            color: Colors.white,
//                                            letterSpacing: 2,
//                                            fontSize: 13),
//                                      ),
//                                      Text(
//                                        grade.toString(),
//                                        style: GoogleFonts.firaSans(
//                                            color: Colors.white,
//                                            letterSpacing: 2,
//                                            fontSize: 16),
//                                      )
//                                    ],
//                                  )
//                                ],
//                              ),
//                              Spacer(),
//                              Row(
//                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                children: [
//                                  Column(
//                                    crossAxisAlignment: CrossAxisAlignment.start,
//                                    children: [
//                                      Text(
//                                        "SCHOOL",
//                                        style: GoogleFonts.firaSans(
//                                            color: Colors.white,
//                                            letterSpacing: 2,
//                                            fontSize: 13),
//                                      ),
//                                      Text(
//                                        schoolOrProfession.toString(),
//                                        style: GoogleFonts.firaSans(
//                                            color: Colors.white,
//                                            fontWeight: FontWeight.w600,
//                                            fontSize: 16),
//                                      )
//                                    ],
//                                  ),
//                                  Column(
//                                    crossAxisAlignment: CrossAxisAlignment.start,
//                                    children: [
//                                      Text(
//                                        "STATE",
//                                        style: GoogleFonts.firaSans(
//                                            color: Colors.white,
//                                            letterSpacing: 2,
//                                            fontSize: 13),
//                                      ),
//                                      Text(
//                                        state.toString(),
//                                        style: GoogleFonts.firaSans(
//                                            color: Colors.white,
//                                            fontWeight: FontWeight.w600,
//                                            fontSize: 16),
//                                      )
//                                    ],
//                                  ),
//                                  Column(
//                                    crossAxisAlignment: CrossAxisAlignment.start,
//                                    children: [
//                                      Text(
//                                        "IS MENTOR",
//                                        style: GoogleFonts.firaSans(
//                                            color: Colors.white,
//                                            letterSpacing: 2,
//                                            fontSize: 13),
//                                      ),
//                                      Text(
//                                        isMentor.toString(),
//                                        style: GoogleFonts.firaSans(
//                                            color: Colors.white,
//                                            fontWeight: FontWeight.w600,
//                                            fontSize: 16),
//                                      )
//                                    ],
//                                  ),
//                                ],
//                              ),
//                              Spacer(),
//                              Row(
//                                children: [
//                                  Expanded(
//                                    child: Container(
//                                      height: getProportionateScreenHeight(70),
//                                      padding: EdgeInsets.symmetric(
//                                          horizontal:
//                                              getProportionateScreenWidth(18)),
//                                      decoration: BoxDecoration(
//                                          color: Color(COLOR_ACCENT),
//                                          borderRadius: BorderRadius.circular(12),
//                                          border: Border.all(
//                                              color: Colors.white, width: 1.3)),
//                                      child: Column(
//                                        crossAxisAlignment:
//                                            CrossAxisAlignment.start,
//                                        mainAxisAlignment:
//                                            MainAxisAlignment.center,
//                                        children: [
//                                          Text(
//                                            "VISITED",
//                                            style: GoogleFonts.firaSans(
//                                                color: Colors.white,
//                                                letterSpacing: 2,
//                                                fontSize: 13),
//                                          ),
//                                          Text(
//                                            visited == null ? "0" : visited.toString(),
//                                            style: GoogleFonts.firaSans(
//                                                color: Colors.white,
//                                                fontWeight: FontWeight.w600,
//                                                fontSize: 22),
//                                          )
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                  SizedBox(
//                                    width: getProportionateScreenWidth(20),
//                                  ),
//                                  InkWell(
//                                    onTap: (){
//                                      print("View Results pressed");
//                                      push(context, ResultListScreen());
//                                    },
//                                    child: Expanded(
//                                      child: Container(
//                                        height: getProportionateScreenHeight(70),
//                                        padding: EdgeInsets.symmetric(
//                                            horizontal:
//                                                getProportionateScreenWidth(18)),
//                                        decoration: BoxDecoration(
//                                            color: Color(COLOR_ACCENT),
//                                            borderRadius: BorderRadius.circular(12),
//                                            border: Border.all(
//                                                color: Colors.white, width: 1.3)),
//                                        child: Row(
//                                          mainAxisAlignment:
//                                              MainAxisAlignment.spaceBetween,
//                                          crossAxisAlignment:
//                                              CrossAxisAlignment.center,
//                                          children: [
//                                            Column(
//                                              crossAxisAlignment:
//                                                  CrossAxisAlignment.start,
//                                              mainAxisAlignment:
//                                                  MainAxisAlignment.center,
//                                              children: [
//                                                Text(
//                                                  "RESULTS",
//                                                  style: GoogleFonts.firaSans(
//                                                      color: Colors.white,
//                                                      letterSpacing: 2,
//                                                      fontSize: 13),
//                                                ),
//                                                Text(
//                                                  resultIds == null ? "0" : resultIds.toList().length.toString(),
//                                                  style: GoogleFonts.firaSans(
//                                                      color: Colors.white,
//                                                      fontWeight: FontWeight.w600,
//                                                      fontSize: 22),
//                                                )
//                                              ],
//                                            ),
//                                            Icon(
//                                              Icons.arrow_forward_ios_rounded,
//                                              color: Colors.white,
//                                            )
//                                          ],
//                                        ),
//                                      ),
//                                    ),
//                                  )
//                                ],
//                              ),
//                              Spacer(),
//                              resultIds == null ? Container() : Container(
//                                padding: EdgeInsets.symmetric(
//                                    horizontal: getProportionateScreenWidth(18),
//                                    vertical: getProportionateScreenHeight(13)),
//                                decoration: BoxDecoration(
//                                    color: Color(COLOR_ACCENT),
//                                    borderRadius: BorderRadius.circular(12),
//                                    border: Border.all(
//                                        color: Colors.white, width: 1.3)),
//                                child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  mainAxisAlignment: MainAxisAlignment.center,
//                                  children: [
//                                    Text(
//                                      "LAST RESULT",
//                                      style: GoogleFonts.firaSans(
//                                          color: Colors.white,
//                                          letterSpacing: 2,
//                                          fontSize: 13),
//                                    ),
//                                    InkWell(
//                                      onTap: (){
//                                        push(context, ResultDetails(resultDateTimes[0], spiritQuadScore[0], spiritQuadDisplay[0], spiritBlurb[0], purposeQuadScore[0], purposeQuadDisplay[0], purposeBlurb[0],  professionQuadScore[0], professionQuadDisplay[0], professionBlurb[0], rewardQuadScore[0], rewardQuadDisplay[0], rewardBlurb[0], resultHighlights[0]));
//                                      },
//                                      child: Row(
//                                        mainAxisAlignment:
//                                            MainAxisAlignment.spaceBetween,
//                                        crossAxisAlignment: CrossAxisAlignment.center,
//                                        children: [
//                                          Column(
//                                            crossAxisAlignment:
//                                                CrossAxisAlignment.start,
//                                            children: [
//                                              Text(
//                                                resultDateTimes[0],
//                                                style: GoogleFonts.firaSans(
//                                                    color: Colors.white,
//                                                    fontWeight: FontWeight.w600,
//                                                    fontSize: 18),
//                                              ),
//                                              Text(
//                                                completedSprints.toString()+ " SPRINTS",
//                                                style: GoogleFonts.firaSans(
//                                                    color: Colors.white,
//                                                    letterSpacing: 2,
//                                                    fontWeight: FontWeight.w600,
//                                                    fontSize: 12),
//                                              ),
//                                            ],
//                                          ),
//                                          ConstrainedBox(
//                                            constraints: BoxConstraints.tightFor(
//                                              width: getProportionateScreenWidth(67),
//                                            ),
//                                            child: ElevatedButton(
//                                                onPressed: () {},
//                                                style: ElevatedButton.styleFrom(
//                                                    shape: RoundedRectangleBorder(
//                                                      borderRadius:
//                                                          BorderRadius.circular(100),
//                                                    ),
//                                                    primary: Colors.white,
//                                                    onPrimary: Color(COLOR_ACCENT),
//                                                    textStyle: GoogleFonts.firaSans(
//                                                        fontSize: 12,
//                                                        color: Color(COLOR_ACCENT))),
//                                                child: Text("VIEW")),
//                                          )
//                                        ],
//                                      ),
//                                    )
//                                  ],
//                                ),
//                              )
//                            ],
//                          ),
//                        ),
//                      ),
//                      Container(
//                        padding: EdgeInsets.symmetric(
//                            horizontal: getProportionateScreenWidth(33),
//                            vertical: getProportionateScreenHeight(11)),
//                        child: Column(
//                          mainAxisAlignment: MainAxisAlignment.start,
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          children: [
//                            Container(
//                              height: 2,
//                              color: Color(0xFFDAE7FF),
//                            ),
//                            SizedBox(height: 10,),
//                            Row(
//                              children: [
//                                SizedBox(height: 10,),
//                                Text(
//                                  "My Counsellors",
//                                  style: GoogleFonts.firaSans(
//                                      fontSize: 18, color: Color(0xFF383838)),
//                                ),
//                                SizedBox(height: 10,),
//                                Spacer(),
//                                SizedBox(width: getProportionateScreenWidth(31)),
//                                Icon(Icons.keyboard_arrow_down)
//                              ],
//                            ),SizedBox(height: 10,),
//                            SizedBox(
//                              height: getProportionateScreenHeight(13),
//                            ),
//                            Container(
//                              height: getProportionateScreenHeight(49),
//                              child: TextFormField(
//                                textAlignVertical: TextAlignVertical.center,
//                                decoration: InputDecoration(
//                                    hintText: "Add Counsellors",
//                                    hintStyle: GoogleFonts.firaSans(
//                                      fontSize: 14,
//                                      color: Color(0xFF989898),
//                                    ),
//                                    suffixText: "+ Add",
//                                    suffixStyle: GoogleFonts.firaSans(
//                                        color: Color(0xFF4C89F4), fontSize: 14),
//                                    border: OutlineInputBorder(
//                                        borderRadius: BorderRadius.circular(6),
//                                        borderSide: BorderSide(
//                                            color: Color(0xFFB5B5B5)))),
//                              ),
//                            ),SizedBox(height: 10,),
//                            SizedBox(
//                              height: getProportionateScreenHeight(13),
//                            ),
//                            Container(
//                              height: 2,
//                              color: Color(0xFFDAE7FF),
//                            ),
//                            SizedBox(
//                              height: getProportionateScreenHeight(11),
//                            ),
//                            CounsellorsTile(),
//                            SizedBox(
//                              height: getProportionateScreenHeight(11),
//                            ),
//                            Container(
//                              height: 2,
//                              color: Color(0xFFDAE7FF),
//                            ),
//                            SizedBox(
//                              height: getProportionateScreenHeight(11),
//                            ),
//                            CounsellorsTile(),
//                            Divider(
//                              color: Color(COLOR_ACCENT),
//                              thickness: 2,
//                              height: 30,
//                            ),
//                            Container(
//                              height: 2,
//                              color: Color(0xFFDAE7FF),
//                            ),
//                            TextButton(
//                                onPressed: () {},
//                                child: Row(
//                                  mainAxisAlignment:
//                                      MainAxisAlignment.spaceBetween,
//                                  children: [
//                                    Text(
//                                      "My Guardians",
//                                      style: GoogleFonts.firaSans(
//                                          color: Color(0xFF383838), fontSize: 18),
//                                    ),
//                                    Icon(
//                                      Icons.arrow_forward_ios_rounded,
//                                      color: Color(0xFF8B8B8B),
//                                      size: 22,
//                                    )
//                                  ],
//                                )),
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
//                                      "Social Media",
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
//                          ],
//                        ),
//                      )
//                    ],
//                  ),
//                ),
//              )
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
//
//class ScoreAndProgressBar extends StatelessWidget {
//  ScoreAndProgressBar({
//    Key key,
//    this.percent,
//    this.sprints, this.textColor,
//  }) : super(key: key);
//  final double percent, sprints;
//  final Color textColor;
//  @override
//  Widget build(BuildContext context) {
//    double _progPercent = percent / 100;
//    double _progtextPercent = percent / 10;
//    var tmp = _progtextPercent.toString().substring(0,5);
//    return Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: [
//        Text(
//          "$tmp/10 LV Score | $sprints Sprints",
//          style: GoogleFonts.firaSans(
//              color: textColor,
//              fontWeight: FontWeight.w600,
//              fontSize: 10),
//        ),
//        SizedBox(
//          height: getProportionateScreenHeight(10),
//        ),
//        LinearPercentIndicator(
//            backgroundColor: Colors.grey[500],
//            progressColor: Colors.yellow[700],
//            padding: EdgeInsets.zero,
//            animation: true,
//            width: getProportionateScreenWidth(144),
//            lineHeight: getProportionateScreenHeight(4),
//            percent: _progPercent),
//      ],
//    );
//  }
//}
//
//class CounsellorsTile extends StatelessWidget {
//  const CounsellorsTile({
//    Key key,
//  }) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Row(
//      mainAxisAlignment: MainAxisAlignment.start,
//      crossAxisAlignment: CrossAxisAlignment.center,
//      children: [
//        CircleAvatar(
//          radius: getProportionateScreenWidth(25),
//          backgroundColor: Colors.transparent,
//          backgroundImage: AssetImage("assets/images/sampleProf.png"),
//        ),
//        SizedBox(
//          width: getProportionateScreenWidth(16),
//        ),
//        Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: [
//            Text(
//              "Sameer Ranjan",
//              style: GoogleFonts.firaSans(
//                  fontSize: 18,
//                  color: Color(0xFF383838),
//                  fontWeight: FontWeight.w500),
//            ),
//            SizedBox(
//              width: getProportionateScreenWidth(10),
//            ),
//            Text(
//              "sameer@catenate.io",
//              style: GoogleFonts.firaSans(
//                fontSize: 10,
//                fontWeight: FontWeight.w600,
//                color: Color(0xFF727272),
//              ),
//            ),
//          ],
//        ),
//        Spacer(),
//        TextButton(
//            onPressed: () {},
//            style: TextButton.styleFrom(),
//            child: Text(
//              "REMOVE",
//              style: GoogleFonts.firaSans(
//                color: Color(0xFFEB1851),
//                fontSize: 12,
//              ),
//            ))
//      ],
//    );
//  }
//}
