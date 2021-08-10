import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/helper.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:mira_mira/UI/BottomNav/bottom_nav_bar.dart';
import 'package:mira_mira/UI/SignUp/ForgotPassword.dart';
import 'package:mira_mira/UI/SignUp/SignInOnlyScreen.dart';
import 'package:mira_mira/UI/Tabs/firstHomeScreen.dart';
import 'package:mira_mira/UI/home_screen/home_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

FocusNode focus11;
FocusNode focus22;

ProgressDialog prLogin;
var googleEmail;
var googleName;
var googleAuthId;
GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'profile',
  ],
);
var appleEmailStudent;
var appleFullNameStudent;

class SignInOnly extends StatefulWidget {
  @override
  _SignInOnlyState createState() => _SignInOnlyState();
}

class _SignInOnlyState extends State<SignInOnly> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwodController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool obscureText = true;

  Future<void> _handleSignIn() async {
    try {
      await googleSignIn.signIn().then((value) {
        prLogin.hide();
        setState(() {
          googleEmail = googleSignIn.currentUser.email;
          googleName = googleSignIn.currentUser.displayName;
          googleAuthId = googleSignIn.currentUser.id;
        });
        print(googleEmail);
        print(googleName);
        print(googleAuthId);
        prLogin.show();
        loginUser2("", "", "GOOGLE");
      });
    } catch (error) {
      print(error);
      _handleSignOut();
    }
  }

  Future<void> _handleSignOut() => googleSignIn.disconnect();

  Future<String> loginUser(String email, String password, String outhType) async {
    prLogin.show();
    String url = apiUrl+"loginUser";
    var body = jsonEncode({
      "userId": email,
      "password": password,
      "outhType": outhType
    });

    http
        .post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
        },
        body: body)
        .then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseAddUser = jsonDecode(response.body);
      print(responseAddUser);

      prLogin.hide();

      var statusMsg = responseAddUser['status'].toString();
      var msg = responseAddUser['message'].toString();

      if (statusMsg == "SUCCESS") {
        prLogin.hide();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userID", emailController.text.toString());
        push(context, HomePage());
      } else if (statusMsg == "FAIL") {
        prLogin.hide();
        Fluttertoast.showToast(
            msg: msg,
            textColor: Colors.white,
            backgroundColor: Color(COLOR_ACCENT));
      }
    });
  }
  Future<String> loginUser2(String email, String password, String outhType) async {
    prLogin.show();
    String url = apiUrl+"loginUser";
    var body = jsonEncode({
      "userId": googleEmail,
      "password": "",
      "outhType": "GOOGLE"
    });

    http
        .post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
        },
        body: body)
        .then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseAddUser = jsonDecode(response.body);
      print(responseAddUser);

      prLogin.hide();

      var statusMsg = responseAddUser['status'].toString();
      var msg = responseAddUser['message'].toString();

      if (statusMsg == "SUCCESS") {
        prLogin.hide();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userID", googleEmail.toString());
        push(context, HomePage());
      } else if (statusMsg == "FAIL") {
        prLogin.hide();
        Fluttertoast.showToast(
            msg: msg,
            textColor: Colors.white,
            backgroundColor: Color(COLOR_ACCENT));
      }
    });
  }
  Future<String> loginUser3(String email, String password, String outhType) async {
    prLogin.show();
    String url = apiUrl+"loginUser";
    var body = jsonEncode({
      "userId": "$appleEmailStudent",
      "password": "",
      "outhType": "APPLE"
    });

    http
        .post(Uri.parse(url),
        headers: {
          'content-type': 'application/json',
        },
        body: body)
        .then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseAddUser = jsonDecode(response.body);
      print(responseAddUser);

      prLogin.hide();

      var statusMsg = responseAddUser['status'].toString();
      var msg = responseAddUser['message'].toString();

      if (statusMsg == "SUCCESS") {
        prLogin.hide();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userID", appleEmailStudent.toString());
        push(context, HomePage());
      } else if (statusMsg == "FAIL") {
        prLogin.hide();
        Fluttertoast.showToast(
            msg: msg,
            textColor: Colors.white,
            backgroundColor: Color(COLOR_ACCENT));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focus11 = FocusNode();
    focus22 = FocusNode();
    setState(() {
      obscureText = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    prLogin = ProgressDialog(context);
//    prLogin.style(
//        message: 'Logging in...',
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
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: (){FocusScope.of(context).requestFocus(new FocusNode());},
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: getProportionateScreenHeight(200),
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
                    SvgPicture.asset(
                      "assets/imageSVG/SignUpDesign.svg",
                      width: SizeConfig.screenWidth,
                      fit: BoxFit.fitWidth,
                    )
                  ],
                ),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child:  Form(
                      key: formKey,
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),
                          Text(
                            "SIGN IN",
                            style: GoogleFonts.firaSans(
                                letterSpacing: 8,
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: getProportionateScreenWidth(279),
                                height: getProportionateScreenHeight(63)),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color(COLOT_SIGNUP_INNER),
                                    side: BorderSide(color: Color(0xFFC9E7FF)),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(5))),
                                onPressed: () {},
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: getProportionateScreenWidth(15),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100)),
                                          border: Border.all(
                                              color: Color(0xff1E73BE))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Icon(
                                          focus11.hasFocus || emailController.text.isNotEmpty ? Icons.email : Icons.email_outlined,
                                          color: Color(0xff1E73BE),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: getProportionateScreenWidth(21),
                                    ),
                                    Container(
                                      width: getProportionateScreenWidth(180),
                                      child: TextFormField(
                                        focusNode: focus11,
                                        controller: emailController,
                                        validator: (value) {
                                          if (value.isEmpty ||
                                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                  .hasMatch(value)) {
                                            return 'Enter a valid email!';
                                          }
                                          return null;
                                        },
                                        style: GoogleFonts.firaSans(
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Email",
                                          hintStyle: GoogleFonts.firaSans(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints.tightFor(
                                    width: getProportionateScreenWidth(279),
                                    height: getProportionateScreenHeight(63)),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(COLOT_SIGNUP_INNER),
                                        side: BorderSide(
                                            color: Color(0xFFC9E7FF)),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(5))),
                                    onPressed: () {},
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width:
                                          getProportionateScreenWidth(15),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(100)),
                                              border: Border.all(
                                                  color: Color(0xff1E73BE))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Icon(
                                              focus22.hasFocus  || passwodController.text.isNotEmpty ? Icons.lock : Icons.lock_outlined,
                                              color: Color(0xff1E73BE),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                          getProportionateScreenWidth(21),
                                        ),
                                        Container(
                                          width:
                                          getProportionateScreenWidth(180),
                                          child: TextFormField(
                                            obscureText: obscureText,
                                            focusNode: focus22,
                                            controller: passwodController,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Password is compulsory';
                                              } else if (value.length >= 25) {
                                                return 'Maximum 25 characters are allowed';
                                              }
                                              return null;
                                            },
                                            style: GoogleFonts.firaSans(
                                              color: Colors.black,
                                            ),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Password",
                                              hintStyle: GoogleFonts.firaSans(
                                                color: Colors.black,
                                              ),
                                              suffixIcon: obscureText == true ? GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      obscureText = false;
                                                    });
                                                  },
                                                  child: Icon(Icons.visibility,color: Colors.grey,)) : GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      obscureText = true;
                                                    });
                                                  },
                                                  child: Icon(Icons.visibility_off,color: Colors.grey,)),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  push(context, ForgotPassword());
                                },
                                child: Text(
                                  "FORGOT PASSWORD ?",
                                  style: GoogleFonts.firaSans(
                                      letterSpacing: 0,
                                      color: Colors.black,
                                      fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(33),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: getProportionateScreenWidth(365),
                                height: getProportionateScreenHeight(50)),
                            child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                    loginUser(emailController.text.toString(), passwodController.text.toString(), "INTERNAL");
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xff1E73BE),
                                    //side: BorderSide(color: Color(0xFFC9E7FF)),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(5))),
                                child: Container(
                                    width: getProportionateScreenWidth(200),
                                    child: Text(
                                      "Login >",
                                      style: GoogleFonts.firaSans(
                                        color: Colors.white,
                                        letterSpacing: 2,
                                        fontSize: 18,
                                      ),
                                    ))),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(33),
                          ),
                          Text(
                            "OR SIGN IN WITH",
                            style: GoogleFonts.firaSans(
                              letterSpacing: 2,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(33),
                          ),
                          Platform.isIOS ? Container()
                              : CustomSignUpButton2(
                            iconPath: "assets/iconSVG/google-icon.svg",
                            btnName: "Login using Google",
                            onPressed: () {
                              _handleSignIn();
                            },
                          ),
                          Platform.isIOS ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomSignUpButton(
                                iconPath: "assets/iconSVG/google-icon.svg",
                                btnName: "Google",
                                onPressed: () {
                                  _handleSignIn();
                                },
                              ),
                              SizedBox(
                                width: getProportionateScreenHeight(20),
                              ),
                              CustomSignUpButton(
                                btnName: "Apple",
                                iconPath: "assets/iconSVG/apple-black.svg",
                                onPressed: () async {
                                  final credential = await SignInWithApple.getAppleIDCredential(
                                    scopes: [
                                      AppleIDAuthorizationScopes.email,
                                      AppleIDAuthorizationScopes.fullName,
                                    ],
//                        webAuthenticationOptions: WebAuthenticationOptions(
//                          // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
//                          clientId:
//                          'miramiracatenate',
//                          redirectUri: Uri.parse('',),
//                        ),
                                  );
                                  print(credential);

                                  setState(() {
                                    appleFullNameStudent = credential.givenName.toString()+" "+credential.familyName.toString();
                                    appleEmailStudent = credential.email;
                                  });

                                  print("appleFullNameStudent : "+appleFullNameStudent);
                                  print("appleEmailStudent : "+appleEmailStudent);

                                  loginUser3("", "", "");
                                  //push(context, HomePage());
                                },
                              ),
                            ],
                          ) : Container(),
                          SizedBox(
                            height: getProportionateScreenHeight(33),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "New user ?",
                                style: GoogleFonts.firaSans(
                                    letterSpacing: 0,
                                    color: Colors.black,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  pop(context);
                                },
                                child: Text(
                                  "Sign up",
                                  style: GoogleFonts.firaSans(
                                      color: Color(0xFF0085FF), fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSignUpButton extends StatefulWidget {
  CustomSignUpButton({this.iconPath, this.btnName, this.onPressed});

  final String iconPath, btnName;
  final Function onPressed;

  @override
  _CustomSignUpButtonState createState() => _CustomSignUpButtonState();
}

class _CustomSignUpButtonState extends State<CustomSignUpButton> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
          width: getProportionateScreenWidth(133),
          height: getProportionateScreenHeight(63)),
      child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
              primary: Color(COLOT_SIGNUP_INNER),
              side: BorderSide(color: Color(0xFFC9E7FF)),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                widget.iconPath,
                width: getProportionateScreenWidth(26),
              ),
              SizedBox(
                width: getProportionateScreenWidth(21),
              ),
              Text(
                widget.btnName,
                style: GoogleFonts.firaSans(
                    fontSize: 18, color: Color(COLOT_SIGNUP_TEXT_COLOR)),
              )
            ],
          )),
    );
  }
}

class CustomSignUpButton2 extends StatefulWidget {
  CustomSignUpButton2({this.iconPath, this.btnName, this.onPressed});

  final String iconPath, btnName;
  final Function onPressed;

  @override
  _CustomSignUpButton2State createState() => _CustomSignUpButton2State();
}

class _CustomSignUpButton2State extends State<CustomSignUpButton2> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
          width: double.infinity,
          height: getProportionateScreenHeight(63)),
      child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
              primary: Color(COLOT_SIGNUP_INNER),
              side: BorderSide(color: Color(0xFFC9E7FF)),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: getProportionateScreenWidth(21),
              ),
              SvgPicture.asset(
                widget.iconPath,
                width: getProportionateScreenWidth(26),
              ),
              SizedBox(
                width: getProportionateScreenWidth(21),
              ),
              Text(
                widget.btnName,
                style: GoogleFonts.firaSans(
                    fontSize: 18, color: Color(COLOT_SIGNUP_TEXT_COLOR)),
              )
            ],
          )),
    );
  }
}
