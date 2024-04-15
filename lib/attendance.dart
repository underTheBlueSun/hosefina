import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hosefina/controller/main_controller.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Attendance extends StatelessWidget {

  void checkMyNameDialog(context, id, number, name) {
    showCupertinoDialog(
      context: context,
      // barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            width: 140, height: 100,
            child: Column(
              children: [
                Text('나의 이름이', style: TextStyle(fontFamily: 'Jua', fontSize: 17),),
                Text(name, style: TextStyle(color: Colors.teal, fontFamily: 'Jua', fontSize: 25),),
                Text('맞나요?', style: TextStyle(fontFamily: 'Jua', fontSize: 17),),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('아닙니다'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('맞습니다'), onPressed: () {
              MainController.to.addVisit(id, number, name);
              Navigator.pop(context);
            })

          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [
          Text('자신의 이름을 선택하세요', style: TextStyle(color: Colors.white, fontFamily: 'Jua'),),
          SizedBox(height: 10,),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('class_info').where('class_code', isEqualTo: GetStorage().read('class_code')).snapshots(),
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

                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Container(
                      width: 500, height: 250,
                      decoration: BoxDecoration(
                        color: Color(0xFF4C4C4C),
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(width: 3, color: Colors.grey.withOpacity(0.5),),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Container(
                                width: 500,
                                child: Center(child: Text('출석부가 존재하지 않습니다', style: TextStyle(fontFamily: 'Jua', fontSize: 30, color: Colors.orangeAccent),))),
                            SizedBox(height: 25,),
                          ],
                        ),
                      ),
                    ),
                  );
                }else{
                  List visitors = snapshot.data!.docs.first['visit'];
                  List visitor_numbers = [];
                  visitors.forEach((map) {
                    visitor_numbers.add(map['number']);
                  });

                  return
                    GridView.builder(
                      primary: false,
                      shrinkWrap: true,
                      // padding: const EdgeInsets.all(10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        /// 아이패드가 가로면? 세로면? 아이폰이면
                        crossAxisCount: MediaQuery.of(context).size.width > 1000 ? 4 : MediaQuery.of(context).size.width > 600 ? 3 : 2,
                        // crossAxisCount: 2,
                        childAspectRatio: 2/0.6, //item 의 가로, 세로 의 비율
                      ),
                      itemCount: MainController.to.attendances.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (!visitor_numbers.contains(MainController.to.attendances[index]['number'])) {
                              checkMyNameDialog(context, snapshot.data!.docs.first.id, MainController.to.attendances[index]['number'], MainController.to.attendances[index]['name']);
                            }

                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
                            child: Card(
                              // color: Colors.teal,
                              // color: visitList.any((e) => mapEquals(e, MainController.to.attendances[index])) ? Colors.grey : Colors.teal,
                              color: visitor_numbers.contains(MainController.to.attendances[index]['number']) ? Colors.grey : Colors.teal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 22,
                                    child:
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Center(
                                        child: Text(MainController.to.attendances[index]['number'].toString(), style: TextStyle(color: Colors.grey, fontSize: 15, fontFamily: 'Jua',),),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text(MainController.to.attendances[index]['name'], style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20,),),
                                ],
                              ),
                            ),
                          ),
                        );

                      },

                    );
                }

              }
          ),

        ],
      ),
    );
  }
}