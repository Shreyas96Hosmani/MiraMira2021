import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';

class Bottomtabs extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabPressed;

  Bottomtabs({this.selectedTab, this.tabPressed});

  @override
  _BottomtabsState createState() => _BottomtabsState();
}

class _BottomtabsState extends State<Bottomtabs> {
  int _selectedTabs;

  @override
  Widget build(BuildContext context) {
    _selectedTabs = widget.selectedTab ?? 0;

    return Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.grey[500],
            blurRadius: 30,
            spreadRadius: 1,
          )
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomTabBtn(
              iconPath: _selectedTabs == 0
                  ? "assets/iconSVG/bottomNavBarIcons/brainblue.svg"
                  : "assets/iconSVG/bottomNavBarIcons/brain.svg",
              selected: _selectedTabs == 0 ? true : false,
              text: "Quiz",
              onPressed: () {
                widget.tabPressed(0);
              },
            ),
            BottomTabBtn(
              iconPath: _selectedTabs == 1
                  ? "assets/iconSVG/bottomNavBarIcons/resultblue.svg"
                  : "assets/iconSVG/bottomNavBarIcons/result.svg",
              selected: _selectedTabs == 1 ? true : false,text: "Results",
              onPressed: () {
                widget.tabPressed(1);
              },
            ),
            BottomTabBtn(
              iconPath: _selectedTabs == 2
                  ? "assets/iconSVG/bottomNavBarIcons/courseblue.svg"
                  : "assets/iconSVG/bottomNavBarIcons/course.svg",
              selected: _selectedTabs == 2 ? true : false,text: "Courses",
              onPressed: () {
                widget.tabPressed(2);
              },
            ),
            BottomTabBtn(
              iconPath: _selectedTabs == 3
                  ? "assets/iconSVG/bottomNavBarIcons/wishlistblue.svg"
                  : "assets/iconSVG/bottomNavBarIcons/wishlist.svg",
              selected: _selectedTabs == 3 ? true : false,text: "Wishlist",
              onPressed: () {
                widget.tabPressed(3);
              },
            ),
            BottomTabBtn(
              iconPath: _selectedTabs == 4
                  ? "assets/iconSVG/bottomNavBarIcons/moreblue.svg"
                  : "assets/iconSVG/bottomNavBarIcons/more.svg",
              selected: _selectedTabs == 4 ? true : false,text: "More",
              onPressed: () {
                widget.tabPressed(4);
              },
            ),
          ],
        ));
  }
}

class BottomTabBtn extends StatefulWidget {
  final String iconPath;
  final bool selected;
  final Function onPressed;
  final String text;

  BottomTabBtn({this.iconPath, this.selected, this.onPressed, this.text});

  @override
  _BottomTabBtnState createState() => _BottomTabBtnState();
}

class _BottomTabBtnState extends State<BottomTabBtn> {
  @override
  Widget build(BuildContext context) {
    bool _selected = widget.selected ?? false;

    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: 110,
        padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              widget.iconPath,
              width: getProportionateScreenHeight(50),
            ),SizedBox(height: 5,),
            Text(widget.text,
              style: GoogleFonts.firaSans(
                color: widget.selected == true ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
