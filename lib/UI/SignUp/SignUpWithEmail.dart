import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/helper.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:mira_mira/UI/BottomNav/bottom_nav_bar.dart';
import 'package:mira_mira/UI/SignUp/SignInOnlyScreen.dart';
import 'package:mira_mira/UI/Tabs/firstHomeScreen.dart';
import 'package:mira_mira/UI/home_screen/home_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

ProgressDialog prLogin;
FocusNode focus1;
FocusNode focus2;
FocusNode focus3;
FocusNode focus4;
FocusNode focus5;

class SignUpWithEmail extends StatefulWidget {
  @override
  _SignUpWithEmailState createState() => _SignUpWithEmailState();
}

class _SignUpWithEmailState extends State<SignUpWithEmail> {
  
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController passwodController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime currentDate = DateTime.now();
  int age = 14;
  bool obscureText1 = true;
  bool obscureText2 = true;

  var addresses;
  var first;
  var tempAddress;
  var tempAddress2;
  var lat; var long;
  var kInitialPosition;
  Location location = new Location();
  LocationData _locationData;
  var state;

  getLocation() async {
    _locationData = await location.getLocation();
    print(_locationData.toString());

    setState(() {
      lat = _locationData.latitude;
      long = _locationData.longitude;
    });

    final coordinates = new Coordinates(lat, long);
    addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");

    setState(() {
      tempAddress = "${first.featureName} : ${first.addressLine}";
      state = "${first.locality}";
    });

    print(state);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1950),
        lastDate: currentDate);
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {

        dobController.text= DateFormat('MM-dd-yyyy').format(pickedDate);

        var years = currentDate.difference(pickedDate);

        DateTime birthDate = DateFormat('MM-dd-yyyy').parse(dobController.text);

        DateTime today = DateTime.now();

         age = today.year - birthDate.year;
         print(age);

         if(age < 14){
           Fluttertoast.showToast(
               msg: "You should be above 14 years of age",
               textColor: Colors.white,
               backgroundColor: Color(COLOR_ACCENT));
           dobController.clear();
         }else{
           setState(() {
             var month;

             month = dobController.text.toString().substring(0,2) == "01" ? "Jan" : dobController.text.toString().substring(0,2) == "02" ? "Feb" : dobController.text.toString().substring(0,2) == "03" ? "Mar" : dobController.text.toString().substring(0,2) == "04" ? "Apr" : dobController.text.toString().substring(0,2) == "05" ? "May" : dobController.text.toString().substring(0,2) == "06" ? "Jun" : dobController.text.toString().substring(0,2) == "07" ? "July" : dobController.text.toString().substring(0,2) == "08" ? "Aug" : dobController.text.toString().substring(0,2) == "09" ? "Sep" : dobController.text.toString().substring(0,2) == "10" ? "Oct" : dobController.text.toString().substring(0,2) == "11" ? "Nov" : "Dec";
             print("month"+month);

             dobController.text = month.toString()+" "+dobController.text.toString().substring(3,5)+", "+dobController.text.toString().substring(6,10);
             print("final DOB : "+dobController.text.toString());

             focus2.unfocus();
           });
         }

      });
  }

  Future<String> addUser(context) async {
    prLogin.show();

    print(state.toString());

    String url =
        "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/addUser";
    var body = jsonEncode({
      "name": nameController.text.toString()??"",
      "userId": emailController.text.toString()??"",
      "password": passwodController.text.toString()??"",
      "email": emailController.text.toString()??"",
      "location": state.toString(),
      "deviceType": Platform.isAndroid ? "Android" : "iOS",
      "deviceId": "",
      "dateOfBirth":  dobController.text.toString(),
      "gender": "Male",
      "age": age.toString(),
      "outhType": "INTERNAL",
      "userPhoto": "",
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userID", emailController.text.toString());
        push(context, HomePage());
      } else if (statusMsg == "FAIL") {
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
    focus1 = FocusNode();
    focus2 = FocusNode();
    focus3 = FocusNode();
    focus4 = FocusNode();
    focus5 = FocusNode();
    getLocation();
    setState(() {
      obscureText1 = true;
      obscureText2 = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    prLogin = ProgressDialog(context);
//    prLogin.style(
//        message: 'Signing up...',
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
                height: getProportionateScreenHeight(220),
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
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: getProportionateScreenHeight(30),
                        ),
                        Text(
                          "SIGN UP",
                          style: GoogleFonts.firaSans(
                              letterSpacing: 8,
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(30),
                        ),
                        buildNameField(context),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        buildAgeField(context),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        buildEmailField(context),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        buildPasswordField(context),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        buildConfirmPasswordField(context),
                        SizedBox(
                          height: getProportionateScreenHeight(40),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                              width: getProportionateScreenWidth(365),
                              height: getProportionateScreenHeight(50)),
                          child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                  addUser(context);
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
                                  child: Text(
                                    "Sign Up >",
                                    style: GoogleFonts.firaSans(
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      fontSize: 18,
                                    ),
                                  ))),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(30),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Already have an account?",
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
                                pushReplacement(context, SignInOnly());
                              },
                              child: Text(
                                "Sign in",
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

  Widget buildNameField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              border: Border.all(color: Color(0xff1E73BE))),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(
              focus1.hasFocus || nameController.text.isNotEmpty ? Icons.person : Icons.person_outline,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(
              width: getProportionateScreenWidth(245),
              height: getProportionateScreenHeight(50)),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color(COLOT_SIGNUP_INNER),
                  side: BorderSide(color: Color(0xFFC9E7FF)),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () {

              },
              child: Container(
                  width: getProportionateScreenWidth(200),
                  child: TextFormField(
                    controller: nameController,
                    focusNode: focus1,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Name is compulsory';
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
                      hintText: "Name",
                      hintStyle: GoogleFonts.firaSans(
                        color: Colors.black,
                      ),
                    ),
                  ))),
        ),
      ],
    );
  }

  Widget buildAgeField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              border: Border.all(color: Color(0xff1E73BE))),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(
              focus2.hasFocus || dobController.text.isNotEmpty ? Icons.person : Icons.person_outline,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(
              width: getProportionateScreenWidth(245),
              height: getProportionateScreenHeight(50)),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color(COLOT_SIGNUP_INNER),
                  side: BorderSide(color: Color(0xFFC9E7FF)),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () {  },
              child: Container(
                  width: getProportionateScreenWidth(200),
                  child: TextField(
                    focusNode: focus2,
                    controller: dobController,
                    onTap: (){
                      focus1.unfocus();
                      _selectDate(context);
                    },
                    style: GoogleFonts.firaSans(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Date of birth (mm/dd/yy)",
                      hintStyle: GoogleFonts.firaSans(
                        color: Colors.black,
                      ),
                    ),
                  ))),
        ),
      ],
    );
  }

  Widget buildEmailField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              border: Border.all(color: Color(0xff1E73BE))),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(
              focus3.hasFocus || emailController.text.isNotEmpty ? Icons.email : Icons.email_outlined,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(
              width: getProportionateScreenWidth(245),
              height: getProportionateScreenHeight(50)),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color(COLOT_SIGNUP_INNER),
                  side: BorderSide(color: Color(0xFFC9E7FF)),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () {},
              child: Container(
                  width: getProportionateScreenWidth(200),
                  child: TextFormField(
                    focusNode: focus3,
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
                  ))),
        ),
      ],
    );
  }

  Widget buildPasswordField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              border: Border.all(color: Color(0xff1E73BE))),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(
              focus4.hasFocus || passwodController.text.isNotEmpty ? Icons.lock : Icons.lock_outline,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(
              width: getProportionateScreenWidth(245),
              height: getProportionateScreenHeight(50)),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color(COLOT_SIGNUP_INNER),
                  side: BorderSide(color: Color(0xFFC9E7FF)),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () {},
              child: Container(
                  width: getProportionateScreenWidth(200),
                  child: TextFormField(
                    focusNode: focus4,
                    controller: passwodController,
                    obscureText: obscureText1,
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
                      suffixIcon: obscureText1 == true ? GestureDetector(
                          onTap: (){
                            setState(() {
                              obscureText1 = false;
                            });
                          },
                          child: Icon(Icons.visibility,color: Colors.grey,)) : GestureDetector(
                          onTap: (){
                            setState(() {
                              obscureText1 = true;
                            });
                          },
                          child: Icon(Icons.visibility_off,color: Colors.grey,)),
                    ),
                  ))),
        ),
      ],
    );
  }

  Widget buildConfirmPasswordField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              border: Border.all(color: Color(0xff1E73BE))),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Icon(
              focus5.hasFocus || confirmPasswordController.text.isNotEmpty ? Icons.lock : Icons.lock_outline,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(
              width: getProportionateScreenWidth(245),
              height: getProportionateScreenHeight(50)),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color(COLOT_SIGNUP_INNER),
                  side: BorderSide(color: Color(0xFFC9E7FF)),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
              onPressed: () {},
              child: Container(
                  width: getProportionateScreenWidth(200),
                  child: TextFormField(
                    obscureText: obscureText2,
                    focusNode: focus5,
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value.length == 0) {
                        return 'Password is compulsory';
                      } else if (value.length < 6) {
                        return 'Password must be greater than 6 charecters';
                      } else if (passwodController.text.toString() !=
                          confirmPasswordController.text.toString()) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    style: GoogleFonts.firaSans(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Confirm Password",
                      hintStyle: GoogleFonts.firaSans(
                        color: Colors.black,
                      ),
                      suffixIcon: obscureText2 == true ? GestureDetector(
                          onTap: (){
                            setState(() {
                              obscureText2 = false;
                            });
                          },
                          child: Icon(Icons.visibility,color: Colors.grey,)) : GestureDetector(
                          onTap: (){
                            setState(() {
                              obscureText2 = true;
                            });
                          },
                          child: Icon(Icons.visibility_off,color: Colors.grey,)),
                    ),
                  ))),
        ),
      ],
    );
  }
}
