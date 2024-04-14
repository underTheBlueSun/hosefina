import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hosefina/controller/point_controller.dart';
import 'package:hosefina/controller/temper_controller.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
// import 'package:vibration/vibration.dart';

import '../controller/main_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';


class PokemonRoulette extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    void winningDialog(context) {
      showDialog(
        context: context,
        barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
        builder: (BuildContext context) {
          int winning_pokemon_index = Random().nextInt(PointController.to.pokemon_list.length);
          PointController.to.addPokemon(PointController.to.pokemon_list[winning_pokemon_index]);
          return AlertDialog(
            backgroundColor: Color(0xFF4C4C4C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            content: Container(
              width: 300, height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        MainController.to.active_screen.value = 'pokemon_main';
                      },
                      child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white,size: 30,),)),
                  SizedBox(height: 20,),
                  Center(child: Image.asset('assets/images/pokemon/${PointController.to.pokemon_list[winning_pokemon_index]}.png', )),
                ],
              ),
            ),
          );
        },
      );

    }

    PointController.to.is_visible_silhouette.value = true;
    // PointController.to.is_visible_winning.value = false;

    return SingleChildScrollView(
      child : Obx(() => Column(
          children: [
            SizedBox(height: 30,),
            Visibility(
              visible: PointController.to.is_visible_silhouette.value,
              child: ImageSlideshow(
                width: double.infinity,
                height: 200,
                initialPage: 0,
                indicatorColor: Colors.transparent,
                indicatorBackgroundColor: Colors.transparent,
                children: [
                  Image.asset('assets/images/pokemon/000101.png', ),
                  Image.asset('assets/images/pokemon/000401.png', ),
                  Image.asset('assets/images/pokemon/000701.png', ),
                ],
                onPageChanged: (value) {
                  // print('Page changed: $value');
                },
                /// Do not auto scroll with null or 0.
                autoPlayInterval: 600,
                isLoop: true,
              ),
            ),
            // Visibility(
            //   visible: PointController.to.is_visible_winning.value,
            //   child: Container(
            //       width: double.infinity,
            //       height: 200,
            //       child: Image.asset('assets/images/pokemon/${PointController.to.pokemon_list[Random().nextInt(PointController.to.pokemon_list.length)]}.png', )),
            // ),

            SizedBox(height: 100,),
            Center(
              child: Container(
                width: 150, height: 70,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: PointController.to.point > 4 ? Colors.teal : Colors.grey, ),
                  onPressed: () {
                    if (PointController.to.point > 4) {
                      PointController.to.is_visible_silhouette.value = false;
                      winningDialog(context);
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(duration: Duration(milliseconds: 1000),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('포인트(★)가 5개 모여야 한번 뽑을 수 있습니다', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 18),),
                            ],
                          ),),);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.catching_pokemon, color: Colors.white, size: 30,),
                      SizedBox(width: 10,),
                      Text('뽑기', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 25),),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            // Text('포인트(★)가 5개 모여야 한번 뽑을 수 있습니다 ', style: TextStyle(color: Colors.white),)
          ],
        ),
      ),
    );

  }
}


