import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../controller/main_controller.dart';
import '../controller/quiz_controller.dart';
import 'package:get/get.dart';

class QuizReady extends StatelessWidget {

  Container buildCountDowntText(time_double) {
    String time = time_double.toInt().toString();
    if (time == '0') {
      return Container(
        alignment: Alignment.topCenter,
        width: 200,
        child: Text('출발!', style: TextStyle(fontSize: 100, fontFamily: 'Jua', color: Colors.orange,),),
      );
    }else {
      return Container(
        alignment: Alignment.topCenter,
        width: 200,
        child: Text(time, style: TextStyle(fontSize: 100, fontFamily: 'Jua', color: Colors.orange,),),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    /// 입장하면 true
    QuizController.to.updIsActiveTrue();

    return
      StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('quiz_question_score').where('class_code', isEqualTo: GetStorage().read('class_code'))
              .snapshots(),
              // .where('quiz_id', isEqualTo: 'hQJfjK1MwxIai4UbdYtP').where('state', isEqualTo: 'ready').snapshots(),
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
            List score_docs = snapshot.data!.docs.toList();
            score_docs.sort((a,b)=> a['question_number'].compareTo(b['question_number']));

            if (score_docs.length > 0) {
              DocumentSnapshot score_doc = score_docs.last;
              QuizController.to.quiz_id = score_doc['quiz_id'];
              QuizController.to.quiz_indi_timer.value = score_doc['indi_timer'];
              QuizController.to.quiz_modum_total_timer.value = score_doc['modum_total_timer'];
              QuizController.to.quiz_modum_indi_timer.value = score_doc['modum_indi_timer'];
              QuizController.to.quiz_type.value = score_doc['quiz_type'];
              QuizController.to.quiz_title.value = score_doc['quiz_title'];
              QuizController.to.score_doc_id = score_doc.id;  /// updUserScore() 에 사용
              QuizController.to.createQuestionList(); /// question 미리 가져오기

              // if (score_doc['state'] == 'ready') {
              //   QuizController.to.is_visible_loading.value = false;
              //   QuizController.to.is_visible_count_down.value = true;
              // }

              QuizController.to.is_visible_loading.value = false;
              QuizController.to.is_visible_count_down.value = true;
            }
            else{
              QuizController.to.is_visible_count_down.value = false;
            }

            return Center(
              child: Column(
                children: [
                  SizedBox(height: 80,),
                  Image.asset('assets/images/mobile_quiz_title.png', fit: BoxFit.cover, width: 150,),
                  // Image.asset('assets/images/quiz_logo.png', fit: BoxFit.cover, width: 200,),
                  SizedBox(height: 50,),
                  Text('대기중...', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 25),),
                  SizedBox(height: 20,),
                  Text('모두가 입장할 때까지\n잠시 기다려주세요.', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),),
                  SizedBox(height: 15,),
                  Obx(() => Visibility(
                    visible: QuizController.to.is_visible_loading.value,
                    child: Container(
                      height: 40,
                      child: LoadingIndicator(
                          indicatorType: Indicator.ballPulse,
                          colors: MainController.to.kDefaultRainbowColors,
                          strokeWidth: 2,
                          backgroundColor: Colors.transparent,
                          pathBackgroundColor: Colors.transparent
                      ),
                    ),
                  ),
                  ),
                  Obx(() => Visibility(
                    visible: QuizController.to.is_visible_count_down.value,
                    child: Countdown(
                      seconds: 3,
                      build: (BuildContext context, double time) {
                        return buildCountDowntText(time);
                      },
                      interval: Duration(milliseconds: 1000),
                      onFinished: () {
                        QuizController.to.question_number.value = 1;
                        QuizController.to.is_visible_count_down.value = false;
                        MainController.to.active_screen.value = 'quiz_play';
                        QuizController.to.start_date = DateTime.now().toString();
                      },
                    ),
                  ),
                  ),



                ],
              ),
            );

          }
      );

  }

}






