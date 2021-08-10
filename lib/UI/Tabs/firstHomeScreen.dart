import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/helper.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:mira_mira/UI/home_screen/home_screen.dart';

bool showQuizes = false;

class FirstHomeScreen extends StatefulWidget {
  @override
  _FirstHomeScreenState createState() => _FirstHomeScreenState();
}

class _FirstHomeScreenState extends State<FirstHomeScreen> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white
    ));
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Start with the Quiz!",
                  style: GoogleFonts.firaSans(
                      color: Color(COLOR_ACCENT),
                      fontSize: getProportionateScreenHeight(21),
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(40),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(40)),
                child: Center(
                  child: Text(
                    "An easy sprint of questions will make\nMiraMira discover your aptitude",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.firaSans(
                        color: Colors.black,letterSpacing: 1,
                        fontSize: getProportionateScreenHeight(17),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(40),
              ),
              SvgPicture.asset("assets/iconSVG/robot.svg"),
              SizedBox(
                height: getProportionateScreenHeight(40),
              ),
              Text(
                "Go ahead, start your journey now.",
                textAlign: TextAlign.center,
                style: GoogleFonts.firaSans(
                    color: Color(0xFF3F4462),letterSpacing: 1,
                    fontSize: getProportionateScreenHeight(15),
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: getProportionateScreenHeight(40),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50, bottom: 50),
                child: TakeQuizButton(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TakeQuizButton extends StatefulWidget {
  const TakeQuizButton({
    Key key,
  }) : super(key: key);

  @override
  _TakeQuizButtonState createState() => _TakeQuizButtonState();
}

class _TakeQuizButtonState extends State<TakeQuizButton> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      showQuizes = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: getProportionateScreenWidth(173),
        height: getProportionateScreenHeight(41)
      ),
      child: ElevatedButton(
          onPressed: () {
            setState(() {
              removeTakeQuizScreen = true;
              showQuizes = true;
            });
            print(showQuizes);
            Future.delayed(Duration(seconds: 2), (){
              setState(() {

              });
            });
            //push(context, QuizListScreen());
          },
          style: ElevatedButton.styleFrom(
            primary: Color(COLOR_ACCENT),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40)
            ),
            textStyle: GoogleFonts.firaSans(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5,
            )
          ),
          child: Text("TAKE THE QUIZ",)),
    );
  }
}
