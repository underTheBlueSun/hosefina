import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hosefina/controller/point_controller.dart';
import 'package:hosefina/controller/temper_controller.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
// import 'package:vibration/vibration.dart';

import '../controller/main_controller.dart';
import 'package:flutter/services.dart';


class PokemonMain extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TemperController.to.setAward();

    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('point').where('class_code', isEqualTo: GetStorage().read('class_code'))
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

            List pokemons_distinct = [];
            if (snapshot.data!.docs.length > 0) {
              PointController.to.point_doc_id = snapshot.data!.docs.first.id;
              if (snapshot.data!.docs.first['pokemons'].length > 0) {
                pokemons_distinct = snapshot.data!.docs.first['pokemons'].toSet().toList();
                pokemons_distinct.sort((a, b) => a.compareTo(b));
              }

              return Column(
                children: [
                  Text('${pokemons_distinct.length}/300', style: TextStyle(color: Colors.white, fontSize: 17),),
                  GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(5),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1/1, //item 의 가로, 세로 의 비율
                    ),
                    itemCount: 300,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10),),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: index < pokemons_distinct.length ?
                              Image.asset('assets/images/pokemon/${pokemons_distinct[index]}.png', ) :
                                  SizedBox(),
                            ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }else{
              return Column(
                children: [
                  Text('0/300', style: TextStyle(color: Colors.white, fontSize: 17),),
                  GridView.builder(
                    primary: false,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(5),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1/1, //item 의 가로, 세로 의 비율
                    ),
                    itemCount: 300,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(10),),
                        ),
                      );
                    },
                  ),
                ],
              );
            }


          }
      ),
    );

  }
}


