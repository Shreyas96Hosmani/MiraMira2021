import 'dart:convert';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mira_mira/Helper/constants.dart';
import 'package:mira_mira/Helper/helper.dart';
import 'package:mira_mira/Helper/sizeconfig.dart';
import 'package:mira_mira/Models/AnswerOptions.dart';
import 'package:mira_mira/Models/QuestionsListParser.dart';
import 'package:mira_mira/UI/QuizScreen/QuizListScreen.dart';
import 'package:mira_mira/UI/SignUp/LoginSignupScreen.dart';
import 'package:flutter/cupertino.dart' hide ReorderableList;
import 'package:flutter/material.dart' hide ReorderableList;
import 'package:mira_mira/UI/Tabs/Results/ResultsListScreen.dart';
import 'package:mira_mira/UI/Widgets/re_orderable_list.dart';
import 'package:mira_mira/UI/home_screen/home_screen.dart';
import 'package:mira_mira/View%20Models/CustomViewModel.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

int numberOfMoves = 0;
var pageIndexIvsF;
bool isQuestionsLoaded = false;
final controller = PageController(viewportFraction: 1);

bool showToolTip = true;

class QuestionsPageViewBuilder extends StatefulWidget {
  final sprintId;
  final sprintIndex;
  final id;
  final quizId;
  final quizIndex;
  final totalQuestion;
  final completedQuestion;

  QuestionsPageViewBuilder(this.sprintId, this.sprintIndex, this.id,
      this.quizId, this.quizIndex, this.totalQuestion, this.completedQuestion)
      : super();

  @override
  _QuestionsPageViewBuilderState createState() =>
      _QuestionsPageViewBuilderState();
}

class _QuestionsPageViewBuilderState extends State<QuestionsPageViewBuilder> {
  Future InitTask() async {
    Provider.of<CustomViewModel>(context, listen: false)
        .GetQuestionsByQuizId(widget.id)
        .then((value) => {
      setState(() {
        isQuestionsLoaded = true;
      })
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      showToolTip = true;
      viewResultsPressed = false;
    });
    print("viewResultsPressed : "+viewResultsPressed.toString());
    pageIndexIvsF = 0;
    numberOfMoves = 0;
    isQuestionsLoaded = false;

    InitTask();
  }

  @override
  Widget build(BuildContext context) {

    prLogin = ProgressDialog(context);
    final providerListener = Provider.of<CustomViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: isQuestionsLoaded == false
          ? Center(
        child: new CircularProgressIndicator(
          strokeWidth: 1,
          backgroundColor: Color(COLOR_WHITE),
          valueColor: AlwaysStoppedAnimation<Color>(Color(COLOR_PRIMARY)),
        ),
      )
          : PageView.builder(
        physics: new NeverScrollableScrollPhysics(),
        itemCount: providerListener.questionsList.length + 1,
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            pageIndexIvsF = index;
            numberOfMoves = 0;
            if (pageIndexIvsF == providerListener.questionsList.length) {
              Provider.of<CustomViewModel>(context, listen: false)
                  .updateQuiz(widget.quizId);
            }
            if (pageIndexIvsF == providerListener.questionsList.length &&
                widget.quizIndex ==
                    providerListener
                        .ListOfQuizList[widget.sprintIndex].length-1) {
              Provider.of<CustomViewModel>(context, listen: false)
                  .updateSprint(providerListener
                  .sprintList[widget.sprintIndex].sprintId);
            }
          });
        },
        itemBuilder: (BuildContext context, int index) {
          /* return MyHomePage("asf");*/
          return QuizDetailsScreen(
              widget.sprintId,
              widget.sprintIndex,
              widget.id,
              widget.quizId,
              widget.quizIndex,
              pageIndexIvsF,
              index == providerListener.questionsList.length
                  ? []
                  : providerListener
                  .questionsList[index].questionOptions);
        },
      ),
    );
  }
}

enum DraggingMode {
  iOS,
  Android,
}

class QuizDetailsScreen extends StatefulWidget {
  final sprintId;
  final sprintIndex;
  final id;
  final quizId;
  final quizIndex;
  final pageIndexIvsF;
  List<QuestionOptions> questionOptions;

