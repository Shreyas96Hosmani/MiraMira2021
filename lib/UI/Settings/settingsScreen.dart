import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/helper.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';

bool showAlerts = true;

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showAlerts = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
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
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(getProportionateScreenWidth(10)),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFDAE7FF), width: 2),
                borderRadius: BorderRadius.circular(7),
                color: Colors.white,
              ),
              height: getProportionateScreenHeight(982),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: getProportionateScreenHeight(96),
                    padding: EdgeInsets.all(
                      getProportionateScreenWidth(22),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            pop(context);
                          },
                          child: Text(
                            "<  Settings",
                            style: GoogleFonts.firaSans(
                                color: Color(0xFF383838),
                                fontWeight: FontWeight.w400,
                                fontSize: 18),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              size: getProportionateScreenWidth(30),
                              color: Color(0xFF6C6C6C),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(14)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        Text(
                          "SECURITY",
                          style: GoogleFonts.firaSans(
                              color: Color(0xFF383838),
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(20),
                        ),
                        SettingCustomButton(
                          onTap: (){},
                          imgPath: "",
                          text: "Password",
                        ),SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(20),
                        ),
                        Text(
                          "NOTIFICATIONS",
                          style: GoogleFonts.firaSans(
                              color: Color(0xFF383838),
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(20),
                        ),
                        SettingCustomButton(
                          onTap: (){},
                          imgPath: "",
                          text: "Alerts",
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        SettingCustomButton(
                          onTap: (){},
                          imgPath: "",
                          text: "Messages",
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),
                        SettingCustomButton(
                          onTap: (){},
                          imgPath: "",
                          text: "Notifications",
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SettingCustomButton extends StatefulWidget {
  const SettingCustomButton({
    Key key, this.text, this.imgPath, this.onTap,
  }) : super(key: key);
  final String text,imgPath;
  final Function onTap;

  @override
  _SettingCustomButtonState createState() => _SettingCustomButtonState();
}

class _SettingCustomButtonState extends State<SettingCustomButton> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
          width: getProportionateScreenWidth(321),
          height: getProportionateScreenHeight(55)),
      child: ElevatedButton(
        onPressed: widget.onTap,
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(16)),
          onPrimary: Color(COLOR_ACCENT),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                  color: Color(0xFFDAE7FF), width: 2)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              widget.imgPath,
              height: getProportionateScreenWidth(25),
            ),
            SizedBox(
              width: getProportionateScreenWidth(21),
            ),
            Text(
              widget.text,
              style: GoogleFonts.firaSans(
                  fontSize: 18,
                  color: Color(0xFF383838),
                  fontWeight: FontWeight.normal),
            ),
            Spacer(),
            widget.text == "Password" ? Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF8B8B8B),
            ) : Container(
              child: Transform.scale(
                scale: 1,
                child: Switch(
                  onChanged: (bool value){
                    setState(() {
                      showAlerts = !showAlerts;
                    });
                  },
                  value: showAlerts,
                  activeColor: Color(0xffb9ce82),
                  activeTrackColor: Colors.grey.shade300,//.shade300,
                  inactiveThumbColor: Colors.red[900],
                  inactiveTrackColor: Colors.grey.shade300,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class logoutButton extends StatelessWidget {
  const logoutButton({
    Key key, this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
          width: getProportionateScreenWidth(321),
          height: getProportionateScreenHeight(55)),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(16)),
          onPrimary: Color(COLOR_ACCENT),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                  color: Color(0xFFC14444), width: 2)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/iconSVG/logout.svg",
              height: getProportionateScreenWidth(25),
            ),
            SizedBox(
              width: getProportionateScreenWidth(21),
            ),
            Text(
              "Logout",
              style: GoogleFonts.firaSans(
                  fontSize: 18,
                  color: Color(0xFFC14444),
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
