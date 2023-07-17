// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_timer_app/utils/app_color.dart';
import 'package:multi_timer_app/utils/constants_style.dart';
import 'package:multi_timer_app/utils/constants_variable.dart';

import '../model/timer_model.dart';
import '../widgets/dot_widget.dart';
import '../widgets/text_form_field_custom.dart';

class TimersScreen extends StatefulWidget {
  const TimersScreen({super.key});

  @override
  State<TimersScreen> createState() => _TimersScreenState();
}

class _TimersScreenState extends State<TimersScreen> {
  final hourController = TextEditingController();
  final minuteController = TextEditingController();
  final secondController = TextEditingController();
  final hourFocusNode = FocusNode();
  final minuteFocusNode = FocusNode();
  final secondFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  List<TimerModel> timerValueList = [];

  Timer? currentTimer;

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: AppColor.whiteColor,
          appBar: AppBar(
            backgroundColor: AppColor.lightGreyColor,
            centerTitle: true,
            title: Text("TIMERS", style: appBarTextStyle),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: timerValueList.isEmpty
                ? SizedBox(
                    height: deviceHeight * 0.8,
                    child: Center(
                      child: Text(
                        'Timer not found\nplease add'.toUpperCase(),
                        style: noDataTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : _timerCardListBuilderWidget(),
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: AppColor.mainColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              elevation: 0,
              child: Icon(
                Icons.add,
                size: 32,
                color: AppColor.whiteColor,
              ),
              onPressed: () {
                hourController.clear();
                minuteController.clear();
                secondController.clear();
                _openTimerDialog();
              })),
    );
  }

  _timerCardListBuilderWidget() {
    return ListView.builder(
      itemCount: timerValueList.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int i) {
        return Container(
          width: deviceWidth,
          height: 102,
          margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
          padding: const EdgeInsets.only(right: 22, left: 22),
          decoration: BoxDecoration(
            color: AppColor.lightGreyColor,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "${timerValueList[i].hour}:${timerValueList[i].minute}:${timerValueList[i].second}",
                  //  '$hours:$minutes:$seconds',
                  style: timerTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    timerValueList.removeAt(i);
                  });
                  // stopTimer();
                },
                child: Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.whiteColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 0.8,
                        ),
                      ]),
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: AppColor.blackColor,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

//open timer dialog
  _openTimerDialog() {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: AppColor.whiteColor,
              ),
              height: deviceHeight * 0.48,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 65,
                      decoration: BoxDecoration(
                          color: AppColor.lightGreyColor,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Center(
                        child: Text(
                          'Add Timer',
                          style: dialogHeadingTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormFiledCustom(
                              controller: hourController,
                              validationError: 'Required Hour',
                              title: 'Hours'),
                          const DotCustomWidget(),
                          TextFormFiledCustom(
                              controller: minuteController,
                              validationError: 'Required Minutes',
                              title: 'Minutes'),
                          const DotCustomWidget(),
                          TextFormFiledCustom(
                              controller: secondController,
                              validationError: 'Required Second',
                              title: 'Second'),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 30),
                      width: double.infinity,
                      height: 62.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.mainColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0))),
                        onPressed: () {
                          int hour = int.parse(hourController.text.toString());
                          int minute =
                              int.parse(minuteController.text.toString());
                          int second =
                              int.parse(secondController.text.toString());
                          if (formKey.currentState!.validate() &&
                              _isValidTime(hour, minute, second)) {
                            TimerModel timerValModelNew = TimerModel(
                                hour: hour, minute: minute, second: second);
                            setState(() {
                              timerValueList.add(timerValModelNew);
                            });
                            _startTimer();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text(
                          "ADD",
                          style: buttonTextStyle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _stopTimer() {
    if (currentTimer != null) {
      currentTimer?.cancel();
      currentTimer = null;
    }
  }

  void _startTimer() {
    debugPrint("=_startTimer====${timerValueList.isEmpty}=====");

    if (timerValueList.isEmpty) {
      return;
    }

    if (currentTimer != null) {
      currentTimer!.cancel();
    }
    debugPrint("==========");
    bool isTimerStopAllList = false;
    currentTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      for (int i = timerValueList.length - 1; i >= 0; i--) {
        if (timerValueList[i].hour!.toInt() != 0 ||
            timerValueList[i].minute!.toInt() != 0 ||
            timerValueList[i].second!.toInt() != 0) {
          isTimerStopAllList = true;
          var secondVal;
          var minuteVal;
          var hourVal;
          Duration duration = Duration(
              hours: timerValueList[i].hour!,
              minutes: timerValueList[i].minute!,
              seconds: timerValueList[i].second!);
          secondVal = duration.inSeconds % 60;
          minuteVal = duration.inMinutes % 60;
          hourVal = duration.inHours;
          if (secondVal > 0) {
            secondVal--;
          } else if (secondVal == 0 && minuteVal > 0) {
            minuteVal--;
            secondVal = 59;
          } else {}

          log("val : $hourVal ':'  $minuteVal  ':'  $secondVal");
          if (hourVal == 0 && minuteVal == 0 && secondVal == 0) {
            timerValueList[i] =
                TimerModel(hour: hourVal, minute: minuteVal, second: secondVal);
            //remove time after time finished
            // timerValueList.removeAt(i);
          } else {
            timerValueList[i] =
                TimerModel(hour: hourVal, minute: minuteVal, second: secondVal);
          }
        } else {}
      }
      if (timerValueList.isEmpty || !isTimerStopAllList) {
        _stopTimer();
      } else {
        _startTimer();
      }
      setState(() {});
    });
  }

  Future<bool> _onWillPop() async {
    final isRunning = currentTimer == null ? false : currentTimer!.isActive;
    if (isRunning) {
      _stopTimer();
    }
    return true;
  }

  bool _isValidTime(int hour, int minute, int second) {
    if (hour == 0 && minute == 0 && second == 0) {
      return false;
    }
    return true;
  }
}
