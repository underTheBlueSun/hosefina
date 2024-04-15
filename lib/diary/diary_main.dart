import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../controller/board_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../controller/diary_controller.dart';
import '../controller/main_controller.dart';
import 'package:flutter/cupertino.dart';


class DiaryMain extends StatelessWidget {

  void morningEmotionDialog(context) {
    showCupertinoDialog(
      context: context,
      // barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          // backgroundColor: Color(0xFFDBB671),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Material(
              color: Colors.transparent,
              child: Column(
                  children: [
                    Image.asset('assets/images/emotion/${DiaryController.to.morning_emotion_icon}.png', height: 50,),
                    Text(DiaryController.to.morning_emotion_name, style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua'),),
                    SizedBox(height: 20,),
                    TextField(
                      controller: TextEditingController(text: DiaryController.to.morning_emotion_content),
                      autofocus: true,
                      onChanged: (value) {
                        DiaryController.to.morning_emotion_content = value;
                      },
                      style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua' , fontSize: 17, ),
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: '왜 ${DiaryController.to.morning_emotion_name} 지 말해줄 수 있나요?',
                        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5), ),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                      ),
                    ),

                  ]
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장'), onPressed: () {
              if (DiaryController.to.morning_emotion_content.length > 0) {
                DiaryController.to.addMorningEmotion();
                Navigator.pop(context);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(duration: Duration(milliseconds: 1000),
                    content: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('왜 ${DiaryController.to.morning_emotion_name} 지 적어 주세요', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),],),),
                );
              }
            })

          ],
        );
      },
    );

  }

  void learningDialog(context) {
    showCupertinoDialog(
      context: context,
      // barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            height: 250,
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('오늘 배운 내용', style: TextStyle(fontFamily: 'Jua', color: Colors.orangeAccent),),
                  TextField(
                    controller: TextEditingController(text: DiaryController.to.learning),
                    autofocus: true,
                    onChanged: (value) {
                      DiaryController.to.learning = value;
                    },
                    style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua' , fontSize: 17, ),
                    maxLines: 8,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장'), onPressed: () {
              DiaryController.to.addLearning();
              Navigator.pop(context);
            })

          ],
        );
      },
    );

  }

  void learningDialog2(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFDBB671),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Center(child: Text('배운 내용',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.white, ),)),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: 250,
            child: TextField(
              controller: TextEditingController(text: DiaryController.to.learning),
              autofocus: true,
              onChanged: (value) {
                DiaryController.to.learning = value;
              },
              style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua' , fontSize: 17, ),
              maxLines: 10,
              // decoration: InputDecoration(
              //   focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white ),),
              //   enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white ),),
              //   contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              //
              // ),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextButton(
                style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                onPressed: () async{
                  Navigator.pop(context);
                },
                child: Text('닫기',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.white, ),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextButton(
                style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                onPressed: () async{
                  DiaryController.to.addLearning();
                  Navigator.pop(context);
                },
                child: Text('저장',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.white, ),),
              ),
            ),

          ],
        );
      },
    );

  }

  void noticeDialog(context) {
    showCupertinoDialog(
      context: context,
      // barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            height: 250,
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('알림장', style: TextStyle(fontFamily: 'Jua', color: Colors.orangeAccent),),
                  TextField(
                    controller: TextEditingController(text: DiaryController.to.notice),
                    autofocus: true,
                    onChanged: (value) {
                      DiaryController.to.notice = value;
                    },
                    style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua' , fontSize: 17, ),
                    maxLines: 8,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장'), onPressed: () {
              DiaryController.to.addNotice();
              Navigator.pop(context);
            })

          ],
        );
      },
    );

  }

  void noticeDialog2(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFDBB671),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Center(child: Text('알림장',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.white, ),)),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: 250,
            child: TextField(
              controller: TextEditingController(text: DiaryController.to.notice),
              autofocus: true,
              onChanged: (value) {
                DiaryController.to.notice = value;
              },
              style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua' , fontSize: 17, ),
              maxLines: 10,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextButton(
                style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                onPressed: () async{
                  Navigator.pop(context);
                },
                child: Text('닫기',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.white, ),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextButton(
                style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                onPressed: () async{
                  DiaryController.to.addNotice();
                  Navigator.pop(context);
                },
                child: Text('저장',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.white, ),),
              ),
            ),

          ],
        );
      },
    );

  }

  void afterEmotionDialog(context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Material(
              color: Colors.transparent,
              child: Column(
                  children: [
                    Image.asset('assets/images/emotion/${DiaryController.to.after_emotion_icon}.png', height: 50,),
                    Text(DiaryController.to.after_emotion_name, style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua'),),
                    SizedBox(height: 20,),
                    TextField(
                      controller: TextEditingController(text: DiaryController.to.after_emotion_content),
                      autofocus: true,
                      onChanged: (value) {
                        DiaryController.to.after_emotion_content = value;
                      },
                      style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua' , fontSize: 17, ),
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: '왜 ${DiaryController.to.after_emotion_name} 지 말해줄 수 있나요?',
                        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5), ),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                      ),
                    ),

                  ]
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장'), onPressed: () {
              if (DiaryController.to.after_emotion_content.length > 0) {
                DiaryController.to.addAfterEmotion();
                Navigator.pop(context);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(duration: Duration(milliseconds: 1000),
                    content: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('왜 ${DiaryController.to.after_emotion_name} 지 적어 주세요', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),],),),
                );
              }
            })

          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        options: CarouselOptions(
          initialPage: DiaryController.to.current_page_index.value,
          onPageChanged: (int, CarouselPageChangedReason) {
            /// 이거 안하면 appbar 날짜 안바뀜
            DiaryController.to.current_page_index.value = int;
          },
          viewportFraction: 1,
          height: MediaQuery.of(context).size.height,
        ),
        itemCount: DiaryController.to.diary_days.length,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
                  .where('date', isEqualTo: DiaryController.to.diary_days[itemIndex]).where('number', isEqualTo: GetStorage().read('number')).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Container(
                    height: 40,
                    child: LoadingIndicator(
                        indicatorType: Indicator.ballPulse,
                        colors: MainController.to.kDefaultRainbowColors,
                        strokeWidth: 2,
                        backgroundColor: Colors.transparent,
                        pathBackgroundColor: Colors.transparent
                    ),
                  ),);
                }
                DiaryController.to.morning_emotion_icon = '';
                DiaryController.to.morning_emotion_name = '';
                DiaryController.to.morning_emotion_content = '';
                DiaryController.to.checklist_points = [0,0,0,0,0,0,0,0,0,0];
                DiaryController.to.learning = '';
                DiaryController.to.notice = '';
                DiaryController.to.after_emotion_icon = '';
                DiaryController.to.after_emotion_name = '';
                DiaryController.to.after_emotion_content = '';

                /// 오늘이 아니면 수정 안되게
                String month = DateFormat('MM').format(DateTime.now());
                String day = DateFormat('dd').format(DateTime.now());
                String dayofweek = DateFormat('EEE', 'ko_KR').format(DateTime.now());
                DiaryController.to.today = '${month}월 ${day}일(${dayofweek})';

                if (snapshot.data!.docs.length > 0) {
                  DiaryController.to.morning_emotion_icon = snapshot.data!.docs.first['morning_emotion_icon'];
                  DiaryController.to.morning_emotion_name = snapshot.data!.docs.first['morning_emotion_name'];
                  DiaryController.to.morning_emotion_content = snapshot.data!.docs.first['morning_emotion_content'];

                  DiaryController.to.checklist_points = [];
                  DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_01']);
                  DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_02']);
                  DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_03']);
                  DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_04']);
                  DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_05']);
                  DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_06']);
                  DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_07']);
                  DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_08']);
                  DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_09']);
                  DiaryController.to.checklist_points.add(snapshot.data!.docs.first['checklist_10']);

                  DiaryController.to.learning = snapshot.data!.docs.first['learning'];
                  DiaryController.to.notice = snapshot.data!.docs.first['notice'];
                  DiaryController.to.after_emotion_icon = snapshot.data!.docs.first['after_emotion_icon'];
                  DiaryController.to.after_emotion_name = snapshot.data!.docs.first['after_emotion_name'];
                  DiaryController.to.after_emotion_content = snapshot.data!.docs.first['after_emotion_content'];

                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      /// 아침감정
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onLongPress: () {
                            if (DiaryController.to.diary_days[itemIndex] == DiaryController.to.today) {
                              morningEmotionDialog(context);
                            }else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(duration: Duration(milliseconds: 1000),
                                  content: Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('오늘 날짜만 추가/수정 할 수 있어요', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),],),),
                              );
                            }
                          },
                          onTap: () {
                            if (DiaryController.to.diary_days[itemIndex] == DiaryController.to.today) {
                              DiaryController.to.emotion_gubun = 'morning';
                              MainController.to.active_screen.value = 'diary_emotion';
                            }else {
                              // DiaryController.to.emotion_gubun = 'morning';
                              // MainController.to.active_screen.value = 'diary_emotion';
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(duration: Duration(milliseconds: 1000),
                                  content: Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('오늘 날짜만 추가/수정 할 수 있어요', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),],),),
                              );
                            }

                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            height: 90,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                            child: DiaryController.to.morning_emotion_icon.length > 0 ?
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('   내용수정: 길게 누르기', style: TextStyle(color: Colors.transparent, fontSize: 10),),
                                  Column(
                                    children: [
                                      Image.asset('assets/images/emotion/${DiaryController.to.morning_emotion_icon}.png', height: 50,),
                                      Text(DiaryController.to.morning_emotion_name, style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua'),),
                                    ],
                                  ),
                                  Text('내용수정: 길게 누르기   ', style: TextStyle(color: Colors.grey.withOpacity(0.5), fontFamily: 'Jua', fontSize: 10),),
                                ],
                              ),
                            ) :
                            GestureDetector(
                              onTap: () {
                                if (DiaryController.to.diary_days[itemIndex] == DiaryController.to.today) {
                                  DiaryController.to.emotion_gubun = 'morning';
                                  MainController.to.active_screen.value = 'diary_emotion';
                                }else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(duration: Duration(milliseconds: 1000),
                                      content: Row(mainAxisAlignment: MainAxisAlignment.center,
                                        children: [Text('오늘 날짜만 추가/수정 할 수 있어요', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),],),),
                                  );
                                }

                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/emotion/weather.png', height: 30,),
                                    SizedBox(width: 10,),
                                    Text('오늘 아침의 마음날씨는 어떤가요?', style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua'),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      /// 체크리스트
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: ListView.separated(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: DiaryController.to.checklist.length,
                              itemBuilder: (BuildContext context, int index) {
                                String checklist_good = 'checklist_good_01';
                                String checklist_bad = 'checklist_bad_01';
                                if (DiaryController.to.checklist_points[index] == 1) {
                                  checklist_good = 'checklist_good_02';
                                  checklist_bad = 'checklist_bad_01';
                                }else if (DiaryController.to.checklist_points[index] == 0){
                                  checklist_good = 'checklist_good_01';
                                  checklist_bad = 'checklist_bad_01';
                                }else{
                                  checklist_good = 'checklist_good_01';
                                  checklist_bad = 'checklist_bad_02';
                                }
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(DiaryController.to.checklist[index], style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua'),),
                                    Row(
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              if (DiaryController.to.diary_days[itemIndex] == DiaryController.to.today) {
                                                HapticFeedback.lightImpact();
                                                if (DiaryController.to.checklist_points[index] == 1) {
                                                  DiaryController.to.addChecklist(index, 0);
                                                }else {
                                                  DiaryController.to.addChecklist(index, 1);
                                                }
                                              }else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(duration: Duration(milliseconds: 1000),
                                                    content: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [Text('오늘 날짜만 추가/수정 할 수 있어요', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),],),),
                                                );
                                              }


                                            },
                                            child:
                                            checklist_good == 'checklist_good_01' ?
                                            Image.asset('assets/images/emotion/${checklist_good}.png', height: 30, width: 30, ) :
                                            Image.asset('assets/images/emotion/${checklist_good}.png', height: 30, width: 30,),
                                        ),
                                        SizedBox(width: 15,),
                                        GestureDetector(
                                            onTap: () {
                                              if (DiaryController.to.diary_days[itemIndex] == DiaryController.to.today) {
                                                HapticFeedback.lightImpact();
                                                if (DiaryController.to.checklist_points[index] == -1) {
                                                  DiaryController.to.addChecklist(index, 0);
                                                }else {
                                                  DiaryController.to.addChecklist(index, -1);
                                                }
                                              }else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(duration: Duration(milliseconds: 1000),
                                                    content: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [Text('오늘 날짜만 추가/수정 할 수 있어요', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),],),),
                                                );
                                              }

                                            },
                                            child:
                                            checklist_bad == 'checklist_bad_01' ?
                                            Image.asset('assets/images/emotion/${checklist_bad}.png', height: 30, width: 30,) :
                                            Image.asset('assets/images/emotion/${checklist_bad}.png', height: 30, width: 30,),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }, separatorBuilder: (BuildContext context, int index) {
                                return Divider(thickness: 0.5, color: Colors.grey.withOpacity(0.5),);
                                },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      /// 일과후 감정
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onLongPress: () {
                            if (DiaryController.to.diary_days[itemIndex] == DiaryController.to.today) {
                              afterEmotionDialog(context);
                            }else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(duration: Duration(milliseconds: 1000),
                                  content: Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('오늘 날짜만 추가/수정 할 수 있어요', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),],),),
                              );
                            }
                          },
                          onTap: () {
                            if (DiaryController.to.diary_days[itemIndex] == DiaryController.to.today) {
                              DiaryController.to.emotion_gubun = 'after';
                              MainController.to.active_screen.value = 'diary_emotion';
                            }else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(duration: Duration(milliseconds: 1000),
                                  content: Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('오늘 날짜만 추가/수정 할 수 있어요', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),],),),
                              );
                            }

                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            height: 90,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                            child: DiaryController.to.after_emotion_icon.length > 0 ?
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('   내용수정: 길게 누르기', style: TextStyle(color: Colors.transparent, fontSize: 10),),
                                  Column(
                                    children: [
                                      Image.asset('assets/images/emotion/${DiaryController.to.after_emotion_icon}.png', height: 50,),
                                      Text(DiaryController.to.after_emotion_name, style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua'),),
                                    ],
                                  ),
                                  Text('내용수정: 길게 누르기   ', style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua', fontSize: 10),),
                                ],
                              ),
                            ) :
                            GestureDetector(
                              onTap: () {
                                if (DiaryController.to.diary_days[itemIndex] == DiaryController.to.today) {
                                  DiaryController.to.emotion_gubun = 'after';
                                  MainController.to.active_screen.value = 'diary_emotion';
                                }else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(duration: Duration(milliseconds: 1000),
                                      content: Row(mainAxisAlignment: MainAxisAlignment.center,
                                        children: [Text('오늘 날짜만 추가/수정 할 수 있어요', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),],),),
                                  );
                                }

                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/emotion/weather.png', height: 30,),
                                    SizedBox(width: 10,),
                                    Text('일과를 마친 지금 마음날씨는 어떤가요?', style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua'),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      /// 오늘 배운 내용
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            if (DiaryController.to.diary_days[itemIndex] == DiaryController.to.today) {
                              learningDialog(context);
                            }else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(duration: Duration(milliseconds: 1000),
                                  content: Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('오늘 날짜만 추가/수정 할 수 있어요', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),],),),
                              );
                            }

                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            // height: 90,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                            child: DiaryController.to.learning.length > 0 ?
                            Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(DiaryController.to.learning, style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua'),),
                            ) :
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/emotion/pencil.png', height: 25,),
                                  SizedBox(width: 10,),
                                  Text('오늘 배운 내용중에 새롭게 알게 되었거나\n기억에 남는 것을 적어 보세요', style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua'),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      /// 알림장
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            if (DiaryController.to.diary_days[itemIndex] == DiaryController.to.today) {
                              noticeDialog(context);
                            }else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(duration: Duration(milliseconds: 1000),
                                  content: Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text('오늘 날짜만 추가/수정 할 수 있어요', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),],),),
                              );
                            }

                          },
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            // height: 90,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                            child: DiaryController.to.notice.length > 0 ?
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(DiaryController.to.notice, style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua'),),
                            ) :
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/emotion/notice.png', height: 30,),
                                  SizedBox(width: 10,),
                                  Text('알림장을 적어 보세요', style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua'),),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                    ],
                  ),
                );
              }
          );
        }

    );

  }
}


