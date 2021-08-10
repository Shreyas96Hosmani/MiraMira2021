import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
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
          itemCount: 1,
          itemBuilder: (context, i) =>
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                      color: Color(0xffEDF3FE),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: Color(0xffC1D7FF))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            "Your LV Score has dropped below 2.0. Take a few quizzes and set that right.",
                            style: GoogleFonts.firaSans(
                                color: Colors.black,
                                fontSize: 14),
                          ),
                        ),SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width/3,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                color: Colors.greenAccent.shade100,
                              ),
                              child: Center(
                                child: Text(
                                  "DISMISS",
                                  style: GoogleFonts.firaSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){

                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width/3,
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Colors.blue.shade700,
                                ),
                                child: Center(
                                  child: Text(
                                    "TAKE A QUIZ",
                                    style: GoogleFonts.firaSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
