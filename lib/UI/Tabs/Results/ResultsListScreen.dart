import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/helper.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:mira_mira/UI/QuizScreen/QuizListScreen.dart';
import 'package:mira_mira/UI/SignUp/LoginSignupScreen.dart';
import 'package:mira_mira/UI/Tabs/Results/resultDetails.dart' as rd;
import 'package:mira_mira/UI/UserProfileScreen/UserProfileScreen.dart';
import 'package:mira_mira/UI/home_screen/home_screen.dart';
import 'package:mira_mira/UI/home_screen/home_screen.dart' as h;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultListScreen extends StatefulWidget {
  @override
  _ResultListScreenState createState() => _ResultListScreenState();
}

class _ResultListScreenState extends State<ResultListScreen> {

  Future<String> getResults(context) async {

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getSprintResult";
    var body = jsonEncode({

      "userId" : isSignedIn.toString(),
    });

    http.post(Uri.parse(url), body: body).then((http.Response response) async {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error fetching data");
      }

      var responseGetResults = jsonDecode(response.body);
      print("responseGetResults"+responseGetResults.toString());

      if(responseGetResults == [] || responseGetResults.isEmpty){
        print("empty");
        setState(() {
          resultIds = null;
        });
      }else{
        setState(() {
          resultIds = List.generate(responseGetResults.length, (index) => responseGetResults[index]['_id'].toString());
          resultDateTimes = List.generate(responseGetResults.length, (index) => responseGetResults[index]['resultDateTime'].toString());
          resultHighlights = List.generate(responseGetResults.length, (index) => responseGetResults[index]['resultHeadPara'].toString());

          spiritQuadScore = List.generate(responseGetResults.length, (index) => responseGetResults[index]['spiritResult']['quadscore'].toString());
          spiritQuadDisplay = List.generate(responseGetResults.length, (index) => responseGetResults[index]['spiritResult']['quadDisplay'].toString());
          spiritBlurb = List.generate(responseGetResults.length, (index) => responseGetResults[index]['spiritResult']['blurb'].toString());

          purposeQuadScore = List.generate(responseGetResults.length, (index) => responseGetResults[index]['purposeResult']['quadscore'].toString());
          purposeQuadDisplay = List.generate(responseGetResults.length, (index) => responseGetResults[index]['purposeResult']['quadDisplay'].toString());
          purposeBlurb = List.generate(responseGetResults.length, (index) => responseGetResults[index]['purposeResult']['blurb'].toString());

          professionQuadScore = List.generate(responseGetResults.length, (index) => responseGetResults[index]['professionResult']['quadscore'].toString());
          professionQuadDisplay = List.generate(responseGetResults.length, (index) => responseGetResults[index]['professionResult']['quadDisplay'].toString());
          professionBlurb = List.generate(responseGetResults.length, (index) => responseGetResults[index]['professionResult']['blurb'].toString());

          rewardQuadScore = List.generate(responseGetResults.length, (index) => responseGetResults[index]['rewardsResult']['quadscore'].toString());
          rewardQuadDisplay = List.generate(responseGetResults.length, (index) => responseGetResults[index]['rewardsResult']['quadDisplay'].toString());
          rewardBlurb = List.generate(responseGetResults.length, (index) => responseGetResults[index]['rewardsResult']['blurb'].toString());
        });

        print(resultIds.toList());
        print(resultDateTimes.toList());
        print(resultHighlights.toList());

        print(spiritQuadScore.toList());
        print(spiritQuadDisplay.toList());
        print(spiritBlurb.toList());

        print(purposeQuadScore.toList());
        print(purposeQuadDisplay.toList());
        print(purposeBlurb.toList());

        print(professionQuadScore.toList());
        print(professionQuadDisplay.toList());
        print(professionBlurb.toList());

        print(rewardQuadScore.toList());
        print(rewardQuadDisplay.toList());
        print(rewardBlurb.toList());
      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResults(context);
//    setState(() {
//      resultIds = null;
//    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0xff1E73BE)
    ));
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: [
            //Top Profile
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: getProportionateScreenHeight(96),
                  color: Color(COLOR_ACCENT),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: SvgPicture.asset(
                      "assets/imageSVG/HeaderSIdeDesign.svg",
                      height: getProportionateScreenHeight(96),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, top: 60),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: SvgPicture.asset("assets/iconSVG/square.svg")),
                ),
                Container(
                  height: getProportionateScreenHeight(96),
                  width: MediaQuery.of(context).size.width/1.2,
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  color: Color(COLOR_ACCENT),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                              radius: getProportionateScreenWidth(30),
                              backgroundColor: Color(0xffFEC55F),//Color(0xFFDDDDDD),
                              backgroundImage: photo == "" || photo == null || photo == "null" ? null : Image.memory(base64Decode(photo),).image,
                              child: Container(
                                //color: Color(0xffFEC55F),
                                margin: EdgeInsets.all(4),
                                child: Container(
                                  child: photo == "" || photo == null || photo == "null" ? SvgPicture.asset(
                                    "assets/imageSVG/miramira.svg",
                                    height: getProportionateScreenHeight(20),
                                    fit: BoxFit.fitHeight,
                                  ) : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(16),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Text(
                            "Hello "+h.userName.toString(),
                            style: GoogleFonts.firaSans(
                                color: Colors.white,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          Text(
                            h.lvScore.toString()+"/10 LV Score | "+h.completedSprints.toString() +" Sprints",
                            style: GoogleFonts.firaSans(
                              fontSize: 12,letterSpacing: 0,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(30),
                    vertical: getProportionateScreenHeight(15)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "RESULTS",
                          style: GoogleFonts.firaSans(
                              color: Color(COLOR_ACCENT),
                              fontSize: 16,letterSpacing: 1,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(10),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "You can see all your results right here. The results over time will show your progress and help MiraMira refine your suggestions",
                          textScaleFactor: 1,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.firaSans(
                              color: Colors.black,
                              fontSize: 14,letterSpacing: 1,
                              height: 1.35,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(20),),
                      ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: resultIds == null ? 0 : resultIds.length,
                        itemBuilder: (context, i) =>
                            SprintTile(index: i,),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
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
            Center(
              child: Text(
                "Start with the Quiz!",
                textScaleFactor: 1,
                style: GoogleFonts.firaSans(
                    color: Color(COLOR_ACCENT),
                    fontSize: getProportionateScreenHeight(21),
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Center(
              child: Text(
                "An easy sprint of questions will make\nMiraMira discover your aptitude",
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: GoogleFonts.firaSans(
                  color: Colors.black,
                  letterSpacing: 1,
                  fontSize: getProportionateScreenHeight(17),
                ),
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Center(child: SvgPicture.asset("assets/iconSVG/robotupsidedown.svg")),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Text(
              "Go ahead, start your journey now.",
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: GoogleFonts.firaSans(
                  color: Color(0xFF3F4462),
                  letterSpacing: 1,
                  fontSize: getProportionateScreenHeight(15),
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50, bottom: 0),
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    width: getProportionateScreenWidth(173),
                    height: getProportionateScreenHeight(41)),
                child: ElevatedButton(
                    onPressed: () {
//                      setState(() {
//                        removeTakeQuizScreen = true;
//                      });
//                      print(removeTakeQuizScreen);
//                      Future.delayed(Duration(seconds: 2), () {
//                        setState(() {});
//                      });
                      push(context, QuizListScreen());
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(COLOR_ACCENT),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        textStyle: GoogleFonts.firaSans(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                        )),
                    child: Text(
                      "TAKE THE QUIZ",
                      textScaleFactor: 1,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

}

class SprintTile extends StatelessWidget {
  const SprintTile({
    Key key, this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tightFor(width: double.infinity),
      child: Card(
        elevation: 0,
        semanticContainer: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: Color(0xFFDAE7FF), width: 1),
        ),
        child: ExpansionTile(
          title: Text("Result "+resultDateTimes[index],style: GoogleFonts.firaSans(
            fontSize: 18,
            color: Color(0xFF383838),
          ),),
          childrenPadding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(15)),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                h.completedSprints.toString()+" SPRINTS",
                style: GoogleFonts.firaSans(
                  fontSize: 14,letterSpacing: 1,
                  color: Color(0xFF383838),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              height: 1,
              color: Color(COLOR_ACCENT),
            ),
            SizedBox(height: 15,),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("You are "+resultHighlights[index]+" person. Read on.",
                textAlign: TextAlign.left,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.firaSans(
                fontSize: 18,letterSpacing: 1,
                color: Colors.blue[700],
              ),),
            ),
            SizedBox(height: 40,),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: (){
                  push(context, rd.ResultDetails(index, resultDateTimes[index], spiritQuadScore[index], spiritQuadDisplay[index], spiritBlurb[index], purposeQuadScore[index], purposeQuadDisplay[index], purposeBlurb[index],  professionQuadScore[index], professionQuadDisplay[index], professionBlurb[index], rewardQuadScore[index], rewardQuadDisplay[index], rewardBlurb[index], resultHighlights[index], index > 0 ? spiritQuadScore[index-1] : "10", index > 0 ? professionQuadScore[index-1] : "10", index > 0 ? rewardQuadScore[index-1] : "10", index > 0 ? purposeQuadScore[index-1] : "10"));
                },
                child: Container(
                  width: 150,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: Colors.blue[700])
                  ),
                  child: Center(
                    child: Text("VIEW DETAILS",style: GoogleFonts.firaSans(
                      fontSize: 18,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }
}

class QuizCircularIndicator extends StatelessWidget {
  const QuizCircularIndicator({
    Key key,
    this.total,
    this.attempted, this.index,
  }) : super(key: key);

  final int total, attempted,index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: CircularPercentIndicator(
        radius: 95,
        lineWidth: getProportionateScreenWidth(8),
        percent: ((360 / total) / 360 * attempted).toDouble(),
        backgroundColor: attempted == total ? Color(0xFFDEDEDE) : Colors.transparent,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Quiz $index",
              style: GoogleFonts.firaSans(
                  color: Color(0xFF3F4462),
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
            SizedBox(
              height: getProportionateScreenHeight(3),
            ),
            attempted == total
                ? SizedBox(
                    height: 0,
                  )
                : Text(
                    "$attempted/$total",
                    style: GoogleFonts.firaSans(
                        color: Color(COLOR_ACCENT),
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
            SizedBox(
              height: getProportionateScreenHeight(3),
            ),
            attempted == total ?Icon(
              Icons.check,
              color:Colors.green,
            ) : SizedBox(height: 0,)
          ],
        ),
        progressColor: Color(0xFFC0D6FF),
      ),
    );
  }
}

class ScoreAndProgressBar extends StatelessWidget {
  ScoreAndProgressBar({
    Key key,
    this.percent,
    this.sprints,
  }) : super(key: key);
  final double percent, sprints;

  @override
  Widget build(BuildContext context) {
    double _progPercent = percent / 100;
    double _progtextPercent = percent / 10;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$_progtextPercent/10 LV Score | $sprints Sprints",
          style: GoogleFonts.firaSans(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 10),
        ),
        SizedBox(
          height: getProportionateScreenHeight(14),
        ),
        LinearPercentIndicator(
            backgroundColor: Colors.grey[500],
            progressColor: Colors.yellow[700],
            padding: EdgeInsets.zero,
            animation: true,
            width: getProportionateScreenWidth(144),
            lineHeight: getProportionateScreenHeight(4),
            percent: _progPercent),
      ],
    );
  }
}
