import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../controller/board_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../controller/coupon_controller.dart';
import '../controller/diary_controller.dart';
import '../controller/main_controller.dart';

class CouponMain extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('coupon_buy').where('class_code', isEqualTo: GetStorage().read('class_code'))
              .where('number', isEqualTo: GetStorage().read('number')).snapshots(),
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
              var sort_docs = snapshot.data!.docs;
              sort_docs.sort((a, b) => b['date'].compareTo(a['date']));
              return Column(
                children: [
                  Text('내가 구매한 쿠폰', style: TextStyle(color: Colors.white, fontFamily: 'Jua'),),
                  GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      /// 그램 1707 * 910/ 왼컴 2048*1030/ 오컴 1920*957, 아이맥 2048, 한성 1920
                      /// 아이패드 가로/세로 = 1180/820, 아이패드프로 가로/세로 = 1366/1024
                      crossAxisCount: MediaQuery.of(context).size.width >= 1920 ? 6 : MediaQuery.of(context).size.width >= 1700 ? 5 :
                      MediaQuery.of(context).size.width >= 1300 ? 4 : MediaQuery.of(context).size.width > 1100 ? 3 : MediaQuery.of(context).size.width > 600 ? 2 : 1,
                      childAspectRatio: 2.5/1, //item 의 가로, 세로 의 비율
                    ),
                    itemCount: sort_docs.length,
                    itemBuilder: (context, index) {
                      var doc = sort_docs[index];
                      String dayofweek = DateFormat('EEE', 'ko_KR').format(DateTime.parse(doc['date'].substring(0,10)));
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15)),),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    /// 왼쪽 반원
                                    Container(
                                      width: 10, height: 25,
                                      decoration: const BoxDecoration(color: Color(0xFF76B8C3), borderRadius: BorderRadius.only(topRight: Radius.circular(100), bottomRight: Radius.circular(100),),),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Image.asset('assets/images/coupon/${doc['icon']}.png', width: 45, height: 45,),
                                              SizedBox(width: 15,),
                                              SizedBox(
                                                width: 150,
                                                child: Text(doc['title'], maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black.withOpacity(0.5), fontFamily: 'Jua', fontSize: 22),),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                                          child: SizedBox(
                                            width: 200,
                                            child: Row(
                                              children: [
                                                Text(doc['name'], style: TextStyle(color: Colors.orange, fontFamily: 'Jua', fontSize: 18),),
                                                Text(', ${doc['date'].substring(5,10)}', style: TextStyle(color: Colors.orange, fontFamily: 'Jua', fontSize: 18),),
                                                Text('(${dayofweek})', style: TextStyle(color: Colors.orange, fontFamily: 'Jua', fontSize: 18),),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 110,
                                // width: MediaQuery.of(context).size.width * 0.3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    /// 세로 점선
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: CustomPaint(
                                          size: Size(3, double.infinity),
                                          painter: DashedLineVerticalPainter()
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.star, color: Color(0xFFE490A0),),
                                        Text(doc['point'].toString(), style: TextStyle(color: Color(0xFF76B8C3), fontWeight: FontWeight.bold, fontSize: 40, fontFamily: 'Jua'),),
                                      ],
                                    ),
                                    /// 오른쪽 반원
                                    Container(
                                      width: 10, height: 25,
                                      decoration: const BoxDecoration(color: Color(0xFF76B8C3), borderRadius: BorderRadius.only(topLeft: Radius.circular(100), bottomLeft: Radius.circular(100),),),
                                    ),
                                  ],
                                ),
                              ),

                            ],),
                        ),
                      );

                    },

                  ),
                ],
              );
            }else{
              return SizedBox();
            }

          }
      ),
    );

  }
}

class DashedLineVerticalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 5, startY = 0;
    final paint = Paint()
      ..color = Color(0xFF76B8C3)
      ..strokeWidth = size.width;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


