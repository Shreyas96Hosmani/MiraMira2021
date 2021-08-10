import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/helper.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:mira_mira/UI/CourseDetailedScreen/CourseDetailScreen.dart';
import 'package:mira_mira/UI/CourseDetailedScreen/InstituteDetailedScreen.dart';
import 'package:mira_mira/UI/CourseDetailedScreen/tabs/CourseScreen.dart';
import 'package:mira_mira/UI/CourseDetailedScreen/tabs/InstituteScreen.dart';
import 'package:mira_mira/UI/CourseDetailedScreen/widget/CompanyTabs2.dart';
import 'package:mira_mira/UI/SignUp/LoginSignupScreen.dart';
import 'package:mira_mira/UI/Tabs/CourseListScreen.dart';
import 'package:mira_mira/UI/home_screen/home_screen.dart';
import 'package:mira_mira/UI/home_screen/home_screen.dart' as h;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:meta/meta.dart';
import 'package:progress_indicators/progress_indicators.dart';

ProgressDialog prKeep;
ProgressDialog prRemove;
bool showAnimation = true;

bool tabOpen = false;

var selectedCourseIdForWishlistedInstitutes;

List<bool> expantionList = [];

class WishListMainScreen extends StatefulWidget {
  @override
  _WishListMainScreenState createState() => _WishListMainScreenState();
}

class _WishListMainScreenState extends State<WishListMainScreen> {
  PageController _controller;
  int _selectedTab = 0;

  Future<String> getWishList(context) async {

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getWishList?userId=$isSignedIn";//isSignedIn

    http.get(Uri.parse(url),).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseGetWishList = jsonDecode(utf8.decode(response.bodyBytes));
      print("responseGetWishList"+responseGetWishList.toString());

      if(responseGetWishList == []){
        print("empty");
        setState(() {
          resultIds = null;
        });
      }else{
        var msg = responseGetWishList['status'].toString();
        if(msg == "SUCCESS"){
          setState(() {
            courseIdsW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['courseId'].toString());
            //courseNamesW = List.generate(responseGetWishList['courses'].length, (index) => responseGetWishList['courses'][index]['courseName'].toString());
            courseDescriptionW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['courseName'].toString());
            //courseDegreesW = List.generate(responseGetWishList['courses'].length, (index) => responseGetWishList['courses'][index]['headlineTraits'].toString());

            instituteIdsW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['id'].toString());
            instituteNamesW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['universityName'].toString());
            instituteDescriptionW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['courseDescription'].toString());
            instituteDegreesW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['degreeDescription'].toString());
            instituteCityStateRateW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['city'].toString()+" | "+responseGetWishList['wishList'][index]['institutes'][0]['state'].toString()+" | \$"+responseGetWishList['wishList'][index]['institutes'][0]['stateFee']['\$numberInt'].toString());
            instituteCity= List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['city'].toString());
            instituteState = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['state'].toString());
            instituteRate = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['stateFee']['\$numberInt'].toString());
            instituteSatScore = List.generate(responseGetWishList['wishList'].length, (index) => "1354");//responseGetWishList['wishList'][index]['institutes'][0]['satScore']['\$numberInt'].toString());
            //instituteFullDescription = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['institutes'][index]['id'].toString());
            instituteRequestForInfoLink = List.generate(responseGetWishList['wishList'].length, (index) => "null");
            instituteGetInTouchLink = List.generate(responseGetWishList['wishList'].length, (index) => "null");

            countOfInstitutesInBrackets = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['countOfInstitutes'].toString());

            courseCount = responseGetWishList['grandCountOfCourses'].toString();
            instituteCount = responseGetWishList['grandCountOfInstitutes'].toString();
          });

          print(courseIdsW.toList());
          print(courseDescriptionW.toList());

          print(instituteIdsW.toList());
          print(instituteNamesW.toList());
          print(instituteDescriptionW.toList());
          print(instituteDegreesW.toList());
          print(instituteCityStateRateW.toList());

          print(courseCount.toString());
          print(instituteCount.toString());

          print("###########");
          print(countOfInstitutesInBrackets.toString());
          print("###########");
        }else{
          setState(() {
            courseIdsW = null;
          });
        }
      }

    });
  }

  Future<String> getWishListedInstitutesByCourseId(context) async {

    setState(() {
      instituteIdsW = [];
    });

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getWishListedInstitutesByCourseId?userId=$isSignedIn&courseId=$selectedCourseIdForWishlistedInstitutes";//isSignedIn

    http.get(Uri.parse(url),).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseGetWishList = jsonDecode(utf8.decode(response.bodyBytes));
      print("responseGetWishListedInstitutesByCourseId  "+responseGetWishList.toString());

      if(responseGetWishList == []){
        print("empty");
        setState(() {
          resultIds = null;
        });
      }else{
        var msg = responseGetWishList['status'].toString();
        if(msg == "SUCCESS"){
          setState(() {

            instituteIdsW = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['id'].toString());
            instituteNamesW = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['universityName'].toString());
            instituteDescriptionW = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['courseDescription'].toString());
            instituteDegreesW = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['degreeDescription'].toString());
            instituteCityStateRateW = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['city'].toString()+" | "+responseGetWishList['wishListedInstitutes'][index]['state'].toString()+" | \$"+responseGetWishList['wishListedInstitutes'][index]['stateFee']['\$numberInt'].toString());
            instituteCity= List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['city'].toString());
            instituteState = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['state'].toString());
            instituteRate = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['stateFee']['\$numberInt'].toString());
            instituteSatScore = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => "1354");//responseGetWishList['wishList'][index]['satScore']['\$numberInt'].toString());
            //instituteFullDescription = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['institutes'][index]['id'].toString());
            instituteRequestForInfoLink = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => "null");
            instituteGetInTouchLink = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => "null");

