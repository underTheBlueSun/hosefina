import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hosefina/controller/point_controller.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controller/main_controller.dart';


class PointMain extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child : Column(
          children: [
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    PointController.to.delAllPoint();
                  },
                  child: Container(
                    // margin: EdgeInsets.all(4),
                    padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                    decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      children: [
                        Text('전체', style: TextStyle(color: Colors.white, fontSize: 17),),
                        SizedBox(width: 2,),
                        Icon(Icons.remove_circle, color: Colors.white, size: 20,),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 15,),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    PointController.to.addAllPoint();
                  },
                  child: Container(
                    // margin: EdgeInsets.all(4),
                    padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      children: [
                        Text('전체', style: TextStyle(color: Colors.white, fontSize: 17),),
                        SizedBox(width: 2,),
                        Icon(Icons.add_circle, color: Colors.white, size: 20,),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 15,),
              ],
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(5),
                  itemCount: MainController.to.attendances.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            CircleAvatar(
                              backgroundColor: Colors.teal,
                            radius: 12,
                            child: Text(MainController.to.attendances[index]['number'].toString(), style: TextStyle(color: Colors.white),),
                          ),
                          SizedBox(width: 10,),
                          Text(MainController.to.attendances[index]['name'], style: TextStyle(color: Colors.black, fontFamily: 'Jua', fontSize: 18),),
                            ],
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('point').where('class_code', isEqualTo: GetStorage().read('class_code'))
                                  .where('number', isEqualTo: MainController.to.attendances[index]['number']).snapshots(),
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
                                var point = 0;
                                if (snapshot.data!.docs.length > 0) {
                                  point = snapshot.data!.docs.toList().first['point'];
                                }

                                return Row(children: [
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      if (point > 0) {
                                        PointController.to.delPoint(MainController.to.attendances[index]['number']);
                                      }

                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      width: 40,
                                      child: Icon(Icons.remove_circle, color: Colors.redAccent, size: 26,),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      // pointDialog(context,point);
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      alignment: Alignment.center,
                                      width: 50,
                                      child: Text(point.toString(), style: TextStyle(color: Colors.orange, fontFamily: 'Jua', fontSize: 20),),
                                    ),
                                  ),


                                  GestureDetector(
                                    onTap: () {
                                      HapticFeedback.lightImpact();
                                      PointController.to.addPoint(MainController.to.attendances[index]['number'], MainController.to.attendances[index]['name']);
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      width: 40,
                                      child: Icon(Icons.add_circle, color: Colors.blueAccent, size: 26,),
                                    ),
                                  ),
                                ],);
                              }
                          ),

                        ],
                      ),
                    );

                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Divider(thickness: 1, color: Colors.grey.withOpacity(0.3),),
                    );
                    },
                ),
              ),
            ),
          ],
        ),
    );

  }
}


