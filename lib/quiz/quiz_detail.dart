import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';

import '../common/sliverGridDelegateWithFixedCrossAxisCountAndFixedHeight.dart';
import '../controller/main_controller.dart';
import '../controller/quiz_controller.dart';

class QuizDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('quiz_question').where('quiz_id', isEqualTo: QuizController.to.quiz_id).snapshots(),
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
          docs.sort((a,b)=> a['date'].compareTo(b['date']));
          return GridView.builder(
            primary: false,
            shrinkWrap: true,
            padding: EdgeInsets.all(15),
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 :  1,
              // crossAxisSpacing: 5,
              // mainAxisSpacing: 5,
              height: 350,  /// 높이 지정
            ),
            // SliverGridDelegateWithFixedCrossAxisCount(
            //   crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 :  1,
            //   childAspectRatio: MediaQuery.of(context).size.width > 1000 ? 2/1.2 : MediaQuery.of(context).size.width > 600  ? 2/1.7 : 2/1.2,
            // ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = docs[index];
              return Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  // width: MediaQuery.of(context).size.width*0.85/2,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white),
                  // decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.withOpacity(0.5),width: 2,),),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// 번호 동그라미
                          Container(
                            width: 19,
                            child:
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Center(
                                child: Text(doc['number'].toString(), style: TextStyle(color: Colors.white, fontSize: 12,),),
                              ),
                            ),
                          ),
                          /// 질문
                          Row(
                            children: [
                              doc['question'].contains('{') || doc['question'].contains('^2') || doc['question'].contains('[')
                                  || doc['question'].contains('times') || doc['question'].contains('div') ?
                              (doc['question'].contains('\n') || doc['question'].contains('. ')) ?
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int index = 0; index < doc['question'].split('\n').length; index++)
                                    for (int index2 = 0; index2 < doc['question'].split('\n')[index].split('. ').length; index2++)
                                      Math.tex(
                                        r'' + doc['question'].split('\n')[index].split('. ')[index2].replaceAll('/', r'\over').replaceAll(' ', r'\space')
                                            .replaceAll('[', '□').replaceAll(']', '').replaceAll('times', r'\times').replaceAll('div', '÷')
                                            .replaceAll('^2', r'{^2}').replaceAll('kg', r'{kg}').replaceAll('L', r'{L}')
                                            .replaceAll('km', r'{km}').replaceAll('m', r'{m}').replaceAll('cm', r'{cm}').replaceAll('mm', r'{mm}') + r'',
                                        mathStyle: MathStyle.display,
                                        textStyle: TextStyle(color: Colors.black, fontSize: 13 ),
                                      ),

                                  /// 모바일은 TeXView 사용. 왜냐 TeXView는 한 화면에 여러개 사용하면 꼬임. 근데 TeXView는 자동으로 줄바꿔주어서 좋음(안드는 안되서 사용안함)
                                  // Math.tex(
                                  //   r'' + doc['question'].split('\n')[index].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                  //       .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                  //   mathStyle: MathStyle.display,
                                  //   textStyle: TextStyle( color: Colors.black),
                                  // ),
                                ],
                              ) :
                              Container(
                                width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width/2.4 : MediaQuery.of(context).size.width/1.2,
                                child: Math.tex(
                                  r'' + doc['question'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                      .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}')
                                      .replaceAll('kg', r'{kg}').replaceAll('L', r'{L}')
                                      .replaceAll('km', r'{km}').replaceAll('m', r'{m}').replaceAll('cm', r'{cm}').replaceAll('mm', r'{mm}')+ r'',
                                  mathStyle: MathStyle.display, textStyle: TextStyle( color: Colors.black, fontSize: 13),
                                ),
                              ):
                              Container(
                                width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width/2.4 : MediaQuery.of(context).size.width/1.2,
                                child: Text(doc['question'], style: TextStyle(fontFamily: 'NanumGothic',  color: Colors.black ),),
                              ),

                            ],
                          ),
                          SizedBox(height: 15,),
                          /// 답지1
                          Row( 
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width/2.4 : MediaQuery.of(context).size.width/1.2,
                                // width: doc['question_image_url'].length > 0 ? MediaQuery.of(context).size.width*0.25 : MediaQuery.of(context).size.width*0.3,
                                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),
                                ),
                                child: doc['question_type'] == '단답형' ?
                                Container(
                                  width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width/2.4 : MediaQuery.of(context).size.width/1.2,
                                  child: Text(doc['answer'], style: TextStyle(  color: Colors.black),),
                                ) :
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      doc['question_type'] == '선택형' ? Icon(Icons.filter_1, color: Colors.teal,) :
                                      doc['question_type'] == 'OX형' ? Text('예', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),) : SizedBox(),
                                      SizedBox(width: 10,),
                                      doc['answer1'].contains('{') || doc['answer1'].contains('^2') || doc['answer1'].contains('[')
                                          || doc['answer1'].contains('times') || doc['answer1'].contains('div') ?
                                      Expanded(
                                        child: Math.tex(
                                          r'' + doc['answer1'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                              .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(fontSize: 16, color: Colors.black),
                                        ),
                                      ) :
                                      Expanded(
                                        child: Container(
                                          child: Text(doc['answer1'], style: TextStyle( color: Colors.black ),),
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      doc['answer'] == '1' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
                                    ],
                                  ),
                                ),
                              ),
                            ],),
                          SizedBox(height: 10,),
                          doc['question_type'] != '단답형' ?
                          /// 답지2
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width/2.4 : MediaQuery.of(context).size.width/1.2,
                                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      doc['question_type'] == '선택형' ? Icon(Icons.filter_2, color: Colors.deepPurple,) :
                                      Text('아니오', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                                      // doc['question_type'] == '선택형' ? Icon(Icons.filter_2, color: Colors.deepPurple,) : Icon(Icons.clear  , color: Colors.red,),
                                      SizedBox(width: 10,),
                                      doc['answer2'].contains('{') || doc['answer2'].contains('^2') || doc['answer2'].contains('[')
                                          || doc['answer2'].contains('times') || doc['answer2'].contains('div') ?
                                      Expanded(
                                        child: Math.tex(
                                          r'' + doc['answer2'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                              .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(fontSize: 16, color: Colors.black),
                                        ),
                                      ) :
                                      Expanded(
                                        child: Container(
                                          child: Text(doc['answer2'], style: TextStyle( color: Colors.black ),),
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      doc['answer'] == '2' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
                                    ],
                                  ),
                                ),
                              ),
                            ],) : SizedBox(),
                          SizedBox(height: 10,),
                          doc['question_type'] == '선택형' ?
                          /// 답지3
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width/2.4 : MediaQuery.of(context).size.width/1.2,
                                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Icon(Icons.filter_3, color: Colors.blue,),
                                      SizedBox(width: 10,),
                                      doc['answer3'].contains('{') || doc['answer3'].contains('^2') || doc['answer3'].contains('[')
                                          || doc['answer3'].contains('times') || doc['answer3'].contains('div') ?
                                      Expanded(
                                        child: Math.tex(
                                          r'' + doc['answer3'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                              .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(fontSize: 16, color: Colors.black),
                                        ),
                                      ) :
                                      Expanded(
                                        child: Container(
                                            child: Text(doc['answer3'], style: TextStyle( color: Colors.black ),)),
                                      ),
                                      SizedBox(width: 5,),
                                      doc['answer'] == '3' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
                                    ],
                                  ),
                                ),
                              ),
                            ],) : SizedBox(),
                          SizedBox(height: 10,),
                          doc['question_type'] == '선택형' ?
                          /// 답지4
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width > 600 ? MediaQuery.of(context).size.width/2.4 : MediaQuery.of(context).size.width/1.2,
                                decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(8),),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Icon(Icons.filter_4, color: Colors.orange,),
                                      SizedBox(width: 10,),
                                      doc['answer4'].contains('{') || doc['answer4'].contains('^2') || doc['answer4'].contains('[')
                                          || doc['answer4'].contains('times') || doc['answer4'].contains('div') ?
                                      Expanded(
                                        child: Math.tex(
                                          r'' + doc['answer4'].replaceAll('/', r'\over').replaceAll(' ', r'\space').replaceAll('[', '□').replaceAll(']', '')
                                              .replaceAll('times', r'\times').replaceAll('div', '÷').replaceAll('^2', r'{^2}') + r'',
                                          mathStyle: MathStyle.display,
                                          textStyle: TextStyle(fontSize: 16, color: Colors.black),
                                        ),
                                      ) :
                                      Expanded(
                                        child: Container(
                                            child: Text(doc['answer4'], style: TextStyle(  color: Colors.black),)),
                                      ),
                                      SizedBox(width: 5,),
                                      doc['answer'] == '4' ? Icon(Icons.circle_outlined, color: Colors.green,) : Icon(Icons.clear, color: Colors.red,),
                                    ],
                                  ),
                                ),
                              ),
                            ],) : SizedBox(),
                          Visibility(
                            visible: doc['question_image_url'].length > 0,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Image.network(doc['question_image_url'], fit: BoxFit.cover, width: 180,),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );

            },

          );

        }
    );

  }
}


