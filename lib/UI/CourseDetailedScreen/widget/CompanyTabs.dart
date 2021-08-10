import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/helper.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:mira_mira/View%20Models/CustomViewModel.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';


SfRangeValues fee_range = SfRangeValues(0.0, 40000.0);
SfRangeValues sat_score_range = SfRangeValues(700.0, 1300.0);
String state="";

class CourseTabs extends StatefulWidget {
  final int selectedTab;
  final String id;
  final Function(int) tabPressed;

  CourseTabs({this.id, this.selectedTab, this.tabPressed});

  @override
  _CourseTabsState createState() => _CourseTabsState();
}

class _CourseTabsState extends State<CourseTabs> {
  int _selectedTabs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final providerListener = Provider.of<CustomViewModel>(context);

    _selectedTabs = widget.selectedTab ?? 0;
    return Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CompanyTabBtn(
                  optName: "OVERVIEW",
                  selected: _selectedTabs == 0 ? true : false,
                  onPressed: () {
                    widget.tabPressed(0);
                  },
                ),
                SizedBox(
                  width: getProportionateScreenWidth(19),
                ),
                CompanyTabBtn(
                  optName: "INSTITUTES"+(providerListener.filteredInstituesList.length>0?(" ("+providerListener.filteredInstituesList.length.toString()+")"):""),
                  selected: _selectedTabs == 1 ? true : false,
                  onPressed: () {
                    widget.tabPressed(1);
                  },
                ),
                Spacer(),
                widget.selectedTab == 1 ? InkWell(
                  onTap: () {
                    widget.tabPressed(1);
                    setState(() {
                      state = "";
                      providerListener.isFilterPressed = !providerListener.isFilterPressed;
                    });
                  },
                  child: SvgPicture.asset(
                    providerListener.isFilterPressed
                        ? "assets/iconSVG/filterButtonBlue.svg"
                        : "assets/iconSVG/filterButton.svg",
                    width: getProportionateScreenWidth(35),
                  ),
                ) : Container(),
              ],
            ),
            providerListener.isFilterPressed == true
                ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "FEE",
                  style: GoogleFonts.firaSans(
                      color: Color(0xFF1E73BE),
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
                SfRangeSliderTheme(
                  data: SfRangeSliderThemeData(
                      activeLabelStyle: GoogleFonts.firaSans(
                        color: Color(COLOR_ACCENT),
                        fontSize: 12,
                      ),
                      inactiveLabelStyle: GoogleFonts.firaSans(
                        color: Color(COLOR_ACCENT),
                        fontSize: 12,
                      ),
                      activeTrackHeight: 3,
                      inactiveTrackHeight: 3,
                      activeDividerRadius: 1.5,
                      inactiveDividerRadius: 5),
                  child: SfRangeSlider(
                    min: 0.0,
                    max: 80000.0,
                    values: fee_range,
                    endThumbIcon: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(100)),
                          color: Color(COLOR_ACCENT)),
                    ),
                    startThumbIcon: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(100)),
                          color: Color(COLOR_ACCENT)),
                    ),
                    labelFormatterCallback:
                        (dynamic actualValue, String formattedText) {
                      return actualValue == 0
                          ? '\$'
                          : actualValue == 20000
                          ? '\$\$'
                          : actualValue == 40000
                          ? '\$\$\$'
                          : actualValue == 60000
                          ? '\$\$\$'
                          : '\$\$\$\$';
                    },
                    activeColor: Color(COLOR_ACCENT),
                    inactiveColor: Colors.grey[300],
                    interval: 20000,
                    showTicks: false,
                    showLabels: true,
                    enableTooltip: false,
                    minorTicksPerInterval: 0,
                    onChanged: (SfRangeValues values) {
                      setState(() {
                        fee_range = values;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "SAT SCORE",
                  style: GoogleFonts.firaSans(
                      color: Color(0xFF1E73BE),
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
                SfRangeSliderTheme(
                  data: SfRangeSliderThemeData(
                      activeLabelStyle: GoogleFonts.firaSans(
                        color: Color(COLOR_ACCENT),
                        fontSize: 12,
                      ),
                      inactiveLabelStyle: GoogleFonts.firaSans(
                        color: Color(COLOR_ACCENT),
                        fontSize: 12,
                      ),
                      activeTrackHeight: 3,
                      inactiveTrackHeight: 3,
                      activeDividerRadius: 1.5,
                      inactiveDividerRadius: 5),
                  child: SfRangeSlider(
                    min: 400.0,
                    max: 1600.0,
                    values: sat_score_range,
                    endThumbIcon: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(100)),
                          color: Color(COLOR_ACCENT)),
                    ),
                    startThumbIcon: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(100)),
                          color: Color(COLOR_ACCENT)),
                    ),
                    activeColor: Color(COLOR_ACCENT),
                    inactiveColor: Colors.grey[300],
                    interval: 300,
                    showTicks: false,
                    showLabels: true,
                    enableTooltip: true,
                    minorTicksPerInterval: 0,
                    onChanged: (SfRangeValues values) {
                      setState(() {
                        sat_score_range = values;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "LOCATION : STATE",
                  style: GoogleFonts.firaSans(
                      color: Color(0xFF1E73BE),
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffC4C4C4))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 20, left: 10, right: 10),
                    child: SearchableDropdown.single(
                      items: StatesList.map((String value) {
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
                      onChanged: (key) {
                        setState(() {
                          if (key != null) {
                            state = StatesListWithCode[key];
                          }
                        });
                      },
                      isExpanded: true,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        print(widget.id.toString());
                        setState(() {
                          state = "";
                        });
                        Provider.of<CustomViewModel>(context, listen: false)
                            .resetInstitues();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
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
                    ),
                    InkWell(
                      onTap: (){
                          Provider.of<CustomViewModel>(context, listen: false)
                              .applyFiltersInstitues(state, fee_range.start.toString(), fee_range.end.toString(), sat_score_range.start.toString(), sat_score_range.end.toString());

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
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
                    )
                  ],
                ),
              ],
            )
                : Container(),
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
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: _selected ? Color(COLOR_ACCENT) : Colors.black),
            ),
            SizedBox(
              height: getProportionateScreenHeight(3),
            ),
            _selected
                ? Container(
              height: 1.4,
              width: 60,
              color: Color(COLOR_ACCENT),
            )
                : SizedBox(
              height: 0,
            ),
          ],
        ),
      ),
    );
  }
}