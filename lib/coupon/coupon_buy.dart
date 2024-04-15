import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hosefina/controller/point_controller.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../controller/board_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../controller/coupon_controller.dart';
import '../controller/diary_controller.dart';
import '../controller/main_controller.dart';

class CouponBuy extends StatelessWidget {

  void buyDialog(context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            height: 100,
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Color(0xFFE490A0),),
                      Text('${CouponController.to.point.toString()}', style: TextStyle(color: Color(0xFFE490A0), fontSize: 25, fontFamily: 'Jua'),),
                      Text('점 차감됩니다', style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Jua'),),
                    ],
                  ),
                  Text('구매하시겠습니까?', style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Jua'),),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('구매'), onPressed: () {
              if (CouponController.to.title.length > 0 && CouponController.to.point > 0 && CouponController.to.icon.value.length > 0) {
                CouponController.to.buyCoupon();
                Navigator.pop(context);
                MainController.to.active_screen.value = 'coupon_main';
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(duration: Duration(milliseconds: 1000),
                    content: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('제목, 점수, 아이콘을 입력해 주세요', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),],),),
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
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('coupon').where('class_code', isEqualTo: GetStorage().read('class_code')).snapshots(),
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
            return ListView.builder(
              // primary: false,
              // shrinkWrap: true,
              // padding: const EdgeInsets.all(15),
              itemCount: sort_docs.length,
              itemBuilder: (context, index) {
                var doc = sort_docs[index];
                // var doc = snapshot.data!.docs[index];
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    CouponController.to.id = doc.id;
                    CouponController.to.title = doc['title'];
                    CouponController.to.icon.value = doc['icon'];
                    CouponController.to.point = doc['point'];

                    if (PointController.to.point_total >= CouponController.to.point) {
                      buyDialog(context);
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(duration: Duration(milliseconds: 1000),
                          content: Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('★ 포인트가 적어서 쿠폰을 구매할 수 없습니다', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),],),),
                      );
                    }

                  },
                  child: Padding(
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
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
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
                  ),
                );

              },

            );
          }else{
            return SizedBox();
          }

        }
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


