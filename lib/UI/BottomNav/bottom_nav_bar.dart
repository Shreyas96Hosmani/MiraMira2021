import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mira_mira/UI/Tabs/Results/ResultsListScreen.dart';
import 'package:mira_mira/UI/Tabs/firstHomeScreen.dart';

class BottomNavPage extends StatefulWidget {
  @override
  _BottomNavPageState createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {

  int selectedIndex;
  int counter;
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> pages = <Widget>[
    //FirstHomeScreen(true),
    ResultListScreen(),
    Center(child: Text("Tab 3"),),
    Center(child: Text("Tab 4"),),
    Center(child: Text("Tab 5"),),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    counter = 1;
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
//        IndexedStack(
//          index: bottomnav.selectedIndex,
//          children: pages,
//        ),
      Center(
        child: pages.elementAt(selectedIndex),
      ),
      bottomNavigationBar: buildEnglishBottomNavigationBar(context),
    );
  }

  Widget buildEnglishBottomNavigationBar(BuildContext context){
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Color(0xff202020),
      selectedItemColor: Colors.blue[700],
      onTap: _onItemTapped,
      items:  <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon:
//          selectedIndex == 0 ? Container(width:30,height:30,
//              decoration: BoxDecoration(
//                borderRadius: BorderRadius.all(Radius.circular(100)),
//                color: Colors.blue[700],
//              ),
//              child: Image.asset("assets/images/brain.png")) :
          Container(width:30,height:30,child: Image.asset("assets/images/brain.png")),
          title:Text("Quiz",
            style: GoogleFonts.firaSans(),
          ),
        ),
        BottomNavigationBarItem(
          icon: Container(width:30,height:30,child: Image.asset("assets/images/results.png")),
          // ignore: deprecated_member_use
          title: Text("Results",style: GoogleFonts.firaSans(),),
          //label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Container(width:30,height:30,child: Image.asset("assets/images/graduation-hat.png")),
          title: Text("Courses",style: GoogleFonts.firaSans(),),
          //label: 'Shopping Cart',
        ),
        BottomNavigationBarItem(
          icon: Container(width:30,height:30,child: Image.asset("assets/images/wishlist.png")),
          // ignore: deprecated_member_use
          title: Text("Wishlist",style: GoogleFonts.firaSans(),),
          //label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Container(width:30,height:30,child: Image.asset("assets/images/menu.png")),
          // ignore: deprecated_member_use
          title: Text("More",style: GoogleFonts.firaSans(),),
          //label: 'Profile',
        ),
      ],
    );
  }

}


