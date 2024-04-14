import 'package:get_storage/get_storage.dart';
import 'package:hosefina/controller/subject_controller.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../controller/board_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/main_controller.dart';

class SubjectAdd extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
        child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
                child: Text(SubjectController.to.subject, style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: Divider(color: Colors.white.withOpacity(0.3),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18, bottom: 10),
                child: SizedBox(
                  // width: 350,
                  height: MediaQuery.of(context).size.width < 600 ? 200 : 450,
                  child: TextField(
                    autofocus: true,
                    onChanged: (value) {
                      SubjectController.to.content = value;
                    },
                    style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
                    // minLines: 10,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: '내용을 입력하세요',
                      hintStyle: TextStyle(fontSize: 17, color: Colors.white.withOpacity(0.5)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                      // focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
                      // enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
                    ),
                  ),
                ),
              ),
              /// 저장버튼
              Container(
                width: 120,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, ),
                  onPressed: () async{
                    SubjectController.to.saveSubjectDiary(GetStorage().read('number'));
                    MainController.to.active_screen.value = 'subject_main';
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save_alt_outlined, color: Colors.white,),
                      SizedBox(width: 5,),
                      Text('저장', style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
              ),


            ]
        ),
      );

  }
}


