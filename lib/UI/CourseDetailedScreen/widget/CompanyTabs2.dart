import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:mira_mira/UI/home_screen/home_screen.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class CourseTabs2 extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabPressed;

  CourseTabs2({this.selectedTab, this.tabPressed});

  @override
  _CourseTabs2State createState() => _CourseTabs2State();
}

class _CourseTabs2State extends State<CourseTabs2> {
  int _selectedTabs;
  bool isFilterPressed = false;
  double _value = 40.0;
  double _value2 = 60.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _selectedTabs = widget.selectedTab ?? 0;
    return Container(
        child: Column(
          children: [
            /*
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(width: getProportionateScreenWidth(19),),
                Spacer(),
//                Column(
//                  mainAxisAlignment: MainAxisAlignment.end,
//                  crossAxisAlignment: CrossAxisAlignment.end,
//                  children: [
//                    InkWell(
//                      onTap: (){
//                        print("filter Pressed $isFilterPressed");
//                        widget.tabPressed(1);
//                        setState(() {
//                          isFilterPressed = !isFilterPressed;
//                        });
//                        print(isFilterPressed);
//                      },
//                      child: SvgPicture.asset(
//                        isFilterPressed ? "assets/iconSVG/shareIconSVG.svg" : "assets/iconSVG/shareIconSVG.svg",
//                        width: getProportionateScreenWidth(35),
//                      ),
//                    ),
//                    SizedBox(height: 5,),
//                    Text(courseDescriptionW == null ? "Share (0)" : "Share ("+courseDescriptionW.toList().length.toString()+")",
//                      style: GoogleFonts.firaSans(
//                        fontSize: 12
//                      ),
//                    ),
//                  ],
//                ),
              ],
            ),

             */
            isFilterPressed == true ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                Text(
                  "FEE",
                  style: GoogleFonts.firaSans(
                      color: Color(0xFF1E73BE),
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
                SfSlider(
                  min: 0.0,
                  max: 100.0,
                  value: _value,
                  interval: 20,
                  showTicks: true,
                  showLabels: true,
                  enableTooltip: true,
                  minorTicksPerInterval: 1,
                  onChanged: (dynamic value){
                    setState(() {
                      _value = value;
                    });
                  },
                ),SizedBox(height: 20,),
                Text(
                  "SAT SCORE",
                  style: GoogleFonts.firaSans(
                      color: Color(0xFF1E73BE),
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
                SfSlider(
                  min: 0.0,
                  max: 100.0,
                  value: _value2,
                  interval: 20,
                  showTicks: true,
                  showLabels: true,
                  enableTooltip: true,
                  minorTicksPerInterval: 1,
                  onChanged: (dynamic value){
                    setState(() {
                      _value2 = value;
                    });
                  },
                ),SizedBox(height: 20,),
                Text(
                  "LOCATION : STATE",
                  style: GoogleFonts.firaSans(
                      color: Color(0xFF1E73BE),
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffC4C4C4))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                    child: SearchableDropdown.single(
                      items: ['Maharashtra', 'Karnataka', 'Delhi', 'Madhyapradesh', 'Gujarat'].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(
                            value,
                            textScaleFactor: 1,
                          ),
                        );
                      }).toList(),
                      value: "Select state",
                      hint: "Select state",
                      searchHint: "Search state",
                      closeButton: SizedBox.shrink(),
                      onChanged: (value) {
                        setState(() {
                          //selectedValue = value;
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                ),SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/3,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(color: Color(0xff1E73BE)),
                      ),
                      child: Center(
                        child: Text(
                          "RESET",
                          style: GoogleFonts.firaSans(
                              color: Color(0xFF1E73BE),
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width/3,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(color: Color(0xff1E73BE)),
                      ),
                      child: Center(
                        child: Text(
                          "APPLY",
                          style: GoogleFonts.firaSans(
                              color: Color(0xFF1E73BE),
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ) : Container(),
          ],
        ));
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
