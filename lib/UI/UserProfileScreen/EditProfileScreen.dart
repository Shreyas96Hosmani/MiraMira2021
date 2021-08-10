import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/helper.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:mira_mira/UI/home_screen/home_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:screenshot/screenshot.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

ProgressDialog prEdit;

TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController iAmAController = TextEditingController();

TextEditingController gradeController = TextEditingController();
TextEditingController schoolController = TextEditingController();
TextEditingController stateController = TextEditingController();

class EditProfileScreen extends StatefulWidget {
  final id;
  final name;
  final email;
  final grade;
  final school;
  final state;
  final county;
  final photo;
  EditProfileScreen(this.id, this.name, this.email, this.grade, this.school, this.state, this.county, this.photo) : super();
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  ScreenshotController screenshotController = ScreenshotController();
  Uint8List _imageFile;
  File profileImage;
  var profileBaseImage;
  var profileFileName;
  final picker = ImagePicker();
  bool isMentor = false;

  back(){
    pop(context);
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: profileImage.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      setState(() {
        profileImage = croppedFile;
      });
    }
  }

  Future getImageOne() async {
    Navigator.of(context).pop();
    var pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 25,);
    setState(() {
      profileImage = File(pickedFile.path);
//      imagePicked = true;
//      saveButton = true;
    });
    _cropImage();
    //print(imagePicked);
  }
  Future getImageOneGallery() async {
    Navigator.of(context).pop();
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 25,);
    setState(() {
      profileImage = File(pickedFile.path);
//      imagePicked = true;
//      saveButton = true;
    });
    _cropImage();
    //print(imagePicked);
  }

  void _settingModalBottomSheetOne(context){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc){
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: InkWell(
                      onTap: (){
                        getImageOne();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Container(
                              //width: 100,
                                child: Icon(Icons.camera_alt, color: Color(COLOR_ACCENT),)),
                          ),
                          Container(
                              width: 150,
                              child: Text("Open using camera",
                                style: GoogleFonts.firaSans(
                                    letterSpacing: 0.5
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: InkWell(
                      onTap: (){
                        getImageOneGallery();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Container(
                              //width: 100,
                                child: Icon(Icons.image, color: Color(COLOR_ACCENT),)),
                          ),
                          Container(
                              width: 150,
                              child: Text("Open using gallery",
                                style: GoogleFonts.firaSans(
                                    letterSpacing: 0.5
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  var _currentSelectedValue;

  Future<String> updateUserProfile(context) async {

    prEdit.show();

    profileBaseImage = profileImage == null ? photo.toString() : base64Encode(profileImage.readAsBytesSync());
    //profileFileName = profileImage.path.split("/").last;

    print("profileBaseImage" + profileBaseImage.toString());

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/updateUserProfile";
    var body = jsonEncode({

      "_id" : widget.id.toString(),
      "schoolGrade" : gradeController.text.toString(),
      "school" : schoolController.text.toString(),
      "state" : stateController.text.toString(),
      "userType" : _currentSelectedValue.toString(),
      "isMentor" : isMentor == true ? "Yes" : "No",
      "image" : {
        "data" : profileBaseImage.toString(),
      },

    });

    http.post(Uri.parse(url), body: body).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseUpdateProfile = jsonDecode(response.body);
      print("responseUpdateProfile"+responseUpdateProfile.toString());

      var msg = responseUpdateProfile['status'].toString();
      if(msg == "SUCCESS"){
        prEdit.hide();
        Fluttertoast.showToast(msg: "Profile updated successfully",backgroundColor: Color(COLOR_ACCENT), textColor: Colors.white).whenComplete(() => pop(context));
      }else{
        prEdit.hide();
        Fluttertoast.showToast(msg: msg,backgroundColor: Color(COLOR_ACCENT), textColor: Colors.white);
      }

    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _currentSelectedValue = null;
      profileImage = null;
      isMentor = false;
      gradeController = TextEditingController(text: widget.grade.toString());
      schoolController = TextEditingController(text: widget.school.toString());
      stateController = TextEditingController(text: widget.state.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    prEdit = ProgressDialog(context);
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
                      Container(
                        height: MediaQuery.of(context).size.height,
                        padding: EdgeInsets.all(
                          getProportionateScreenWidth(22),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.white),
                            color: Color(COLOR_ACCENT)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Update your profile",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.firaSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
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
                            SizedBox(height: 20,),
                            Text(
                              "Before you go further we would like to know more about you.",
                              textScaleFactor: 1,
                              style: GoogleFonts.firaSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16),
                            ),
                            SizedBox(height: 40,),
                            photo == null || photo == "null" || photo == "" ? Stack(
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
                                        radius: getProportionateScreenWidth(40),
                                        backgroundColor: Color(0xffFEC55F),//Color(0xFFDDDDDD),
                                        backgroundImage: profileImage == null ? AssetImage("assets/imageSVG/miramira.png") : FileImage(profileImage),
                                      ),
                                    ),
                                  ),
                                ),
//                                Container(
//                                  decoration: BoxDecoration(
//                                      borderRadius: BorderRadius.all(Radius.circular(100)),
//                                      border: Border.all(color: Colors.white, width: 2),
//                                      boxShadow: [new BoxShadow(
//                                        color: Colors.black,
//                                        blurRadius: 7.0,
//                                      ),]
//                                  ),
//                                  child: CircleAvatar(
//                                    radius: getProportionateScreenWidth(40),
//                                    backgroundColor: Color(0xFFDDDDDD),
//                                    backgroundImage: profileImage == null ? AssetImage("assets/images/sampleProf.png") : FileImage(profileImage),
////                                    child: Container(
////                                      color: Colors.transparent,
////                                      margin: EdgeInsets.all(4),
////                                      child: Container(
////                                        child: profileImage == null ? Image.asset("assets/images/sampleProf.png") : Container(),
////                                        decoration: BoxDecoration(
////                                            image: DecorationImage(
////                                              image: profileImage == null ? AssetImage("assets/images/sampleProf.png") : FileImage(profileImage),
////                                              fit: BoxFit.cover,
////                                            )
////                                        ),
////                                      ),
////                                    ),
//                                  ),
//                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 65, top: 10),
                                  child: InkWell(
                                    onTap: (){
                                      _settingModalBottomSheetOne(context);
                                    },
                                    child: Container(
                                      width: 35,height: 35,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(100)),
                                        color: Colors.white
                                      ),
                                      child: Center(child: Icon(Icons.add, color: Color(COLOR_ACCENT),)),
                                    ),
                                  ),
                                ),
                              ],
                            ) : Stack(
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
                                        radius: getProportionateScreenWidth(40),
                                        backgroundColor: Color(0xffFEC55F),//Color(0xFFDDDDDD),
                                        backgroundImage: profileImage == null ? Image.memory(base64photo).image : FileImage(profileImage),
                                      ),
                                    ),
                                  ),
                                ),