//            countOfInstitutesInBrackets = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishList'][index]['countOfInstitutes'].toString());
//
//            courseCount = responseGetWishList['grandCountOfCourses'].toString();
//            instituteCount = responseGetWishList['grandCountOfInstitutes'].toString();
          });


          print(instituteIdsW.toList());
          print(instituteNamesW.toList());
          print(instituteDescriptionW.toList());
          print(instituteDegreesW.toList());
          print(instituteCityStateRateW.toList());

        }else{
          setState(() {
            courseIdsW = null;
          });
        }
      }

    });
  }
  int selected = 0;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
    setState(() {
      selected = null;
      instituteIdsW = [];
      expantionList = List.generate(courseIdsW.length, (index) => false);
      tabOpen = false;
    });
    Future.delayed(Duration(seconds: 8),(){
      setState(() {
        showAnimation = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //getWishList(context);
    prKeep = ProgressDialog(context);
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
                    horizontal: getProportionateScreenWidth(0),
                    vertical: getProportionateScreenHeight(0)),
                height: getProportionateScreenHeight(982),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: getProportionateScreenHeight(82),
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(25),
                          vertical: getProportionateScreenHeight(0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "WISHLIST",
                                style: GoogleFonts.firaSans(
                                    color: Color(0xFF383838),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Text(
                            courseCount+" COURSES | "+instituteCount+" INSTITUTIONS",
                            style: GoogleFonts.firaSans(
                                color: Color(0xFF383838),
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(25),
                          vertical: getProportionateScreenHeight(0)),
                      child: CourseTabs2(
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
                      height: getProportionateScreenHeight(10),
                    ),
                    courseIdsW == null || courseIdsW.toList().isEmpty ? FirstHomeScreen(context) : Expanded(
                      child: PageView(
                        controller: _controller,
                        onPageChanged: (num) {
                          setState(() {
                            _selectedTab = num;
                          });
                        },
                        children: [ListView.builder(
                          key: Key('builder ${selected.toString()}'),
                          physics: ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: courseIdsW == null ? 0 : courseIdsW.length,
                      itemBuilder: (context, i) =>
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(10),
                                vertical: getProportionateScreenHeight(0)),
                            child: Container(
                              constraints: BoxConstraints.tightFor(width: double.infinity),
                              child: Theme(
                                data: ThemeData(
                                    primaryColor: Colors.white
                                ),
                                child: ExpansionTile(
                                  key: Key(i.toString()),
                                  initiallyExpanded: i==selected,
                                  onExpansionChanged: (val){
                                    setState(() {
                                      Duration(seconds:  20000);
                                      selected = i;
                                    });
                                    if(val == true){
                                      setState(() {
                                        tabOpen = val;
                                        selectedCourseIdForWishlistedInstitutes = courseIdsW[i].toString();
                                      });
                                      print(selectedCourseIdForWishlistedInstitutes);
                                      getWishListedInstitutesByCourseId(context);
                                      print("tabOpen : " + tabOpen.toString());
                                    }else{
                                      setState(() {
                                        instituteIdsW = [];
                                      });
                                    }
                                  },
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 0,),
                                      Text(
                                        courseDescriptionW[i]+" ("+countOfInstitutesInBrackets[i]+")",
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.firaSans(
                                            fontSize: 18,
                                            color: Color(0xFF1E73BE),
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                      SizedBox(height: 0,),
                                      Divider(thickness: 1, color: Color(0xFF1E73BE),),
                                      SizedBox(height: 0,),
                                    ],
                                  ),
                                  childrenPadding:
                                  EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(0)),
                                  children: [
                                    instituteIdsW.isEmpty ? Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Center(
                                        child: JumpingDotsProgressIndicator(
                                          fontSize: 25.0,color: Color(0xff1E73BE),
                                        ),
                                      ),
                                    ) : Container(
                                      height: getProportionateScreenHeight(121) * double.parse(instituteIdsW.length.toString()),
                                      child: ListView.builder(
                                          itemCount: instituteIdsW == null ? 0 : instituteIdsW.length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            return InstituteListTile(index: index);
                                          }),
                                    ),
//            SizedBox(
//              height: 10,
//            ),
//            Container(
//              height: 1,
//              color: Color(COLOR_ACCENT),
//            ),
//            SizedBox(
//              height: 10,
//            ),
//            Text(
//              courseDescriptionW[widget.index],
//              maxLines: 2,
//              overflow: TextOverflow.ellipsis,
//              style: GoogleFonts.firaSans(
//                fontSize: 18,
//                color: Color(0xFF3F4462),
//              ),
//            ),
//            SizedBox(
//              height: 40,
//            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: [
//                CourseButton(
//                    text: "VIEW DETAILS",
//                    onPressed: () {
//                      //push(context, CourseDetailedScreen());
//                    })
//              ],
//            ),
//            SizedBox(
//              height: 40,
//            ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    ),
                          //InstituteScreen2()
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
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
            Center(child: SvgPicture.asset("assets/iconSVG/robotupsidedown.svg")),
            SizedBox(
              height: getProportionateScreenHeight(50),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Text(
                "No courses or institutions found! You can add them anytime once they are available!",
                textAlign: TextAlign.center,
                style: GoogleFonts.firaSans(
                    color: Color(0xFF3F4462),
                    letterSpacing: 1,
                    fontSize: getProportionateScreenHeight(15),
                    fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
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

  Future<String> getWishListedInstitutesByCourseId(context) async {

//    if(selectedCourseIdForWishlistedInstitutes == courseIdsW[widget.index].toString()){
//      setState(() {
//        expantionList = List.generate(courseIdsW.length, (index) => index == widget.index ? true : false);
//        print(expantionList.toList());
//        //expantionList[widget.index] = true;
//      });
//    }else{
//      setState(() {
//
//      });
//    }

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getWishListedInstitutesByCourseId?userId=$isSignedIn&courseId=$selectedCourseIdForWishlistedInstitutes";//isSignedIn

    http.get(Uri.parse(url),).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseGetWishList = jsonDecode(utf8.decode(response.bodyBytes));
      print("responseGetWishListedInstitutesByCourseId  "+responseGetWishList.toString());

      if(responseGetWishList == []){
        print("empty");
        setState(() {
          resultIds = null;
        });
      }else{
        var msg = responseGetWishList['status'].toString();
        if(msg == "SUCCESS"){
          setState(() {

            instituteIdsW = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['id'].toString());
            instituteNamesW = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['universityName'].toString());
            instituteDescriptionW = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['courseDescription'].toString());
            instituteDegreesW = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['degreeDescription'].toString());
            instituteCityStateRateW = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['city'].toString()+" | "+responseGetWishList['wishListedInstitutes'][index]['state'].toString()+" | \$"+responseGetWishList['wishListedInstitutes'][index]['stateFee']['\$numberInt'].toString());
            instituteCity= List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['city'].toString());
            instituteState = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['state'].toString());
            instituteRate = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['stateFee']['\$numberInt'].toString());
            instituteSatScore = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => "1354");//responseGetWishList['wishList'][index]['satScore']['\$numberInt'].toString());
            //instituteFullDescription = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['institutes'][index]['id'].toString());
            instituteRequestForInfoLink = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => "null");
            instituteGetInTouchLink = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => "null");

//            countOfInstitutesInBrackets = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishList'][index]['countOfInstitutes'].toString());
//
//            courseCount = responseGetWishList['grandCountOfCourses'].toString();
//            instituteCount = responseGetWishList['grandCountOfInstitutes'].toString();
          });


          print(instituteIdsW.toList());
          print(instituteNamesW.toList());
          print(instituteDescriptionW.toList());
          print(instituteDegreesW.toList());
          print(instituteCityStateRateW.toList());

        }else{
          setState(() {
            courseIdsW = null;
          });
        }
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tightFor(width: double.infinity),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.white
        ),
        child: ExpansionTile(
          initiallyExpanded: expantionList[widget.index],
          onExpansionChanged: (val){
            if(val == true){
              setState(() {
                tabOpen = val;
                selectedCourseIdForWishlistedInstitutes = courseIdsW[widget.index].toString();
              });
              print(selectedCourseIdForWishlistedInstitutes);
              getWishListedInstitutesByCourseId(context);
              print("tabOpen : " + tabOpen.toString());
            }else{

            }
          },
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 0,),
              Text(
                courseDescriptionW[widget.index]+" ("+countOfInstitutesInBrackets[widget.index]+")",
                textAlign: TextAlign.start,
                style: GoogleFonts.firaSans(
                  fontSize: 18,
                  color: Color(0xFF1E73BE),
                  fontWeight: FontWeight.w400
                ),
              ),
              SizedBox(height: 0,),
              Divider(thickness: 1, color: Color(0xFF1E73BE),),
              SizedBox(height: 0,),
            ],
          ),
          childrenPadding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(0)),
          children: [
            instituteIdsW.isEmpty ? Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: JumpingDotsProgressIndicator(
                  fontSize: 25.0,color: Color(0xff1E73BE),
                ),
              ),
            ) : Container(
              height: getProportionateScreenHeight(121) * double.parse(instituteIdsW.length.toString()),
              child: ListView.builder(
                  itemCount: instituteIdsW == null ? 0 : instituteIdsW.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return InstituteListTile(index: index);
                  }),
            ),
