import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hosefina/controller/main_controller.dart';
import 'package:hosefina/controller/pointer_controller.dart';
import 'package:hosefina/controller/subject_controller.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'controller/diary_controller.dart';
import 'controller/temper_controller.dart';

class MainList extends StatelessWidget {
  // List title_list = ['mobile_diary_title.png', 'mobile_subject_title.png', 'mobile_board_title.png', 'mobile_quiz_title.png', 'mobile_couponshop_title.png', 'mobile_temper_title.png',
  //   'mobile_point_title.png', 'mobile_auction_title.png', 'mobile_relationship_title.png', 'mobile_sheet_title.png','mobile_pokemon_title.png', ];
  // List title_name_list = ['생활공책', '주제일기', '학급보드', '퀴즈', '쿠폰가게', '학급온도계',  '포인트','경매', '교우관계', '답안지', '포켓몬'];
  // List active_screen_list = ['diary_main', 'subject_main','board_main', 'quiz', 'coupon_main', 'temper_main', 'point_main', 'auction_main', 'relationship_main',
  //   'trade_main', 'money_main', 'sheet_main', 'pokemon_main', ];

  List title_list = ['mobile_diary_title.png', 'mobile_subject_title.png', 'mobile_board_title.png', 'mobile_quiz_title.png', 'mobile_couponshop_title.png',
    'mobile_temper_title.png', 'mobile_relation_title.png', 'mobile_point_title.png', 'mobile_exam_title.png'];
  List title_name_list = ['생활공책', '주제일기', '학급보드', '퀴즈', '쿠폰가게', '학급온도계', '교우관계', '포인트', '진단평가'];
  List active_screen_list = ['diary_main', 'subject_main','board_main', 'quiz', 'coupon_main', 'temper_main', 'relation_main', 'point_main', 'exam_main'];

