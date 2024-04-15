import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hosefina/controller/diary_controller.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../controller/board_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../controller/main_controller.dart';


class EmotionList extends StatelessWidget {

  void morningEmotionDialog(context) {
    DiaryController.to.morning_emotion_content = '';
    // showDialog(
    showCupertinoDialog(
      context: context,
      // barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
        // return AlertDialog(
          // backgroundColor: Color(0xFFDBB671),
          // backgroundColor: Color(0xFF5E5E5E),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Material(
              color: Colors.transparent,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/images/emotion/${DiaryController.to.morning_emotion_icon}.png', height: 50,),
                    Text(DiaryController.to.morning_emotion_name, style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua'),),
                    SizedBox(height: 20,),
                    TextField(
                      // autofocus: true,
                      onChanged: (value) {
                        DiaryController.to.morning_emotion_content = value;
                      },
                      style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua' ),
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: '왜 ${DiaryController.to.morning_emotion_name} 지 적어 보세요',
                        hintStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

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
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장'), onPressed: () {
              if (DiaryController.to.morning_emotion_content.length > 0) {
                DiaryController.to.addMorningEmotion();
                Navigator.pop(context);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(duration: Duration(milliseconds: 1000),
                    content: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('왜 ${DiaryController.to.morning_emotion_name} 지 적어 주세요', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),],),),
                );
              }
            })

          ],
        );
      },
    );

  }

  void afterEmotionDialog(context) {
    DiaryController.to.after_emotion_content = '';
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: Material(
              color: Colors.transparent,
              child: Column(
                  children: [
                    Image.asset('assets/images/emotion/${DiaryController.to.after_emotion_icon}.png', height: 50,),
                    Text(DiaryController.to.after_emotion_name, style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua'),),
                    SizedBox(height: 20,),
                    TextField(
                      onChanged: (value) {
                        DiaryController.to.after_emotion_content = value;
                      },
                      style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua' ),
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: '왜 ${DiaryController.to.after_emotion_name} 지 적어 보세요',
                        hintStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

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
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장'), onPressed: () {
              if (DiaryController.to.after_emotion_content.length > 0) {
                DiaryController.to.addAfterEmotion();
                Navigator.pop(context);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(duration: Duration(milliseconds: 1000),
                    content: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('왜 ${DiaryController.to.after_emotion_name} 지 적어 주세요', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),],),),
                );
              }
            })

          ],
        );
      },
    );

  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GridView.builder(
        primary: false,
        shrinkWrap: true,
        padding: const EdgeInsets.all(15),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 8 : 4,
          childAspectRatio: 1/1.2, //item 의 가로, 세로 의 비율
          // childAspectRatio: 1/1.2, //item 의 가로, 세로 의 비율
        ),
        itemCount: DiaryController.to.emotion_file_names.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              if (DiaryController.to.emotion_gubun == 'morning') {
                DiaryController.to.morning_emotion_icon = DiaryController.to.emotion_file_names[index];
                DiaryController.to.morning_emotion_name = DiaryController.to.emotion_names[index];
                morningEmotionDialog(context);
              }else{
                DiaryController.to.after_emotion_icon = DiaryController.to.emotion_file_names[index];
                DiaryController.to.after_emotion_name = DiaryController.to.emotion_names[index];
                afterEmotionDialog(context);
              }

            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              child: Column(
                children: [
                  Image.asset('assets/images/emotion/${DiaryController.to.emotion_file_names[index]}.png', height: 50,),
                  Text(DiaryController.to.emotion_names[index], style: TextStyle(color: Colors.white, fontFamily: 'Jua'),),
                ],
              ),
            ),
          );

        },

      ),
    );

  }
}