//            SizedBox(
//              height: 10,
//            ),
//            Container(
//              height: 1,
//              color: Color(COLOR_ACCENT),
//            ),
//            SizedBox(
//              height: 10,
//            ),
//            Text(
//              courseDescriptionW[widget.index],
//              maxLines: 2,
//              overflow: TextOverflow.ellipsis,
//              style: GoogleFonts.firaSans(
//                fontSize: 18,
//                color: Color(0xFF3F4462),
//              ),
//            ),
//            SizedBox(
//              height: 40,
//            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: [
//                CourseButton(
//                    text: "VIEW DETAILS",
//                    onPressed: () {
//                      //push(context, CourseDetailedScreen());
//                    })
//              ],
//            ),
//            SizedBox(
//              height: 40,
//            ),
          ],
        ),
      ),
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
        child: Text(text),
      ),
    );
  }
}

class InstituteScreen2 extends StatefulWidget {
  @override
  _InstituteScreen2State createState() => _InstituteScreen2State();
}

class _InstituteScreen2State extends State<InstituteScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
          itemCount: instituteIdsW == null ? 0 : instituteIdsW.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return InstituteListTile(index: index);
          }),
    );
  }
}

class InstituteListTile extends StatefulWidget {

  final int index;
  const InstituteListTile({
    Key key, this.index,
  }) : super(key: key);

