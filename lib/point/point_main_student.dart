import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hosefina/controller/pointer_controller.dart';
import 'package:hosefina/controller/point_controller.dart';
import 'package:hosefina/controller/temper_controller.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controller/main_controller.dart';
import 'package:flutter/services.dart';


class PointMainStudent extends StatelessWidget {

  // void pointDialog(context, point) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Color(0xFF4C4C4C),
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  //         content: Container(
  //           width: 120, height: 120,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               SizedBox(height: 30,),
  //               SizedBox(
  //                 width: 120,
  //                 height: 60,
  //                 child: TextField(
  //                   controller: TextEditingController(text: point.toString()),
  //                   autofocus: true,
  //                   textAlignVertical: TextAlignVertical.center,
  //                   textAlign: TextAlign.center,
  //                   onSubmitted: (value) {
  //                     if (value.length > 0) {
  //                       MainController.to.checkEmail(value, context);
  //                       // Navigator.pop(context);
  //                     }
  //                   },
  //                   style: TextStyle(color: Colors.white , fontSize: 17, ),
  //                   // minLines: 1,
  //                   maxLines: 1,
  //                   decoration: InputDecoration(
  //                     // hintText: '이메일을 입력하세요',
  //                     // hintStyle: TextStyle(fontSize: 19, color: Colors.white.withOpacity(0.5)),
  //                     focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white.withOpacity(0.5) ),),
  //                     enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white.withOpacity(0.5), ),),
  //                     contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
  //
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           Padding(
  //             padding: const EdgeInsets.all(5),
  //             child: ElevatedButton(
  //               style: ElevatedButton.styleFrom(backgroundColor: Colors.teal,),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //               child: Text('취소',style: TextStyle(fontFamily: 'Jua', fontSize: 15, color: Colors.white),),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  //
  // }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child : ListView.builder(
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.all(5),
        itemCount: PointerController.to.my_pointer_docs.length,
        itemBuilder: (context, index1){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.3),  borderRadius: BorderRadius.circular(10),),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(PointerController.to.my_pointer_docs[index1]['role'], style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),),
                  SizedBox(height: 10,),
                  ListView.separated(
                    primary: false,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(5),
                    itemCount: PointerController.to.my_pointer_docs[index1]['pointeds'].length,
                    itemBuilder: (context, index2){
                      String pointed_numNname = PointerController.to.my_pointer_docs[index1]['pointeds'][index2];
                      int pointed_number = int.parse(pointed_numNname.substring(0,pointed_numNname.indexOf('/')));
                      String pointed_name = pointed_numNname.substring(pointed_numNname.indexOf('/')+1,pointed_numNname.length);

                      return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('point').where('class_code', isEqualTo: GetStorage().read('class_code'))
                              .where('number', isEqualTo: pointed_number).snapshots(),
                              // .where('number', isEqualTo: PointController.to.my_pointer_docs[index1]['pointeds'][index2]).snapshots(),
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

                            return Padding(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.teal,
                                      radius: 12,
                                      child: Text(pointed_number.toString(), style: TextStyle(color: Colors.white),),
                                      // child: Text(snapshot.data!.docs.first['number'].toString(), style: TextStyle(color: Colors.white),),
                                    ),
                                    SizedBox(width: 10,),
                                    Text(pointed_name, style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 18),),
                                    // Text(snapshot.data!.docs.first['name'], style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 18),),
                                  ],
                                  ),
                                  Row(children: [
                                    GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        if (point > 0) {
                                          PointController.to.delPoint(pointed_number);
                                          // PokemonController.to.delPoint(snapshot.data!.docs.first['number']);
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
                                        child: Text(point.toString(), style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),),
                                      ),
                                    ),


                                    GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        PointController.to.addPoint(pointed_number, pointed_name);
                                        // PokemonController.to.addPoint(snapshot.data!.docs.first['number'], snapshot.data!.docs.first['name']);
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        width: 40,
                                        child: Icon(Icons.add_circle, color: Colors.blueAccent, size: 26,),
                                      ),
                                    ),
                                  ],),

                                ],
                              ),
                            );
                          }
                      );


                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Divider(thickness: 1, color: Colors.white.withOpacity(0.2),),
                      );
                    },
                  ),
                ],
              ),
            ),
          );

        },
      ),
    );

  }
}


