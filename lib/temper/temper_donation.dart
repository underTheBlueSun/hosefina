import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hosefina/controller/temper_controller.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import '../controller/main_controller.dart';


class TemperDonation extends StatelessWidget {

  void awardDialog(context, award_number, award_title) {
    showCupertinoDialog(
      context: context,
      // barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          // backgroundColor: Color(0xFFDBB671),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: 120, height: 150,
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 100,
                    child: TextField(
                      // maxLength: 7,
                      controller: TextEditingController(text: award_title),
                      textAlignVertical: TextAlignVertical.center,
                      // textAlign: TextAlign.center,
                      onChanged: (value) {
                        TemperController.to.award_title = value;
                      },
                      style: TextStyle(fontFamily: 'Jua',  fontSize: 20, ),
                      // minLines: 1,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: '내용을 입력하세요',
                        hintStyle: TextStyle(fontSize: 19, color: Colors.grey.withOpacity(0.5)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              TemperController.to.award_title = '';
              Navigator.pop(context);
            }),

          ],
        );
      },
    );

  }

  void addDialog(context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            // width: 120, height: 150,
            child: Material(
              color: Colors.transparent,
              child: Center(child: Text('스티커를 하나 추가하시겠습니까?', style: TextStyle(fontFamily: 'Jua'),)),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('추가'), onPressed: () {
              TemperController.to.addPoint();
              Navigator.pop(context);
            })

          ],
        );
      },
    );

  }

  void removeDialog(context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            // width: 120, height: 150,
            child: Material(
              color: Colors.transparent,
              child: Center(child: Text('스티커를 하나 제거하시겠습니까?', style: TextStyle(fontFamily: 'Jua'),)),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('제거'), onPressed: () {
              TemperController.to.removePoint();
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
        stream: FirebaseFirestore.instance.collection('temper_donation').where('class_code', isEqualTo: GetStorage().read('class_code'))
            .where('number', isEqualTo: GetStorage().read('number')).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
          if (!snapshot2.hasData) {
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

          var docs = snapshot2.data!.docs.sort((a, b) => a['date'].compareTo(b['date']));

          // snapshot2.data!.docs.forEach((doc) {
          //   award_list[doc['award_number']] = doc['award_title'];
          // });

          return ListView.separated(
            primary: false,
            shrinkWrap: true,
            padding: EdgeInsets.all(20),
            itemCount: snapshot2.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot2.data!.docs[index];
              return
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(TemperController.to.getDateWithYoil(doc['date']), style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 15),),
                    Text('★ ${doc['point'].toString()}', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 15),),
                  ],
                );
            },
            separatorBuilder: (BuildContext context, int index) { return Divider(thickness: 1); }
          );
        }

    );

  }
}


