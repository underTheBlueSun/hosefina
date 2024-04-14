import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TemperController extends GetxController {
  static TemperController get to => Get.find();

  int award_number = 0;
  int point = 0;
  String award_title = '';
  List award_list = [];
  int point_by_sticker = 1;
  int donation_point = 0;
  RxString dummy_date = DateTime.now().toString().obs;

  @override
  void onInit() async {
    /// 보상 담기
    // setAward();

  }

  // void setAward() async{
  // // Future<void> setAward() async{
  //   await FirebaseFirestore.instance.collection('temper_award').where('class_code', isEqualTo: GetStorage().read('class_code'))
  //       .get().then((QuerySnapshot snapshot) {
  //     if (snapshot.docs.length > 0) {
  //       award_list = snapshot.docs.toList();
  //     }
  //   });
  // }

  void getPointBySticker() async{
    await FirebaseFirestore.instance.collection('temper_pointbysticker').where('class_code', isEqualTo: GetStorage().read('class_code')).get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        point_by_sticker = snapshot.docs.first['pointbysticker'];
      }

    });
  }

  void updatePoint() async{
    await FirebaseFirestore.instance.collection('temper_pointbysticker').where('class_code', isEqualTo: GetStorage().read('class_code')).get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        FirebaseFirestore.instance.collection('temper_pointbysticker').doc(snapshot.docs.first.id).update({'pointbysticker': point_by_sticker});
      }else {
        FirebaseFirestore.instance.collection('temper_pointbysticker').add({'date': DateTime.now(), 'email': GetStorage().read('email'),
          'class_code': GetStorage().read('class_code'), 'pointbysticker': point_by_sticker })
            .catchError((error) { print('saveAward() : ${error}'); });
      }

    });
  }

  void saveAward() async{
    await FirebaseFirestore.instance.collection('temper_award').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('award_number', isEqualTo: award_number).get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        if (award_title.length > 0) {
          FirebaseFirestore.instance.collection('temper_award').doc(snapshot.docs.first.id).update({'award_title': award_title});
        }else {
          FirebaseFirestore.instance.collection('temper_award').doc(snapshot.docs.first.id).delete();
        }

      }else {
        FirebaseFirestore.instance.collection('temper_award').add({'date': DateTime.now(), 'email': GetStorage().read('email'),
          'class_code': GetStorage().read('class_code'), 'award_number': award_number, 'award_title': award_title, })
            .catchError((error) { print('saveAward() : ${error}'); });
      }
    });
    /// 보상 담기
    // setAward();
  }

  void addPoint() async{
    await FirebaseFirestore.instance.collection('temper_point').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        FirebaseFirestore.instance.collection('temper_point').doc(snapshot.docs.first.id).update({'point': FieldValue.increment(point_by_sticker)});
      }else {
        FirebaseFirestore.instance.collection('temper_point').add({'date': DateTime.now(), 'email': GetStorage().read('email'),
          'class_code': GetStorage().read('class_code'), 'point': 1 })
            .catchError((error) { print('addPoint() : ${error}'); });
      }
    });
  }

  void removePoint() async{
    await FirebaseFirestore.instance.collection('temper_point').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        /// 음수 안나오게 하기 위해
        if (snapshot.docs.first['point'] <= point_by_sticker) {
          FirebaseFirestore.instance.collection('temper_point').doc(snapshot.docs.first.id).update({'point': 0});
        }else {
          FirebaseFirestore.instance.collection('temper_point').doc(snapshot.docs.first.id).update({'point': FieldValue.increment(-point_by_sticker)});
        }

      }
    });
  }

  void donationPoint() async{
    FirebaseFirestore.instance.collection('temper_donation').add({'date': DateTime.now(), 'class_code': GetStorage().read('class_code'),
      'number': GetStorage().read('number'), 'name': GetStorage().read('name'), 'point': donation_point, 'reset': false });
  }

  String getDateWithYoil(date) {
    // DateTime yyyymmdd_datetime = DateTime.parse(date);
    // String month = DateFormat('MM').format(yyyymmdd_datetime);
    // String day = DateFormat('dd').format(yyyymmdd_datetime);
    // String dayofweek = DateFormat('EEE', 'ko_KR').format(yyyymmdd_datetime);

    String month = DateFormat('MM').format(date.toDate());
    String day = DateFormat('dd').format(date.toDate());
    String dayofweek = DateFormat('EEE', 'ko_KR').format(date.toDate());
    return '${month}.${day} (${dayofweek})';
  }


}






