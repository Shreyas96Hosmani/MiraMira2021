import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/helper.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:mira_mira/UI/SignUp/LoginSignupScreen.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  jumpScreen() {
    Future.delayed(const Duration(seconds: 3), () async {
      pushReplacement(context, LoginScreen());
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    jumpScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Color(0xff1E73BE),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: getProportionateScreenHeight(132),),
            Container(
              height: getProportionateScreenHeight(81.87),
              child: SvgPicture.asset("assets/imageSVG/miramira.svg"),
            ),
            SizedBox(height: getProportionateScreenHeight(132),),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(58)),
              child: Text(
                "A decision-aid tool\nfor school students\nto choose their career\npowered by AI.",
                textAlign: TextAlign.center,
                style: GoogleFonts.firaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 20,letterSpacing: 0.5
                ),
              ),
            ),
            Spacer(),
            Container(
              child: SvgPicture.asset("assets/imageSVG/splashDesign.svg",fit: BoxFit.cover,
                width: SizeConfig.screenWidth,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(20),),
          ],
        ),
      ),
    );
  }
}
