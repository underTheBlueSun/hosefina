import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../controller/main_controller.dart';
import '../controller/quiz_controller.dart';
import 'package:get/get.dart';

class Test extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return
      Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                cursorColor: Colors.black,
                autofocus: true,
                textAlignVertical: TextAlignVertical.center,
                onSubmitted: (value) {
                },
                style: TextStyle(color: Colors.black , fontSize: 25, ),
                // style: TextStyle(color: Colors.white , fontSize: 16, ),
                maxLines: 1,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '정답을 입력하세요',
                  hintStyle: TextStyle(fontSize: 20, color: Colors.grey.withOpacity(0.5)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white,  ),),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.white,  ),),
                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),

                ),
              ),
            ),
          ),
        ),
      ],);

  }

}








