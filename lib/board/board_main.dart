import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../controller/board_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../controller/main_controller.dart';


class BoardMain extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('board_main')
              .where('class_code', isEqualTo: GetStorage().read('class_code')).where('gubun', isEqualTo: '보드').snapshots(),
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
            List docs = snapshot.data!.docs.toList();
            docs.sort((a,b)=> b['main_id'].compareTo(a['main_id']));
            return
              Column(
                children: [
                  Text('학급보드', style: TextStyle(fontFamily: 'Jua', color: Colors.white, fontSize: 20),),
                  GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(15),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (MediaQuery.of(context).size.width / 300).ceil(),
                      // crossAxisCount: 2,
                      childAspectRatio: 2/1.1, //item 의 가로, 세로 의 비율
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = docs[index];
                      return GestureDetector(
                        onTap: () {
                          BoardController.to.background.value = doc['background'];
                          BoardController.to.board_main_id = doc['main_id'];
                          BoardController.to.board_title = doc['title'];
                          BoardController.to.board_gubun = doc['gubun'];
                          BoardController.to.board_type = doc['type'];
                          if (doc['type'] == '개인') {
                            MainController.to.active_screen.value = 'board_indi';
                          }else {
                            MainController.to.active_screen.value = 'board_modum';
                          }

                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            /// 길이가 10이면 배경색깔
                            decoration: doc['background'].length == 10 ?
                            BoxDecoration(color: Color(int.parse(doc['background'])), borderRadius: BorderRadius.circular(10)) :
                            BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/' + doc['background'] + '_thumb.png'),
                                fit: BoxFit.cover, opacity: 0.8), borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12, right: 12,top:12,),
                                  child: Container(
                                    width: 250,
                                    child: Stack(
                                      children: <Widget>[
                                        Text(doc['title'], maxLines: 2, style: TextStyle(fontFamily: 'Jua',
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 3
                                            ..color = Colors.black.withOpacity(0.3),
                                        ),
                                        ),
                                        Text(doc['title'], maxLines: 2, style: TextStyle(fontFamily: 'Jua', color: Colors.white,),),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(doc['main_id'].toDate().toString().substring(2,16), style: TextStyle(fontSize: 12, color: Colors.white),),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );

                    },

                  ),
                ],
              );
          }
      ),
    );

  }
}


