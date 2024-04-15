import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hosefina/common/point_widget.dart';
import 'package:hosefina/controller/auction_controller.dart';
import 'package:hosefina/controller/exam_controller.dart';
import 'package:hosefina/controller/point_controller.dart';
import 'package:hosefina/controller/subject_controller.dart';
import 'package:hosefina/controller/temper_controller.dart';
import 'package:loading_indicator/loading_indicator.dart';
// import 'package:restart_app/restart_app.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../controller/board_controller.dart';
import 'package:flutter/material.dart';
import '../controller/main_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controller/diary_controller.dart';
import 'controller/quiz_controller.dart';


class AppBarWidget extends StatelessWidget {

  void loginDialog(context) {
    showCupertinoDialog(
      context: context,
      // barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            height: 200,
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  /// 이메일
                  TextField(
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      MainController.to.email = value;
                    },
                    style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua' , fontSize: 20, ),
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: '이메일을 입력하세요',
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5), ),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                    ),
                  ),
                  SizedBox(height: 20,),
                  /// 비밀번호
                  TextField(
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    obscureText: true,
                    onChanged: (value) {
                      MainController.to.pwd = value;
                    },
                    onSubmitted: (value) async{
                      await MainController.to.loginTeacher(context);
                    },
                    style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua' , fontSize: 20, ),
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: '비밀번호를 입력하세요',
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5), ),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                    ),
                  ),
                  SizedBox(height: 30,),
                  Obx(() => Text(MainController.to.is_visible_not_email_message.value, style: TextStyle(fontSize: 12, color: Colors.orange),),
                  ),
                  // Obx(() => Visibility(
                  //   visible: MainController.to.is_visible_not_email_message.value,
                  //   child: Text('비밀번호가 일치하지 않거나 이메일에 맞는 반코드가 존재하지 않습니다.', style: TextStyle(fontSize: 12, color: Colors.orange),),
                  // ),
                  // ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('로그인'), onPressed: () async{
              await MainController.to.loginTeacher(context);
            })

          ],
        );
      },
    );

  }

  void pointByStickerDialog(context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            width: 120, height: 150,
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  Text('스티커 하나당\n별포인트를 몇점으로 하시겠습니까?'),
                  SizedBox(height: 20,),
                  SizedBox(
                    width: 200,
                    height: 60,
                    child: TextField(
                      controller: TextEditingController(text: TemperController.to.point_by_sticker.toString()),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      cursorColor: Colors.black,
                      autofocus: true,
                      textAlignVertical: TextAlignVertical.center,
                      onChanged: (value) {
                        TemperController.to.point_by_sticker = int.parse(value);
                      },
                      onSubmitted: (value) {
                        TemperController.to.updatePoint();
                        Navigator.pop(context);
                      },
                      style: TextStyle(fontFamily: 'Jua', fontSize: 20, ),
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: '스티커당 별포인트 입력',
                        hintStyle: TextStyle(fontSize: 19, color: Colors.grey.withOpacity(0.5)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey, ),),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                      ),
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
              TemperController.to.updatePoint();
              Navigator.pop(context);
            })

          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {

    /// 전체 스탬프 찍기 위해  전체 인텍스 가져오기
    List allIndexs = [];

    if (MainController.to.active_screen.value == 'class_code_add' || MainController.to.active_screen.value == 'main_list') {
      return SizedBox();
    } else if (MainController.to.active_screen.value == 'attendance') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 90, height: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: () async{
                MainController.to.is_visible_not_email_message.value = '';
                loginDialog(context);
              },
              child: Text('선생님', style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      );
    } else if (MainController.to.active_screen.value == 'board_indi' || MainController.to.active_screen.value == 'board_modum') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              MainController.to.active_screen.value = 'board_main';
            },
            child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white.withOpacity(0.7),size: 30,),),
          ),
          Expanded(child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Center(child: Text(BoardController.to.board_title, maxLines: 2, style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),)),
          )),
          GetStorage().read('job') == 'student' ?
          PointWidget() :
          // buildStreamBuilder() :
          SizedBox(),
        ],
      );
    }else if (MainController.to.active_screen.value == 'board_add') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              MainController.to.active_screen.value = 'board_main';
            },
            child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white.withOpacity(0.7),size: 30,),),
          ),
          Row(
            children: [
              /// 사진
              GestureDetector(
                onTap: () {
                  BoardController.to.selectImage();
                },
                child: Column(
                  children: [
                    Icon(Icons.photo, color: Colors.white),
                    Text('사진', style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
                  ],
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     BoardController.to.selectImage();
              //   },
              //   child: Container(width: 50, height: 35, color: Colors.transparent, child: Image.asset('assets/images/camera.png', ),),
              // ),
              SizedBox(width: 20,),
              GestureDetector(
                onTap: () async{
                  if (BoardController.to.indi_title.length > 0 && BoardController.to.indi_content.length > 0) {
                    if (BoardController.to.board_type == '개인') {
                      BoardController.to.saveBoardIndi(GetStorage().read('number'),);
                      if (BoardController.to.board_gubun == '보드') {
                        MainController.to.active_screen.value = 'board_indi';
                      }else{
                        MainController.to.active_screen.value = 'board_auction';
                      }

                    }else {
                      BoardController.to.saveBoardModum();
                      MainController.to.active_screen.value = 'board_modum';
                    }
                    BoardController.to.imageModel.value.imageInt8 == null;
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(duration: Duration(milliseconds: 1000),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('제목과 내용을 입력하세요', style: TextStyle(fontFamily: 'Jua', fontSize: 18),),
                          ],
                        ),),);
                  }

                },
                child: Column(
                  children: [
                    Icon(Icons.save, color: Colors.white),
                    Text('저장', style: TextStyle(fontFamily: 'Jua', fontSize: 17, color: Colors.white),),
                  ],
                ),
              ),
              // GestureDetector(
              //   onTap: () async{
              //     if (BoardController.to.indi_title.length > 0) {
              //       if (BoardController.to.board_type == '개인') {
              //         await BoardController.to.saveBoardIndi(GetStorage().read('number'),);
              //         if (BoardController.to.board_gubun == '보드') {
              //           MainController.to.active_screen.value = 'board_indi';
              //         }else{
              //           MainController.to.active_screen.value = 'board_auction';
              //         }
              //
              //       }else {
              //         await BoardController.to.saveBoardModum();
              //         MainController.to.active_screen.value = 'board_modum';
              //       }
              //       BoardController.to.imageModel.value.imageInt8 == null;
              //     }
              //
              //   },
              //   child: Container(
              //     width: 80, height: 30,
              //     decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(15)),
              //     child: Center(child: Text('저장', style: TextStyle(fontSize: 16, fontFamily: 'Jua', color: Colors.white),),),
              //   ),
              // ),
            ],
          ),
        ],
      );
    } else if (MainController.to.active_screen.value == 'quiz_play'  || MainController.to.active_screen.value == 'quiz_next_person' ) {
      if (QuizController.to.quiz_type.value == '개인') {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                // Restart.restartApp(); /// 퀴즈 모둠 -> 개인순으로 하면 obx 에러남(빌드전에 setstate했다고)
                /// 닫기하면 플레이어 입장 활성화를 false로
                QuizController.to.updIsActiveFalse();
                QuizController.to.is_visible_score.value = false;
                MainController.to.active_screen.value = 'main_list';
              },
              child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white.withOpacity(0.7),size: 30,),),
            ),
            Container(width: 50, height: 30, child: Icon(Icons.cancel, color: Colors.transparent,size: 30,),),
          ],
        );
      } else {  /// 모둠
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                // Restart.restartApp(); /// 퀴즈 모둠 -> 개인순으로 하면 obx 에러남(빌드전에 setstate했다고)
                /// 닫기하면 플레이어 입장 활성화를 false로
                QuizController.to.updIsActiveFalse();
                QuizController.to.is_visible_score.value = false;
                MainController.to.active_screen.value = 'main_list';
              },
              child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white.withOpacity(0.7),size: 30,),),
            ),
            Expanded(child: Center(child: Text('${QuizController.to.question_number.toString()}/${QuizController.to.questions.length.toString()}', style: TextStyle(fontFamily: 'Jua', color: Colors.white, ),))),
            Container(width: 50, height: 30, child: Icon(Icons.cancel, color: Colors.transparent,size: 30,),),
          ],
        );
      }

    }else if (MainController.to.active_screen.value == 'quiz_myquiz' ) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              MainController.to.active_screen.value = 'main_list';
            },
            child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white.withOpacity(0.7),size: 30,),),
          ),
          Row(
            children: [
              TextButton(
                style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
                onPressed: () {
                  QuizController.to.active_screen.value = 'all';
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Icon(Icons.people_alt_outlined, size: 35, color: Colors.white),
                      Text('전체', style: TextStyle(fontFamily: 'Jua', fontSize: 13,color: Colors.white),)
                    ],
                  ),
                ),
              ),
              // SizedBox(width: 10,),
              TextButton(
                style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.5))),
                onPressed: () {
                  QuizController.to.active_screen.value = 'all';
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Icon(Icons.quiz_outlined, size: 35, color: Colors.white),
                      Text('나의퀴즈', style: TextStyle(fontFamily: 'Jua', fontSize: 13,color: Colors.white),)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }else if (MainController.to.active_screen.value == 'temper_main') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              MainController.to.active_screen.value = 'main_list';
            },
            child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white.withOpacity(0.7),size: 30,),),
          ),
          GetStorage().read('job') == 'teacher' ?
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  MainController.to.active_screen.value = 'temper_edit';
                },
                child: Column(
                  children: [
                    Icon(Icons.edit, size: 30, color: Colors.white,),
                    Text('보상편집', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 15),),
                  ],
                ),
              ),
              SizedBox(width: 20,),
              Container(
                width: 60,
                child: GestureDetector(
                  onTap: () {
                    pointByStickerDialog(context);
                  },
                  child: Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('temper_pointbysticker').where('class_code', isEqualTo: GetStorage().read('class_code')).snapshots(),
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
                            TemperController.to.point_by_sticker = 1;
                            if (snapshot.data!.docs.length > 0) {
                              TemperController.to.point_by_sticker = snapshot.data!.docs.first['pointbysticker'];
                            }
                            return Text(TemperController.to.point_by_sticker.toString(), style: TextStyle(color: Colors.orange, fontFamily: 'Jua', fontSize: 23));
                          }
                      ),
                      Text('●/★', style: TextStyle(fontFamily: 'Jua', color: Colors.white, fontSize: 17),)
                    ],
                  ),
                ),
              ),
            ],
          ) :
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  MainController.to.active_screen.value = 'temper_donation';
                },
                child: Column(
                  children: [
                    Icon(Icons.list, color: Colors.white,),
                    Text('기부내역', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 15),),
                  ],
                ),
              ),
              SizedBox(width: 20,),
              PointWidget(),
              // buildStreamBuilder(),
            ],
          ),

        ],
      );
    }else if (MainController.to.active_screen.value == 'temper_edit') {
      return Row(
        children: [
          GestureDetector(
            onTap: () {
              MainController.to.active_screen.value = 'temper_main';
            },
            child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white.withOpacity(0.7),size: 30,),),
          ),

        ],
      );
    }else if (MainController.to.active_screen.value == 'temper_donation') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              MainController.to.active_screen.value = 'temper_main';
            },
            child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white.withOpacity(0.7),size: 30,),),
          ),
          Text('기부내역', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 17),),
          Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.transparent,size: 30,),),

        ],
      );
    } else if (MainController.to.active_screen.value == 'point_main') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              MainController.to.active_screen.value = 'main_list';
            },
            child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white.withOpacity(0.7),size: 30,),),
          ),
          GestureDetector(
            onTap: () {
              MainController.to.active_screen.value = 'pointer_main';
            },
            child: Row(
              children: [
                Icon(Icons.people, color: Colors.white,),
                SizedBox(width: 2,),
                Text('포인터', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 17), ),
              ],
            ),
          ),
        ],
      );
    }else if (MainController.to.active_screen.value == 'diary_main') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              // DiaryController.to.updPoint();
              MainController.to.active_screen.value = 'main_list';
            },
            child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white.withOpacity(0.7),size: 30,),),
          ),
          // Obx(() => Text(DiaryController.to.mmdd_yoil.value, style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),)),
          Obx(() => Text(DiaryController.to.diary_days[DiaryController.to.current_page_index.value], style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),)),
          Row(
            children: [
              GetStorage().read('job') == 'student' ?
              // buildStreamBuilder() :
              PointWidget() :
              SizedBox(),
            ],
          ),

        ],
      );
    }else if (MainController.to.active_screen.value == 'diary_main_teacher') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              MainController.to.active_screen.value = 'main_list';
            },
            child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white.withOpacity(0.7),size: 30,),),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  DiaryController.to.current_page_index.value = DiaryController.to.current_page_index.value - 1;
                },
                child: Icon(Icons.arrow_circle_left, size: 30, color: Colors.orangeAccent,),
              ),
              SizedBox(width: 10,),
              Obx(() => Text(DiaryController.to.diary_days[DiaryController.to.current_page_index.value], style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),)),
              SizedBox(width: 10,),
              GestureDetector(
                onTap: () {
                  DiaryController.to.current_page_index.value = DiaryController.to.current_page_index.value + 1;
                },
                child: Icon(Icons.arrow_circle_right, size: 30, color: Colors.orangeAccent,),
              ),
            ],
          ),
          Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.transparent,size: 30,),),
        ],
      );
    }else if (MainController.to.active_screen.value == 'coupon_main' && GetStorage().read('job') == 'student') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              MainController.to.active_screen.value = 'main_list';
            },
            child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white.withOpacity(0.7),size: 30,),),
          ),
          Text('내가 구매한 쿠폰', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),),
          PointWidget(),
        ],
      );
    }else if (MainController.to.active_screen.value == 'coupon_main_teacher') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              MainController.to.active_screen.value = 'main_list';
            },
            child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white.withOpacity(0.7),size: 30,),),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  MainController.to.active_screen.value = 'coupon_add';
                },
                child: Column(
                  children: [
                    Icon(Icons.airplane_ticket, size: 30, color: Colors.white,),
                    Text('쿠폰등록', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 15),),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    }else if (MainController.to.active_screen.value == 'subject_main' || MainController.to.active_screen.value == 'subject_add') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              MainController.to.active_screen.value = 'main_list';

            },
            child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white.withOpacity(0.7),size: 30,),),
          ),
          Obx(() => Text(SubjectController.to.mmdd_yoil.value, style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),)),
          Row(
            children: [
              GetStorage().read('job') == 'student' ?
              PointWidget() :
              // buildStreamBuilder() :
              GestureDetector(
                onTap: () async{
                  await SubjectController.to.getSubjects();
                  MainController.to.active_screen.value = 'subject_edit';
                },
                child: Column(
                  children: [
                    Icon(Icons.edit_calendar_outlined, size: 30, color: Colors.white,),
                    Text('주제편집', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 15),),
                  ],
                ),
              ),
            ],
          ),

        ],
      );
    }else if (MainController.to.active_screen.value == 'exam_main') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              MainController.to.active_screen.value = 'main_list';
            },
            child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white.withOpacity(0.7),size: 30,),),
          ),
          Text(GetStorage().read('name'), style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),),
          Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.transparent,size: 30,),),

        ],
      );
    }else if (MainController.to.active_screen.value == 'exam_sheet') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              MainController.to.active_screen.value = 'exam_main';
            },
            child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white.withOpacity(0.7),size: 30,),),
          ),
          Text(ExamController.to.subject, style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),),
          Text(GetStorage().read('name'), style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 15),),

        ],
      );
    }else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (MainController.to.active_screen.value == 'board_main') {
                MainController.to.active_screen.value = 'main_list';
              }else if (MainController.to.active_screen.value == 'board_indi' || MainController.to.active_screen.value == 'board_modum') {
                MainController.to.active_screen.value = 'board_main';
              }else if (MainController.to.active_screen.value == 'quiz_ready' ||  MainController.to.active_screen.value == 'quiz_score') {
                /// 닫기하면 플레이어 입장 활성화를 false로
                QuizController.to.updIsActiveFalse();
                QuizController.to.is_visible_score.value = false;
                MainController.to.active_screen.value = 'main_list';
              }else if (MainController.to.active_screen.value == 'auction_main') {
                MainController.to.active_screen.value = 'main_list';
                AuctionController.to.test_width.value = 0.8;
              }else if (MainController.to.active_screen.value == 'pokemon_main') {
                MainController.to.active_screen.value = 'main_list';
              }else if (MainController.to.active_screen.value == 'pointer_main') {
                MainController.to.active_screen.value = 'point_main';
              }else if (MainController.to.active_screen.value == 'pointer_add') {
                MainController.to.active_screen.value = 'pointer_main';
              }else if (MainController.to.active_screen.value == 'pointer_detail') {
                MainController.to.active_screen.value = 'pointer_main';
              }else if (MainController.to.active_screen.value == 'diary_emotion') {
                MainController.to.active_screen.value = 'diary_main';
              }else if (MainController.to.active_screen.value == 'coupon_add') {
                MainController.to.active_screen.value = 'coupon_main_teacher';
              }else if (MainController.to.active_screen.value == 'coupon_buy') {
                MainController.to.active_screen.value = 'coupon_main';
              }else if (MainController.to.active_screen.value == 'subject_add') {
                MainController.to.active_screen.value = 'subject_main';
              }else if (MainController.to.active_screen.value == 'subject_edit') {
                MainController.to.active_screen.value = 'subject_main';
              }else{
                MainController.to.active_screen.value = 'main_list';
              }
            },
            child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white.withOpacity(0.7),size: 30,),),
          ),
          Row(
            children: [
              // Text(GetStorage().read('name'), style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 11),),
              // SizedBox(width: 5,),
              GetStorage().read('job') == 'student' ?
              PointWidget() :
              // buildStreamBuilder() :
              SizedBox(),
            ],
          ),


        ],
      );
    }
  }

  // StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilder() {
  //   return StreamBuilder<QuerySnapshot>(
  //       stream: FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
  //           .where('number', isEqualTo: GetStorage().read('number')).snapshots(),
  //       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //         if (!snapshot.hasData) {
  //           return Center(child: Container(
  //             height: 40,
  //             child: LoadingIndicator(
  //                 indicatorType: Indicator.ballPulse,
  //                 colors: MainController.to.kDefaultRainbowColors,
  //                 strokeWidth: 2,
  //                 backgroundColor: Colors.transparent,
  //                 pathBackgroundColor: Colors.transparent
  //             ),
  //           ),);
  //         }
  //         int diary_point = 0;
  //         int point_point = 0;
  //         snapshot.data!.docs.forEach((doc) {
  //           if(doc['checklist_01'] > 0) diary_point = diary_point + doc['checklist_01'] as int;
  //           if(doc['checklist_02'] > 0) diary_point = diary_point + doc['checklist_02'] as int;
  //           if(doc['checklist_03'] > 0) diary_point = diary_point + doc['checklist_03'] as int;
  //           if(doc['checklist_04'] > 0) diary_point = diary_point + doc['checklist_04'] as int;
  //           if(doc['checklist_05'] > 0) diary_point = diary_point + doc['checklist_05'] as int;
  //           if(doc['checklist_06'] > 0) diary_point = diary_point + doc['checklist_06'] as int;
  //           if(doc['checklist_07'] > 0) diary_point = diary_point + doc['checklist_07'] as int;
  //           if(doc['checklist_08'] > 0) diary_point = diary_point + doc['checklist_08'] as int;
  //           if(doc['checklist_09'] > 0) diary_point = diary_point + doc['checklist_09'] as int;
  //           if(doc['checklist_10'] > 0) diary_point = diary_point + doc['checklist_10'] as int;
  //         });
  //
  //         return StreamBuilder<QuerySnapshot>(
  //             stream: FirebaseFirestore.instance.collection('point').where('class_code', isEqualTo: GetStorage().read('class_code'))
  //                 .where('number', isEqualTo: GetStorage().read('number')).snapshots(),
  //             builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //               if (!snapshot.hasData) {
  //                 return Center(child: Container(
  //                   height: 40,
  //                   child: LoadingIndicator(
  //                       indicatorType: Indicator.ballPulse,
  //                       colors: MainController.to.kDefaultRainbowColors,
  //                       strokeWidth: 2,
  //                       backgroundColor: Colors.transparent,
  //                       pathBackgroundColor: Colors.transparent
  //                   ),
  //                 ),);
  //               }
  //
  //               if (snapshot.data!.docs.length > 0) {
  //                 point_point = snapshot.data!.docs.first['point'];
  //               }
  //
  //               return Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   Icon(Icons.star, color: Color(0xFFE490A0),),
  //                   SizedBox(width: 3,),
  //                   Text((diary_point+point_point).toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, ),),
  //                 ],);
  //             }
  //         );
  //
  //       }
  //   );
  // }

}


