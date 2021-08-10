import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:mira_mira/UI/UserProfileScreen/UserProfileScreen.dart';

class MessageCenterTabs extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabPressed;

  MessageCenterTabs({this.selectedTab, this.tabPressed});

  @override
  _MessageCenterTabsState createState() => _MessageCenterTabsState();
}

class _MessageCenterTabsState extends State<MessageCenterTabs> {
  int _selectedTabs;
  bool isFilterPressed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectedTabs = widget.selectedTab ?? 0;
    return Scaffold(
      //backgroundColor: Colors.grey,
      body: SafeArea(
        child: Stack(
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
                        Text(
                          "<  Message Center",
                          style: GoogleFonts.firaSans(
                              color: Color(0xFF383838),
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CompanyTabBtn(
                                  optName: "ALERTS",
                                  selected: _selectedTabs == 0 ? true : false,
                                  onPressed: () {
                                    widget.tabPressed(0);
                                  },
                                ),
                                SizedBox(width: getProportionateScreenWidth(19),),
                                CompanyTabBtn(
                                  optName: "NOTIFICATIONS",
                                  selected: _selectedTabs == 1 ? true : false,
                                  onPressed: () {
                                    widget.tabPressed(1);
                                  },
                                ),
                                SizedBox(width: getProportionateScreenWidth(19),),
                                CompanyTabBtn(
                                  optName: "MESSAGES",
                                  selected: _selectedTabs == 1 ? true : false,
                                  onPressed: () {
                                    widget.tabPressed(2);
                                  },
                                ),
                              ],
                            )),
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

class CompanyTabBtn extends StatelessWidget {
  final bool selected;
  final Function onPressed;
  final String optName;

  CompanyTabBtn({this.selected, this.onPressed, this.optName});

  @override
  Widget build(BuildContext context) {
    bool _selected = selected ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        child: Column(
          children: [
            Text(
              optName,
              style: GoogleFonts.firaSans(
                  fontWeight:FontWeight.w500,
                  fontSize: 17,
                  color: _selected ? Color(COLOR_ACCENT) : Colors.black),
            ),
            SizedBox(height: getProportionateScreenHeight(3),),
            _selected ? Container(
              height: 1.4,
              width: 60,
              color: Color(COLOR_ACCENT),
            ): SizedBox(height: 0,),
          ],
        ),
      ),
    );
  }
}
