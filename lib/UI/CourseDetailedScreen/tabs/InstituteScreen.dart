import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/helper.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:mira_mira/UI/CourseDetailedScreen/InstituteDetailedScreen.dart';
import 'package:mira_mira/Models/InstituesListParser.dart';
import 'package:http/http.dart' as http;
import 'package:mira_mira/View%20Models/CustomViewModel.dart';
import 'dart:convert';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';

var universityId;
var universityName;
var universityDegrees;
var universityState;
var universityCity;
var universityStartDate;
var universityCourseFee;
var universityMinSatScore;
var universityIsKept;

var insId;
var selectedInsId;

ProgressDialog prAdd;
ProgressDialog prRem;

bool showLoading = false;


AnimationController _controller;
Animation<Offset> _animation;
bool showAnimation = true;

class InstituteScreen extends StatefulWidget {
  final id;

  InstituteScreen(this.id) : super();

  @override
  _InstituteScreenState createState() => _InstituteScreenState();
}

class _InstituteScreenState extends State<InstituteScreen>
    with TickerProviderStateMixin {
  Future getInstitues() async {
    print(widget.id.toString());
    Provider.of<CustomViewModel>(context, listen: false)
        .getInstitues(widget.id.toString());
  }

  Future<String> getCourseOverView(context) async {

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getDetailsAndInstitutionListOfCourse?courseId="+widget.id.toString();

    http.get(Uri.parse(url)).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseGetCourseDetails = jsonDecode(utf8.decode(response.bodyBytes));
      print(responseGetCourseDetails);

      var msg = responseGetCourseDetails['status'].toString();
      if(msg == "SUCCESS"){

        setState(() {
          universityIsKept = List.generate(responseGetCourseDetails['institutions'].length, (index) => responseGetCourseDetails['institutions'][index]['isWishListed'].toString());
        });

        print(universityIsKept.toList());

      }else {

      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCourseOverView(context);
    setState(() {
      insId = widget.id.toString();
      selectedInsId = null;
      showLoading = false;
      showAnimation = true;
    });
    getInstitues();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticIn,
    ));
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        showAnimation = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);
    prAdd = ProgressDialog(context);
    prRem = ProgressDialog(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          providerListener.isIntituesLoaded == true
          ? providerListener.filteredInstituesList.length > 0
          ? ListView.builder(
          itemCount: providerListener.filteredInstituesList.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return InstituteListTile(
              instituesListParser: providerListener.filteredInstituesList[index],
              index: index,
            );
          })
          : SizedBox(
        height: 1,
      )
          : Center(
        child: new CircularProgressIndicator(
          strokeWidth: 1,
          backgroundColor: Color(COLOR_WHITE),
          valueColor:
          AlwaysStoppedAnimation<Color>(Color(COLOR_PRIMARY)),
        ),
      ),
    );
  }
}

class InstituteListTile extends StatefulWidget {
  final int index;
  InstituteListTile({Key key, this.instituesListParser, this.index})
      : super(
    key: key,
  );

  final InstituesListParser instituesListParser;

  @override
  _InstituteListTileState createState() => _InstituteListTileState();
}

class _InstituteListTileState extends State<InstituteListTile> {