  @override
  _InstituteListTileState createState() => _InstituteListTileState();
}

class _InstituteListTileState extends State<InstituteListTile> {

  Future<String> getWishList(context) async {

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getWishList?userId=$isSignedIn";//isSignedIn

    http.get(Uri.parse(url),).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseGetWishList = jsonDecode(utf8.decode(response.bodyBytes));
      print("responseGetWishList"+responseGetWishList.toString());

      if(responseGetWishList == []){
        print("empty");
        setState(() {
          resultIds = null;
        });
      }else{
        var msg = responseGetWishList['status'].toString();
        if(msg == "SUCCESS"){
          setState(() {
            courseIdsW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['courseId'].toString());
            //courseNamesW = List.generate(responseGetWishList['courses'].length, (index) => responseGetWishList['courses'][index]['courseName'].toString());
            courseDescriptionW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['courseName'].toString());
            //courseDegreesW = List.generate(responseGetWishList['courses'].length, (index) => responseGetWishList['courses'][index]['headlineTraits'].toString());

            instituteIdsW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['id'].toString());
            instituteNamesW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['universityName'].toString());
            instituteDescriptionW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['courseDescription'].toString());
            instituteDegreesW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['degreeDescription'].toString());
            instituteCityStateRateW = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['city'].toString()+" | "+responseGetWishList['wishList'][index]['institutes'][0]['state'].toString()+" | \$"+responseGetWishList['wishList'][index]['institutes'][0]['stateFee']['\$numberInt'].toString());
            instituteCity= List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['city'].toString());
            instituteState = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['state'].toString());
            instituteRate = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['institutes'][0]['stateFee']['\$numberInt'].toString());
            instituteSatScore = List.generate(responseGetWishList['wishList'].length, (index) => "1354");//responseGetWishList['wishList'][index]['institutes'][0]['satScore']['\$numberInt'].toString());
            //instituteFullDescription = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['institutes'][index]['id'].toString());
            instituteRequestForInfoLink = List.generate(responseGetWishList['wishList'].length, (index) => "null");
            instituteGetInTouchLink = List.generate(responseGetWishList['wishList'].length, (index) => "null");

            countOfInstitutesInBrackets = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['wishList'][index]['countOfInstitutes'].toString());

            courseCount = responseGetWishList['grandCountOfCourses'].toString();
            instituteCount = responseGetWishList['grandCountOfInstitutes'].toString();
          });

          print(courseIdsW.toList());
          print(courseDescriptionW.toList());

          print(instituteIdsW.toList());
          print(instituteNamesW.toList());
          print(instituteDescriptionW.toList());
          print(instituteDegreesW.toList());
          print(instituteCityStateRateW.toList());

          print(courseCount.toString());
          print(instituteCount.toString());

          print("###########");
          print(countOfInstitutesInBrackets.toString());
          print("###########");
        }else{
          setState(() {
            courseIdsW = null;
          });
        }
      }

    });
  }

  Future<String> getWishListedInstitutesByCourseId(context) async {

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getWishListedInstitutesByCourseId?userId=$isSignedIn&courseId=$selectedCourseIdForWishlistedInstitutes";//isSignedIn

    http.get(Uri.parse(url),).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseGetWishList = jsonDecode(utf8.decode(response.bodyBytes));
      print("responseGetWishListedInstitutesByCourseId  "+responseGetWishList.toString());

      if(responseGetWishList == []){
        print("empty");
        setState(() {
          resultIds = null;
        });
      }else{
        var msg = responseGetWishList['status'].toString();
        if(msg == "SUCCESS"){
          setState(() {
            tabOpen = false;
            instituteIdsW = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['id'].toString());
            instituteNamesW = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['universityName'].toString());
            instituteDescriptionW = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['courseDescription'].toString());
            instituteDegreesW = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['degreeDescription'].toString());
            instituteCityStateRateW = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['city'].toString()+" | "+responseGetWishList['wishListedInstitutes'][index]['state'].toString()+" | \$"+responseGetWishList['wishListedInstitutes'][index]['stateFee']['\$numberInt'].toString());
            instituteCity= List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['city'].toString());
            instituteState = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['state'].toString());
            instituteRate = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishListedInstitutes'][index]['stateFee']['\$numberInt'].toString());
            instituteSatScore = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => "1354");//responseGetWishList['wishList'][index]['satScore']['\$numberInt'].toString());
            //instituteFullDescription = List.generate(responseGetWishList['wishList'].length, (index) => responseGetWishList['institutes'][index]['id'].toString());
            instituteRequestForInfoLink = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => "null");
            instituteGetInTouchLink = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => "null");