  QuizDetailsScreen(this.sprintId, this.sprintIndex, this.id, this.quizId,
      this.quizIndex, this.pageIndexIvsF, this.questionOptions)
      : super();

  @override
  _QuizDetailsScreenState createState() => _QuizDetailsScreenState();
}

class _QuizDetailsScreenState extends State<QuizDetailsScreen> {
  List<AnswerOptions> _items;

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return _items.indexWhere((AnswerOptions d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    // Uncomment to allow only even target reorder possition
    // if (newPositionIndex % 2 == 1)
    //   return false;

    final draggedItem = _items[draggingIndex];
    setState(() {
      debugPrint("Reordering1 $item -> $newPosition");
      _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);

    });
    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = _items[_indexOfKey(item)];
    debugPrint("Reordering finished for ${draggedItem.optionVal}}");
    numberOfMoves+=1;
    print("numberOfMoves"+numberOfMoves.toString());
  }

  //
  // Reordering works by having ReorderableList widget in hierarchy
  // containing ReorderableItems widgets
  //

  DraggingMode _draggingMode = DraggingMode.iOS;
  GlobalKey _toolTipKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _items = [];

    setState(() {
      viewResultsPressed = false;
    });
    for (int i = 0; i < widget.questionOptions.length; ++i) {
      String label = widget.questionOptions[i].optionVal.toString();
      print("******2");
      print(label);
      _items.add(AnswerOptions(
          widget.questionOptions[i].optionId,
          widget.questionOptions[i].optionVal,
          widget.questionOptions[i].optionGrade,
          ValueKey(i)));
    }

  }

  @override
  Widget build(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    print("pageIndexIvsF" + pageIndexIvsF.toString());
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: getProportionateScreenHeight(96),
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              color: Color(COLOR_ACCENT),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
              child: Container(
                height: SizeConfig.screenHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFDAE7FF)),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      height: MediaQuery.of(context).size.height / 1.08,
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20)),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                             Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  (providerListener.sprintList[widget.sprintIndex]
                                              .sprintName ??
                                          "") +
                                      " | " +
                                      (providerListener
                                              .ListOfQuizList[widget.sprintIndex]
                                                  [widget.quizIndex]
                                              .quizName ??
                                          ""),
                                  style: GoogleFonts.firaSans(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18),
                                ),
                                showToolTip == true  && providerListener
                                    .ListOfQuizList[widget.sprintIndex]
                                [widget.quizIndex]
                                    .quizName == "Quiz 1" && pageIndexIvsF.toString() == "0" ? Container() : GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 30,
                                      color: Color(0xff6C6C6C),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                StepProgressIndicator(
                                  totalSteps: providerListener.questionsList.length,
                                  currentStep: pageIndexIvsF + 1,
                                  selectedColor: Color(0xff1E73BE),
                                  unselectedColor: Color(0xffDEDEDE),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Divider(
                              color: Color(COLOR_ACCENT),
                              thickness: 2,
                              height: 1,
                            ),
                            pageIndexIvsF == providerListener.questionsList.length
                                ? Container()
                                : SizedBox(
                                    height: 15,
                                  ),
                            pageIndexIvsF != providerListener.questionsList.length
                                ?  Text(
                              "Hold and move options to reorder them from A to D - most likely to least likely",
                              textScaleFactor: 1,
                              style: GoogleFonts.firaSans(
                                  color: Color(0xff616161), fontSize: 12),
                            ): SizedBox(
                              height: 1,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            pageIndexIvsF == providerListener.questionsList.length
                                ? Container()
                                : Text(
                                    providerListener
                                        .questionsList[pageIndexIvsF].questionText,
                              textScaleFactor: 1,
                                    //questionText[pageIndexIvsF],
                                    style: GoogleFonts.firaSans(
                                        color: Colors.blue[700],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            pageIndexIvsF == providerListener.questionsList.length
                                ? widget.quizIndex ==
                                providerListener
                                    .ListOfQuizList[widget.sprintIndex]
                                    .length -
                                    1
                                ? buildSprintCompleteWidget(context)
                                : buildQuizCompleteWidget(context)
                                : buildOptionsListViewBuilder(
                                context, pageIndexIvsF),
//                            Padding(
//                                  padding: EdgeInsets.only(top: getProportionateScreenHeight(50)),
//                                  child: Align(
//                              alignment: Alignment.center,
//                              child: buildOptionsListViewBuilder(
//                                  context, pageIndexIvsF),),
//                                ),
                            pageIndexIvsF == providerListener.questionsList.length
                                ? Container()
                                : Padding(
                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      prLogin.show();
                                      Provider.of<CustomViewModel>(context,
                                          listen: false)
                                          .updateQuestion(
                                          widget.quizId,
                                          providerListener
                                              .questionsList[
                                          pageIndexIvsF]
                                              .questionId,
                                          "SKIPPED",
                                          pageIndexIvsF == 0 &&
                                              providerListener
                                                  .questionsList
                                                  .length ==
                                                  int.parse(providerListener
                                                      .ListOfQuizList[
                                                  widget
                                                      .sprintIndex]
                                                  [widget
                                                      .quizIndex]
                                                      .totalQuestionCount)
                                              ? true
                                              : false,
                                          _items,
                                          numberOfMoves)
                                          .then((value) {
                                        setState(() {
                                          prLogin.hide();
                                          if (value == "error") {
                                            toastCommon(context,
                                                "Check internet or try after sometime");
                                          } else if (value == "success") {

                                            providerListener.ListOfQuizList[widget.sprintIndex][widget.quizIndex].skippedQuestionCount=(int.parse(providerListener.ListOfQuizList[widget.sprintIndex][widget.quizIndex].skippedQuestionCount)+1).toString();

                                            controller.nextPage(
                                                duration:
                                                Duration(seconds: 1),
                                                curve: Curves.easeIn);
                                          } else {
                                            toastCommon(context,
                                                "Check internet or try after sometime");
                                          }
                                        });
                                      });
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        color: Color(0xff69CDCD),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "SKIP",textScaleFactor: 1,
                                          style: GoogleFonts.firaSans(
                                              color: Colors.white,
                                              letterSpacing: 1,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      prLogin.show();
                                      Provider.of<CustomViewModel>(context,
                                          listen: false)
                                          .updateQuestion(
                                          widget.quizId,
                                          providerListener
                                              .questionsList[
                                          pageIndexIvsF]
                                              .questionId,
                                          "COMPLETED",
                                          pageIndexIvsF == 0 &&
                                              providerListener
                                                  .questionsList
                                                  .length ==
                                                  int.parse(providerListener
                                                      .ListOfQuizList[
                                                  widget
                                                      .sprintIndex]
                                                  [widget
                                                      .quizIndex]
                                                      .totalQuestionCount)
                                              ? true
                                              : false,
                                          _items,
                                          numberOfMoves)
                                          .then((value) {
                                        setState(() {
                                          prLogin.hide();
                                          if (value == "error") {
                                            toastCommon(context,
                                                "Check internet or try after sometime");
                                          } else if (value == "success") {
                                            providerListener.quizStatus =
                                            "COMPLETED";
                                            providerListener.ListOfQuizList[widget.sprintIndex][widget.quizIndex].completedQuestionCount=(int.parse(providerListener.ListOfQuizList[widget.sprintIndex][widget.quizIndex].completedQuestionCount)+1).toString();
                                            controller.nextPage(
                                                duration:
                                                Duration(seconds: 1),
                                                curve: Curves.easeIn);
                                          } else {
                                            toastCommon(context,
                                                "Check internet or try after sometime");
                                          }
                                        });
                                      });
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        color: Colors.blue.shade700,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "DONE",textScaleFactor: 1,
                                          style: GoogleFonts.firaSans(
                                              color: Colors.white,
                                              letterSpacing: 1,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            showToolTip == true && providerListener
                .ListOfQuizList[widget.sprintIndex]
            [widget.quizIndex]
                .quizName == "Quiz 1" && pageIndexIvsF.toString() == "0" ?
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(0.6),
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            onTap: () async {
                              setState(() {
                                showToolTip = false;
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 30,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/8.5,),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Text("Hold and move options to reorder them from A to D - most likely to least likely.",
                        textScaleFactor: 1,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.firaSans(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    InkWell(
                      onTap: (){
                        setState(() {
                          showToolTip = false;
                        });
                      },
                      child: Container(
                        height: 35,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.white)
                        ),
                        child: Center(
                          child: Text("GOT IT!",textScaleFactor: 1,
                            style: GoogleFonts.firaSans(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          )
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset("assets/images/path1.png"),
                            Image.asset("assets/images/circlehelp.png"),
                          ],
                        )),
                    SizedBox(height: 0,),
                    Padding(
                      padding: EdgeInsets.only(left: getProportionateScreenWidth(30)),
                      child: Text("Hold here and move to\nreorder the options",
                        textScaleFactor: 1,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.firaSans(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(left: getProportionateScreenWidth(90)),
                      child: Text("Skip question if you don’t\nwant to answer",
                        textScaleFactor: 1,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.firaSans(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 0,),
                    Padding(
                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width/3.2),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 80),
                                child: Image.asset("assets/images/path2.png"),
                              ),
                              Image.asset("assets/images/circlehelp.png"),
                            ],
                          )),
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ) : Container(),
//            Padding(
//              padding: EdgeInsets.only(right: getProportionateScreenWidth(50),
//                top: MediaQuery.of(context).size.height/4.2,
//              ),
//              child: Align(
//                alignment: Alignment.topRight,
//                child: Container(
//                  height: 70,
//                  width: 120,
//                  decoration: BoxDecoration(
//                      color: Colors.grey[300]
//                  ),
//                ),
//              ),
//            )
          ],
        ),
      ),
    );
  }

  buildOptionsListViewBuilder(BuildContext context, int index) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/35),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(left: getProportionateScreenWidth(46), top: 5),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        border: Border.all(color: Color(0xff1E73BE))),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "MOST LIKELY",textScaleFactor: 1,
                  style: GoogleFonts.firaSans(
                      color: Colors.black, letterSpacing: 2, fontSize: 14),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Container(
              height: MediaQuery.of(context).size.height / 2.5,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 35),
                    child: ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: providerListener
                          .questionsList[index].questionOptions.length,
                      itemBuilder: (context, i) => Container(
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide.none,
                                bottom: Divider.createBorderSide(context)),
                            color: Colors.white),
                        child: SafeArea(
                            top: false,
                            bottom: false,
                            child: Opacity(
                              // hide content for placeholder
                              opacity: 1.0,
                              child: IntrinsicHeight(
                                child: StreamBuilder<Object>(
                                    stream: null,
                                    builder: (context, snapshot) {
                                      return Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 75,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width /
                                                1.4,
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 20),
                                                  child: Container(
                                                    height: 70,
                                                    width: 1,
                                                    color: Color(0xff1E73BE),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 15),
                                                  child: Container(
                                                    //height: 100,
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                        1.4,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffD5D5D5),
                                                      border: Border.all(
                                                          color:
                                                          Color(0xffA3A3A3)),
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10)),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left: 15,
                                                              right: 20),
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                context)
                                                                .size
                                                                .width /
                                                                2.1,
                                                            decoration:
                                                            BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .all(Radius
                                                                  .circular(
                                                                  10)),
                                                            ),
                                                            child: Text(
                                                              "a",textScaleFactor: 1,
                                                              maxLines: 2,
                                                              style: GoogleFonts.firaSans(
                                                                  color: Colors
                                                                      .transparent,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                          EdgeInsets.only(
                                                              right: 18.0,
                                                              left: 18.0),
                                                          decoration:
                                                          BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.all(
                                                                Radius
                                                                    .circular(
                                                                    10)),
                                                            //color: Color(0xffEDF3FE),
                                                          ),
                                                          child: Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Container(
                                                                  width: 17,
                                                                  height: 2,
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Container(
                                                                  width: 17,
                                                                  height: 2,
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Container(
                                                                  width: 17,
                                                                  height: 2,
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Container(
                                                                  width: 17,
                                                                  height: 2,
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                              ),
                            )),
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      ReorderableList(
                        onReorder: this._reorderCallback,
                        onReorderDone: this._reorderDone,
                        child: CustomScrollView(
                          // cacheExtent: 3000,
                          slivers: <Widget>[
                            SliverPadding(
                                padding: EdgeInsets.only(bottom: 10),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      return Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            index == 0
                                                ? "A"
                                                : index == 1
                                                ? "B"
                                                : index == 2
                                                ? "C"
                                                : index == 3
                                                ? "D"
                                                : "E",textScaleFactor: 1,
                                            style: GoogleFonts.firaSans(
                                                color: Colors.blue[700],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          Item(
                                            data: _items[index],
                                            // first and last attributes affect border drawn during dragging
                                            isFirst: index == 0,
                                            isLast: index == _items.length - 1,
                                            draggingMode: _draggingMode,
                                          ),
                                        ],
                                      );
                                    },
                                    childCount: _items.length,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 51, top: double.parse(_items.length.toString())*81 ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 20,
                        width: 1,
                        decoration: BoxDecoration(color: Color(0xff1E73BE)),
                      ),
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(100)),
                            border: Border.all(color: Color(0xff1E73BE))),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    "LEAST LIKELY",textScaleFactor: 1,
                    style: GoogleFonts.firaSans(
                        color: Colors.black, letterSpacing: 2, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildQuizCompleteWidget(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "Fantastic! You finished a Quiz!",
            textScaleFactor: 1,
            style: GoogleFonts.firaSans(
                color: Color(COLOR_ACCENT),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: getProportionateScreenHeight(23),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(40)),
            child: Text(
              "Your results get more accurate and suggestions more pointed with every Quiz and Sprint",
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: GoogleFonts.firaSans(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(15),
          ),
          SvgPicture.asset(
            "assets/imageSVG/FantasticSvg.svg",
            height: getProportionateScreenHeight(337.68),
          ),
          SizedBox(
            height: getProportionateScreenHeight(20),
          ),
          Text(
            "Tap on Continue to close and finish this Sprint. Let's Go!",
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: GoogleFonts.firaSans(
                color: Color(0xFF3F4462),
                fontSize: 17,
                fontWeight: FontWeight.normal),
          ),
          SizedBox(
            height: 10,
          ),
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(
                width: getProportionateScreenWidth(173),
                height: getProportionateScreenHeight(41)),
            child: ElevatedButton(
                onPressed: () {
                  pushReplacement(
                    context,
                    QuestionsPageViewBuilder(
                        widget.sprintId,
                        widget.sprintIndex,
                        providerListener
                            .ListOfQuizList[widget.sprintIndex]
                        [widget.quizIndex + 1]
                            .id,
                        providerListener
                            .ListOfQuizList[widget.sprintIndex]
                        [widget.quizIndex + 1]
                            .quizId,
                        widget.quizIndex + 1,
                        providerListener
                            .ListOfQuizList[widget.sprintIndex]
                        [widget.quizIndex + 1]
                            .totalQuestionCount,
                        providerListener
                            .ListOfQuizList[widget.sprintIndex]
                        [widget.quizIndex + 1]
                            .completedQuestionCount),
                  );
                },
                style: ElevatedButton.styleFrom(
                    primary: Color(COLOR_ACCENT),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    textStyle: GoogleFonts.firaSans(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500)),
                child: Text("CONTINUE")),
          ),
        ],
      ),
    );
  }

  buildSprintCompleteWidget(BuildContext context) {
    final providerListener = Provider.of<CustomViewModel>(context);

    return Center(
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "Yahoo! That was a good Sprint.",
                textScaleFactor: 1,
                style: GoogleFonts.firaSans(
                    color: Color(COLOR_ACCENT),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 23,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(40)),
                child: Text(
                  widget.sprintIndex==providerListener.sprintList.length-1?"You have finished all the available sprints":"Now you can view the results. However more Sprints can better the accuracy and suggestions.",
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.firaSans(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SvgPicture.asset(
                "assets/imageSVG/goodSprint.svg",
                height: getProportionateScreenHeight(300),
              ),
              SizedBox(
                height: 0,
              ),
              Text(
                widget.sprintIndex==providerListener.sprintList.length-1?"":"Tap on continue to do another easy Sprint or view results for the completed ones.",
                textAlign: TextAlign.center,
                textScaleFactor: 1,
                style: GoogleFonts.firaSans(
                    color: Color(0xFF3F4462),
                    fontSize: getProportionateScreenHeight(17),
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: getProportionateScreenHeight(30),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: getProportionateScreenWidth(123),
                        height: getProportionateScreenHeight(41)),
                    child: ElevatedButton(
                        onPressed: () {
                          if(widget.sprintIndex<providerListener.sprintList.length-1){
                            prLogin.show();
                            Provider.of<CustomViewModel>(
                                context,
                                listen: false)
                                .GetQuizBySprintsId(
                                providerListener
                                    .sprintList[widget.sprintIndex+1].id,
                                widget.sprintIndex+1).then((value) {

                              providerListener
                                  .sprintList[widget.sprintIndex].sprintStatus = "COMPLETED";
                              providerListener
                                  .tempattendingSprintIndex =
                                  widget.sprintIndex+1;
                              providerListener
                                  .attendingSprintIndex =
                                  widget.sprintIndex+1;
                              prLogin.hide();
                              setState(() {
                                viewResultsPressed = true;
                              });
                              pop(context);
//                      pushReplacement(
//                        context,
//                        QuestionsPageViewBuilder(
//                            providerListener
//                                .sprintList[widget.sprintIndex].sprintId,
//                            widget.sprintIndex + 1,
//                            providerListener
//                                .ListOfQuizList[widget.sprintIndex + 1][0].id,
//                            providerListener
//                                .ListOfQuizList[widget.sprintIndex + 1][0].quizId,
//                            0,
//                            providerListener
//                                .ListOfQuizList[widget.sprintIndex + 1][0]
//                                .totalQuestionCount,
//                            providerListener
//                                .ListOfQuizList[widget.sprintIndex + 1][0]
//                                .completedQuestionCount),
//                      );

                            });


                          }else{
                            setState(() {
                              viewResultsPressed = true;
                            });
                            pop(context);
                          }

                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(COLOR_ACCENT),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            textStyle: GoogleFonts.firaSans(
                                fontSize: 14,
                                color: Colors.white,letterSpacing: 1,
                                fontWeight: FontWeight.w500)),
                        child: Text("VIEW RESULTS")),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: getProportionateScreenWidth(123),
                        height: getProportionateScreenHeight(41)),
                    child: ElevatedButton(
                        onPressed: () {
                          if(widget.sprintIndex<providerListener.sprintList.length-1){
                            prLogin.show();
                            Provider.of<CustomViewModel>(
                                context,
                                listen: false)
                                .GetQuizBySprintsId(
                                providerListener
                                    .sprintList[widget.sprintIndex+1].id,
                                widget.sprintIndex+1).then((value) {

                              providerListener
                                  .sprintList[widget.sprintIndex].sprintStatus = "COMPLETED";
                              providerListener
                                  .tempattendingSprintIndex =
                                  widget.sprintIndex+1;
                              providerListener
                                  .attendingSprintIndex =
                                  widget.sprintIndex+1;
                              prLogin.hide();
                              //pushReplacement(context, ResultListScreen());
                      pushReplacement(
                        context,
                        QuestionsPageViewBuilder(
                            providerListener
                                .sprintList[widget.sprintIndex].sprintId,
                            widget.sprintIndex + 1,
                            providerListener
                                .ListOfQuizList[widget.sprintIndex + 1][0].id,
                            providerListener
                                .ListOfQuizList[widget.sprintIndex + 1][0].quizId,
                            0,
                            providerListener
                                .ListOfQuizList[widget.sprintIndex + 1][0]
                                .totalQuestionCount,
                            providerListener
                                .ListOfQuizList[widget.sprintIndex + 1][0]
                                .completedQuestionCount),
                      );

                            });


                          }else{
                            pushReplacement(context, ResultListScreen());
                          }

                        },
                        style: ElevatedButton.styleFrom(
                            primary: Color(COLOR_ACCENT),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            textStyle: GoogleFonts.firaSans(
                                fontSize: 14,
                                color: Colors.white,letterSpacing: 1,
                                fontWeight: FontWeight.w500)),
                        child: Text(widget.sprintIndex==providerListener.sprintList.length-1?"Go Back":"CONTINUE")),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  Item({
    this.data,
    this.isFirst,
    this.isLast,
    this.draggingMode,
  });

  final AnswerOptions data;
  final bool isFirst;
  final bool isLast;
  final DraggingMode draggingMode;

  Widget _buildChild(BuildContext context, ReorderableItemState state) {
    BoxDecoration decoration;

    if (state == ReorderableItemState.dragProxy ||
        state == ReorderableItemState.dragProxyFinished) {
      // slightly transparent background white dragging (just like on iOS)
      //decoration = BoxDecoration(color: Color(0xffD5D5D5));
    } else {
      bool placeholder = state == ReorderableItemState.placeholder;
      decoration = BoxDecoration(
          border: Border(
              top: isFirst && !placeholder
                  ? Divider.createBorderSide(context) //
                  : BorderSide.none,
              bottom: isLast && placeholder
                  ? BorderSide.none //
                  : Divider.createBorderSide(context)),
          color: placeholder ? null : Colors.white);
    }

    // For iOS dragging mode, there will be drag handle on the right that triggers
    // reordering; For android mode it will be just an empty container
    Widget dragHandle = draggingMode == DraggingMode.iOS
        ? ReorderableListener(
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 75,
            width: MediaQuery.of(context).size.width / 1.4,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    height: 70,
                    width: 1,
                    color: Color(0xff1E73BE),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    //height: 100,
                    width:
                    MediaQuery.of(context).size.width / 1.4,
                    decoration: BoxDecoration(
                      color: Color(0xffEDF3FE),
                      border:
                      Border.all(color: Color(0xffC1D7FF)),
                      borderRadius:
                      BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 20),
                          child: Container(
                            width: MediaQuery.of(context)
                                .size
                                .width /
                                2.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10)),
                            ),
                            child: Text(
                              data.optionVal,textScaleFactor: 1,
                              //maxLines: 2,
                              style: GoogleFonts.firaSans(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 18.0, left: 18.0),
                          color: Color(0x08000000),
                          child: Center(
                            child: Icon(Icons.reorder, color: Color(0xFF888888)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        : Container();

    Widget content = Container(
      decoration: decoration,
      child: SafeArea(
          top: false,
          bottom: false,
          child: Opacity(
            // hide content for placeholder
            opacity: state == ReorderableItemState.placeholder ? 0.0 : 1.0,
            child: IntrinsicHeight(
              child: StreamBuilder<Object>(
                  stream: null,
                  builder: (context, snapshot) {
                    return Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 75,
                              width: MediaQuery.of(context).size.width / 1.4,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Container(
                                      height: 70,
                                      width: 1,
                                      color: Color(0xff1E73BE),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                      //height: 100,
                                      width:
                                      MediaQuery.of(context).size.width / 1.4,
                                      decoration: BoxDecoration(
                                        color: Color(0xffEDF3FE),
                                        border:
                                        Border.all(color: Color(0xffC1D7FF)),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 20),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  2.1,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              child: Text(
                                                data.optionVal,textScaleFactor: 1,
                                                //maxLines: 2,
                                                style: GoogleFonts.firaSans(
                                                    color: Colors.grey[700],
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(right: 18.0, left: 18.0),
                                            color: Color(0x08000000),
                                            child: Center(
                                              child: Icon(Icons.reorder, color: Color(0xFF888888)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        dragHandle,
                      ],
                    );
                  }),
            ),
          )),
    );

    // For android dragging mode, wrap the entire content in DelayedReorderableListener
    if (draggingMode == DraggingMode.Android) {
      content = DelayedReorderableListener(
        child: content,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableItem(
        key: data.key, //
        childBuilder: _buildChild);
  }
}
