import 'package:flutter/material.dart';
import 'package:hosefina/controller/main_controller.dart';
import 'package:get/get.dart';
import 'package:hosefina/controller/pointer_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:get_storage/get_storage.dart';

class PointerAdd extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('pointer').where('class_code', isEqualTo: GetStorage().read('class_code'))
              .where('pointer_number', isEqualTo: PointerController.to.pointer_number).where('role', isEqualTo: PointerController.to.role).snapshots(),
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
            List pointeds = [];
            if (snapshot.data!.docs.length > 0) {
              pointeds = snapshot.data!.docs.first['pointeds'];
            }

            return Column(
              children: [
                SizedBox(height: 20,),
              // Text(PointController.to.pointer_name, style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 17),),
              // SizedBox(
              //   width: 250,
              //   height: 60,
              //   child: TextField(
              //     // autofocus: true,
              //     textAlignVertical: TextAlignVertical.center,
              //     textAlign: TextAlign.center,
              //     onChanged: (value) {
              //       PointController.to.role = value;
              //     },
              //     style: TextStyle(color: Colors.white , fontSize: 17, ),
              //     // minLines: 1,
              //     maxLines: 1,
              //     decoration: InputDecoration(
              //       hintText: '역할을 입력하세요',
              //       hintStyle: TextStyle(fontSize: 19, color: Colors.white.withOpacity(0.5)),
              //       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white.withOpacity(0.5) ),),
              //       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white.withOpacity(0.5), ),),
              //       contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              //
              //     ),
              //   ),
              // ),
              // SizedBox(height: 30,),
              Text('담당할 대상을 선택하세요', style: TextStyle(color: Colors.white, ),),
                SizedBox(height: 10,),
              GridView.builder(
                primary: false,
                shrinkWrap: true,
                padding: const EdgeInsets.all(5),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3/1.2, //item 의 가로, 세로 의 비율
                ),
                itemCount: MainController.to.attendances.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (PointerController.to.role.trim().length > 0) {
                        if (pointeds.contains(MainController.to.attendances[index]['number'].toString() + '/' + MainController.to.attendances[index]['name'])) {
                          PointerController.to.delPointed(MainController.to.attendances[index]['number'].toString() + '/' + MainController.to.attendances[index]['name']);
                        }else{
                          PointerController.to.addPointed(MainController.to.attendances[index]['number'], MainController.to.attendances[index]['name']);
                        }
                      }else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(duration: Duration(milliseconds: 1000),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('역할을 먼저 입력하세요', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 18),),
                              ],
                            ),),);
                      }

                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 12),
                      child: Container(
                        decoration: pointeds.contains(MainController.to.attendances[index]['number'].toString() + '/' + MainController.to.attendances[index]['name']) ?
                        BoxDecoration(color: Colors.orange,  borderRadius: BorderRadius.circular(10),) :
                        BoxDecoration(border: Border.all(color: Colors.white),  borderRadius: BorderRadius.circular(10),),
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
                            Text(MainController.to.attendances[index]['name'], style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 19,),),
                          ],
                        ),
                      ),
                    ),
                  );

                },

              ),

            ],
            );
          }
      ),
    );
  }
}