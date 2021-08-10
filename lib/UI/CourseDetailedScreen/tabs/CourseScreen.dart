import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shimmer/shimmer.dart';

var courseWhoIsItFor;
var courseFullTextMiner;

var courseImage;

class CourseScreen extends StatefulWidget {

  final subtitle;
  final description;
  final id;
  CourseScreen(this.subtitle, this.description, this.id) : super();

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {

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
          courseWhoIsItFor = responseGetCourseDetails['courseDetails']['headlineTraits'].toString();
          courseFullTextMiner = responseGetCourseDetails['courseDetails']['appTextNextPage'].toString()+"\n\n"+responseGetCourseDetails['courseDetails']['appTextScanner'].toString()+"\n\n"+responseGetCourseDetails['courseDetails']['appTextReader'].toString()+"\n\n"+responseGetCourseDetails['courseDetails']['appTextMiner'].toString();
          courseImage = responseGetCourseDetails['courseDetails']['courseImage'].toString();
        });

        print(courseWhoIsItFor);
        print(courseFullTextMiner);
        print(courseImage);

      }else {

      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      courseImage = null;
    });
    getCourseOverView(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              courseImage == null ? Shimmer.fromColors(child: Container(
                width: getProportionateScreenWidth(280),
                height: getProportionateScreenHeight(150),
              ), baseColor: Colors.white,
                highlightColor: Colors.grey.shade300,) : Container(
                width: getProportionateScreenWidth(280),
                height: getProportionateScreenHeight(150),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(courseImage.toString()),
                        fit: BoxFit.cover)),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
//              Text(
//                "US",
//                style: GoogleFonts.firaSans(
//                  color: Color(0xFF383838),
//                  fontSize: 18,
//                ),
//              ),
//              SizedBox(
//                height: getProportionateScreenHeight(11),
//              ),
              Text(
                widget.subtitle.toString(),
                textScaleFactor: 1,
                style: GoogleFonts.firaSans(
                    color: Colors.black,letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              Text(
                "WHO IS IT FOR ?",
                style: GoogleFonts.firaSans(
                  color: Color(0xFF3F4462),
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              Text(
                courseWhoIsItFor == null ? "loading..." : courseWhoIsItFor.toString(),
                textScaleFactor: 1,
                style: GoogleFonts.firaSans(
                    color: Colors.black,letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              Text(
                "COURSE DESCRIPTION",
                style: GoogleFonts.firaSans(
                    color: Color(0xFF3F4462),
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
              Text(
                courseFullTextMiner == null ? "loading..." : courseFullTextMiner.toString(),
                textScaleFactor: 1,
                style: GoogleFonts.firaSans(
                    color: Colors.black,letterSpacing: 0.5,
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
              SizedBox(
                height: getProportionateScreenHeight(20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
