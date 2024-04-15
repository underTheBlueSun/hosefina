import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hosefina/controller/temper_controller.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controller/main_controller.dart';
import '../controller/relation_controller.dart';


class RelationMain extends StatelessWidget {

  void checklistDialog(context, name, index) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            height: 250,
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('${name}와 왜 사이가 안좋은가요?', style: TextStyle(fontFamily: 'Jua', color: Colors.orangeAccent),),
                  TextField(
                    // controller: TextEditingController(text: content),
                    autofocus: true,
                    cursorColor: Colors.black,
                    onChanged: (value) {
                      RelationController.to.content = value;
                    },
                    style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua' , fontSize: 17, ),
                    maxLines: 7,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            // CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
            //   RelationController.to.bad_act = '';
            //   Navigator.pop(context);
            // }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장'), onPressed: () {
              RelationController.to.addChecklist(index, -1);
              Navigator.pop(context);
            })

          ],
        );
      },
    );

  }

  void badActDialog(context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            height: 250,
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Text('나외의 다른 친구에게 나쁜 말,나쁜 행동을 하는 경우를 본 적이 있으면 적어봅시다', style: TextStyle(fontFamily: 'Jua', color: Colors.orangeAccent),),
                  TextField(
                    controller: TextEditingController(text: RelationController.to.bad_act),
                    autofocus: true,
                    cursorColor: Colors.black,
                    onChanged: (value) {
                      RelationController.to.bad_act = value;
                    },
                    style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua' , fontSize: 17, ),
                    maxLines: 7,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              RelationController.to.bad_act = '';
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장'), onPressed: () {
              RelationController.to.updBadAct();
              Navigator.pop(context);
            })

          ],
        );
      },
    );

  }

  void checklist2Dialog(context, index, content) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            height: 250,
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Text('${name}와 왜 사이가 안좋은가요?', style: TextStyle(fontFamily: 'Jua', color: Colors.orangeAccent),),
                  TextField(
                    controller: TextEditingController(text: content),
                    autofocus: true,
                    cursorColor: Colors.black,
                    onChanged: (value) {
                      RelationController.to.content = value;
                    },
                    style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua' , fontSize: 17, ),
                    maxLines: 7,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장'), onPressed: () {
              RelationController.to.addChecklist(index, -1);
              Navigator.pop(context);
            })

          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('relation').where('class_code', isEqualTo: GetStorage().read('class_code'))
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
          RelationController.to.checklist_points = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

          if (snapshot.data!.docs.length > 0) {
            RelationController.to.checklist_points = [];
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_01']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_02']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_03']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_04']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_05']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_06']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_07']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_08']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_09']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_10']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_11']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_12']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_13']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_14']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_15']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_16']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_17']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_18']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_19']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_20']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_21']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_22']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_23']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_24']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_25']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_26']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_27']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_28']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_29']);
            RelationController.to.checklist_points.add(snapshot.data!.docs.first['n_30']);

            RelationController.to.checklist_cs = [];
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_01_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_02_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_03_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_04_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_05_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_06_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_07_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_08_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_09_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_10_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_11_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_12_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_13_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_14_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_15_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_16_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_17_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_18_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_19_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_20_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_21_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_22_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_23_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_24_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_25_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_26_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_27_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_28_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_29_c']);
            RelationController.to.checklist_cs.add(snapshot.data!.docs.first['n_30_c']);

            RelationController.to.bad_act = snapshot.data!.docs.first['bad_act'];

          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(color: Colors.teal.withOpacity(0.4), borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/emotion/checklist_good_02.png', height: 30, width: 30, ),
                              Text('    친하거나 친하게 지내고 싶은 경우', style: TextStyle(fontFamily: 'Jua', color: Colors.white),),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Image.asset('assets/images/emotion/checklist_bad_02.png', height: 30, width: 30, ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('    사이가 안 좋거나 나를 힘들게 하는 경우', style: TextStyle(fontFamily: 'Jua', color: Colors.white),),
                                  Text('    길게 눌러서 내용 수정', style: TextStyle(fontFamily: 'Jua', color: Colors.orangeAccent),),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: MainController.to.attendances.length,
                        itemBuilder: (BuildContext context, int index) {
                          var attendance_doc = MainController.to.attendances[index];
                          String checklist_good = 'checklist_good_01';
                          String checklist_bad = 'checklist_bad_01';
                          if (RelationController.to.checklist_points[index] == 1) {
                            checklist_good = 'checklist_good_02';
                            checklist_bad = 'checklist_bad_01';
                          }else if (RelationController.to.checklist_points[index] == 0){
                            checklist_good = 'checklist_good_01';
                            checklist_bad = 'checklist_bad_01';
                          }else{
                            checklist_good = 'checklist_good_01';
                            checklist_bad = 'checklist_bad_02';
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(attendance_doc['name'], style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua', fontSize: 17),),

                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      if (RelationController.to.checklist_points[index] == 1) {
                                        RelationController.to.addChecklist(index, 0);
                                      }else {
                                        RelationController.to.addChecklist(index, 1);
                                      }
                                    },
                                    child:
                                    checklist_good == 'checklist_good_01' ?
                                    Image.asset('assets/images/emotion/${checklist_good}.png', height: 30, width: 30, ) :
                                    Image.asset('assets/images/emotion/${checklist_good}.png', height: 30, width: 30,),
                                  ),
                                  SizedBox(width: 15,),
                                  GestureDetector(
                                    onLongPress: () {
                                      if (RelationController.to.checklist_points[index] == -1) {
                                        RelationController.to.content = RelationController.to.checklist_cs[index];
                                        checklist2Dialog(context, index, RelationController.to.checklist_cs[index]);
                                      }
                                    },
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      if (RelationController.to.checklist_points[index] == -1) {
                                        RelationController.to.content = '';
                                        RelationController.to.addChecklist(index, 0);
                                      }else {
                                        // RelationController.to.addChecklist(index, -1);
                                        checklistDialog(context, attendance_doc['name'], index);
                                      }

                                    },
                                    child:
                                    checklist_bad == 'checklist_bad_01' ?
                                    Image.asset('assets/images/emotion/${checklist_bad}.png', height: 30, width: 30,) :
                                    Image.asset('assets/images/emotion/${checklist_bad}.png', height: 30, width: 30,),
                                  ),
                                  SizedBox(width: 20,),
                                ],
                              ),
                            ],
                          );
                        }, separatorBuilder: (BuildContext context, int index) {
                        return Divider(thickness: 0.5, color: Colors.grey.withOpacity(0.5),);
                      },
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    badActDialog(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: RelationController.to.bad_act.length > 0 ?
                        Text(RelationController.to.bad_act, style: TextStyle(fontFamily: 'Jua', color: Colors.grey,),) :
                        Text('친구가 힘들어 하는 경우를 본 적이 있나요?', style: TextStyle(fontFamily: 'Jua', color: Colors.grey,),),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30,),
              ],
            )
          );
        }
    );

  }
}


