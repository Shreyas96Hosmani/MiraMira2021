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
import 'package:mira_mira/UI/SignUp/SignInOnlyScreen.dart';
import 'package:mira_mira/UI/SignUp/SignUpWithEmail.dart';
import 'package:mira_mira/UI/home_screen/home_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
var appleEmailStudent;
var appleFullNameStudent;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

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
        addUser(context);
      });
    } catch (error) {
      print(error);
      _handleSignOut();
    }
  }
  Future<void> _handleSignOut() => googleSignIn.disconnect();

  Future<String> addUser(context) async {

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/addUser";
    var body = jsonEncode({
      "name" : "$googleName",
      "userId" : "$googleEmail",
      "password" : "abcd1234",
      "email" : "$googleEmail",
      "location" : "Hyderabad",
      "deviceType" : Platform.isAndroid ? "Android" : "iOS",
      "deviceId" : "",
      "dateOfBirth" : "01-01-1983",
      "gender" : "Male",
      "age" : "38",
      "outhType" : "GOOGLE",
      "userPhoto" : "",
    });


    http.post(Uri.parse(url),
        headers: {
          'content-type' : 'application/json',
        },
        body: body).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseAddUser = jsonDecode(response.body);
      print(responseAddUser);

      prLogin.hide();

      var statusMsg = responseAddUser['status'].toString();
      var msg = responseAddUser['message'].toString();

      if(statusMsg == "SUCCESS"){
        Fluttertoast.showToast(msg: "Name : $googleName\nemail : $googleEmail", textColor: Colors.white, backgroundColor: Color(COLOR_ACCENT)).whenComplete(() async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("userID", googleEmail.toString());
          push(context, HomePage());
        });
      }else if(statusMsg == "FAIL"){
        Fluttertoast.showToast(msg: msg, textColor: Colors.white, backgroundColor: Color(COLOR_ACCENT));
      }

    });
  }

  Future<String> addUser2(context) async {

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/addUser";
    var body = jsonEncode({
      "name" : "$appleFullNameStudent",
      "userId" : "$appleEmailStudent",
      "password" : "abcd1234",
      "email" : "$appleEmailStudent",
      "location" : "Hyderabad",
      "deviceType" : Platform.isAndroid ? "Android" : "iOS",
      "deviceId" : "",
      "dateOfBirth" : "01-01-1983",
      "gender" : "Male",
      "age" : "38",
      "outhType" : "APPLE",
      "userPhoto" : "",
    });


    http.post(Uri.parse(url),
        headers: {
          'content-type' : 'application/json',
        },
        body: body).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseAddUser = jsonDecode(response.body);
      print(responseAddUser);

      prLogin.hide();

      var statusMsg = responseAddUser['status'].toString();
      var msg = responseAddUser['message'].toString();

      if(statusMsg == "SUCCESS"){
        Fluttertoast.showToast(msg: "Name : $googleName\nemail : $googleEmail", textColor: Colors.white, backgroundColor: Color(COLOR_ACCENT)).whenComplete(() async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("userID", appleEmailStudent.toString());
          push(context, HomePage());
        });
      }else if(statusMsg == "FAIL"){
        Fluttertoast.showToast(msg: msg, textColor: Colors.white, backgroundColor: Color(COLOR_ACCENT));
      }

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

  _isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isSignedIn  = prefs.getString('userID');
      print(isSignedIn);
      if(isSignedIn == null || isSignedIn == "null"){

      }else{
        isLoggedIn = true;
        //getSprints(context);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
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
            Container(
              width: MediaQuery.of(context).size.width/1.3,
                height: MediaQuery.of(context).size.height/2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(40),
                ),
                Text(
                  "GET STARTED",
                  style: GoogleFonts.firaSans(
                      letterSpacing: 8,
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(40),
                ),
                CustomSignUpButton(
                  iconPath: "assets/iconSVG/google-icon.svg",
                  btnName: "Signup with Google",
                  onPressed: () {
                    prLogin.show();
                    _handleSignIn();
                  },
                ),
                Platform.isIOS ?
                SizedBox(
                  height: getProportionateScreenHeight(17),
                ) : Container(),
                Platform.isIOS ?
                CustomSignUpButton(
                  btnName: "Signup with Apple",
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

                    addUser2(context);

//                      final signInWithAppleEndpoint = Uri(
//                        scheme: 'https',
//                        host: 'flutter-sign-in-with-apple-example.glitch.me',
//                        path: '/sign_in_with_apple',
//                        queryParameters: <String, String>{
//                          'code': credential.authorizationCode,
//                          if (credential.givenName != null)
//                            'firstName': credential.givenName,
//                          if (credential.familyName != null)
//                            'lastName': credential.familyName,
//                          'useBundleId':
//                          Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
//                          if (credential.state != null) 'state': credential.state,
//                        },
//                      );
//
//                      final session = await http.Client().post(
//                        signInWithAppleEndpoint,
//                      );
//
//                      // If we got this far, a session based on the Apple ID credential has been created in your system,
//                      // and you can now set this as the app's session
//                      print(session);
                  },
                ) : Container(),
                SizedBox(
                  height: getProportionateScreenHeight(17),
                ),
                CustomSignUpButton(
                  btnName: "Signup with Email",
                  iconPath: "assets/iconSVG/attherate.svg",
                  onPressed: () {
                    push(context, SignUpWithEmail());
                  },
                ),
                SizedBox(
                  height: getProportionateScreenHeight(33),
                ),
                Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: GoogleFonts.firaSans(
                        letterSpacing: 0,
                          color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                        push(context, SignInOnly());
                      },
                      child: Text("Sign in",
                              style: GoogleFonts.firaSans(
                                  color: Color(0xFF0085FF), fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ))
          ],
        ),
      ),
    ) : HomePage();
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
          width: getProportionateScreenWidth(279),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
