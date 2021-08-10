import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var rfiLinkURL;
var gitLinkURL;
var instImage;
var universitySummary;

var inStateFee;
var outStateFee;
var satMinScore;
var satMaxScore;

class InstituteDetailedScreen extends StatefulWidget {

  final name;
  final degree;
  final city;
  final state;
  final rate;
  final satScore;
  final rfiLink;
  final gitLink;
  final insId;
  InstituteDetailedScreen(this.name, this.degree, this.city, this.state, this.rate, this.satScore, this.rfiLink, this.gitLink, this.insId) : super();

  @override
  _InstituteDetailedScreenState createState() => _InstituteDetailedScreenState();
}

class _InstituteDetailedScreenState extends State<InstituteDetailedScreen> {

  Future<String> getInstituteDetails(context) async {

    String url = "https://us-east-1.aws.webhooks.mongodb-realm.com/api/client/v2.0/app/miramira-buowd/service/miramira/incoming_webhook/getInstituteById?id="+widget.insId.toString();

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
          rfiLinkURL = responseGetCourseDetails['instituteDetails']['requestForInfoLink'].toString();
          gitLinkURL = responseGetCourseDetails['instituteDetails']['getInTouchLink'].toString();
          instImage = responseGetCourseDetails['instituteDetails']['universityImage'].toString();
          inStateFee =responseGetCourseDetails['instituteDetails']['stateFee']['\$numberInt'].toString();
          outStateFee =responseGetCourseDetails['instituteDetails']['tutionFee']['\$numberInt'].toString();
          universitySummary = responseGetCourseDetails['instituteDetails']['universitySummary'].toString() == "{\$numberInt: 0}" ? "Detailed information not available at the moment, will be available shortly" : responseGetCourseDetails['instituteDetails']['universitySummary'].toString();
        });

        print(rfiLinkURL);
        print(gitLinkURL);
        print(instImage);
        print(inStateFee);
        print(outStateFee);
        print(universitySummary);

      }else {

        setState(() {

        });

      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      universitySummary = "Loading summary...";
      instImage = null;
    });
    getInstituteDetails(context);
  }

  @override
  Widget build(BuildContext context) {
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
                  horizontal: getProportionateScreenWidth(10),
                  vertical: getProportionateScreenHeight(10)),
              height: getProportionateScreenHeight(982),
              child: SingleChildScrollView(
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios_outlined,
                                    size: getProportionateScreenWidth(30),
                                    color: Color(0xFF6C6C6C),
                                  )),SizedBox(width: 5,),
                              Container(
                                width: getProportionateScreenWidth(252),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.name.toString(),
                                      style: GoogleFonts.firaSans(
                                          color: Color(0xFF383838),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      widget.degree.toString(),
                                      maxLines: 2,
                                      style: GoogleFonts.firaSans(
                                          color: Color(0xFF383838),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(36)),
                      child: Column(
                        children: [
                          /*
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  print("wishlist added");
                                },
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/iconSVG/wishlistButton.svg",
                                      width: getProportionateScreenWidth(35),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(7),
                                    ),
                                    Text(
                                      "WISHLIST",
                                      style: GoogleFonts.firaSans(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: getProportionateScreenWidth(20),
                              ),
                              InkWell(
                                onTap: () {
                                  print("wishlist added");
                                },
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/iconSVG/shareIconSVG.svg",
                                      width: getProportionateScreenWidth(35),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(7),
                                    ),
                                    Text(
                                      "SHARE",
                                      style: GoogleFonts.firaSans(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(22),
                          ),

                           */
                          Container(
                            height: 3,
                            color: Color(COLOR_ACCENT),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(22),
                          ),
                          InfoTexts(
                            infoType: "LOCATION",
                            info: widget.city.toString()+", "+widget.state.toString(),
                          ),
                          InfoTexts(
                            infoType: "IN-STATE FEE ",
                            info: "\$"+inStateFee.toString(),
                          ),
                          InfoTexts(
                            infoType: "OUT-STATE FEE",
                            info: "\$"+outStateFee.toString(),//""\$"+widget.rate.toString(),
                          ),
                          InfoTexts(
                            infoType: "SAT SCORE",
                            info: widget.satScore.toString(),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(25),
                          ),
                          instImage == null ? Shimmer.fromColors(child: Container(
                            width: getProportionateScreenWidth(280),
                            height: getProportionateScreenHeight(150),
                          ), baseColor: Colors.white,
                            highlightColor: Colors.grey.shade300,) : Container(
                            width: getProportionateScreenWidth(280),
                            height: getProportionateScreenHeight(150),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(instImage.toString()),
                                    fit: BoxFit.cover)),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(17),
                          ),
                          Container(
                            width: getProportionateScreenWidth(275),
                            child: Text(
                              universitySummary.toString(),
                              textScaleFactor: 1,
                              style: GoogleFonts.firaSans(
                                  color: Colors.black,letterSpacing: 0.5,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                          InstituteHelpButton(
                            text: "REQUEST FOR INFORMATION",
                            onPressed: () {
                              if(rfiLinkURL.toString().contains('https')){
                                launch(rfiLinkURL.toString());
                              }else{
                                launch("https://"+rfiLinkURL.toString());
                              }
                            },
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(9),
                          ),
                          InstituteHelpButton(
                            text: "GET IN TOUCH",
                            onPressed: () {
                              if(gitLinkURL.toString().contains('https')){
                                launch(gitLinkURL.toString());
                              }else{
                                launch("https://"+gitLinkURL.toString());
                              }
                            },
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              size: getProportionateScreenWidth(30),
                              color: Color(0xFF6C6C6C),
                            ),
                            Text("Back To List",style: GoogleFonts.firaSans(fontSize: 18,color: Color(0xFF383838)),)
                          ],
                        ),
                      ),
                    )
                    //SizedBox(height: getProportionateScreenHeight(100),),
                  ],
                ),
              ),
            ),
//            Padding(
//              padding: const EdgeInsets.only(bottom: 30, left: 30),
//              child: Align(
//                alignment: Alignment.bottomLeft,
//                child: Row(
//                  children: [
//                    Icon(
//                      Icons.arrow_back_ios,
//                      size: getProportionateScreenWidth(30),
//                      color: Color(0xFF6C6C6C),
//                    ),
//                    Text("Back To List",style: GoogleFonts.firaSans(fontSize: 18,color: Color(0xFF383838)),)
//                  ],
//                ),
//              ),
//            )
          ],
        ),
      ),
    );
  }
}

class InfoTexts extends StatelessWidget {
  const InfoTexts({
    Key key,
    this.infoType,
    this.info,
  }) : super(key: key);

  final String infoType, info;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: getProportionateScreenHeight(5),
        ),
        Text(
          "$infoType : $info",
          style: GoogleFonts.firaSans(
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(5),
        ),
        Container(
          height: 1,
          color: Color(COLOR_ACCENT),
        ),
      ],
    );
  }
}

class InstituteHelpButton extends StatelessWidget {
  const InstituteHelpButton({
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
        width: getProportionateScreenWidth(265),
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
