import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../controller/board_controller.dart';
import '../controller/main_controller.dart';
import '../controller/subject_controller.dart';

class SubjectEdit extends StatelessWidget {

  void saveSubjectDialog(context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            width: 150,
            height: 170,
            // color: Color(0xFF5E5E5E),
            child: Material(
              color: Colors.transparent,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 170,
                      child: TextField(
                        autofocus: true,
                        controller: TextEditingController(text: SubjectController.to.subject),
                        onChanged: (value) {
                          SubjectController.to.subject = value;
                        },
                        style: TextStyle(fontFamily: 'Jua',  ),
                        maxLines: 10,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
                        ),
                      ),
                    ),

                  ]
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장', ), onPressed: () async{
              // SubjectController.to.mmdd = DateTime.now().month.toString().padLeft(2,'0') + DateTime.now().day.toString().padLeft(2,'0');
              await SubjectController.to.saveSubject2();
              await SubjectController.to.getSubjects();
              SubjectController.to.dummy_date.value = DateTime.now().toString();
              Navigator.pop(context);
            }),

          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
        child: Column(
          children: [
            /// 더미
            Text(SubjectController.to.dummy_date.value, style: TextStyle(fontSize: 0),),
            Padding(
              padding: const EdgeInsets.all(8),
              child: AlignedGridView.count(
                  shrinkWrap: true,
                  primary: false,
                  physics: NeverScrollableScrollPhysics(),
                  // crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 3,
                  crossAxisCount: MediaQuery.of(context).size.width > 1000 ? 4 : MediaQuery.of(context).size.width > 600 ? 3 : 1, /// 아이패드가 가로면? 세로면? 아이폰이면
                  crossAxisSpacing: 15,
                  itemCount: SubjectController.to.subjects.length,
                  itemBuilder: (_, index) {
                    var mmdd = SubjectController.to.subjects[index].mmdd;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          SubjectController.to.subject_id = SubjectController.to.subjects[index].id;
                          SubjectController.to.mmdd = SubjectController.to.subjects[index].mmdd;
                          SubjectController.to.subject = SubjectController.to.subjects[index].subject;
                          saveSubjectDialog(context);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                    width: 70,
                                  height: 20,
                                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
                                    child: Text('  ' + mmdd.substring(0,2) + '.' + mmdd.substring(2,4), style: TextStyle(fontFamily: 'Jua', fontSize: 14, color: Colors.orangeAccent),),
                                ),

                              ],
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width,
                                height: 60,
                                decoration: BoxDecoration(color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8), topRight: Radius.circular(8))),
                                // decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(SubjectController.to.subjects[index].subject,  maxLines: 2,
                                    overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'Jua', fontSize: 16, color: Colors.white),),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }
              ),
            ),
            SizedBox(height: 100,),
          ],
        ),
      ),
    );

  }
}



