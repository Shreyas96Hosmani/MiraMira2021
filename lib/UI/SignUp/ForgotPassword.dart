import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/helper.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:mira_mira/UI/BottomNav/bottom_nav_bar.dart';
import 'package:mira_mira/UI/SignUp/SignInOnlyScreen.dart';
import 'package:mira_mira/UI/SignUp/SignUpWithEmail.dart';
import 'package:mira_mira/UI/Tabs/firstHomeScreen.dart';
import 'package:mira_mira/UI/home_screen/home_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';

ProgressDialog prLogin;
var googleEmail;
var googleName;
var googleAuthId;
bool isLoggedIn = false;
String isSignedIn;
GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'profile',
  ],
);

TextEditingController forgotPasswordEmailController = TextEditingController();

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  bool showDots = false;

  Future<String> forgotPassword(context) async {

    setState(() {
      showDots = true;
    });

    var email = forgotPasswordEmailController.text.toString();

    print("email : "+email.toString());

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getForgotPasswordLink?emailId=$email";

    http.get(Uri.parse(url)).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseLoadUserProfile = jsonDecode(response.body);
      print(responseLoadUserProfile);

      var msg = responseLoadUserProfile['status'].toString();
      var msg2 = responseLoadUserProfile['message'].toString();
      if(msg == "SUCCESS"){
        setState(() {
          showDots = false;
        });
        forgotPasswordEmailController.clear();
        pop(context);
        Fluttertoast.showToast(msg: "Email sent",backgroundColor: Color(COLOR_ACCENT), textColor: Colors.white);
      }else{
        setState(() {
          showDots = false;
        });
        Fluttertoast.showToast(msg: msg2,backgroundColor: Colors.white, textColor: Colors.red);
      }

    });
  }

  _isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSignedIn  = prefs.getString('userID');
      print(isSignedIn);
      if(isSignedIn == null || isSignedIn == "null"){

      }else{
        isLoggedIn = true;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    forgotPasswordEmailController = TextEditingController();
    setState(() {
      showDots = false;
      isLoggedIn = false;
    });
    _isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    prLogin = ProgressDialog(context);
    SizeConfig().init(context);
    return isLoggedIn == false ? Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: getProportionateScreenHeight(351),
                    color: Color(COLOR_ACCENT),
                    child: Column(
                      children: [
                        Spacer(),
                        Center(
                          child: SvgPicture.asset(
                            "assets/imageSVG/miramira.svg",
                            height: getProportionateScreenHeight(60.66),
                          ),
                        ),
                        Spacer(),
                        SvgPicture.asset(
                          "assets/imageSVG/SignUpDesign.svg",
                          width: SizeConfig.screenWidth,
                          fit: BoxFit.fitWidth,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 20),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            size: getProportionateScreenWidth(30),
                            color: Colors.white,
                          )),
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width/1.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: getProportionateScreenHeight(60),
                    ),
                    Text(
                      "FORGOT PASSWORD",
                      style: GoogleFonts.firaSans(
                          letterSpacing: 8,
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(30),
                    ),
                    Text(
                      "Enter your email and we will send\nyou a password reset link...",
                      style: GoogleFonts.firaSans(
                          letterSpacing: 1,
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(60),
                    ),
                    CustomSignUpButton(
                      icon: Icon(Icons.email_outlined,color: Color(0xff1E73BE),),
                      btnName: "Enter email here...",
                      onPressed: () {
                        //forgotPassword(context);
                      },
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(60),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                          width: getProportionateScreenWidth(365),
                          height: getProportionateScreenHeight(50)),
                      child: ElevatedButton(
                          onPressed: (){
                            if(forgotPasswordEmailController.text.isEmpty){
                              Fluttertoast.showToast(msg: "Email cannot be empty",backgroundColor: Colors.white, textColor: Colors.red);
                            }else{
                              forgotPassword(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xff1E73BE),
                              //side: BorderSide(color: Color(0xFFC9E7FF)),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          child: Container(
                              width: getProportionateScreenWidth(200),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(showDots == true ? "Get Link  " : "Get Link >",
                                    style: GoogleFonts.firaSans(
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      fontSize: 18,
                                    ),
                                  ),
                                  showDots == true ?
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                                    child: JumpingDotsProgressIndicator(
                                      fontSize: 25.0,color: Colors.white,
                                    ),
                                  ) : Container(),
                                ],
                              ))),
                    ),
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    ) : HomePage();
  }
}

class CustomSignUpButton extends StatefulWidget {
  CustomSignUpButton({this.icon, this.btnName, this.onPressed});

  final Icon icon;
  final String btnName;
  final Function onPressed;

  @override
  _CustomSignUpButtonState createState() => _CustomSignUpButtonState();
}

class _CustomSignUpButtonState extends State<CustomSignUpButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                border: Border.all(color: Color(0xff1E73BE))
            ),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: widget.icon,
            )),SizedBox(width: 10,),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(
              width: getProportionateScreenWidth(245),
              height: getProportionateScreenHeight(50)),
          child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                  primary: Color(COLOT_SIGNUP_INNER),
                  side: BorderSide(color: Color(0xFFC9E7FF)),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              child: Container(
                  width: getProportionateScreenWidth(200),
                  child: TextFormField(
                    controller: forgotPasswordEmailController,
                    style: GoogleFonts.firaSans(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.btnName,
                      hintStyle: GoogleFonts.firaSans(
                        color: Colors.black,
                      ),
                    ),
                  ))),
        ),
      ],
    );
  }
}