//            countOfInstitutesInBrackets = List.generate(responseGetWishList['wishListedInstitutes'].length, (index) => responseGetWishList['wishList'][index]['countOfInstitutes'].toString());
//
//            courseCount = responseGetWishList['grandCountOfCourses'].toString();
//            instituteCount = responseGetWishList['grandCountOfInstitutes'].toString();
          });


          print(instituteIdsW.toList());
          print(instituteNamesW.toList());
          print(instituteDescriptionW.toList());
          print(instituteDegreesW.toList());
          print(instituteCityStateRateW.toList());

        }else{
          setState(() {
            courseIdsW = null;
          });
        }
      }

    });
  }

  Future<String> removeFromWishList(context) async {

    prRemove.show();

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/removeFromWishList?id="+h.selectedCourseId.toString();

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
        setState(() {
          tabOpen = false;
        });
        Fluttertoast.showToast(msg: "Removed",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){
          getWishList(context);
          getWishListedInstitutesByCourseId(context);
        });
      }else{
        prRemove.hide();
        Fluttertoast.showToast(msg: "Please check your network connection",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){
          getWishListedInstitutesByCourseId(context);
        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      actions: <Widget>[
        InkWell(
          onTap: (){
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
                                child: Text("Are you sure you want to remove this institute? You can always add it later.", style: GoogleFonts.firaSans(textStyle: TextStyle(fontSize: 16,height: 1.25, letterSpacing: 1,
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
                                        setState(() {
                                          h.selectedCourseId = instituteIdsW[widget.index].toString();
                                          print(h.selectedCourseId);
                                        });
                                        removeFromWishList(context);
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
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 5, left: 10),
            child: Container(
              width: 50,
              height: getProportionateScreenHeight(101),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                border: Border.all(color: Color(0xff1E73BE)),
                color: Color(0xff1E73BE)
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/iconSVG/pin.svg",
                      color: Colors.white,
                    ),
                    SizedBox(height: 2,),
                    Text("REMOVE",
                      style: GoogleFonts.firaSans(
                          letterSpacing: 1,
                          color: Colors.white,
                          fontSize: 12
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
      child: GestureDetector(
        onTap: (){
          push(context, InstituteDetailedScreen(instituteNamesW[widget.index],instituteDegreesW[widget.index],instituteCity[widget.index], instituteState[widget.index],instituteRate[widget.index], instituteSatScore[widget.index], instituteRequestForInfoLink[widget.index], instituteGetInTouchLink[widget.index], instituteIdsW[widget.index]));
        },
        child: Container(
          height: getProportionateScreenHeight(101),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Color(0xFFDAE7FF)),
            //color: Color(COLOR_ACCENT)
          ),
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(getProportionateScreenWidth(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: getProportionateScreenWidth(210),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          instituteNamesW[widget.index],
                          style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF383838),
                              fontSize: 14),
                        ),SizedBox(height: 5,),
                        Text(
                          instituteDegreesW[widget.index],
                          style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF383838),
                              fontSize: 14),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          instituteCityStateRateW[widget.index],
                          style: GoogleFonts.firaSans(
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF383838),
                              fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,color: Color(0xFF8B8B8B),)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
        end: const Offset(-0.3, 0.0)
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
        end: const Offset(-0.3, 0.0)
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



