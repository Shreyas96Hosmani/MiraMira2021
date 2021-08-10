import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertsScreen extends StatefulWidget {
  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 160, left: 30, right: 30),
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: 2,
          itemBuilder: (context, i) =>
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffEDF3FE),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Color(0xffC1D7FF))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 10,),
                        Icon(Icons.warning, color: Color(0xff1E73BE),size: 20,),
                        SizedBox(width: 20,),
                        Flexible(
                          child: Text(
                            "Lorem ipsum is placeholder text commonly used in the graphic, and publishing industries for previewing layouts and visual mockups.",
                            style: GoogleFonts.firaSans(
                                color: Colors.black,
                                fontSize: 14),
                          ),
                        ),SizedBox(width: 10,),
                      ],
                    ),
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
