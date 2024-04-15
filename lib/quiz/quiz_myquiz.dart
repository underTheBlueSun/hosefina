import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hosefina/quiz/quiz_detail.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../common/sliverGridDelegateWithFixedCrossAxisCountAndFixedHeight.dart';
import '../controller/main_controller.dart';
import '../controller/quiz_controller.dart';

class QuizMyQuiz extends StatelessWidget {

  void detailDialog(context) {
    /// 전체화면에서 다이어로그 띄우기
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      pageBuilder: (_,__,___) {
        return Scaffold(
          // backgroundColor: Color(0xFF5E5E5E),
          appBar: AppBar(
            centerTitle: false, // 왼쪽에 두기위해
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Color(0xFF76B8C3),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white.withOpacity(0.7),size: 30,),),
                ),
                Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.transparent,size: 30,),),
              ],
            ),
          ),
          body: QuizDetail(),
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Text('나의 퀴즈', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontWeight: FontWeight.bold, fontSize: 35,),),
            // child: Text('나의 퀴즈', style: TextStyle(color: Color(0xff76B8C3), fontFamily: 'Jua', fontWeight: FontWeight.bold, fontSize: 35,),),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('quiz_main').where('class_code', isEqualTo: GetStorage().read('class_code')).snapshots(),
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
                List docs = snapshot.data!.docs.toList();
                docs.sort((a,b)=> b['date'].compareTo(a['date']));

                return
                  GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                      crossAxisCount: MediaQuery.of(context).size.width > 1100 ? 4 : MediaQuery.of(context).size.width > 600 ? 3 : 1,
                      // crossAxisSpacing: 5,
                      // mainAxisSpacing: 5,
                      height: 150,  /// 높이 지정
                    ),
                    // SliverGridDelegateWithFixedCrossAxisCount(
                    //   crossAxisCount: MediaQuery.of(context).size.width > 1100 ? 4 : MediaQuery.of(context).size.width > 600 ? 3 : 1,
                    //   // crossAxisCount : (MediaQuery.of(context).size.width/250).floor(),
                    //   /// 0.78인 이유는 singlescrollview 할때 끝에 잘리지 않게 하기위해
                    //   childAspectRatio: 1 / 0.55,
                    // ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          // color: Color(0xff76B8C3),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                          // decoration: BoxDecoration(color: Color(0xff76B8C3), borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    QuizController.to.quiz_id = doc.id;
                                    QuizController.to.quiz_title.value = doc['title'];
                                    QuizController.to.quiz_description = doc['description'];
                                    QuizController.to.quiz_grade.value = doc['grade'];
                                    QuizController.to.quiz_semester.value = doc['semester'];
                                    QuizController.to.quiz_subject.value = doc['subject'];
                                    QuizController.to.quiz_quiz_type.value = doc['quiz_type'];
                                    QuizController.to.quiz_quiz_title.value = doc['title'];
                                    // QuizController.to.quiz_question_type.value = doc['question_type'];
                                    QuizController.to.quiz_indi_timer.value = doc['indi_timer'];
                                    QuizController.to.quiz_modum_total_timer.value = doc['modum_total_timer'];
                                    QuizController.to.quiz_modum_indi_timer.value = doc['modum_indi_timer'];
                                    QuizController.to.quiz_public_type.value = doc['public'];
                                    QuizController.to.quiz_date = doc['date'].toDate();

                                    detailDialog(context);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    width: MediaQuery.sizeOf(context).width,
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Text(doc['title'], maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 17,),),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.cloud_download, size: 18, color: Colors.black,),
                                        // Icon(Icons.favorite_border, size: 18, color: Colors.black,),
                                        SizedBox(width: 3,),
                                        Text(doc['like'].toString(), style: TextStyle(color: Colors.black, fontSize: 12,),),
                                      ],
                                    ),

                                    Text(DateFormat('yy.MM.dd').format(doc['date'].toDate()).toString(), style: TextStyle(color: Colors.black, fontSize: 12,),),
                                    // Text(doc['date'].toDate().year.toString()+'.'+doc['date'].toDate().month.toString()+'.'+doc['date'].toDate().day.toString(), style: TextStyle(color: Colors.black, fontSize: 12,),),
                                    Text(GetStorage().read('email').substring(0, GetStorage().read('email').indexOf('@')), style: TextStyle(color: Colors.black, fontSize: 12,),),
                                  ],
                                ),
                              ),
                            ],),
                        ),
                      );
                    },

                  );
              }
          ),

        ],),
    );

  }
}


