import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/helper.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:mira_mira/UI/CourseDetailedScreen/tabs/CourseScreen.dart';
import 'package:mira_mira/UI/CourseDetailedScreen/tabs/InstituteScreen.dart';
import 'package:mira_mira/UI/CourseDetailedScreen/widget/CompanyTabs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';

ProgressDialog prKeep2;
ProgressDialog prRemove;
bool showToolTipI = true;

class CourseDetailedScreen extends StatefulWidget {

  final noOfIns;
  final name;
  final subTitle;
  final fullDescription;
  final id;
  final isKept;
  CourseDetailedScreen(this.noOfIns, this.name, this.subTitle, this.fullDescription, this.id, this.isKept) : super();

  @override
  _CourseDetailedScreenState createState() => _CourseDetailedScreenState();
}

class _CourseDetailedScreenState extends State<CourseDetailedScreen> {
  PageController _controller;
  int _selectedTab = 0;
  var tmp;
  SharedPreferences prefs;

  Future<String> addToWishlist(context) async {

    prKeep2.show();

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/addToKeepList?courseId="+widget.id.toString();
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
        prKeep2.hide();
        Fluttertoast.showToast(msg: "Added to wishlist",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){
          pop(context);
        });
      }else{
        prKeep2.hide();
        Fluttertoast.showToast(msg: "Please check your network connection",backgroundColor: Color(0xff1E73BE), textColor: Colors.white);
      }

    });
  }

  Future<String> removeFromWishList(context) async {

    prRemove.show();

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/removeFromKeepList?courseId="+widget.id.toString();

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
          pop(context);
        });
      }else{
        prRemove.hide();
        Fluttertoast.showToast(msg: "Please check your network connection",backgroundColor: Color(0xff1E73BE), textColor: Colors.white);
      }

    });
  }

  getString() async {
    prefs = await SharedPreferences.getInstance();
    tmp = prefs.getString("showToolTipI");
    print("showToolTipI ::::" + tmp);
  }

  @override
  void initState() {
    _controller = PageController();
    super.initState();
    getString();
    setState(() {
      showToolTipI = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    prKeep2 = ProgressDialog(context);
    prRemove = ProgressDialog(context);
    return SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                height: getProportionateScreenHeight(96),
                color: Color(COLOR_ACCENT),
              ),
              Container(
                margin: EdgeInsets.all(getProportionateScreenWidth(10)),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFDAE7FF), width: 2),
                  borderRadius: BorderRadius.circular(7),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(27),
                    vertical: getProportionateScreenHeight(0)),
                height: getProportionateScreenHeight(982),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: getProportionateScreenHeight(82),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.name.toString(),
                                style: GoogleFonts.firaSans(
                                    color: Color(0xFF383838),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1,
                                    fontSize: 20),
                              ),
                              showToolTipI == true  && tmp != "false" && _selectedTab == 1 ? Container() : GestureDetector(
                                  onTap: () {
                                    //print("showToolTipI ::::" + tmp.toString());
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: getProportionateScreenWidth(30),
                                    color: Color(0xFF6C6C6C),
                                  )),
                            ],
                          ),
                          Text(
                            widget.noOfIns.toString()+" INSTITUTIONS",
                            style: GoogleFonts.firaSans(
                                color: Color(0xFF383838),
                                letterSpacing: 2,
                                fontWeight: FontWeight.w400,
                                fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 0,),
                    InkWell(
                      onTap: () {
                        print("wishlist added");
                      },
                      child: CourseButton(
                        text: widget.isKept == "0" ? "KEEP" : "REMOVE",
                        onPressed: () {
                          if(widget.isKept == "0"){
                            addToWishlist(context);
                          }else{
                            removeFromWishList(context);
                          }
                          //push(context, CourseDetailedScreen());
                        },
                      ),
                    ),SizedBox(height: 40,),
                    Container(
                      child: CourseTabs(
                        id: widget.id.toString(),
                        selectedTab: _selectedTab,
                        tabPressed: (num) {
                          _controller.animateToPage(num,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic);
                          print(_selectedTab);
                        },
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(30),
                    ),
                    Expanded(
                      child: PageView(
                        controller: _controller,
                        onPageChanged: (num) {
                          setState(() {
                            _selectedTab = num;
                          });
                        },
                        children: [CourseScreen(widget.subTitle, widget.fullDescription, widget.id), InstituteScreen(widget.id)],
                      ),
                    ),
                  ],
                ),
              ),
              showToolTipI == true && tmp != "false" && _selectedTab == 1 ?
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
                                prefs.setString("showToolTipI", "false");
                                setState(() {
                                  showToolTipI = false;
                                });
                              },
                              child: Icon(
                                Icons.close,
                                size: 30,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height/5,),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Text("You can add an institution  to your Wishlist.",
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
                          prefs.setString("showToolTipI", "false");
                          setState(() {
                            showToolTipI = false;
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
                      SizedBox(height: MediaQuery.of(context).size.height/5.5,),
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
                                SizedBox(width: 30,),
                                Image.asset("assets/images/patharrow.png"),
                                SizedBox(width: 20,),
                                Text("Swipe right to add\nto Wishlist",
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
        ));
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