  void payDialog(context) {
    showCupertinoDialog(
      context: context,
      // barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게 
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            height: 150,
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(DateTime.now().toString().substring(0,10) + '\n부터 유료화 할까요?',),
                  SizedBox(height: 30,),
                  Text('30일 무료', style: TextStyle(fontSize: 20, color: Colors.orange, fontFamily: 'Jua'),),
                  // TextField(
                  //   controller: TextEditingController(text: MainController.to.free_period.toString()),
                  //   keyboardType: TextInputType.number,
                  //   inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  //   textAlign: TextAlign.center,
                  //   onChanged: (value) {
                  //     MainController.to.free_period = int.parse(value);
                  //   },
                  //   style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua' , fontSize: 20, ),
                  //   maxLines: 1,
                  //   decoration: InputDecoration(
                  //     hintText: '무료사용기간 입력',
                  //     hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5), ),
                  //     focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                  //     enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                  //     contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  //
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('무료'), onPressed: () {
              MainController.to.pay_gubun = '무료';
              MainController.to.payment();
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('유료'), onPressed: () {
              MainController.to.pay_gubun = '유료';
              MainController.to.payment();
              Navigator.pop(context);
            })

          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    /// 포인터
    // PointerController.to.getMyPointer();

    // var free_end_date = DateTime.parse(MainController.to.free_end_date);
    // var now = DateTime.now();
    // var diff = free_end_date.difference(now).inDays;
    // var pay_gubun = MainController.to.payment_pay_gubun;

    // if (GetStorage().read('job') == 'teacher') {
    //   MainController.to.checkFreePay();
    // }

    // if (MainController.to.purchase == 'yes' || (pay_gubun == '유료' && diff >= 0) || pay_gubun == '무료') {

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('class_info').where('class_code', isEqualTo: GetStorage().read('class_code')).snapshots(),
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

          var free_end_date = DateTime.parse(snapshot.data!.docs.first['temp2']);
          var now = DateTime.now();
          var diff = free_end_date.difference(now).inDays;
          var pay_gubun = snapshot.data!.docs.first['gubun'];

          if (snapshot.data!.docs.first['purchase'] == 'yes' || (pay_gubun == '유료' && diff >= 0) || pay_gubun == '무료') {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    pay_gubun == '유료' && diff >= 0 && diff.toString().length < 4 ?  //  && diff.toString().length < 4 안하면 2913125일 남았습니다 라고 뜸(< 4는 대충 준 값)
                    Column(
                      children: [
                        Text('무료기간: ${diff}일 남았습니다', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 15),),
                        SizedBox(height: 20,),
                      ],
                    ) : SizedBox(),
                    Image.asset('assets/images/mobile_hosefina_title2.png', width: MediaQuery.of(context).size.width < 600 ? 150 : 200,),
                    SizedBox(height: 60,),
                    GridView.builder(
                      primary: false,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(30),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 1000 ? 8 : MediaQuery.of(context).size.width > 600 ? 6 : 3,
                        childAspectRatio: 1/1, //item 의 가로, 세로 의 비율
                        // childAspectRatio: 1/1.2, //item 의 가로, 세로 의 비율
                      ),
                      itemCount: title_list.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            HapticFeedback.lightImpact();
                            /// 인터넷 연결 체크
                            final connectivityResult = await (Connectivity().checkConnectivity());

                            if (connectivityResult == ConnectivityResult.none) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(duration: Duration(milliseconds: 1000),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('인터넷에 연결되어 있지 않습니다.', style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 18),),
                                    ],
                                  ),),);
                            }else {
                              if (active_screen_list[index] == 'point_main' && GetStorage().read('job') == 'student' && PointerController.to.my_pointer_docs.length == 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(duration: Duration(milliseconds: 1000),
                                    content: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('권한이 없습니다', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),
                                      ],
                                    ),),);
                              }else if (active_screen_list[index] == 'point_main' && GetStorage().read('job') == 'student' && PointerController.to.my_pointer_docs.length > 0) {
                                MainController.to.active_screen.value = 'point_main_student';
                              }else if (active_screen_list[index] == 'diary_main') {
                                /// 오늘 날짜로 보여주기
                                String month = DateFormat('MM').format(DateTime.now());
                                String day = DateFormat('dd').format(DateTime.now());
                                String dayofweek = DateFormat('EEE', 'ko_KR').format(DateTime.now());

                                // DiaryController.to.mmdd_yoil.value = '${month}월 ${day}일(${dayofweek})';
                                // DiaryController.to.getCurrentPage();
                                DiaryController.to.current_page_index.value = DiaryController.to.diary_days.indexOf('${month}월 ${day}일(${dayofweek})');
                                if (GetStorage().read('job') == 'student') {
                                  MainController.to.active_screen.value = active_screen_list[index];
                                }else {
                                  MainController.to.active_screen.value = 'diary_main_teacher';
                                }

                              }else if (active_screen_list[index] == 'quiz') {
                                if (GetStorage().read('job') == 'student') {
                                  MainController.to.active_screen.value = 'quiz_ready';
                                }else {
                                  MainController.to.active_screen.value = 'quiz_myquiz';
                                }

                              }else if (active_screen_list[index] == 'coupon_main') {
                                if (GetStorage().read('job') == 'student') {
                                  MainController.to.active_screen.value = active_screen_list[index];
                                }else {
                                  MainController.to.active_screen.value = 'coupon_main_teacher';
                                }

                              }else if (active_screen_list[index] == 'subject_main') {
                                SubjectController.to.mmdd = DateTime.now().month.toString().padLeft(2,'0') + DateTime.now().day.toString().padLeft(2,'0');
                                await SubjectController.to.getSubjects();
                                MainController.to.active_screen.value = 'subject_main';
                              }else if (active_screen_list[index] == 'temper_main') {
                                TemperController.to.getPointBySticker();
                                MainController.to.active_screen.value = 'temper_main';
                              }
                              else {
                                MainController.to.active_screen.value = active_screen_list[index];
                              }
                            }

                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                            child: Column(
                              children: [
                                Image.asset('assets/images/${title_list[index]}', height: 70,),
                                Text(title_name_list[index], style: TextStyle(color: Colors.black.withOpacity(0.6), fontFamily: 'Jua'),),
                              ],
                            ),
                          ),
                        );

                      },

                    ),
                    // SizedBox(height: 10,),
                    /// 퇴장버튼
                    Container(
                      width: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent, ),
                        onPressed: () async{
                          MainController.to.exitClass();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.exit_to_app_outlined, color: Colors.white,),
                            SizedBox(width: 5,),
                            Text('퇴장', style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    /// 이용약관
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            const webUrl = "https://drive.google.com/file/d/1Cdpef3kvqYG79MAh7G7L2c0gXfAtSTZy/view?usp=drive_link";
                            try {
                              await launchUrlString(webUrl, mode: LaunchMode.platformDefault);
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Text('이용약관', style: TextStyle(color: Colors.white,),),
                        ),
                        Text('  &  ', style: TextStyle(color: Colors.white),),
                        GestureDetector(
                            onTap: () async {
                              const webUrl = "https://drive.google.com/file/d/1JABPxzke6DLrjQADIFTUHkRLMI6eDQvG/view?usp=drive_link";
                              try {
                                await launchUrlString(webUrl, mode: LaunchMode.platformDefault);
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Text('개인정보처리방침', style: TextStyle(color: Colors.white,),)),
                      ],
                    ),
                    SizedBox(height: 20,),
                    (GetStorage().read('job') == 'teacher' && GetStorage().read('email') == 'umssam00@gmail.com') ?
                    /// 유료화
                    Container(
                      width: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amberAccent, ),
                        onPressed: () async{
                          payDialog(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.exit_to_app_outlined, color: Colors.black,),
                            SizedBox(width: 5,),
                            Text('유료화', style: TextStyle(color: Colors.black),),
                          ],
                        ),
                      ),
                    ) :
                    SizedBox(),
                  ],
                ),
              ),
            );
          }else{
            return SizedBox();
          }

        }
    );

  }
}