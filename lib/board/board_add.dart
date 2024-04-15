import 'package:loading_indicator/loading_indicator.dart';

import '../controller/board_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/main_controller.dart';

class BoardAdd extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return
      SingleChildScrollView(
        child: Obx(() => Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
                child: SizedBox(
                  // width: 350,
                  height: 30,
                  child: TextField(
                    autofocus: true,
                    onChanged: (value) {
                      BoardController.to.indi_title = value;
                    },
                    style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
                    // minLines: 1,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: '제목을 입력하세요',
                      hintStyle: TextStyle(fontSize: 17, color: Colors.white.withOpacity(0.5)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                      // focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
                      // enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
                      // contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: Divider(color: Colors.white.withOpacity(0.3),),
              ),
              Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 18, right: 18, bottom: 10),
                  child: SizedBox(
                    // width: 350,
                    height: MediaQuery.of(context).size.width < 600 ? 250 : 450,
                    child: TextField(
                      onChanged: (value) {
                        BoardController.to.indi_content = value;
                      },
                      style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
                      minLines: 10,
                      maxLines: null,
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
                BoardController.to.isImageLoading.value == true ?
                Center(child: Container(
                  height: 40,
                  child: LoadingIndicator(
                      indicatorType: Indicator.ballPulse,
                      colors: MainController.to.kDefaultRainbowColors,
                      strokeWidth: 2,
                      backgroundColor: Colors.transparent,
                      pathBackgroundColor: Colors.transparent
                  ),
                ),) : SizedBox(),

              ],),


              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, right: 15, left: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: BoardController.to.imageModel.value.imageInt8 == null ?
                  SizedBox() :
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.memory(BoardController.to.imageModel.value.imageInt8!, fit: BoxFit.fill)),
                ),
              ),
              Text(BoardController.to.dummy.value.toString(), style: TextStyle(fontSize: 0),),

            ]
        ),
        ),
      );

  }
}