//                                Container(
//                                  decoration: BoxDecoration(
//                                      borderRadius: BorderRadius.all(Radius.circular(100)),
//                                      border: Border.all(color: Colors.white, width: 2),
//                                      boxShadow: [new BoxShadow(
//                                        color: Colors.black,
//                                        blurRadius: 7.0,
//                                      ),]
//                                  ),
//                                  child: CircleAvatar(
//                                    radius: getProportionateScreenWidth(40),
//                                    backgroundColor: Color(0xFFDDDDDD),
//                                    backgroundImage: profileImage == null ? AssetImage("assets/images/sampleProf.png") : FileImage(profileImage),
////                                    child: Container(
////                                      color: Colors.transparent,
////                                      margin: EdgeInsets.all(4),
////                                      child: Container(
////                                        child: profileImage == null ? Image.asset("assets/images/sampleProf.png") : Container(),
////                                        decoration: BoxDecoration(
////                                            image: DecorationImage(
////                                              image: profileImage == null ? AssetImage("assets/images/sampleProf.png") : FileImage(profileImage),
////                                              fit: BoxFit.cover,
////                                            )
////                                        ),
////                                      ),
////                                    ),
//                                  ),
//                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 65, top: 10),
                                  child: InkWell(
                                    onTap: (){
                                      _settingModalBottomSheetOne(context);
                                    },
                                    child: Container(
                                      width: 35,height: 35,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(100)),
                                          color: Colors.white
                                      ),
                                      child: Center(child: Icon(Icons.add, color: Color(COLOR_ACCENT),)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  child: Text("NAME",textScaleFactor: 1,
                                    style: GoogleFonts.firaSans(
                                      color: Colors.white,
                                      letterSpacing: 1
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20,),
                                ConstrainedBox(
                                  constraints: BoxConstraints.tightFor(
                                      width: getProportionateScreenWidth(220),
                                      height: getProportionateScreenHeight(45)),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Color(COLOR_ACCENT),
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
                                          Container(
                                            width: getProportionateScreenWidth(170),
                                            child: TextFormField(
                                              //focusNode: focus11,
                                              //controller: emailController,
                                              enabled: false,
                                              style: GoogleFonts.firaSans(
                                                color: Colors.black,
                                              ),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: widget.name.toString(),
                                                hintStyle: GoogleFonts.firaSans(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  child: Text("EMAIL",textScaleFactor: 1,
                                    style: GoogleFonts.firaSans(
                                        color: Colors.white,
                                        letterSpacing: 1
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20,),
                                ConstrainedBox(
                                  constraints: BoxConstraints.tightFor(
                                      width: getProportionateScreenWidth(220),
                                      height: getProportionateScreenHeight(45)),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Color(COLOR_ACCENT),
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
                                          Container(
                                            width: getProportionateScreenWidth(170),
                                            child: TextFormField(
                                              //focusNode: focus11,
                                              //controller: emailController,
                                              enabled: false,
//                                              validator: (value) {
//                                                if (value.isEmpty ||
//                                                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                                                        .hasMatch(value)) {
//                                                  return 'Enter a valid email!';
//                                                }
//                                                return null;
//                                              },
                                              style: GoogleFonts.firaSans(
                                                color: Colors.black,
                                              ),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: widget.email.toString(),
                                                hintStyle: GoogleFonts.firaSans(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  child: Text("I AM A",textScaleFactor: 1,
                                    style: GoogleFonts.firaSans(
                                        color: Colors.white,
                                        letterSpacing: 1
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20,),
//                                _currentSelectedValue == "Student" || _currentSelectedValue == "Professional" ?
//                                ConstrainedBox(
//                                  constraints: BoxConstraints.tightFor(
//                                      width: getProportionateScreenWidth(220),
//                                      height: getProportionateScreenHeight(45)),
//                                  child: ElevatedButton(
//                                    style: ElevatedButton.styleFrom(
//                                        primary: Color(COLOR_ACCENT),
//                                        side: BorderSide(color: Color(0xFFC9E7FF)),
//                                        elevation: 0,
//                                        shape: RoundedRectangleBorder(
//                                            borderRadius:
//                                            BorderRadius.circular(5))),
//                                    onPressed: () {
//                                      setState(() {
//                                        _currentSelectedValue = null;
//                                      });
//                                    },
//                                    child: Row(
//                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                      children: [
//                                        Text(_currentSelectedValue.toString(),
//                                          style: GoogleFonts.firaSans(
//                                              color: Colors.white,
//                                              letterSpacing: 1
//                                          ),
//                                        ),
//                                        InkWell(
//                                            onTap: (){
//                                              setState(() {
//                                                _currentSelectedValue = null;
//                                              });
//                                            },
//                                            child: Icon(Icons.arrow_drop_down, color: Colors.grey[300],size: 20,)),
//                                      ],
//                                    ),
//                                    /*
//                                      Row(
//                                        crossAxisAlignment: CrossAxisAlignment.center,
//                                        mainAxisAlignment: MainAxisAlignment.start,
//                                        children: [
//                                          Container(
//                                            width: getProportionateScreenWidth(170),
//                                            child: TextFormField(
//                                              //focusNode: focus11,
//                                              //controller: emailController,
//                                              validator: (value) {
//                                                if (value.isEmpty ||
//                                                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                                                        .hasMatch(value)) {
//                                                  return 'Enter a valid email!';
//                                                }
//                                                return null;
//                                              },
//                                              style: GoogleFonts.firaSans(
//                                                color: Colors.black,
//                                              ),
//                                              decoration: InputDecoration(
//                                                border: InputBorder.none,
//                                                hintText: "Emily Baumgartner",
//                                                hintStyle: GoogleFonts.firaSans(
//                                                  color: Colors.white,
//                                                ),
//                                              ),
//                                            ),
//                                          )
//                                        ],
//                                      )
//
//                                           */
//                                  ),
//                                )
//                                    :
                                ConstrainedBox(
                                  constraints: BoxConstraints.tightFor(
                                      width: getProportionateScreenWidth(220),
                                      height: getProportionateScreenHeight(45)),
                                  child: Theme(
                                    data: ThemeData(primaryColor: Color(0xFFC9E7FF)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Color(0xFFC9E7FF)),
                                        borderRadius: BorderRadius.all(Radius.circular(5))
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 15, right: 15),
                                        child: FormField<String>(
                                          builder: (FormFieldState<String> state) {
                                            return InputDecorator(
                                              decoration: InputDecoration.collapsed(
//                                                  labelStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
//                                                  errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                                  hintText: '',
                                                  hintStyle: GoogleFonts.firaSans(
                                                      color: Colors.white,
                                                      letterSpacing: 1
                                                  ),
                                              ),
                                              isEmpty: _currentSelectedValue == 'Student',
                                              child: Container(
                                                width: getProportionateScreenWidth(220),
                                                height: getProportionateScreenHeight(45),
                                                child: DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    value: _currentSelectedValue,
                                                    style: GoogleFonts.firaSans(
                                                      color: Colors.white,
                                                      letterSpacing: 1
                                                    ),
                                                    isDense: true,
                                                    onChanged: (String newValue) {
                                                      setState(() {
                                                        _currentSelectedValue = newValue;
                                                        state.didChange(newValue);
                                                      });
                                                      print(_currentSelectedValue);
                                                    },
                                                    dropdownColor: Color(COLOR_ACCENT),
                                                    items: ['Student','Professional'].map((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Container(
                                                          //color: Color(COLOR_ACCENT),
                                                          child: Text(value,
                                                            style: GoogleFonts.firaSans(
                                                                color: Colors.white,
                                                                letterSpacing: 1
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40,),

                            _currentSelectedValue == null ? Container() : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      child: Text(_currentSelectedValue == "Professional" ? "JOB" : "GRADE",
                                        textScaleFactor: 1,
                                        style: GoogleFonts.firaSans(
                                            color: Colors.white,
                                            letterSpacing: 1
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    ConstrainedBox(
                                      constraints: BoxConstraints.tightFor(
                                          width: getProportionateScreenWidth(220),
                                          height: getProportionateScreenHeight(45)),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Color(COLOR_ACCENT),
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
                                              Container(
                                                width: getProportionateScreenWidth(170),
                                                child: TextFormField(
                                                  //focusNode: focus11,
                                                  controller: gradeController,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'All fields are mandatory';
                                                    }
                                                    return null;
                                                  },
                                                  style: GoogleFonts.firaSans(
                                                    color: Colors.white,
                                                  ),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    //hintText: _currentSelectedValue == "Professional" ? "Doctor" : "12",
                                                    hintStyle: GoogleFonts.firaSans(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      child: Text(_currentSelectedValue == "Professional" ? "FIRM" : "SCHOOL",
                                        textScaleFactor: 1,
                                        style: GoogleFonts.firaSans(
                                            color: Colors.white,
                                            letterSpacing: 1
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    ConstrainedBox(
                                      constraints: BoxConstraints.tightFor(
                                          width: getProportionateScreenWidth(220),
                                          height: getProportionateScreenHeight(45)),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Color(COLOR_ACCENT),
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
                                              Container(
                                                width: getProportionateScreenWidth(170),
                                                child: TextFormField(
                                                  //focusNode: focus11,
                                                  controller: schoolController,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'All fields are mandatory';
                                                    }
                                                    return null;
                                                  },
                                                  style: GoogleFonts.firaSans(
                                                    color: Colors.white,
                                                  ),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    //hintText: _currentSelectedValue == "Professional" ? "Nova Healthcare System" : "Richdale High",
                                                    hintStyle: GoogleFonts.firaSans(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 60,
                                      child: Text("STATE",
                                        textScaleFactor: 1,
                                        style: GoogleFonts.firaSans(
                                            color: Colors.white,
                                            letterSpacing: 1
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20,),
                                    ConstrainedBox(
                                      constraints: BoxConstraints.tightFor(
                                          width: getProportionateScreenWidth(220),
                                          height: getProportionateScreenHeight(45)),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Color(COLOR_ACCENT),
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
                                              Container(
                                                width: getProportionateScreenWidth(170),
                                                child: TextFormField(
                                                  //focusNode: focus11,
                                                  controller: stateController,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'All fields are mandatory';
                                                    }
                                                    return null;
                                                  },
                                                  style: GoogleFonts.firaSans(
                                                    color: Colors.white,
                                                  ),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    //hintText: "Texas",
                                                    hintStyle: GoogleFonts.firaSans(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                    ),
                                    SizedBox(width: 20,),
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          isMentor = !isMentor;
                                        });
                                        print(isMentor);
                                      },
                                      child: Container(
                                        width: getProportionateScreenWidth(220),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 20,width: 20,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(2)),
                                                  border: Border.all(color: Colors.white)
                                              ),
                                              child: isMentor == false ? Container() : Center(
                                                child: Icon(Icons.check,color: Colors.white, size: 10,),
                                              ),
                                            ),SizedBox(width: 10,),
                                            Text("Yes, I want to be a mentor.",
                                              textScaleFactor: 1,
                                              style: GoogleFonts.firaSans(
                                                  color: Colors.white,
                                                  letterSpacing: 1
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                    ),
                                    SizedBox(width: 20,),
                                    Container(
                                      width: getProportionateScreenWidth(220),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              if(gradeController.text.isEmpty || schoolController.text.isEmpty || stateController.text.isEmpty){
                                                Fluttertoast.showToast(msg: "All fields are mandatory",backgroundColor: Colors.white, textColor: Colors.red);
                                              }else{
                                                print("all okay");
                                                updateUserProfile(context);
                                              }
                                              //Fluttertoast.showToast(msg: "Updated successfully",backgroundColor: Color(COLOR_ACCENT), textColor: Colors.white).whenComplete(() =>pop(context));
                                            },
                                            child: Container(
                                              height: 35,width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  border: Border.all(color: Colors.white)
                                              ),
                                              child: Center(
                                                child: Text("UPDATE",
                                                  style: GoogleFonts.firaSans(
                                                      color: Colors.white,
                                                      letterSpacing: 1
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10,),
                                          InkWell(
                                            onTap: (){
                                              pop(context);
                                            },
                                            child: Container(
                                              height: 35,width: 100,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  border: Border.all(color: Colors.white)
                                              ),
                                              child: Center(
                                                child: Text("CANCEL",
                                                  style: GoogleFonts.firaSans(
                                                      color: Colors.white,
                                                      letterSpacing: 1
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
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
