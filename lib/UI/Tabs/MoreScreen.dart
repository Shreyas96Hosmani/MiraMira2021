//import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:mira_mira/Helper/constants.dart';
//import 'package:mira_mira/Helper/helper.dart';
//import 'package:mira_mira/Helper/sizeconfig.dart';
//import 'package:mira_mira/UI/MessageCenter/messageCenter.dart';
//import 'package:mira_mira/UI/Settings/settingsScreen.dart';
//import 'package:mira_mira/UI/SignUp/LoginSignupScreen.dart';
//import 'package:mira_mira/UI/UserProfileScreen/UserProfileScreen.dart';
//import 'package:mira_mira/UI/home_screen/home_screen.dart';
//import 'package:mira_mira/UI/home_screen/home_screen.dart' as h;
//import 'package:percent_indicator/linear_percent_indicator.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//
//class MoreScreen extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return SafeArea(
//      child: Scaffold(
//        body: Stack(
//          children: [
//            Container(
//              width: double.infinity,
//              height: getProportionateScreenHeight(96),
//              color: Color(COLOR_ACCENT),
//              child: Align(
//                alignment: Alignment.topRight,
//                child: SvgPicture.asset(
//                  "assets/imageSVG/HeaderSIdeDesign.svg",
//                  height: getProportionateScreenHeight(96),
//                  fit: BoxFit.fitHeight,
//                ),
//              ),
//            ),
//            Container(
//              width: double.infinity,
//              margin: EdgeInsets.all(getProportionateScreenWidth(10)),
//              decoration: BoxDecoration(
//                border: Border.all(color: Color(0xFFDAE7FF), width: 2),
//                borderRadius: BorderRadius.circular(7),
//                color: Colors.white,
//              ),
//              height: getProportionateScreenHeight(982),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisAlignment: MainAxisAlignment.start,
//                children: [
//                  Container(
//                    height: getProportionateScreenHeight(96),
//                    padding: EdgeInsets.all(
//                      getProportionateScreenWidth(22),
//                    ),
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: [
//                        Text(
//                          "More",
//                          style: GoogleFonts.firaSans(
//                              color: Color(0xFF383838),
//                              fontWeight: FontWeight.w400,
//                              fontSize: 18),
//                        ),
////                        GestureDetector(
////                            onTap: () {
////                              Navigator.pop(context);
////                            },
////                            child: Icon(
////                              Icons.close,
////                              size: getProportionateScreenWidth(30),
////                              color: Color(0xFF6C6C6C),
////                            )),
//                      ],
//                    ),
//                  ),
//                  Container(
//                    padding: EdgeInsets.symmetric(
//                        horizontal: getProportionateScreenWidth(14)),
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: [
//                        ProfileButton(
//                          name: h.userName.toString(),
//                          email: isSignedIn.toString(),
//                          percentage: 40,
//                          onPressed: () {
//                            push(context, UserProfileScreen());
//                          },
//                        ),
//                        SizedBox(
//                          height: getProportionateScreenHeight(10),
//                        ),
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
//                        logoutButton(
////                          onPressed: (){
////                            Navigator.of(context).popUntil((route) => route.isFirst);
////                          },
//                        )
//                      ],
//                    ),
//                  )
//                ],
//              ),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//class logoutButton extends StatelessWidget {
//  const logoutButton({
//    Key key, this.onPressed,
//  }) : super(key: key);
//
//  final Function onPressed;
//
//  @override
//  Widget build(BuildContext context) {
//    return ConstrainedBox(
//      constraints: BoxConstraints.tightFor(
//          width: getProportionateScreenWidth(321),
//          height: getProportionateScreenHeight(55)),
//      child: ElevatedButton(
//        onPressed: () async {
//          print("enfjwehf");
//          SharedPreferences prefs = await SharedPreferences.getInstance();
//          prefs.clear().whenComplete((){
//            googleSignIn.disconnect();
//            Fluttertoast.showToast(msg: "Logged out", backgroundColor: Color(COLOR_ACCENT), textColor: Colors.white);
//            Navigator.pushReplacement(
//                context,
//                PageRouteBuilder(
//                  pageBuilder: (c, a1, a2) => LoginScreen(),
//                  transitionsBuilder: (c, anim, a2, child) =>
//                      FadeTransition(opacity: anim, child: child),
//                  transitionDuration: Duration(milliseconds: 300),
//                ));
//          });
//        },
//        style: ElevatedButton.styleFrom(
//          primary: Colors.white,
//          elevation: 0,
//          padding: EdgeInsets.symmetric(
//              horizontal: getProportionateScreenWidth(16)),
//          onPrimary: Color(COLOR_ACCENT),
//          shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(8),
//              side: BorderSide(
//                  color: Color(0xFFC14444), width: 2)),
//        ),
//        child: Row(
//          children: [
//            SvgPicture.asset(
//              "assets/iconSVG/logout.svg",
//              height: getProportionateScreenWidth(25),
//            ),
//            SizedBox(
//              width: getProportionateScreenWidth(21),
//            ),
//            Text(
//              "Logout",
//              style: GoogleFonts.firaSans(
//                  fontSize: 18,
//                  color: Color(0xFFC14444),
//                  fontWeight: FontWeight.normal),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//class SettingCustomButton extends StatelessWidget {
//  const SettingCustomButton({
//    Key key, this.text, this.imgPath, this.onTap,
//  }) : super(key: key);
//  final String text,imgPath;
//  final Function onTap;
//
//  @override
//  Widget build(BuildContext context) {
//    return ConstrainedBox(
//      constraints: BoxConstraints.tightFor(
//          width: getProportionateScreenWidth(321),
//          height: getProportionateScreenHeight(55)),
//      child: ElevatedButton(
//        onPressed: onTap,
//        style: ElevatedButton.styleFrom(
//          primary: Colors.white,
//          elevation: 0,
//          padding: EdgeInsets.symmetric(
//              horizontal: getProportionateScreenWidth(16)),
//          onPrimary: Color(COLOR_ACCENT),
//          shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(8),
//              side: BorderSide(
//                  color: Color(0xFFDAE7FF), width: 2)),
//        ),
//        child: Row(
//          children: [
//            SvgPicture.asset(
//              imgPath,
//              height: getProportionateScreenWidth(25),
//            ),
//            SizedBox(
//              width: getProportionateScreenWidth(21),
//            ),
//            Text(
//              text,
//              style: GoogleFonts.firaSans(
//                  fontSize: 18,
//                  color: Color(0xFF383838),
//                  fontWeight: FontWeight.normal),
//            ),
//            Spacer(),
//            Icon(
//              Icons.arrow_forward_ios,
//              color: Color(0xFF8B8B8B),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//class ProfileButton extends StatelessWidget {
//  const ProfileButton({
//    Key key,
//    this.name,
//    this.email,
//    this.profileImg,
//    this.percentage,
//    this.onPressed,
//  }) : super(key: key);
//
//  final String name, email, profileImg;
//  final double percentage;
//  final Function onPressed;
//
//  @override
//  Widget build(BuildContext context) {
//    return ConstrainedBox(
//      constraints: BoxConstraints.tightFor(
//          width: getProportionateScreenWidth(321),
//          height: getProportionateScreenHeight(150)),
//      child: ElevatedButton(
//        onPressed: onPressed,
//        style: ElevatedButton.styleFrom(
//          primary: Color(0xff1E73BE),
//          elevation: 0,
//          padding: EdgeInsets.all(getProportionateScreenWidth(16)),
//          onPrimary: Color(0xff1E73BE),
//          shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(8),
//              side: BorderSide(color: Color(0xff1E73BE), width: 2)),
//        ),
//        child: Row(
//          children: [
//            Container(
//              decoration: BoxDecoration(
//                  borderRadius: BorderRadius.all(Radius.circular(100)),
//                  boxShadow: [new BoxShadow(
//                    color: Colors.black,
//                    blurRadius: 7.0,
//                  ),]
//              ),
//              child: CircleAvatar(
//                radius: getProportionateScreenWidth(32.5),
//                backgroundColor: Colors.white,
//                child: Container(
//                  color: Colors.transparent,
//                  margin: EdgeInsets.all(4),
//                  child: Container(
//                    child: Image.asset("assets/images/sampleProf.png"),
//                  ),
//                ),
//              ),
//            ),
////            CircleAvatar(
////              radius: getProportionateScreenWidth(32.5),
////              backgroundColor: Colors.blue[700],
////              //backgroundImage: AssetImage(profileImg),
////              child: Icon(Icons.person, color: Colors.white,),
////            ),
//            SizedBox(
//              width: getProportionateScreenWidth(21),
//            ),
//            Column(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: [
//                Text(
//                  "My Profile",
//                  style: GoogleFonts.firaSans(
//                      fontSize: 18, color: Colors.white),
//                ),
//                Spacer(),
//                Text(
//                  "Shreyas Hosmani",//name,
//                  style: GoogleFonts.firaSans(
//                      fontSize: 15,
//                      color: Colors.white,
//                      fontWeight: FontWeight.bold),
//                ),
//                Spacer(),
//                Text(
//                  "godlab.developers@gmail.com",//email,
//                  style: GoogleFonts.firaSans(
//                    fontSize: 14,
//                    color: Colors.white,
//                  ),
//                ),
//                SizedBox(
//                  height: getProportionateScreenHeight(14),
//                ),
//                ScoreAndProgressBar(
//                  percent: 30,//double.parse(h.completedSprints)/double.parse(h.sprintNames.length.toString()),
//                  sprints: 4,//double.parse(h.completedSprints.toString()),
//                  textColor: Colors.white,
//                ),
//              ],
//            ),
//            Spacer(),
//            Icon(
//              Icons.arrow_forward_ios,
//              color: Colors.white,
//            ),
//          ],
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
//    return Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: [
//        Text(
//          "$_progtextPercent/10 LV Score | $sprints Sprints",
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
