import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
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
                padding: const EdgeInsets.only(top: 0),
                child: Column(
                  children: [
                    Divider(color: Color(0xffDAE7FF),thickness: 1,),
                    Container(
//                  decoration: BoxDecoration(
//                      color: Color(0xffEDF3FE),
//                      borderRadius: BorderRadius.all(Radius.circular(10)),
//                      border: Border.all(color: Color(0xffC1D7FF))
//                  ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 10,),
                            Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffEDF3FE),
                                    borderRadius: BorderRadius.all(Radius.circular(100)),
                                    border: Border.all(color: Color(0xffC1D7FF))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                                  child: Icon(Icons.person_add_outlined, color: Color(0xff1E73BE),size: 20,),
                                )),
                            SizedBox(width: 20,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sameer Ranjan",
                                  style: GoogleFonts.firaSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),SizedBox(height: 5,),
                                Text(
                                  "Guardians",
                                  style: GoogleFonts.firaSans(
                                      color: Colors.grey,
                                      //fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                                SizedBox(height: 20,),
                                Text(
                                  "Lorem ipsum is placeholder…",
                                  style: GoogleFonts.firaSans(
                                      color: Colors.grey,
                                      //fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: Color(0xffDAE7FF),thickness: 1,),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
