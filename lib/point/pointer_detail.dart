import 'package:flutter/material.dart';
import 'package:hosefina/controller/main_controller.dart';
import 'package:get/get.dart';
import 'package:hosefina/controller/pointer_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:get_storage/get_storage.dart';

class PointerDetail extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    void updRoleDialog(context) {
      showDialog(
        context: context,
        barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFF4C4C4C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            content: Container(
              width: 200, height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Text(PointerController.to.pointer_name, style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 17),),
                  SizedBox(
                    width: 180,
                    height: 60,
                    child: TextField(
                      controller: TextEditingController(text: PointerController.to.role),
                      autofocus: true,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      onSubmitted: (value) {
                        if (value.trim().length > 0) {
                          PointerController.to.upd_role = value;
                          PointerController.to.updRole();
                          Navigator.pop(context);
                          MainController.to.active_screen.value = 'pointer_main';
                        }

                      },
                      style: TextStyle(color: Colors.white , fontSize: 17, ),
                      // minLines: 1,
                      maxLines: 1,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white.withOpacity(0.5) ),),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white.withOpacity(0.5), ),),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal,),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('취소',style: TextStyle(fontFamily: 'Jua', fontSize: 15, color: Colors.white),),
                ),
              ),
            ],
          );
        },
      );

    }

    void delPointerDialog(context, doc_id) {
      showDialog(
        context: context,
        barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFF4C4C4C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            content: Container(
              width: 200, height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 30,),
                  Text('삭제 하시겠습니까?', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 17),),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal,),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('아니오',style: TextStyle(fontFamily: 'Jua', fontSize: 15, color: Colors.white),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal,),
                      onPressed: () {
                        PointerController.to.delPointer(doc_id);
                        Navigator.pop(context);
                        MainController.to.active_screen.value = 'pointer_main';
                      },
                      child: Text('예',style: TextStyle(fontFamily: 'Jua', fontSize: 15, color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );

    }

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
                // SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.teal,  borderRadius: BorderRadius.circular(10),),
                    padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('포인터', style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'Jua'),),
                          Text(PointerController.to.pointer_name, style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'Jua'),),

                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('역할', style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'Jua'),),
                          Row(
                            children: [
                              Text(PointerController.to.role, style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'Jua'),),
                              SizedBox(width: 20,),
                              GestureDetector(
                                onTap: () {
                                  updRoleDialog(context);
                                },
                                child: Icon(Icons.edit, color: Colors.white,),
                              )
                            ],
                          ),


                        ],
                      ),
                    ],),
                  ),
                ),

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
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: () {
                    delPointerDialog(context, snapshot.data!.docs.first.id);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 200,
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('삭제', style: TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'Jua'),),
                    ),
                  ),
                ),

              ],
            );
          }
      ),
    );
  }
}