  Future<String> getCourseOverView(context) async {

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getDetailsAndInstitutionListOfCourse?courseId="+insId.toString();

    http.get(Uri.parse(url)).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseGetCourseDetails = jsonDecode(utf8.decode(response.bodyBytes));
      print(responseGetCourseDetails);

      var msg = responseGetCourseDetails['status'].toString();
      if(msg == "SUCCESS"){

        setState(() {
          universityIsKept = List.generate(responseGetCourseDetails['institutions'].length, (index) => responseGetCourseDetails['institutions'][index]['isWishListed'].toString());
        });

        print(universityIsKept.toList());

      }else {

      }

    });
  }

  Future<String> addToWishlist(context) async {

    setState(() {
      showLoading = true;
    });

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/addToWishList?id="+selectedInsId.toString();
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
        //prAdd.hide();
        Fluttertoast.showToast(msg: "Added",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){
          getCourseOverView(context);
        });
        setState(() {
          showLoading = false;
        });
      }else{
        //prAdd.hide();
        Fluttertoast.showToast(msg: "Please check your network connection",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){

        });
        setState(() {
          showLoading = false;
        });
      }

    });
  }

  Future<String> removeFromWishList(context) async {

    setState(() {
      showLoading = true;
    });

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/removeFromWishList?id="+selectedInsId.toString();

    http.get(Uri.parse(url)).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseAddToWishList = jsonDecode(response.body);
      print(responseAddToWishList);

      var msg = responseAddToWishList['status'].toString();
      if(msg == "SUCCESS"){
        //prRem.hide();
        setState(() {
          showLoading = false;
        });
        Fluttertoast.showToast(msg: "Removed",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){
          getCourseOverView(context);
        });
      }else{
        setState(() {
          showLoading = false;
        });
        //prRem.hide();
        Fluttertoast.showToast(msg: "Please check your network connection",backgroundColor: Color(0xff1E73BE), textColor: Colors.white).whenComplete((){

        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          actions: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  selectedInsId = widget.instituesListParser.id.toString();
                  //showLoading = true;
                });
                if(universityIsKept[widget.index].toString() == "0"){
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
                                      child: Text("Are you sure you want to add this institute? You can always remove it later.", style: GoogleFonts.firaSans(textStyle: TextStyle(fontSize: 16,height: 1.25, letterSpacing: 1,
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
                                              addToWishlist(context);
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
                }else{
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
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 0, left: 10, right: 5, bottom: 7),
                child: Container(
                  width: 120,
                  height: getProportionateScreenHeight(95),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    border: Border.all(color: Color(0xff1E73BE)),
                    color: universityIsKept[widget.index].toString() == "1" ? Color(0xff1E73BE) :
                    Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      showLoading == true ? JumpingDotsProgressIndicator(
                        fontSize: 25.0,color: Color(0xff1E73BE),
                      ) : universityIsKept[widget.index].toString() == "0" ? Icon(Icons.add, color: Color(0xff1E73BE), size: 30,) :
                      universityIsKept[widget.index].toString() == "1" ?
                      SvgPicture.asset("assets/iconSVG/pin.svg",
                        color: universityIsKept[widget.index].toString() == "1" ? Colors.white :
                        Color(0xff1E73BE),
                      ) : Icon(Icons.add, color: Color(0xff1E73BE), size: 30,),
                      SizedBox(height: 2,),
                      Text(
                        universityIsKept[widget.index].toString() == "1" ? "REMOVE" :
                        "ADD TO\nWISHLIST",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.firaSans(
                          letterSpacing: 1,
                          color: universityIsKept[widget.index].toString() == "1" ? Colors.white : Color(0xff1E73BE),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          child: GestureDetector(
            onTap: () {
              push(
                  context,
                  InstituteDetailedScreen(
                      widget.instituesListParser.universityName,
                      widget.instituesListParser.degreeDescription+" "+widget.instituesListParser.courseDescription,
                      widget.instituesListParser.city,
                      widget.instituesListParser.state,
                      widget.instituesListParser.tutionFee.numberInt,
                      widget.instituesListParser.satScore.numberInt,
                      "https://catenate.io",
                      "https://catenate.io",
                      widget.instituesListParser.id));
            },
            child: Container(
              height: getProportionateScreenHeight(101),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Color(0xFFDAE7FF)),
              ),
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: getProportionateScreenWidth(252),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.instituesListParser.universityName,
                              style: GoogleFonts.firaSans(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF383838),
                                  fontSize: 14),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              widget.instituesListParser.degreeDescription,
                              style: GoogleFonts.firaSans(
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF383838),
                                  fontSize: 14),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.instituesListParser.state,
                                  style: GoogleFonts.firaSans(
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF383838),
                                      letterSpacing: 1,
                                      fontSize: 12),
                                ),
                                Text(
                                  ", " +
                                      widget.instituesListParser.city +
                                      " | ",
                                  style: GoogleFonts.firaSans(
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF383838),
                                      letterSpacing: 1,
                                      fontSize: 12),
                                ),
                                Text(
                                  "\$",
                                  style: GoogleFonts.firaSans(
                                      fontWeight: FontWeight.w900,
                                      color: Color(COLOR_ACCENT),
                                      letterSpacing: 1,
                                      fontSize: 12),
                                ),
                                Text(
                                  widget.instituesListParser.stateFee.numberInt??"",
                                  style: GoogleFonts.firaSans(
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF383838),
                                      letterSpacing: 1,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xFF8B8B8B),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        universityIsKept[widget.index].toString() == "1" ?  Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 13),
            child: Container(
              height: 5, width: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Color(0xff1E73BE),
              ),
            ),
          ),
        ) : Container(),
      ],
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

class _SlideMenuState extends State<SlideMenu>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = new Tween(
        begin: const Offset(0.0, 0.0), end: const Offset(-0.3, 0.0))
        .animate(new CurveTween(curve: Curves.decelerate).animate(_controller));

    return new GestureDetector(
      onHorizontalDragUpdate: (data) {
        // we can access context.size here
        setState(() {
          _controller.value -= data.primaryDelta / context.size.width;
        });
      },
      onHorizontalDragEnd: (data) {
        if (data.primaryVelocity > 2500)
          _controller
              .animateTo(.0); //close menu on fast swipe in the right direction
        else if (_controller.value >= .5 ||
            data.primaryVelocity <
                -2500) // fully open if dragged a lot to left or on fast swipe to left
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

class _SlideMenu2State extends State<SlideMenu2>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
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
        begin: const Offset(0.0, 0.0), end: const Offset(-0.3, 0.0))
        .animate(new CurveTween(curve: Curves.decelerate).animate(_controller));

    return new GestureDetector(
      onHorizontalDragUpdate: (data) {
        // we can access context.size here
        setState(() {
          _controller.value -= data.primaryDelta / context.size.width;
        });
      },
      onHorizontalDragEnd: (data) {
        if (data.primaryVelocity > 2500)
          _controller
              .animateTo(.0); //close menu on fast swipe in the right direction
        else if (_controller.value >= .5 ||
            data.primaryVelocity <
                -2500) // fully open if dragged a lot to left or on fast swipe to left
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