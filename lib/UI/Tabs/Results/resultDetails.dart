import 'dart:io';
import 'dart:typed_data';
import 'package:mira_mira/Helper/helper.dart';
import 'package:mira_mira/UI/Tabs/Results/CourseListScreenForResults.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:mira_mira/UI/Widgets/radar_chart.dart';
import 'package:mira_mira/UI/home_screen/home_screen.dart';
import 'package:mira_mira/UI/home_screen/home_screen.dart' as h;
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

int tick1; int tick2; int tick3; int tick4;
int tick5; int tick6; int tick7; int tick8;

class ResultDetails extends StatefulWidget {

  final index;
  final resultDateTimes;
  final spiritQuadScore;
  final spiritQuadDisplay;
  final spiritBlurb;
  final purposeQuadScore;
  final purposeQuadDisplay;
  final purposeBlurb;
  final professionQuadScore;
  final professionQuadDisplay;
  final professionBlurb;
  final rewardQuadScore;
  final rewardQuadDisplay;
  final rewardBlurb;
  final resultHighLight;
  final prevSpiritQuadScore;
  final prevProfessionQuadScore;
  final prevRewardQuadScore;
  final prevPurposeQuadScore;
  ResultDetails(this.index, this.resultDateTimes, this.spiritQuadScore, this.spiritQuadDisplay, this.spiritBlurb, this.purposeQuadScore, this.purposeQuadDisplay,
      this.purposeBlurb, this.professionQuadScore, this.professionQuadDisplay, this.professionBlurb, this.rewardQuadScore, this.rewardQuadDisplay, this.rewardBlurb, this.resultHighLight,
      this.prevSpiritQuadScore, this.prevProfessionQuadScore, this.prevRewardQuadScore, this.prevPurposeQuadScore)
  : super();

  @override
  _ResultDetailsState createState() => _ResultDetailsState();
}

class _ResultDetailsState extends State<ResultDetails> {

