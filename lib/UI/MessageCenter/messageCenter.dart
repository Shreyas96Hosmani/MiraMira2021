import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:mira_mira/UI/MessageCenter/messageCenterTabs.dart';
import 'package:mira_mira/UI/MessageCenter/tabs/alertsScreen.dart';
import 'package:mira_mira/UI/MessageCenter/tabs/messagesScreen.dart';
import 'package:mira_mira/UI/MessageCenter/tabs/notificationsScreen.dart';
class MessageCenter extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabPressed;

  MessageCenter({this.selectedTab, this.tabPressed});

  @override
  _MessageCenterState createState() => _MessageCenterState();
}

class _MessageCenterState extends State<MessageCenter> {
  PageController _controller;
  int _selectedTab = 0;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //_selectedTab = widget.selectedTab ?? 0;
    return SafeArea(
      //backgroundColor: Colors.grey,
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
              child: MessageCenterTabs(
                selectedTab: _selectedTab,
                tabPressed: (num) {
                  _controller.animateToPage(num,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic);
                  print(_selectedTab);
                },
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (num) {
                  setState(() {
                    _selectedTab = num;
                  });
                },
                children: [AlertsScreen(), NotificationsScreen(), MessagesScreen()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
