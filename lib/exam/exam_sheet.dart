import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hosefina/controller/exam_controller.dart';
import 'package:hosefina/controller/main_controller.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamSheet extends StatelessWidget {
  List won_num_list = ['①', '②', '③', '④'];
  // List won_num_list = ['①', '②', '③', '④', '⑤'];

  @override
  Widget build(BuildContext context) {

    void submittDialog(context) {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Container(
              height: 100,
              child: Material(
                color: Colors.transparent,
                child: Center(child: Text('제출하면 더 이상 수정할 수 없습니다.\n정말 제출하시겠습니까?', style: TextStyle(fontFamily: 'Jua', fontSize: 15),)),
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(isDefaultAction: true, child: Text('아니오'), onPressed: () {
                Navigator.pop(context);
              }),
              CupertinoDialogAction(isDefaultAction: true, child: Text('제출합니다', style: TextStyle(color: Colors.redAccent),), onPressed: () {
                ExamController.to.addSheet();
                // ExamController.to.complete_subject_list.add(ExamController.to.subject);
                MainController.to.active_screen.value = 'exam_main';
                Navigator.pop(context);
              })

            ],
          );
        },
      );

    }

    return SingleChildScrollView(
      child: Obx(() => Column(
        children: [
          Text(ExamController.to.dummy_date.value, style: TextStyle(fontSize: 0),),
          Padding(
              padding: const EdgeInsets.all(15),
              // padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 60),
              child: Table(
                border: TableBorder.all(color: Colors.black.withOpacity(0.3)),
                // border: TableBorder.symmetric(inside: BorderSide(color: Colors.white.withOpacity(0.5))),
                children: [
                  /// 번호
                  for (int number = 1; number < 26; number++)
                  TableRow(children: [
                    TableCell(
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        color: Colors.black.withOpacity(0.4),
                        child: Text(number.toString(), style: TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ),
                    /// 답지
                    for (int i = 0; i < 4; i++)
                      TableCell(
                        child: GestureDetector(
                          onTap: () {
                            ExamController.to.answer_list.value[ExamController.to.answer_list.value.indexWhere((e) => e.number == number)].answer = i+1;
                            ExamController.to.dummy_date.value = DateTime.now().toString();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 40,
                            color: ExamController.to.answer_list.value[ExamController.to.answer_list.value.indexWhere((answer) => answer.number == number)].answer == i+1 ?
                            Colors.redAccent.withOpacity(0.8) : Colors.white,
                            child: Text(won_num_list[i], style: TextStyle(fontSize: 25, color: Colors.black),),
                          ),
                        ),
                      ),
                  ]),

                ],
              ),
            ),
          SizedBox(height: 20,),
          /// 제출버튼
          Container(
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, ),
              onPressed: () async{
                submittDialog(context);
              },
              child: Text('제출하기', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),),
            ),
          ),
          SizedBox(height: 50,),
        ],
      ),
      ),
    );

  }
}