  bool useSides = false;
  double numberOfFeatures = 4;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      viewCoursesPressed = false;
    });
    if(widget.spiritQuadScore.contains('.')){
      int idx1 = widget.spiritQuadScore.indexOf('.');
      setState(() {
        tick1 = int.parse(widget.spiritQuadScore.toString().substring(0,idx1));
      });
      print("spiritQuadScore : "+widget.spiritQuadScore.toString().substring(0,idx1));
    }else{
      setState(() {
        tick1 = int.parse(widget.spiritQuadScore.toString());
      });
    }
    if(widget.purposeQuadScore.contains('.')){
      int idx2 = widget.purposeQuadScore.indexOf('.');
      setState(() {
        tick2 = int.parse(widget.purposeQuadScore.toString().substring(0,idx2));
      });
      print("purposeQuadScore : "+widget.purposeQuadScore.toString().substring(0,idx2));
    }else{
      setState(() {
        tick2 = int.parse(widget.purposeQuadScore.toString());
      });
    }
    if(widget.professionQuadScore.contains('.')){
      int idx3 = widget.professionQuadScore.indexOf('.');
      setState(() {
        tick3 = int.parse(widget.professionQuadScore.toString().substring(0,idx3));
      });
      print("professionQuadScore : "+widget.professionQuadScore.toString().substring(0,idx3));
    }else{
      setState(() {
        tick3 = int.parse(widget.professionQuadScore.toString());
      });
    }
    if(widget.rewardQuadScore.contains('.')){
      int idx4 = widget.rewardQuadScore.indexOf('.');
      setState(() {
        tick4 = int.parse(widget.rewardQuadScore.toString().substring(0,idx4));
      });
      print("rewardQuadScore : "+widget.rewardQuadScore.toString().substring(0,idx4));
    }else{
      setState(() {
        tick4 = int.parse(widget.rewardQuadScore.toString());
      });
    }

    if(widget.prevSpiritQuadScore.contains('.')){
      int idx1 = widget.prevSpiritQuadScore.indexOf('.');
      setState(() {
        tick5 = int.parse(widget.prevSpiritQuadScore.toString().substring(0,idx1));
      });
      print("prevSpiritQuadScore : "+widget.prevSpiritQuadScore.toString().substring(0,idx1));
    }else{
      setState(() {
        tick5 = int.parse(widget.prevSpiritQuadScore.toString());
      });
    }
    if(widget.prevPurposeQuadScore.contains('.')){
      int idx2 = widget.prevPurposeQuadScore.indexOf('.');
      setState(() {
        tick6 = int.parse(widget.prevPurposeQuadScore.toString().substring(0,idx2));
      });
      print("prevPurposeQuadScore : "+widget.prevPurposeQuadScore.toString().substring(0,idx2));
    }else{
      setState(() {
        tick6 = int.parse(widget.prevPurposeQuadScore.toString());
      });
    }
    if(widget.prevProfessionQuadScore.contains('.')){
      int idx3 = widget.prevProfessionQuadScore.indexOf('.');
      setState(() {
        tick7 = int.parse(widget.prevProfessionQuadScore.toString().substring(0,idx3));
      });
      print("prevProfessionQuadScore : "+widget.prevProfessionQuadScore.toString().substring(0,idx3));
    }else{
      setState(() {
        tick7 = int.parse(widget.prevProfessionQuadScore.toString());
      });
    }
    if(widget.prevRewardQuadScore.contains('.')){
      int idx4 = widget.prevRewardQuadScore.indexOf('.');
      setState(() {
        tick8 = int.parse(widget.prevRewardQuadScore.toString().substring(0,idx4));
      });
      print("prevRewardQuadScore : "+widget.prevRewardQuadScore.toString().substring(0,idx4));
    }else{
      setState(() {
        tick8 = int.parse(widget.prevRewardQuadScore.toString());
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    const ticks = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    var features = ["", "", "", "",];
    var data = [
      widget.index.toString() == "0" ? [0, 0, 0, 0,] : [tick8,tick6,tick5,tick7],//[widget.prevRewardQuadScore,widget.prevPurposeQuadScore,widget.prevSpiritQuadScore,widget.prevProfessionQuadScore],
      [tick4, tick2, tick1, tick3,],
    ];

    features = features.sublist(0, numberOfFeatures.floor());

    data = data
        .map((graph) => graph.sublist(0, numberOfFeatures.floor()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: getProportionateScreenHeight(96),
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            color: Colors.blue[700],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: ListView(
              scrollDirection: Axis.vertical,
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(
                      color: Colors.blue[200],
                      blurRadius: 1.0,
                    ),],
                    color: Colors.white,
                  ),
                  height: MediaQuery.of(context).size.height/1.1,
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: ListView(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 20,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Result "+widget.resultDateTimes.toString(),textScaleFactor: 1,
                                  style: GoogleFonts.firaSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18),
                                ),
                                GestureDetector(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.close)),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName.toString(),
                                      style: GoogleFonts.firaSans(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    ),SizedBox(height: 5,),
                                    Text(
                                      h.lvScore.toString()+"/10 LV Score | "+h.completedSprints.toString()+" Sprints",
                                      textScaleFactor: 1,
                                      style: GoogleFonts.firaSans(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () async {
                                    await screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List image) async {
                                      if (image != null) {
                                        final directory = await getApplicationDocumentsDirectory();
                                        final imagePath = await File('${directory.path}/image.png').create();
                                        await imagePath.writeAsBytes(image);

                                        /// Share Plugin
                                        await Share.shareFiles([imagePath.path],text: 'Here\'s my Quad Result on MiraMira');
                                      }
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    "assets/iconSVG/shareOutlineWhite.svg",
                                    height: getProportionateScreenWidth(21),
                                    color: Color(COLOR_ACCENT),
                                  ),
                                )
                              ],
                            ),SizedBox(height: 5,),
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: [
//                          Padding(
//                            padding: const EdgeInsets.only(top: 10),
//                            child: Text(
//                              h.lvScore.toString()+"/10 LV Score | "+h.completedSprints.toString()+" Sprints | Richardson, TX",
//                              style: GoogleFonts.firaSans(
//                                  color: Colors.black,
//                                  fontWeight: FontWeight.w400,
//                                  fontSize: 14),
//                            ),
//                          ),
//                          Spacer(),
//                          Padding(
//                            padding: const EdgeInsets.only(right: 5),
//                            child: SvgPicture.asset(
//                              "assets/iconSVG/shareOutlineWhite.svg",
//                              height: getProportionateScreenWidth(21),
//                              color: Color(COLOR_ACCENT),
//                            ),
//                          ),
//                        ],
//                      ),
                            SizedBox(height: 10,),
                            Divider(
                              color: Colors.blue[50],thickness: 3,
                            ),
                            SizedBox(
                              height: getProportionateScreenWidth(10),
                            ),
                          ],
                        ),
                      ),

                      Screenshot(
                        controller: screenshotController,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "You are "+widget.resultHighLight.toString()+" person. Read on.",
                                    textScaleFactor: 1,
                                    style: GoogleFonts.firaSans(
                                        color: Colors.blue[700],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenWidth(20),
                                  ),
                                  Stack(
                                    children: [
                                      Center(
                                        child: Container(
                                          height: 300,
                                          width: 300,
                                          child: Transform.rotate(
                                            angle: 40,
                                            child: RadarChart.light(
                                              ticks: ticks,
                                              features: features,
                                              data: data,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "SPIRIT",textScaleFactor: 1,
                                            style: GoogleFonts.firaSans(
                                                color: Colors.blue[700],
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          ),SizedBox(height: 10,),
                                          Text(
                                            widget.spiritQuadDisplay.toString().toUpperCase(),textScaleFactor: 1,
                                            style: GoogleFonts.firaSans(
                                                color: Colors.blue[700],
                                                //fontWeight: FontWeight.w300,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "PROFESSION",textScaleFactor: 1,
                                              style: GoogleFonts.firaSans(
                                                  color: Colors.blue[700],
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            ),SizedBox(height: 10,),
                                            Text(
                                              widget.professionQuadDisplay.toString().toUpperCase(),textScaleFactor: 1,
                                              style: GoogleFonts.firaSans(
                                                  color: Colors.blue[700],
                                                  //fontWeight: FontWeight.w500,
                                                  fontSize: 12),
                                            ),
//                                Text(
//                                  "PATIENT",
//                                  style: GoogleFonts.firaSans(
//                                      color: Colors.blue[700],
//                                      //fontWeight: FontWeight.w500,
//                                      fontSize: 12),
//                                ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 270),
                                        child: Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "PURPOSE",textScaleFactor: 1,
                                                style: GoogleFonts.firaSans(
                                                    color: Colors.blue[700],
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14),
                                              ),SizedBox(height: 10,),
                                              Text(
                                                widget.purposeQuadDisplay.toString().toUpperCase(),textScaleFactor: 1,
                                                style: GoogleFonts.firaSans(
                                                    color: Colors.blue[700],
                                                    //fontWeight: FontWeight.w500,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 270),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "REWARD",textScaleFactor: 1,
                                                style: GoogleFonts.firaSans(
                                                    color: Colors.blue[700],
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14),
                                              ),SizedBox(height: 10,),
                                              Text(
                                                widget.rewardQuadDisplay.toString().toUpperCase(),textScaleFactor: 1,
                                                style: GoogleFonts.firaSans(
                                                    color: Colors.blue[700],
                                                    //fontWeight: FontWeight.w500,
                                                    fontSize: 12),
                                              ),
//                                  Text(
//                                    "PLURALIST",
//                                    style: GoogleFonts.firaSans(
//                                        color: Colors.blue[700],
//                                        //fontWeight: FontWeight.w500,
//                                        fontSize: 12),
//                                  ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30,),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "SPIRIT",textScaleFactor: 1,
                              style: GoogleFonts.firaSans(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),SizedBox(
                              height: getProportionateScreenWidth(10),
                            ),
                            Text(
                              widget.spiritBlurb,textScaleFactor: 1,
                              style: GoogleFonts.firaSans(
                                  color: Colors.black,letterSpacing: 0.5,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                            SizedBox(height: 30,),
                            Text(
                              "PURPOSE",textScaleFactor: 1,
                              style: GoogleFonts.firaSans(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),SizedBox(
                              height: getProportionateScreenWidth(10),
                            ),
                            Text(
                              widget.purposeBlurb.toString(),textScaleFactor: 1,
                              style: GoogleFonts.firaSans(
                                  color: Colors.black,letterSpacing: 0.5,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                            SizedBox(height: 30,),
                            Text(
                              "PROFESSION",textScaleFactor: 1,
                              style: GoogleFonts.firaSans(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),SizedBox(
                              height: getProportionateScreenWidth(10),
                            ),
                            Text(
                              widget.professionBlurb.toString(),textScaleFactor: 1,
                              style: GoogleFonts.firaSans(
                                  color: Colors.black,letterSpacing: 0.5,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                            SizedBox(height: 30,),
                            Text(
                              "REWARD",textScaleFactor: 1,
                              style: GoogleFonts.firaSans(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),SizedBox(
                              height: getProportionateScreenWidth(10),
                            ),
                            Text(
                              widget.rewardBlurb.toString(),textScaleFactor: 1,
                              style: GoogleFonts.firaSans(
                                  color: Colors.black,letterSpacing: 0.5,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              height: getProportionateScreenWidth(40),
                            ),
                            //Spacer(),
                            Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints.tightFor(
                                  width: getProportionateScreenWidth(132),
                                  height: getProportionateScreenHeight(33),
                                ),
                                child: ElevatedButton(
                                  onPressed: (){
                                    setState(() {
                                      viewCoursesPressed = true;
                                    });
                                    print("viewCoursesPressed : "+viewCoursesPressed.toString());
                                    pop(context);
                                  },
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
                                  child: Text("VIEW COURSES"),
                                ),
                              ),
                            ),
                            /*
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints.tightFor(
                                      width: getProportionateScreenWidth(132),
                                      height: getProportionateScreenHeight(33),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: (){

                                      },
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
                                      child: Text("MAIL RESULT"),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  ConstrainedBox(
                                    constraints: BoxConstraints.tightFor(
                                      width: getProportionateScreenWidth(132),
                                      height: getProportionateScreenHeight(33),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: (){
                                        setState(() {
                                          viewCoursesPressed = true;
                                        });
                                        print("viewCoursesPressed : "+viewCoursesPressed.toString());
                                        pop(context);
                                      },
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
                                      child: Text("VIEW COURSES"),
                                    ),
                                  ),
                                  /*
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        viewCoursesPressed = true;
                                      });
                                      print("viewCoursesPressed : "+viewCoursesPressed.toString());
                                      pop(context);
                                      //push(context, CourseListScreenForResults());
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width/3,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        border: Border.all(color: Colors.blue.shade700),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "VIEW COURSES",textScaleFactor: 1,
                                          style: GoogleFonts.firaSans(
                                              color: Colors.blue.shade700,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),

                                   */
                                ],
                              ),
                            ),

                             */
                            SizedBox(
                              height: getProportionateScreenWidth(40),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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

class CourseButton2 extends StatelessWidget {
  const CourseButton2({
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
