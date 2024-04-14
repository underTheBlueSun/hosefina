import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../controller/main_controller.dart';
import '../controller/quiz_controller.dart';
import 'package:get/get.dart';

class QuizScore extends StatelessWidget {

  Container buildCountDowntText(time_double) {
    String time = time_double.toInt().toString();
    if (time == '0') {
      return Container(
        alignment: Alignment.topCenter,
        width: 170,
        child: Text('출발!', style: TextStyle(fontSize: 70, fontFamily: 'Jua', color: Colors.orange,),),
      );
    }else {
      return Container(
        alignment: Alignment.topCenter,
        width: 170,
        child: Text(time, style: TextStyle(fontSize: 70, fontFamily: 'Jua', color: Colors.orange,),),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (QuizController.to.quiz_type.value == '개인') {
      /// 타이머 다 돌기전에 클릭시
      Future.delayed( Duration(milliseconds: QuizController.to.remain_time.toInt()*1000 + 1000), () async{ // 1초정도 더 늦게 결과값 받아오는게 안전하지않을까 싶어서
        await QuizController.to.scoreQuestion(QuizController.to.number, QuizController.to.answer.value);
        await QuizController.to.scoreTotal();
        await QuizController.to.scoreMobile();
        QuizController.to.is_visible_score.value = true;
      });

      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('quiz_question_score').where('class_code', isEqualTo: GetStorage().read('class_code'))
              .where('quiz_id', isEqualTo: QuizController.to.quiz_id).where('state', isEqualTo: 'ready').snapshots(),
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
              QuizController.to.score_doc_id = score_doc.id;  /// updUserScore() 에 사용
              if (score_doc['state'] == 'ready') {
                QuizController.to.is_visible_count_down.value = true;
              }
            }

            return Obx(() => Center(
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  QuizController.to.is_visible_score.value == false ?
                  Column(
                    children: [
                      Text('문제 풀이시간이 아직 끝나지 않았습니다.', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),),
                      SizedBox(height: 10,),
                      Text('잠시 기다려주세요', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),),
                      SizedBox(height: 30,),
                      Container(
                        height: 40,
                        child: LoadingIndicator(
                            indicatorType: Indicator.ballPulse,
                            colors: MainController.to.kDefaultRainbowColors,
                            strokeWidth: 2,
                            backgroundColor: Colors.transparent,
                            pathBackgroundColor: Colors.transparent
                        ),
                      ),
                    ],
                  ) :
                  Column(
                    children: [
                      QuizController.to.correct == 'O' ?
                      Column(
                        children: [
                          Image.asset('assets/images/marie_02.png', width: 100,),
                          SizedBox(height: 30,),
                          Text('정답입니다', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 40),),
                        ],
                      ) :
                      Column(
                        children: [
                          Image.asset('assets/images/marie_01.png', width: 100,),
                          SizedBox(height: 30,),
                          Text('오답입니다', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 40),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Divider(color: Colors.grey,),
                      SizedBox(height: 20,),
                      Text('나의 ${QuizController.to.number}번 문제 순위', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),),
                      Text(QuizController.to.rank_question_index == -1 ?
                      QuizController.to.score_question_list.length.toString() + '/' + QuizController.to.score_question_list.length.toString() :
                      QuizController.to.rank_question_index.toString() + '/' + QuizController.to.score_question_list.length.toString(),
                        style: TextStyle(color: Colors.orange, fontFamily: 'Jua', fontSize: 30),),
                      SizedBox(height: 20,),
                      Text('나의 전체 순위', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),),
                      Text(QuizController.to.rank_tatal_index.toString() + '/' + QuizController.to.total_list.length.toString(), style: TextStyle(color: Colors.teal, fontFamily: 'Jua', fontSize: 30),),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Obx(() => Visibility(
                    visible: QuizController.to.is_visible_count_down.value,
                    child: Countdown(
                      seconds: 3,
                      build: (BuildContext context, double time) {
                        return buildCountDowntText(time);
                      },
                      interval: Duration(milliseconds: 1000),
                      onFinished: () {
                        QuizController.to.is_visible_count_down.value = false;
                        MainController.to.active_screen.value = 'quiz_play';
                        QuizController.to.start_date = DateTime.now().toString();
                        QuizController.to.is_visible_score.value = false;

                      },
                    ),
                  ),
                  ),
                ],
              ),
            ),
            );


          }
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
          SizedBox(height: 100,),
            ///  문항수
            Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('문제수', style: TextStyle(fontFamily: 'Jua', color: Colors.white, fontSize: 20),),
                    Text(QuizController.to.questions.length.toString(), style: TextStyle(fontFamily: 'Jua', color: Colors.orange),),
                  ],
                ),
              ),
            ),
          SizedBox(height: 30,),
            ///  맞춘갯수
            Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('맞춘 개수', style: TextStyle(fontFamily: 'Jua', color: Colors.white, fontSize: 20),),
                    Text(QuizController.to.score.toString(), style: TextStyle(fontFamily: 'Jua', color: Colors.teal),),
                  ],
                ),
              ),
            ),
        ],),
      );
    }


  }

}






