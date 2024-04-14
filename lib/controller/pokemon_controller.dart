import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hosefina/controller/main_controller.dart';

class PokemonController extends GetxController {
  static PokemonController get to => Get.find();
  int point = 0;
  int pokemon_cnt = 0;
  RxBool is_visible_silhouette = true.obs;
  // RxBool is_visible_winning = false.obs;

  List pokemon_list =
  ['000101','000401','000701','001001','001301','001601','001901','002101','002301','002501','002701','002901','003501','003701','003901','004101','004301',
    '004601','004801','004901','005001','005201','005401','005601','005801','006001','006301','006601','006901','007201','007401','007501','007601','007701',
  '007901','008101','008301','008401','008601','008801','009001','009201','009401','009501','009601'];

  @override
  void onInit() async {

    // getPoint();

  }

  // void getPoint() async{
  //   await FirebaseFirestore.instance.collection('point').where('class_code', isEqualTo: GetStorage().read('class_code'))
  //       .where('number', isEqualTo: GetStorage().read('number')).get().then((QuerySnapshot snapshot) {
  //     if (snapshot.docs.length > 0) {
  //       point = snapshot.docs.first['point'];
  //       pokemon_cnt = (snapshot.docs.first['point'] / 2).ceil();
  //     }
  //   });
  // }

  void addPoint(number, name) async{
    /// 담임도 addPoint를 사용하니깐 number로 받아야 함
    await FirebaseFirestore.instance.collection('point').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('number', isEqualTo: number).get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        FirebaseFirestore.instance.collection('point').doc(snapshot.docs.first.id).update({'point': FieldValue.increment(1)});
        // point = snapshot.docs.first['point'] + 1;
        // pokemon_cnt = ((snapshot.docs.first['point'] + 1) / 2).ceil();

      }else {
        FirebaseFirestore.instance.collection('point').add({'date': DateTime.now(), 'class_code': GetStorage().read('class_code'),
          'number': number, 'name': name, 'point': 1, });
        // point = 1;
        // pokemon_cnt = 1;
      }
    });
  }

  void delPoint(number) async{
    await FirebaseFirestore.instance.collection('point').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('number', isEqualTo: number).get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        if (snapshot.docs.first['point'] > 0) {
          FirebaseFirestore.instance.collection('point').doc(snapshot.docs.first.id).update({'point': FieldValue.increment(-1)});
          // point = snapshot.docs.first['point'] - 1;
          // pokemon_cnt = ((snapshot.docs.first['point'] - 1) / 2).ceil();
        }

      }
    });
  }

  void addAllPoint() async{
    MainController.to.attendances.forEach((doc) {
      FirebaseFirestore.instance.collection('point').where('class_code', isEqualTo: GetStorage().read('class_code'))
          .where('number', isEqualTo: doc['number']).get().then((QuerySnapshot snapshot) {
        if (snapshot.docs.length > 0) {
          FirebaseFirestore.instance.collection('point').doc(snapshot.docs.first.id).update({'point': FieldValue.increment(1)});
          // point = snapshot.docs.first['point'] + 1;
          // pokemon_cnt = ((snapshot.docs.first['point'] + 1) / 2).ceil();

        }else {
          FirebaseFirestore.instance.collection('point').add({'date': DateTime.now(), 'class_code': GetStorage().read('class_code'),
            'number': doc['number'], 'name': doc['name'], 'point': 1, });
          // point = 1;
          // pokemon_cnt = 1;
        }
      });
    });
  }

  void delAllPoint() async{
    MainController.to.attendances.forEach((doc) {
      FirebaseFirestore.instance.collection('point').where('class_code', isEqualTo: GetStorage().read('class_code'))
          .where('number', isEqualTo: doc['number']).get().then((QuerySnapshot snapshot) {
        if (snapshot.docs.first['point'] > 0) {
          FirebaseFirestore.instance.collection('point').doc(snapshot.docs.first.id).update({'point': FieldValue.increment(-1)});
          // point = snapshot.docs.first['point'] - 1;
          // pokemon_cnt = ((snapshot.docs.first['point'] - 1) / 2).ceil();
        }
      });
    });


  }

}






