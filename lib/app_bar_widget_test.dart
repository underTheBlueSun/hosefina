// import 'package:hosefina/controller/auction_controller.dart';
// import 'package:hosefina/controller/point_controller.dart';
// import 'package:hosefina/controller/temper_controller.dart';
// import 'package:restart_app/restart_app.dart';
// import 'package:slide_countdown/slide_countdown.dart';
// import 'package:timer_count_down/timer_count_down.dart';
//
// import '../controller/board_controller.dart';
// import 'package:flutter/material.dart';
// import '../controller/main_controller.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
//
// import 'controller/quiz_controller.dart';
//
//
// class AppBarWidget extends StatelessWidget {
//
//   void checkEmailTeacherDialog(context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Color(0xFF4C4C4C),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//           content: Container(
//             width: 140, height: 120,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(height: 30,),
//                 SizedBox(
//                   width: 250,
//                   height: 60,
//                   child: TextField(
//                     autofocus: true,
//                     textAlignVertical: TextAlignVertical.center,
//                     textAlign: TextAlign.center,
//                     onSubmitted: (value) {
//                       if (value.length > 0) {
//                         MainController.to.checkEmail(value, context);
//                         // Navigator.pop(context);
//                       }
//                     },
//                     style: TextStyle(color: Colors.white , fontSize: 17, ),
//                     // minLines: 1,
//                     maxLines: 1,
//                     decoration: InputDecoration(
//                       hintText: '이메일을 입력하세요',
//                       hintStyle: TextStyle(fontSize: 19, color: Colors.white.withOpacity(0.5)),
//                       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white.withOpacity(0.5) ),),
//                       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white.withOpacity(0.5), ),),
//                       contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//
//                     ),
//                   ),
//                 ),
//                 Obx(() => Visibility(
//                   visible: MainController.to.is_visible_not_email_message.value,
//                   child: Text('이메일이 존재하지 않습니다', style: TextStyle(fontSize: 12, color: Colors.orange),),
//                 ),
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(5),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.teal,),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text('취소',style: TextStyle(fontFamily: 'Jua', fontSize: 15, color: Colors.white),),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (MainController.to.active_screen.value == 'class_code_add' || MainController.to.active_screen.value == 'main_list') {
//       return SizedBox();
//     } else if (MainController.to.active_screen.value == 'attendance') {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           SizedBox(
//             width: 90, height: 30,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white.withOpacity(0.8),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
//               ),
//               onPressed: () async{
//                 MainController.to.is_visible_not_email_message.value = false;
//                 checkEmailTeacherDialog(context);
//               },
//               child: Text('선생님', style: TextStyle(color: Colors.black),),
//             ),
//           ),
//         ],
//       );
//     } else if (MainController.to.active_screen.value == 'board_main') {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () {
//               MainController.to.active_screen.value = 'main_list';
//             },
//             child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white,size: 30,),),
//           ),
//           // Text('학급보드', style: TextStyle(fontFamily: 'Jua', color: Colors.white, ),),
//           // Container(width: 50, height: 30, child: Icon(Icons.cancel, color: Colors.transparent,size: 30,),),
//         ],
//       );
//     } else if (MainController.to.active_screen.value == 'board_indi' || MainController.to.active_screen.value == 'board_modum') {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () {
//               MainController.to.active_screen.value = 'board_main';
//             },
//             child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white,size: 30,),),
//           ),
//           Container(
//             alignment: Alignment.center,
//             width: MediaQuery.of(context).size.width > 1000 ? 1000 : MediaQuery.of(context).size.width > 600 ? 600 : 250,
//             child: Text(BoardController.to.board_title, style: TextStyle(fontFamily: 'Jua', color: Colors.white, ),),
//           ),
//           Container(width: 50, height: 30, child: Icon(Icons.cancel, color: Colors.transparent,size: 30,),),
//         ],
//       );
//     } else if (MainController.to.active_screen.value == 'board_add') {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () {
//               MainController.to.active_screen.value = 'board_main';
//             },
//             child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white,size: 30,),),
//           ),
//           Row(
//             children: [
//               /// 사진
//               GestureDetector(
//                 onTap: () {
//                   BoardController.to.selectImage();
//                 },
//                 child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.camera_alt, color: Colors.white,)),
//                 // child: Image.asset('assets/images/camera.png', height: 32),
//               ),
//               SizedBox(width: 10,),
//               /// 저장
//               GestureDetector(
//                 onTap: () async{
//                   if (BoardController.to.indi_title.length > 0) {
//                     if (BoardController.to.board_type == '개인') {
//                       await BoardController.to.saveBoardIndi(GetStorage().read('number'),);
//                       if (BoardController.to.board_gubun == '보드') {
//                         MainController.to.active_screen.value = 'board_indi';
//                       }else{
//                         MainController.to.active_screen.value = 'board_auction';
//                       }
//
//                     }else {
//                       await BoardController.to.saveBoardModum(Get.arguments['modum_number'],);
//                       MainController.to.active_screen.value = 'board_modum';
//                     }
//                     BoardController.to.imageModel.value.imageInt8 == null;
//                   }
//
//                 },
//                 child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.save, color: Colors.white,)),
//                 // child: Image.asset('assets/images/font_save.png', height: 32),
//               ),
//             ],
//           ),
//         ],
//       );
//     }
//     else if (MainController.to.active_screen.value == 'quiz_ready' ||  MainController.to.active_screen.value == 'quiz_score') {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () {
//               // Restart.restartApp(); /// 퀴즈 모둠 -> 개인순으로 하면 obx 에러남(빌드전에 setstate했다고)
//               QuizController.to.is_visible_score.value = false;
//               MainController.to.active_screen.value = 'main_list';
//             },
//             child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white, size: 30,),),
//           ),
//           // Expanded(child: Center(child: Text(QuizController.to.quiz_title.value, style: TextStyle(fontFamily: 'Jua', color: Colors.white, ),))),
//           Container(width: 50, height: 30, child: Icon(Icons.cancel, color: Colors.transparent,size: 30,),),
//         ],
//       );
//     }
//     else if (MainController.to.active_screen.value == 'quiz_play'  || MainController.to.active_screen.value == 'quiz_next_person' ) {
//       if (QuizController.to.quiz_type.value == '개인') {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 // Restart.restartApp(); /// 퀴즈 모둠 -> 개인순으로 하면 obx 에러남(빌드전에 setstate했다고)
//                 QuizController.to.is_visible_score.value = false;
//                 MainController.to.active_screen.value = 'main_list';
//               },
//               child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white,size: 30,),),
//             ),
//             Countdown(
//               seconds: int.parse(QuizController.to.quiz_indi_timer.value),
//               build: (BuildContext context, double time) {
//                 QuizController.to.remain_time = time;  /// 타이머 다 돌기전에 선택지 클릭시
//                 return Row(
//                   children: [
//                     Icon(Icons.access_alarm, color: Colors.white,),
//                     SizedBox(width: 10,),
//                     Container(
//                         width: 50,
//                         child: Text(time.toInt().toString(), style: TextStyle(color: Colors.white,),)),
//                   ],);
//               },
//               interval: Duration(milliseconds: 1000),
//               onFinished: () {
//                 MainController.to.active_screen.value = 'quiz_score';
//               },
//             ),
//             Container(width: 50, height: 30, child: Icon(Icons.cancel, color: Colors.transparent,size: 30,),),
//           ],
//         );
//       } else {  /// 모둠
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 // Restart.restartApp(); /// 퀴즈 모둠 -> 개인순으로 하면 obx 에러남(빌드전에 setstate했다고)
//                 QuizController.to.is_visible_score.value = false;
//                 MainController.to.active_screen.value = 'main_list';
//               },
//               child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white,size: 30,),),
//             ),
//             Expanded(child: Center(child: Text('${QuizController.to.question_number.toString()}/${QuizController.to.questions.length.toString()}', style: TextStyle(fontFamily: 'Jua', color: Colors.white, ),))),
//             Container(width: 50, height: 30, child: Icon(Icons.cancel, color: Colors.transparent,size: 30,),),
//           ],
//         );
//       }
//
//     }else if (MainController.to.active_screen.value == 'auction_main') {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () {
//               MainController.to.active_screen.value = 'main_list';
//               AuctionController.to.test_width.value = 0.8;
//             },
//             child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white,),),
//           ),
//           Text('경매', style: TextStyle(fontFamily: 'Jua', color: Colors.white, ),),
//           Container(width: 50, height: 30, child: Icon(Icons.cancel, color: Colors.transparent,),),
//         ],
//       );
//     }else if (MainController.to.active_screen.value == 'temper_main') {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () {
//               MainController.to.active_screen.value = 'main_list';
//             },
//             child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white,size: 30,),),
//           ),
//           GetStorage().read('job') == 'teacher' ?
//           GestureDetector(
//             onTap: () {
//               MainController.to.active_screen.value = 'temper_edit';
//             },
//             child: Container(width: 50, height: 30,  child: Icon(Icons.edit, color: Colors.white, size: 30,)),
//           ) : SizedBox(),
//
//         ],
//       );
//     }else if (MainController.to.active_screen.value == 'temper_edit') {
//       return Row(
//         children: [
//           GestureDetector(
//             onTap: () {
//               MainController.to.active_screen.value = 'temper_main';
//             },
//             child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white,size: 30,),),
//           ),
//
//         ],
//       );
//     } else if (MainController.to.active_screen.value == 'pokemon_main') {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () {
//               MainController.to.active_screen.value = 'main_list';
//             },
//             child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white,size: 30,),),
//           ),
//           Text('포켓몬 도감', style: TextStyle(fontFamily: 'Jua', color: Colors.white),),
//           Text('${PokemonController.to.pokemon_cnt.toString()}/300', style: TextStyle(color: Colors.white),),
//         ],
//       );
//     }else if (MainController.to.active_screen.value == 'point_main') {
//       return Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () {
//               MainController.to.active_screen.value = 'main_list';
//             },
//             child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white,size: 30,),),
//           ),
//           Row(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   PokemonController.to.delAllPoint();
//                 },
//                 child: Container(
//                   // margin: EdgeInsets.all(4),
//                   padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
//                   decoration: BoxDecoration(
//                       color: Colors.redAccent,
//                       borderRadius: BorderRadius.circular(10)
//                   ),
//                   child: Row(
//                     children: [
//                       Text('전체', style: TextStyle(color: Colors.white, fontSize: 17),),
//                       SizedBox(width: 2,),
//                       Icon(Icons.remove_circle, color: Colors.white, size: 20,),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(width: 15,),
//               GestureDetector(
//                 onTap: () {
//                   PokemonController.to.addAllPoint();
//                 },
//                 child: Container(
//                   // margin: EdgeInsets.all(4),
//                   padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
//                   decoration: BoxDecoration(
//                       color: Colors.blueAccent,
//                       borderRadius: BorderRadius.circular(10)
//                   ),
//                   child: Row(
//                     children: [
//                       Text('전체', style: TextStyle(color: Colors.white, fontSize: 17),),
//                       SizedBox(width: 2,),
//                       Icon(Icons.add_circle, color: Colors.white, size: 20,),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       );
//     }else {
//       return SizedBox();
//     }
//   }
// }
//
//
