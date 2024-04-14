import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:hosefina/controller/auction_controller.dart';
import '../controller/board_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../controller/main_controller.dart';


class AuctionMain extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            SizedBox(height: 10,),
            Container(
              width: 50,
              // color: Colors.blue,
              child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      color: Colors.blue,
                      child: Text('입력', style: TextStyle(color: Colors.white),),
                    ),
                  );

                },

              ),
            ),
          ],
        ),
        Stack(children: [
          Image.asset('assets/images/temp1.png', height: 600,),
          Column(
            children: [
              SizedBox(height: 10,),
              Container(
                width: 120,
                child: GridView.builder(
                  primary: false,
                  shrinkWrap: true,
                  // padding: EdgeInsets.all(15),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 1/1, //item 의 가로, 세로 의 비율
                  ),
                  itemCount: 100,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(2),
                      child: Container(
                        color: Colors.red,
                        child: Text(index.toString(), style: TextStyle(color: Colors.white),),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 30,),
              GestureDetector(
                  onTap: () {

                  },
                  child: Icon(Icons.add, color: Colors.white, size: 50,)),
            ],
          ),
        ],),

        Column(
          children: [
            SizedBox(height: 10,),
            Container(
              width: 50,
              // color: Colors.blue,
              child: ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      color: Colors.orange,
                      child: Text('입력', style: TextStyle(color: Colors.white),),
                    ),
                  );

                },

              ),
            ),
          ],
        ),
      ],

    );

  }
}


