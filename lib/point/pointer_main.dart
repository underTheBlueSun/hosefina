import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hosefina/controller/pointer_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../controller/main_controller.dart';


class PointerMain extends StatelessWidget {

  void addRoleDialog(context) {
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
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    onSubmitted: (value) {
                      if (value.trim().length > 0) {
                        PointerController.to.role = value;
                        PointerController.to.addRole();
                        MainController.to.active_screen.value = 'pointer_add';
                        Navigator.pop(context);
                      }

                    },
                    style: TextStyle(color: Colors.white , fontSize: 17, ),
                    // minLines: 1,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: '역할을 입력하세요',
                      hintStyle: TextStyle(fontSize: 19, color: Colors.white.withOpacity(0.5)),
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

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child : ListView.separated(
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.all(5),
        itemCount: MainController.to.attendances.length,
        itemBuilder: (context, attendances_index){
          return Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.teal,
                      radius: 12,
                      child: Text(MainController.to.attendances[attendances_index]['number'].toString(), style: TextStyle(color: Colors.white),),
                    ),
                    SizedBox(width: 10,),
                    Text(MainController.to.attendances[attendances_index]['name'], style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 18),),
                  ],
                ),

                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('pointer').where('class_code', isEqualTo: GetStorage().read('class_code'))
                        .where('pointer_number', isEqualTo: MainController.to.attendances[attendances_index]['number']).snapshots(),
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
                      if (snapshot.data!.docs.length > 0) {
                        return SingleChildScrollView(
                          child: Container(
                            width: 200, height: 50,
                            child: GridView.builder(
                              primary: false,
                              shrinkWrap: true,
                              // padding: const EdgeInsets.all(5),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3/1.1, //item 의 가로, 세로 의 비율
                              ),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, pointer_index) {
                                return GestureDetector(
                                  onTap: () {
                                    PointerController.to.pointer_number = MainController.to.attendances[attendances_index]['number'];
                                    PointerController.to.pointer_name = MainController.to.attendances[attendances_index]['name'];
                                    PointerController.to.role = snapshot.data!.docs[pointer_index]['role'];
                                    MainController.to.active_screen.value = 'pointer_detail';
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Container(
                                        alignment: Alignment.center,
                                        width: 90,
                                        decoration: BoxDecoration(border: Border.all(color: Colors.white),  borderRadius: BorderRadius.circular(5),),
                                        child: Text(snapshot.data!.docs[pointer_index]['role'], overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 14, ),)
                                    ),
                                  ),
                                );

                              },

                            ),
                          ),
                        );
                      }else {
                        return SizedBox();
                      }

                    }
                ),

                GestureDetector(
                  onTap: () {
                    PointerController.to.pointer_name = MainController.to.attendances[attendances_index]['name'];
                    PointerController.to.pointer_number = MainController.to.attendances[attendances_index]['number'];
                    addRoleDialog(context);
                  },
                  child: Container(
                      padding: EdgeInsets.only(left: 6, right: 6, top: 3, bottom: 3),
                      decoration: BoxDecoration(color: Colors.orange,  borderRadius: BorderRadius.circular(10),),
                      child: Text('임명', style: TextStyle(color: Colors.black, fontSize: 17, fontFamily: 'Jua'),)
                  ),
                ),
              ],
            ),
          );

        },
        separatorBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Divider(thickness: 1, color: Colors.white.withOpacity(0.2),),
          );
        },
      ),
    );

  }
}


