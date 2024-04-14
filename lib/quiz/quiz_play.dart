import 'package:slide_countdown/slide_countdown.dart';

import '../controller/main_controller.dart';
import '../controller/quiz_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_math_fork/flutter_math.dart';
// import 'package:flutter_tex/flutter_tex.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_count_down.dart';

class QuizPlay extends StatelessWidget {

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
    if (QuizController.to.quiz_type.value == '개인') {
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('quiz_question_score').where('class_code', isEqualTo: GetStorage().read('class_code'))
              .where('quiz_id', isEqualTo: QuizController.to.quiz_id).where('state', isEqualTo: 'active').snapshots(),
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
            var score_doc;
            if (score_docs.length > 0) {
              score_doc = score_docs.last;
              DocumentSnapshot doc = QuizController.to.questions.where((doc) => doc['number'] == score_doc['question_number']).first  ;
              QuizController.to.number = doc['number'];
              QuizController.to.answer.value = doc['answer'];

              return Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          /// 질문
                          // (doc['question'].contains('{') || doc['question'].contains('^2') || doc['question'].contains('[')
                          //     || doc['question'].contains('times') || doc['question'].contains('div')) && doc['question'].length > 30 ?
                          // Column(
                          //   children: [
                          //     Math.tex(
                          //       r'' + doc['question'].substring(0,30).replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                          //           .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                          //       mathStyle: MathStyle.display,
                          //       textStyle: TextStyle(fontSize: 20, color: Colors.white),
                          //     ),
                          //     Math.tex(
                          //       r'' + doc['question'].substring(30,doc['question'].length).replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                          //           .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                          //       mathStyle: MathStyle.display,
                          //       textStyle: TextStyle(fontSize: 20, color: Colors.white),
                          //     ),
                          //   ],
                          // )
                          //     :
                          // (doc['question'].contains('{') || doc['question'].contains('^2') || doc['question'].contains('[')
                          //     || doc['question'].contains('times') || doc['question'].contains('div')) ?
                          // Math.tex(
                          //   r'' + doc['question'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                          //       .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                          //   mathStyle: MathStyle.display,
                          //   textStyle: TextStyle(fontSize: 20, color: Colors.white),
                          // )

                          doc['question'].contains('{') || doc['question'].contains('^2') || doc['question'].contains('[')
                              || doc['question'].contains('times') || doc['question'].contains('div') ?
                          (doc['question'].contains('\n') || doc['question'].contains('. ')) ?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int index = 0; index < doc['question'].split('\n').length; index++)
                                for (int index2 = 0; index2 < doc['question'].split('\n')[index].split('. ').length; index2++)
                                  Math.tex(
                                    r'' + doc['question'].split('\n')[index].split('. ')[index2].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                        .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                    mathStyle: MathStyle.display,
                                    textStyle: TextStyle(fontSize: 17, color: Colors.white,),
                                  ),
                                // Math.tex(
                                //   r'' + doc['question'].split('\n')[index].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                //       .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                //   mathStyle: MathStyle.display,
                                //   textStyle: TextStyle(fontSize: 15, color: Colors.white,),
                                // ),
                            ],
                          ) :
                          Math.tex(
                            r'' + doc['question'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                            mathStyle: MathStyle.display,
                            textStyle: TextStyle(fontSize: 16, color: Colors.white),
                          )
                              :
                          Text(doc['question'], style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Jua'),),

                          SizedBox(height: 10,),
                          /// 이미지
                          Visibility(
                            // visible: true,
                            visible: doc['question_image_url'].length > 0,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                // child: Image.asset('assets/images/quiz_background2.png', fit: BoxFit.cover, width: 400,),
                                child: Image.network(doc['question_image_url'], fit: BoxFit.cover, width: 400,),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          /// 답지
                          doc['question_type'] == '단답형' ?
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                cursorColor: Colors.black,
                                autofocus: true,
                                textAlignVertical: TextAlignVertical.center,
                                onSubmitted: (value) {
                                  QuizController.to.question_type = '단답형';
                                  QuizController.to.end_date = DateTime.now().toString();
                                  QuizController.to.updUserScore(value.trim(), doc['answer']);
                                  MainController.to.active_screen.value = 'quiz_score';
                                  QuizController.to.number = doc['number'];
                                  QuizController.to.answer.value = doc['answer'];
                                },
                                style: TextStyle(color: Colors.black , fontSize: 25, ),
                                // style: TextStyle(color: Colors.white , fontSize: 16, ),
                                maxLines: 1,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: '정답을 입력하세요',
                                  hintStyle: TextStyle(fontSize: 20, color: Colors.grey.withOpacity(0.5)),
                                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white,  ),),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white,  ),),
                                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),

                                ),
                              ),
                            ),
                          ) :
                          InkWell(
                            onTap: () {
                              /// 버튼 연타때문에 async 뺌
                              QuizController.to.end_date = DateTime.now().toString();
                              QuizController.to.updUserScore('1', doc['answer']);
                              // await QuizController.to.updUserScore('1', doc['answer']);
                              MainController.to.active_screen.value = 'quiz_score';
                              QuizController.to.number = doc['number'];
                              QuizController.to.answer.value = doc['answer'];
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.9,
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8),
                                  // decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        doc['question_type'] == '선택형' ? Icon(Icons.filter_1, color: Colors.teal, size: 30,) :
                                        doc['question_type'] == 'OX형' ? Text('예', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),) : SizedBox(),
                                        SizedBox(width: 10,),
                                        doc['answer1'].contains('{') || doc['answer1'].contains('^2') || doc['answer1'].contains('[')
                                            || doc['answer1'].contains('times') || doc['answer1'].contains('div') ?
                                        Math.tex(
                                          r'' + doc['answer1'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                              .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(fontSize: 20, color: Colors.white),
                                        ) :
                                        Container(
                                            width: MediaQuery.of(context).size.width*0.7,
                                            child: Text(doc['answer1'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),),
                                            // child: Text(doc['answer1'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],),
                          ),
                          SizedBox(height: 15,),
                          doc['question_type'] != '단답형' ?
                          InkWell(
                            onTap: () {
                              QuizController.to.end_date = DateTime.now().toString();
                              QuizController.to.updUserScore('2', doc['answer']);
                              MainController.to.active_screen.value = 'quiz_score';
                              QuizController.to.number = doc['number'];
                              QuizController.to.answer.value = doc['answer'];
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.9,
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8),
                                  // decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        doc['question_type'] == '선택형' ? Icon(Icons.filter_2, color: Colors.deepPurple, size: 30,) :
                                        Text('아니오', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),),
                                        // doc['question_type'] == '선택형' ? Icon(Icons.filter_2, color: Colors.deepPurple, size: 30,) : Icon(Icons.clear, color: Colors.red, size: 30,),
                                        SizedBox(width: 10,),
                                        doc['answer2'].contains('{') || doc['answer2'].contains('^2') || doc['answer2'].contains('[')
                                            || doc['answer2'].contains('times') || doc['answer2'].contains('div') ?
                                        Math.tex(
                                          r'' + doc['answer2'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                              .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(fontSize: 20, color: Colors.white),
                                        ) :
                                        Container(
                                            width: MediaQuery.of(context).size.width*0.7,
                                            child: Text(doc['answer2'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),)),
                                            // child: Text(doc['answer2'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],),
                          ) : SizedBox(),
                          SizedBox(height: 15,),
                          doc['question_type'] == '선택형' ?
                          InkWell(
                            onTap: () {
                              QuizController.to.end_date = DateTime.now().toString();
                              QuizController.to.updUserScore('3', doc['answer']);
                              MainController.to.active_screen.value = 'quiz_score';
                              QuizController.to.number = doc['number'];
                              QuizController.to.answer.value = doc['answer'];
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.9,
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8),
                                  // decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        Icon(Icons.filter_3, color: Colors.blue, size: 30,),
                                        SizedBox(width: 10,),
                                        doc['answer3'].contains('{') || doc['answer3'].contains('^2') || doc['answer3'].contains('[')
                                            || doc['answer3'].contains('times') || doc['answer3'].contains('div') ?
                                        Math.tex(
                                          r'' + doc['answer3'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                              .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(fontSize: 20, color: Colors.white),
                                        ) :
                                        Container(
                                            width: MediaQuery.of(context).size.width*0.7,
                                            child: Text(doc['answer3'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),)),
                                            // child: Text(doc['answer3'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],),
                          ) : SizedBox(),
                          SizedBox(height: 15,),
                          doc['question_type'] == '선택형' ?
                          InkWell(
                            onTap: () {
                              QuizController.to.end_date = DateTime.now().toString();
                              QuizController.to.updUserScore('4', doc['answer']);
                              MainController.to.active_screen.value = 'quiz_score';
                              QuizController.to.number = doc['number'];
                              QuizController.to.answer.value = doc['answer'];
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.9,
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8),),
                                  // decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(8),),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        Icon(Icons.filter_4, color: Colors.orange, size: 30,),
                                        SizedBox(width: 10,),
                                        doc['answer4'].contains('{') || doc['answer4'].contains('^2') || doc['answer4'].contains('[')
                                            || doc['answer4'].contains('times') || doc['answer4'].contains('div') ?
                                        Math.tex(
                                          r'' + doc['answer4'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                              .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(fontSize: 20, color: Colors.white),
                                        ) :
                                        Container(
                                            width: MediaQuery.of(context).size.width*0.7,
                                            child: Text(doc['answer4'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),)),
                                            // child: Text(doc['answer4'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],),
                          ) : SizedBox(),
                          SizedBox(height: 15,),
                        ],),
                    ),
                  ),
                  Obx(() => Visibility(
                    visible: QuizController.to.is_visible_count_down.value,
                    child: Countdown(
                      seconds: 3,
                      build: (BuildContext context, double time) {
                        return buildCountDowntText(time.toString());
                      },
                      interval: Duration(milliseconds: 1000),
                      onFinished: () {
                        // QuizController.to.updQuestionState(doc['number'], 'active');
                        // QuizController.to.is_visible_count_down.value = false;
                      },
                    ),
                  ),
                  ),
                ],);
            }else {
              return SizedBox();
            }

          }
      );
    } else {  /// 모둠
      return Obx(() => StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('quiz_question_score').where('class_code', isEqualTo: GetStorage().read('class_code'))
                .where('quiz_id', isEqualTo: QuizController.to.quiz_id).where('question_number', isEqualTo: QuizController.to.question_number.value).snapshots(),
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
              // List score_docs = snapshot.data!.docs.toList();
              // score_docs.sort((a,b)=> a['question_number'].compareTo(b['question_number']));
              // var score_doc;

              QuizController.to.select_answer.value = 0;
              QuizController.to.submitters = [];

              if (snapshot.data!.docs.length > 0) {
                DocumentSnapshot doc = QuizController.to.questions.where((doc) => doc['number'] == QuizController.to.question_number.value).first;
                QuizController.to.score_doc_id = snapshot.data!.docs.first.id;
                QuizController.to.submitters = snapshot.data!.docs.first['submitter'];
                QuizController.to.submitters.forEach((submitter) {
                  if (submitter['name'] == GetStorage().read('name')) {
                    QuizController.to.select_answer.value = int.parse(submitter['select_answer']);
                  }
                });

                return Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Obx(() => Column(
                            children: [
                              /// 질문
                              // (doc['question'].contains('{') || doc['question'].contains('^2') || doc['question'].contains('[')
                              //     || doc['question'].contains('times') || doc['question'].contains('div')) && doc['question'].length > 30 ?
                              // Column(
                              //   children: [
                              //     Math.tex(
                              //       r'' + doc['question'].substring(0,30).replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                              //           .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                              //       mathStyle: MathStyle.display,
                              //       textStyle: TextStyle(fontSize: 20, color: Colors.white),
                              //     ),
                              //     Math.tex(
                              //       r'' + doc['question'].substring(30,doc['question'].length).replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                              //           .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                              //       mathStyle: MathStyle.display,
                              //       textStyle: TextStyle(fontSize: 20, color: Colors.white),
                              //     ),
                              //   ],
                              // )
                              //     :
                              // (doc['question'].contains('{') || doc['question'].contains('^2') || doc['question'].contains('[')
                              //     || doc['question'].contains('times') || doc['question'].contains('div')) ?
                              // Math.tex(
                              //   r'' + doc['question'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                              //       .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                              //   mathStyle: MathStyle.display,
                              //   textStyle: TextStyle(fontSize: 20, color: Colors.white),
                              // )

                              doc['question'].contains('{') || doc['question'].contains('^2') || doc['question'].contains('[')
                                  || doc['question'].contains('times') || doc['question'].contains('div') ?
                              doc['question'].contains('\n') ?
                              Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      for (int index = 0; index < doc['question'].split('\n').length; index++)
                                        Math.tex(
                                          r'' + doc['question'].split('\n')[index].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                              .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}')
                                              .replaceAll('kg', r'{kg}').replaceAll('L', r'{L}')
                                              .replaceAll('km', r'{km}').replaceAll('m', r'{m}').replaceAll('cm', r'{cm}').replaceAll('mm', r'{mm}') + r'',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(fontSize: 50, color: Colors.black,),
                                        ),
                                    ],
                                  )
                              ) :
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Math.tex(
                                  r'' + doc['question'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                      .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}')
                                      .replaceAll('kg', r'{kg}').replaceAll('L', r'{L}')
                                      .replaceAll('m', r'{m}').replaceAll('cm', r'{cm}').replaceAll('mm', r'{mm}') + r'',
                                  mathStyle: MathStyle.display,
                                  textStyle: TextStyle(fontSize: 50, color: Colors.black),
                                ),
                              )
                                  :
                              Text(doc['question'], style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Jua'),),


                              SizedBox(height: 10,),
                              /// 이미지
                              Visibility(
                                // visible: true,
                                visible: doc['question_image_url'].length > 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    // child: Image.asset('assets/images/quiz_background2.png', fit: BoxFit.cover, width: 400,),
                                    child: Image.network(doc['question_image_url'], fit: BoxFit.cover, width: 400,),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              /// 답지
                              InkWell(
                                onTap: () {
                                  if (QuizController.to.select_answer.value == 0) {
                                    QuizController.to.select_answer.value = 1;
                                    /// 버튼 연타때문에 async 뺌
                                    QuizController.to.end_date = DateTime.now().toString();
                                    QuizController.to.updUserScore('1', doc['answer']);
                                    // MainController.to.active_screen.value = 'quiz_score';
                                    QuizController.to.number = doc['number'];
                                    QuizController.to.answer.value = doc['answer'];
                                  }

                                },
                                child: Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width*0.9,
                                    decoration: BoxDecoration(color: QuizController.to.select_answer.value == 1 ? Colors.teal.withOpacity(0.5) : Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        children: [
                                          doc['question_type'] == '선택형' ? Icon(Icons.filter_1, color: Colors.teal, size: 30,) :
                                          doc['question_type'] == 'OX형' ? Text('예', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),) : SizedBox(),
                                          SizedBox(width: 10,),
                                          doc['answer1'].contains('{') || doc['answer1'].contains('^2') || doc['answer1'].contains('[')
                                              || doc['answer1'].contains('times') || doc['answer1'].contains('div') ?
                                          Math.tex(
                                            r'' + doc['answer1'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                                .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                            mathStyle: MathStyle.display,
                                            textStyle: TextStyle(fontSize: 20, color: Colors.white),
                                          ) :
                                          Container(
                                              width: MediaQuery.of(context).size.width*0.7,
                                              child: Text(doc['answer1'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15,),
                              doc['question_type'] != '단답형' ?
                              InkWell(
                                onTap: () {
                                  if (QuizController.to.select_answer.value == 0) {
                                    QuizController.to.select_answer.value = 2;
                                    QuizController.to.end_date = DateTime.now().toString();
                                    QuizController.to.updUserScore('2', doc['answer']);
                                    // MainController.to.active_screen.value = 'quiz_score';
                                    QuizController.to.number = doc['number'];
                                    QuizController.to.answer.value = doc['answer'];
                                  }

                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.9,
                                  decoration: BoxDecoration(color: QuizController.to.select_answer.value == 2 ? Colors.teal.withOpacity(0.5) : Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        doc['question_type'] == '선택형' ? Icon(Icons.filter_2, color: Colors.deepPurple, size: 30,) :
                                        Text('아니오', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),),
                                        // doc['question_type'] == '선택형' ? Icon(Icons.filter_2, color: Colors.deepPurple, size: 30,) : Icon(Icons.clear, color: Colors.red, size: 30,),
                                        SizedBox(width: 10,),
                                        doc['answer2'].contains('{') || doc['answer2'].contains('^2') || doc['answer2'].contains('[')
                                            || doc['answer2'].contains('times') || doc['answer2'].contains('div') ?
                                        Math.tex(
                                          r'' + doc['answer2'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                              .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(fontSize: 20, color: Colors.white),
                                        ) :
                                        Container(
                                            width: MediaQuery.of(context).size.width*0.7,
                                            child: Text(doc['answer2'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),)),
                                      ],
                                    ),
                                  ),
                                ),
                              ) : SizedBox(),
                              SizedBox(height: 15,),
                              doc['question_type'] == '선택형' ?
                              InkWell(
                                onTap: () {
                                  if (QuizController.to.select_answer.value == 0) {
                                    QuizController.to.select_answer.value = 3;
                                    QuizController.to.end_date = DateTime.now().toString();
                                    QuizController.to.updUserScore('3', doc['answer']);
                                    // MainController.to.active_screen.value = 'quiz_score';
                                    QuizController.to.number = doc['number'];
                                    QuizController.to.answer.value = doc['answer'];
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.9,
                                  decoration: BoxDecoration(color: QuizController.to.select_answer.value == 3 ? Colors.teal.withOpacity(0.5) : Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        Icon(Icons.filter_3, color: Colors.blue, size: 30,),
                                        SizedBox(width: 10,),
                                        doc['answer3'].contains('{') || doc['answer3'].contains('^2') || doc['answer3'].contains('[')
                                            || doc['answer3'].contains('times') || doc['answer3'].contains('div') ?
                                        Math.tex(
                                          r'' + doc['answer3'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                              .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(fontSize: 20, color: Colors.white),
                                        ) :
                                        Container(
                                            width: MediaQuery.of(context).size.width*0.7,
                                            child: Text(doc['answer3'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),)),
                                      ],
                                    ),
                                  ),
                                ),
                              ) : SizedBox(),
                              SizedBox(height: 15,),
                              doc['question_type'] == '선택형' ?
                              InkWell(
                                onTap: () {
                                  if (QuizController.to.select_answer.value == 0) {
                                    QuizController.to.select_answer.value = 4;
                                    QuizController.to.end_date = DateTime.now().toString();
                                    QuizController.to.updUserScore('4', doc['answer']);
                                    // MainController.to.active_screen.value = 'quiz_score';
                                    QuizController.to.number = doc['number'];
                                    QuizController.to.answer.value = doc['answer'];
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width*0.9,
                                  decoration: BoxDecoration(color: QuizController.to.select_answer.value == 4 ? Colors.teal.withOpacity(0.5) : Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(8),),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        Icon(Icons.filter_4, color: Colors.orange, size: 30,),
                                        SizedBox(width: 10,),
                                        doc['answer4'].contains('{') || doc['answer4'].contains('^2') || doc['answer4'].contains('[')
                                            || doc['answer4'].contains('times') || doc['answer4'].contains('div') ?
                                        Math.tex(
                                          r'' + doc['answer4'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                              .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(fontSize: 20, color: Colors.white),
                                        ) :
                                        Container(
                                            width: MediaQuery.of(context).size.width*0.7,
                                            child: Text(doc['answer4'], style: TextStyle(fontFamily: 'NanumGothic', fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),)),
                                      ],
                                    ),
                                  ),
                                ),
                              ) : SizedBox(),
                              SizedBox(height: 50,),
                            ],),
                        ),
                      ),
                    ),

                    Obx(() => Visibility(
                      visible: QuizController.to.is_visible_count_down.value,
                      child: Countdown(
                        seconds: 3,
                        build: (BuildContext context, double time) {
                          return buildCountDowntText(time.toString());
                        },
                        interval: Duration(milliseconds: 1000),
                        onFinished: () {
                          // QuizController.to.updQuestionState(doc['number'], 'active');
                          // QuizController.to.is_visible_count_down.value = false;
                        },
                      ),
                    ),
                    ),
                  ],);
              }else {
                return SizedBox();
              }



            }
        ),
      );
    }

  }
}


