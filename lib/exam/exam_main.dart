import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hosefina/controller/exam_controller.dart';
import 'package:hosefina/controller/main_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ExamMain extends StatelessWidget {
  List subject_list = ['국어', '사회', '수학', '과학', '영어'];
  List icon_list = [Icons.menu_book_outlined, Icons.landscape_outlined, Icons.format_list_numbered, Icons.science_outlined, Icons.sort_by_alpha_outlined];
  List complete_subject_list = [];

  void deleteDialog(context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            height: 100,
            child: Material(
              color: Colors.transparent,
              child: Center(child: Text('모든 학생 답지가 삭제됩니다.\n정말 삭제하시겠습니까?', style: TextStyle(fontFamily: 'Jua', fontSize: 15),)),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('아니오'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('삭제', style: TextStyle(color: Colors.redAccent),), onPressed: () {
              ExamController.to.deleteSheet();
              Navigator.pop(context);
            })

          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {

    return
      StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('exam_sheet').where('class_code', isEqualTo: GetStorage().read('class_code'))
              .where('number', isEqualTo: GetStorage().read('number')).snapshots(),
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

            complete_subject_list = [];
            snapshot.data!.docs.forEach((doc) {
              complete_subject_list.add(doc['subject']);
            });

            return Column(
              children: [
                for (int i = 0; i < 5; i++)
                  GestureDetector(
                    onTap: () {
                      if (!complete_subject_list.contains(subject_list[i])) {
                        ExamController.to.subject = subject_list[i];
                        MainController.to.active_screen.value = 'exam_sheet';
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15)),),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 20,),
                              Row(
                                children: [
                                  Icon(icon_list[i]),
                                  SizedBox(width: 10,),
                                  Text(subject_list[i], style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 20),),
                                ],
                              ),
                              complete_subject_list.contains(subject_list[i]) ?
                              Icon(Icons.check_circle, color: Colors.orangeAccent,) : SizedBox(width: 20,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                /// 답안지 삭제 버튼
                GetStorage().read('email') == 'umssam00@gmail.com' && GetStorage().read('job') == 'teacher' ?
                Container(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent, ),
                    onPressed: () {
                      deleteDialog(context);
                    },
                    child: Text('답안지 모두 삭제', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),),
                  ),
                ) : SizedBox(),
                SizedBox(height: 10,),

              ],

            );
          }
      );

  }
}


