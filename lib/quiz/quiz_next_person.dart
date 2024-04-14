import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../controller/main_controller.dart';
import '../controller/quiz_controller.dart';
import 'package:get/get.dart';

class QuizNextPerson extends StatelessWidget {

  Container buildCountDowntText(time_double) {
    String time = time_double.toInt().toString();
    if (time == '0') {
      return Container(
        alignment: Alignment.topCenter,
        width: 170,
        child: Text('출발!', style: TextStyle(fontSize: 70, fontFamily: 'Jua', color: Colors.orange,),),
      );
    }else {
      return Container(
        alignment: Alignment.topCenter,
        width: 170,
        child: Text(time, style: TextStyle(fontSize: 70, fontFamily: 'Jua', color: Colors.orange,),),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 100,),
          Text('다음 사람 준비', style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'Jua'),),
          SizedBox(height: 50,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),),
            onPressed: () {
              MainController.to.active_screen.value = 'quiz_play';
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 11, right: 8),
              child: Text('시작',style: TextStyle(fontFamily: 'Jua', fontSize: 20,  color: Colors.white),),
            ),
          ),
        ],),
    );


  }

}






