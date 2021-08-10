//import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:mira_mira/Helper/constants.dart';
//import 'package:mira_mira/Helper/helper.dart';
//import 'package:mira_mira/Helper/sizeconfig.dart';
//import 'package:mira_mira/UI/QuizScreen/quizPageViewBuilder.dart';
//import 'package:mira_mira/UI/SignUp/LoginSignupScreen.dart';
//import 'package:mira_mira/UI/UserProfileScreen/UserProfileScreen.dart';
//import 'package:mira_mira/UI/home_screen/home_screen.dart';
//import 'package:mira_mira/View%20Models/CustomViewModel.dart';
//import 'package:percent_indicator/circular_percent_indicator.dart';
//import 'package:percent_indicator/linear_percent_indicator.dart';
//import 'package:http/http.dart' as http;
//import 'package:provider/provider.dart';
//import 'dart:convert';
//
//import 'package:shimmer/shimmer.dart';
//
//import 'QuestionsPageViewer.dart';
//
//class QuizListScreen extends StatefulWidget {
//  @override
//  _QuizListScreenState createState() => _QuizListScreenState();
//}
//
//class _QuizListScreenState extends State<QuizListScreen> {
//  bool _isloaded = false;
//
//  Future InitTask() async {
//    Provider.of<CustomViewModel>(context, listen: false)
//        .GetProfileData()
//        .then((value) {
//      Provider.of<CustomViewModel>(context, listen: false)
//          .GetSprints()
//          .then((value) => {
//        setState(() {
//          _isloaded = true;
//        })
//      });
//    });
//  }
//
//  back(){
//    setState(() {
//      removeTakeQuizScreen = false;
//    });
//    print(removeTakeQuizScreen);
//    Future.delayed(Duration(seconds: 2), (){
//      setState(() {
//
//      });
//    });
//  }
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    InitTask();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final providerListener = Provider.of<CustomViewModel>(context);
//
//    return SafeArea(
//        child: Scaffold(
//          backgroundColor: Colors.white,
//          body: _isloaded == false
//              ? Container(
//            child: Column(
//              children: [
//                //Top Profile
//                Container(
//                  height: getProportionateScreenHeight(96),
//                  padding: EdgeInsets.symmetric(
//                      horizontal: getProportionateScreenWidth(20)),
//                  color: Colors.white,
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: [
//                      Shimmer.fromColors(
//                        baseColor: Colors.white,
//                        highlightColor: Colors.grey.shade300,
//                        child: CircleAvatar(
//                          radius: getProportionateScreenWidth(36),
//                          backgroundColor: Color(0xFFDDDDDD),
//                          child: Container(
//                            color: Colors.transparent,
//                            margin: EdgeInsets.all(4),
//                            child: Container(),
//                          ),
//                        ),
//                      ),
//                      SizedBox(
//                        width: getProportionateScreenWidth(16),
//                      ),
//                      Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        children: [
//                          Spacer(),
//                          Shimmer.fromColors(
//                            baseColor: Colors.white,
//                            highlightColor: Colors.grey.shade300,
//                            child: Container(
//                              width: 100,
//                              height: 10,
//                            ),
//                          ),
//                          SizedBox(
//                            height: getProportionateScreenHeight(10),
//                          ),
//                          Shimmer.fromColors(
//                            baseColor: Colors.white,
//                            highlightColor: Colors.grey.shade300,
//                            child: ScoreAndProgressBar(
//                              lvScore: 10.0,
//                              numberOfCompletedSprints: 10,
//                            ),
//                          ),
//                          Spacer(),
//                        ],
//                      )
//                    ],
//                  ),
//                ),
//              ],
//            ),
//          )
//              : WillPopScope(
//            onWillPop: ()=> back(),
//                child: Container(
//            child: Column(
//                children: [
//                  //Top Profile
//                  Container(
//                    height: getProportionateScreenHeight(110),
//                    padding: EdgeInsets.symmetric(
//                        horizontal: getProportionateScreenWidth(20)),
//                    color: Color(COLOR_ACCENT),
//                    child: Row(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      children: [
//                        Container(
//                          decoration: BoxDecoration(
//                              borderRadius: BorderRadius.all(Radius.circular(100)),
//                              boxShadow: [new BoxShadow(
//                                color: Colors.black,
//                                blurRadius: 7.0,
//                              ),]
//                          ),
//                          child: Container(
//                            decoration: BoxDecoration(
//                                borderRadius: BorderRadius.all(Radius.circular(100)),
//                              color: Colors.white,
//                            ),
//                            child: Padding(
//                              padding: const EdgeInsets.all(5.0),
//                              child: CircleAvatar(
//                                radius: getProportionateScreenWidth(30),
//                                backgroundColor: Color(0xffFEC55F),//Color(0xFFDDDDDD),
//                                backgroundImage: photo == "" || photo == null || photo == "null" ? null : Image.memory(base64Decode(photo),).image,
//                                child: Container(
//                                  //color: Color(0xffFEC55F),
//                                  margin: EdgeInsets.all(4),
//                                  child: Container(
//                                    child: photo == "" || photo == null || photo == "null" ? SvgPicture.asset(
//                                      "assets/imageSVG/miramira.svg",
//                                      height: getProportionateScreenHeight(20),
//                                      fit: BoxFit.fitHeight,
//                                    ) : null,
//                                  ),
//                                ),
//                              ),
//                            ),
//                          ),
//                        ),
//                        SizedBox(
//                          width: getProportionateScreenWidth(16),
//                        ),
//                        Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: [
//                            Spacer(),
//                            Text(
//                              "Hello " +
//                                  (providerListener.userDetails.name ??
//                                      ""), //userName.toString(),
//                              style: GoogleFonts.firaSans(
//                                  color: Colors.white,
//                                  letterSpacing: 0.5,
//                                  fontWeight: FontWeight.w600,
//                                  fontSize: 15),
//                            ),
//                            SizedBox(
//                              height: getProportionateScreenHeight(10),
//                            ),
//                            ScoreAndProgressBar(
//                              lvScore: double.parse(providerListener.userDetails.lvScore==""?"0":(providerListener.userDetails.lvScore??"0")),
//                              numberOfCompletedSprints: int.parse(providerListener.userDetails.numberOfCompletedSprints??"0"),
//                            ),
//                            Spacer(),
//                          ],
//                        )
//                      ],
//                    ),
//                  ),
//                  Expanded(
//                    child: Container(
//                      width: double.infinity,
//                      padding: EdgeInsets.symmetric(
//                          horizontal: getProportionateScreenWidth(20),
//                          vertical: getProportionateScreenHeight(15)),
//                      child: SingleChildScrollView(
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: [
//                            Padding(
//                              padding: const EdgeInsets.only(left: 5, right: 5),
//                              child: Text(
//                                "QUIZ",textScaleFactor: 1,
//                                style: GoogleFonts.firaSans(
//                                    color: Color(COLOR_ACCENT),
//                                    fontSize: 16,
//                                    letterSpacing: 1,
//                                    fontWeight: FontWeight.w600),
//                              ),
//                            ),
//                            SizedBox(
//                              height: getProportionateScreenHeight(10),
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.only(left: 5, right: 5),
//                              child: Text(
//                                "Attempt as many sprints and get accurate results and suggestions. As you go try to get a stronger life vector score for better accuracy. Have fun!",
//                                textScaleFactor: 1,
//                                textAlign: TextAlign.left,
//                                style: GoogleFonts.firaSans(
//                                    color: Colors.black,
//                                    height: 1.35,
//                                    fontSize: 14,letterSpacing: 1,
//                                    fontWeight: FontWeight.w400),
//                              ),
//                            ),
//                            SizedBox(
//                              height: getProportionateScreenHeight(20),
//                            ),
//                            providerListener.sprintList.length > 0
//                                ? ListView.builder(
//                                physics: ScrollPhysics(),
//                                shrinkWrap: true,
//                                scrollDirection: Axis.vertical,
//                                itemCount:
//                                providerListener.sprintList.length,
//                                itemBuilder: (context, sprintIndex) {
//                                  return Card(
//                                    elevation: 0,
//                                    shape: new RoundedRectangleBorder(
//                                        side: new BorderSide(
//                                            color: Color(0xFFDAE7FF),
//                                            width: 2.0),
//                                        borderRadius:
//                                        BorderRadius.circular(4.0)),
//                                    child: ExpansionPanelList(
//                                        elevation: 0,
//                                        animationDuration:
//                                        const Duration(seconds: 2),
//                                        expandedHeaderPadding:
//                                        EdgeInsets.all(10),
//                                        dividerColor: Color(0xFFDAE7FF),
//                                        expansionCallback:
//                                            (int item, bool isExpanded) {
//                                          setState(() {
//                                            print(providerListener
//                                                .tempattendingSprintIndex);
//                                            print(sprintIndex);
//                                            if (providerListener
//                                                .tempattendingSprintIndex ==
//                                                -1) {
//                                              if (sprintIndex <=
//                                                  providerListener
//                                                      .attendingSprintIndex) {
//                                                if (providerListener
//                                                    .tempattendingSprintIndex ==
//                                                    sprintIndex) {
//                                                  providerListener
//                                                      .tempattendingSprintIndex = -1;
//                                                } else {
//                                                  providerListener
//                                                      .ListOfQuizList[
//                                                  sprintIndex]
//                                                      .clear();
//                                                  Provider.of<CustomViewModel>(
//                                                      context,
//                                                      listen: false)
//                                                      .GetQuizBySprintsId(
//                                                      providerListener
//                                                          .sprintList[
//                                                      sprintIndex]
//                                                          .id,
//                                                      sprintIndex);
//                                                  providerListener
//                                                      .tempattendingSprintIndex =
//                                                      sprintIndex;
//                                                }
//                                              } else {
//                                                toastCommon(context,
//                                                    "Please complete previous sprints!");
//                                              }
//                                            } else if (sprintIndex <=
//                                                providerListener
//                                                    .attendingSprintIndex) {
//                                              if (providerListener
//                                                  .tempattendingSprintIndex ==
//                                                  sprintIndex) {
//                                                providerListener
//                                                    .tempattendingSprintIndex = -1;
//                                              } else {
//                                                providerListener
//                                                    .ListOfQuizList[
//                                                sprintIndex]
//                                                    .clear();
//                                                Provider.of<CustomViewModel>(
//                                                    context,
//                                                    listen: false)
//                                                    .GetQuizBySprintsId(
//                                                    providerListener
//                                                        .sprintList[
//                                                    sprintIndex]
//                                                        .id,
//                                                    sprintIndex);
//                                                providerListener
//                                                    .tempattendingSprintIndex =
//                                                    sprintIndex;
//                                              }
//                                            } else {
//                                              toastCommon(context,
//                                                  "Please complete previous sprints!");
//                                            }
//                                          });
//                                        },
//                                        children: [
//                                          ExpansionPanel(
//                                              isExpanded: sprintIndex ==
//                                                  providerListener
//                                                      .tempattendingSprintIndex,
//                                              canTapOnHeader: true,
//                                              headerBuilder:
//                                                  (BuildContext context,
//                                                  bool isExpanded) {
//                                                return Container(
//                                                  padding: EdgeInsets.only(
//                                                      left: 12,
//                                                      right: 20,
//                                                      bottom: 10,
//                                                      top: 10),
//                                                  child: Row(
//                                                    mainAxisAlignment:
//                                                    MainAxisAlignment
//                                                        .spaceBetween,
//                                                    children: [
//                                                      Column(
//                                                        mainAxisAlignment:
//                                                        MainAxisAlignment
//                                                            .start,
//                                                        crossAxisAlignment:
//                                                        CrossAxisAlignment
//                                                            .start,
//                                                        children: [
//                                                          SizedBox(
//                                                            height: 10,
//                                                          ),
//                                                          Text(
//                                                            providerListener
//                                                                .sprintList[
//                                                            sprintIndex]
//                                                                .sprintName,
//                                                            style: GoogleFonts
//                                                                .firaSans(
//                                                              fontSize: 18,
//                                                              color: Color(
//                                                                  0xFF383838),
//                                                            ),
//                                                          ),
//                                                          SizedBox(
//                                                            height: 5,
//                                                          ),
//                                                          sprintIndex ==
//                                                              providerListener
//                                                                  .tempattendingSprintIndex
//                                                              ? Align(
//                                                            alignment:
//                                                            Alignment
//                                                                .topLeft,
//                                                            child:
//                                                            Text(
//                                                              "5 QUIZES OF 5 QUESTIONS",
//                                                              style: GoogleFonts
//                                                                  .firaSans(
//                                                                fontSize:
//                                                                14,
//                                                                color:
//                                                                Color(0xFF383838),
//                                                              ),
//                                                            ),
//                                                          )
//                                                              : SizedBox(
//                                                            height: 1,
//                                                          ),
//                                                        ],
//                                                      ),
//                                                    ],
//                                                  ),
//                                                );
//                                              },
//                                              body: Container(
//                                                padding: EdgeInsets.symmetric(
//                                                    horizontal:
//                                                    getProportionateScreenWidth(
//                                                        15)),
//                                                child: Column(
//                                                  children: [
//                                                    SizedBox(
//                                                      height: 20,
//                                                    ),
//                                                    Container(
//                                                      height: 1,
//                                                      color: Color(
//                                                          COLOR_ACCENT),
//                                                    ),
//                                                    SizedBox(
//                                                      height: 20,
//                                                    ),
//                                                    Container(
//                                                        height:
//                                                        getProportionateScreenHeight(
//                                                            240),
//                                                        padding: EdgeInsets
//                                                            .symmetric(
//                                                            vertical:
//                                                            10),
//                                                        child:
//                                                        GridView.count(
//                                                          shrinkWrap: true,
//                                                          crossAxisCount: 3,
//                                                          crossAxisSpacing:
//                                                          2.5,
//                                                          mainAxisSpacing:
//                                                          2.5,
//                                                          physics:
//                                                          NeverScrollableScrollPhysics(),
//                                                          children: List.generate(
//                                                              providerListener
//                                                                  .ListOfQuizList[
//                                                              sprintIndex]
//                                                                  .length,
//                                                                  (quizIndex) {
//                                                                return QuizCircularIndicator(
//                                                                    index:
//                                                                    quizIndex,
//                                                                    sprintIndex:
//                                                                    sprintIndex,
//                                                                    sprintId: providerListener
//                                                                        .sprintList[
//                                                                    sprintIndex]
//                                                                        .sprintId);
//                                                              }),
//                                                        )),
//                                                  ],
//                                                ),
//                                              )),
//                                        ]),
//                                  );
//                                })
//
//                            /*ListView.builder(
//                                      physics: ScrollPhysics(),
//                                      shrinkWrap: true,
//                                      scrollDirection: Axis.vertical,
//                                      itemCount:
//                                          providerListener.sprintList.length,
//                                      itemBuilder: (context, i) => SpritList(
//                                            index: i,
//                                            id: providerListener.sprintList[i].id,
//                                          ))*/
//                                : SizedBox(
//                              height: getProportionateScreenHeight(1),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                  )
//                ],
//            ),
//          ),
//              ),
//        ));
//  }
//}
//
//class SpritList extends StatefulWidget {
//  const SpritList({
//    Key key,
//    this.id,
//    this.index,
//  }) : super(key: key);
//
//  final int index;
//  final String id;
//
//  @override
//  _SpritListState createState() => _SpritListState();
//}
//
//class _SpritListState extends State<SpritList> {
//  PageStorageKey _key;
//
//  @override
//  Widget build(BuildContext context) {
//    _key = new PageStorageKey('${widget.index}');
//    final providerListener = Provider.of<CustomViewModel>(context);
//
//    return Container(
//      constraints: BoxConstraints.tightFor(width: double.infinity),
//      child: Card(
//          elevation: 0,
//          semanticContainer: true,
//          shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.circular(6),
//            side: BorderSide(color: Color(0xFFDAE7FF), width: 1),
//          ),
//          child: (providerListener.sprintList[widget.index].sprintStatus ==
//              "COMPLETED" ||
//              widget.index == providerListener.attendingSprintIndex)
//              ? ExpansionTile(
//            title: Column(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: [
//                SizedBox(
//                  height: 10,
//                ),
//                Text(
//                  providerListener.sprintList[widget.index].sprintName,
//                  style: GoogleFonts.firaSans(
//                    fontSize: 18,
//                    color: Color(0xFF383838),
//                  ),
//                ),
//                SizedBox(
//                  height: 5,
//                ),
//                Align(
//                  alignment: Alignment.topLeft,
//                  child: Text(
//                    "5 QUIZZES OF 5 QUESTIONS",
//                    style: GoogleFonts.firaSans(
//                      fontSize: 14,
//                      color: Color(0xFF383838),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//            initiallyExpanded:
//            widget.index == providerListener.attendingSprintIndex,
//            onExpansionChanged: (val) {
//              print(val);
//              if (val == true) {
//                Provider.of<CustomViewModel>(context, listen: false)
//                    .GetQuizBySprintsId(widget.id, widget.index);
//              }
//            },
//            childrenPadding: EdgeInsets.symmetric(
//                horizontal: getProportionateScreenWidth(15)),
//            children: [
//              Column(
//                children: [
//                  SizedBox(
//                    height: 20,
//                  ),
//                  Container(
//                    height: 1,
//                    color: Color(COLOR_ACCENT),
//                  ),
//                  SizedBox(
//                    height: 20,
//                  ),
//                  Container(
//                      height: getProportionateScreenHeight(300),
//                      padding: EdgeInsets.symmetric(vertical: 10),
//                      child: GridView.count(
//                        shrinkWrap: true,
//                        key: ValueKey(widget.index),
//                        crossAxisCount: 3,
//                        crossAxisSpacing: 2.5,
//                        mainAxisSpacing: 2.5,
//                        physics: NeverScrollableScrollPhysics(),
//                        children: List.generate(
//                            providerListener.ListOfQuizList[widget.index]
//                                .length, (index) {
//                          return QuizCircularIndicator(
//                              index: index,
//                              sprintIndex: widget.index,
//                              sprintId: widget.id);
//                        }),
//                      )),
//                ],
//              )
//            ],
//          )
//              : Container(
//            padding:
//            EdgeInsets.only(left: 12, right: 20, bottom: 10, top: 10),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: [
//                Column(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: [
//                    SizedBox(
//                      height: 10,
//                    ),
//                    Text(
//                      providerListener
//                          .sprintList[widget.index].sprintName,
//                      style: GoogleFonts.firaSans(
//                        fontSize: 18,
//                        color: Color(0xFF383838),
//                      ),
//                    ),
//                    SizedBox(
//                      height: 5,
//                    ),
//                  ],
//                ),
//                Icon(
//                  Icons.arrow_forward_ios_sharp,
//                  size: getProportionateScreenWidth(15),
//                  color: Color(0xFF6C6C6C),
//                ),
//              ],
//            ),
//          )),
//    );
//  }
//}
//
//class QuizCircularIndicator extends StatefulWidget {
//  const QuizCircularIndicator({
//    Key key,
//    this.index,
//    this.sprintIndex,
//    this.sprintId,
//  }) : super(key: key);
//
//  final int index;
//  final int sprintIndex;
//  final String sprintId;
//
//  @override
//  _QuizCircularIndicatorState createState() => _QuizCircularIndicatorState();
//}
//
//class _QuizCircularIndicatorState extends State<QuizCircularIndicator> {
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final providerListener = Provider.of<CustomViewModel>(context);
//
//    return GestureDetector(
//      onTap: () {
//        if (int.parse(providerListener
//            .ListOfQuizList[widget.sprintIndex][widget.index]
//            .totalQuestionCount) <=
//            (int.parse(providerListener
//                .ListOfQuizList[widget.sprintIndex][widget.index]
//                .completedQuestionCount) +
//                int.parse(providerListener
//                    .ListOfQuizList[widget.sprintIndex][widget.index]
//                    .skippedQuestionCount))) {
//          toastCommon(
//              context,
//              "You have completed " +
//                  providerListener
//                      .ListOfQuizList[widget.sprintIndex][widget.index]
//                      .quizName ??
//                  "");
//        } else {
//          print(providerListener
//              .ListOfQuizList[widget.sprintIndex][widget.index].id);
//
//          if (widget.index == 0) {
//            push(
//                context,
//                QuestionsPageViewBuilder(
//                    widget.sprintId,
//                    widget.sprintIndex,
//                    providerListener
//                        .ListOfQuizList[widget.sprintIndex][widget.index].id,
//                    providerListener
//                        .ListOfQuizList[widget.sprintIndex][widget.index]
//                        .quizId,
//                    widget.index,
//                    providerListener
//                        .ListOfQuizList[widget.sprintIndex][widget.index]
//                        .totalQuestionCount,
//                    providerListener
//                        .ListOfQuizList[widget.sprintIndex][widget.index]
//                        .completedQuestionCount));
//          } else if ((int.parse(providerListener
//              .ListOfQuizList[widget.sprintIndex][widget.index - 1]
//              .completedQuestionCount) +
//              int.parse(providerListener
//                  .ListOfQuizList[widget.sprintIndex][widget.index - 1]
//                  .skippedQuestionCount)) ==
//              int.parse(providerListener
//                  .ListOfQuizList[widget.sprintIndex][widget.index - 1]
//                  .totalQuestionCount)) {
//            push(
//                context,
//                QuestionsPageViewBuilder(
//                    widget.sprintId,
//                    widget.sprintIndex,
//                    providerListener
//                        .ListOfQuizList[widget.sprintIndex][widget.index].id,
//                    providerListener
//                        .ListOfQuizList[widget.sprintIndex][widget.index]
//                        .quizId,
//                    widget.index,
//                    providerListener
//                        .ListOfQuizList[widget.sprintIndex][widget.index]
//                        .totalQuestionCount,
//                    providerListener
//                        .ListOfQuizList[widget.sprintIndex][widget.index]
//                        .completedQuestionCount));
//          }else{
//            toastCommon(context,
//                "Please complete previous quiz!");
//          }
//        }
//
//        /*push(context, MyHomePage("test"));*/
//      },
//      child: CircularPercentIndicator(
//        radius: 95,
//        lineWidth: getProportionateScreenWidth(8),
//        percent: ((int.parse(providerListener.ListOfQuizList[widget.sprintIndex][widget.index].completedQuestionCount) +
//            int.parse(providerListener
//                .ListOfQuizList[widget.sprintIndex]
//            [widget.index]
//                .skippedQuestionCount)) /
//            int.parse(providerListener
//                .ListOfQuizList[widget.sprintIndex][widget.index]
//                .totalQuestionCount))
//            .toDouble() >
//            1.0
//            ? 1.0
//            : (int.parse(providerListener
//            .ListOfQuizList[widget.sprintIndex][widget.index]
//            .completedQuestionCount) +
//            int.parse(providerListener
//                .ListOfQuizList[widget.sprintIndex][widget.index]
//                .skippedQuestionCount)) /
//            int.parse(providerListener.ListOfQuizList[widget.sprintIndex][widget.index].totalQuestionCount).toDouble(),
//        backgroundColor: Colors.white,
//        center: CircleAvatar(
//          radius: 40,
//          backgroundColor: Color(0xFFEDF3FE),
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: [
//              Text(
//                providerListener
//                    .ListOfQuizList[widget.sprintIndex][widget.index].quizName,
//                style: GoogleFonts.firaSans(
//                    color: Color(0xFF3F4462),
//                    fontWeight: FontWeight.w500,
//                    fontSize: 16),
//              ),
//              SizedBox(
//                height: getProportionateScreenHeight(3),
//              ),
//              int.parse(providerListener
//                  .ListOfQuizList[widget.sprintIndex][widget.index]
//                  .totalQuestionCount) <=
//                  (int.parse(providerListener
//                      .ListOfQuizList[widget.sprintIndex][widget.index]
//                      .completedQuestionCount))
//                  ? SizedBox(
//                height: 0,
//              )
//                  : Text(
//                providerListener
//                    .ListOfQuizList[widget.sprintIndex][widget.index]
//                    .completedQuestionCount
//                    .toString() +
//                    "/" +
//                    providerListener
//                        .ListOfQuizList[widget.sprintIndex][widget.index]
//                        .totalQuestionCount,
//                style: GoogleFonts.firaSans(
//                    color: Color(COLOR_ACCENT),
//                    fontWeight: FontWeight.w400,
//                    fontSize: 16),
//              ),
//              SizedBox(
//                height: getProportionateScreenHeight(3),
//              ),
//              int.parse(providerListener
//                  .ListOfQuizList[widget.sprintIndex][widget.index]
//                  .totalQuestionCount) <=
//                  (int.parse(providerListener
//                      .ListOfQuizList[widget.sprintIndex][widget.index]
//                      .completedQuestionCount))
//                  ? Padding(
//                padding: const EdgeInsets.only(top: 5),
//                child: Icon(
//                  Icons.check,
//                  color: Colors.green,
//                  size: 15,
//                ),
//              )
//                  : SizedBox(
//                height: 0,
//              )
//            ],
//          ),
//        ),
//        progressColor: int.parse(providerListener
//            .ListOfQuizList[widget.sprintIndex][widget.index]
//            .totalQuestionCount) <=
//            (int.parse(providerListener
//                .ListOfQuizList[widget.sprintIndex][widget.index]
//                .completedQuestionCount))
//            ? Colors.grey[300]
//            : Color(0xFFC0D6FF),
//      ),
//    );
//  }
//}
//
//class ScoreAndProgressBar extends StatelessWidget {
//  ScoreAndProgressBar({
//    Key key,
//    this.lvScore,
//    this.numberOfCompletedSprints,
//  }) : super(key: key);
//  final double lvScore;
//  final int numberOfCompletedSprints;
//
//  @override
//  Widget build(BuildContext context) {
//    double _progPercent = lvScore / 10;
//    double _progPercentText = (lvScore);
//    return Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: [
//        Text(
//          "$_progPercentText/10 LV Score | $completedSprints Sprints",
//          style: GoogleFonts.firaSans(
//              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 10),
//        ),
//        SizedBox(
//          height: getProportionateScreenHeight(14),
//        ),
//        LinearPercentIndicator(
//            backgroundColor: Colors.grey[200],
//            progressColor: Color(0xFFFEC55F),
//            padding: EdgeInsets.zero,
//            animation: true,
//            width: getProportionateScreenWidth(144),
//            lineHeight: getProportionateScreenHeight(4),
//            percent: _progPercent),
//      ],
//    );
//  }
//}
