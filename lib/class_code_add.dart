import 'package:flutter/material.dart';
import 'package:hosefina/controller/main_controller.dart';
import 'package:get/get.dart';

class ClassCodeAdd extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset('assets/images/mobile_hosefina_title2.png', width: 150,),
        SizedBox(height: 50,),
        Text('반 코드', style: TextStyle(color: Colors.white),),
        SizedBox(
          width: 200,
          height: 60,
          child: TextField(
            autofocus: true,
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.center,
            // onChanged: (value) {
            //   if (value.length > 0) {
            //   }
            // },
            onSubmitted: (value) {
              if (value.length > 0) {
                MainController.to.checkClassCode(value);
              }
            },
            style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 20, ),
            // minLines: 1,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: '반 코드를 입력하세요',
              hintStyle: TextStyle(fontSize: 19, color: Colors.white.withOpacity(0.5)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white.withOpacity(0.5) ),),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white.withOpacity(0.5), ),),
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

            ),
          ),
        ),
        Obx(() => Visibility(
              visible: MainController.to.is_visible_not_class_code_message.value,
              child: Text('반 코드가 존재하지 않습니다', style: TextStyle(fontSize: 12, color: Colors.orange),),
          ),
        ),
      ],
    );
  }
}