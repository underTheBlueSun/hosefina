import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class RelationController extends GetxController {
  static RelationController get to => Get.find();

  List checklist_points = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
  List checklist_cs = ['','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',];
  String content = '';
  String bad_act = '';


  @override
  void onInit() async {

  }

  List name_list = ['n_01','n_02','n_03','n_04','n_05','n_06','n_07','n_08','n_09','n_10','n_11','n_12','n_13','n_14','n_15','n_16','n_17','n_18','n_19','n_20',
    'n_21','n_22','n_23','n_24','n_25','n_26','n_27','n_28','n_29','n_30'];
  List c_name_list = ['n_01_c','n_02_c','n_03_c','n_04_c','n_05_c','n_06_c','n_07_c','n_08_c','n_09_c','n_10_c','n_11_c','n_12_c','n_13_c','n_14_c','n_15_c','n_16_c',
    'n_17_c','n_18_c','n_19_c','n_20_c', 'n_21_c','n_22_c','n_23_c','n_24_c','n_25_c','n_26_c','n_27_c','n_28_c','n_29_c','n_30_c'];
  List value_list = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
  List content_list = ['','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''];
  void addChecklist(index, point) async{
    value_list = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    content_list = ['','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''];
    value_list[index] = point;
    content_list[index] = content;
    
    // String column_name = '';
    // String column_name_c = '';
    // int n_01 = 0;
    // int n_02 = 0;
    // int n_03 = 0;
    // int n_04 = 0;
    // int n_05 = 0;
    // int n_06= 0;
    // int n_07 = 0;
    // int n_08 = 0;
    // int n_09 = 0;
    // int n_10 = 0;
    // int n_11 = 0;
    // int n_12 = 0;
    // int n_13 = 0;
    // int n_14 = 0;
    // int n_15 = 0;
    // int n_16= 0;
    // int n_17 = 0;
    // int n_18 = 0;
    // int n_19 = 0;
    // int n_20 = 0;
    // int n_21 = 0;
    // int n_22 = 0;
    // int n_23 = 0;
    // int n_24 = 0;
    // int n_25 = 0;
    // int n_26= 0;
    // int n_27 = 0;
    // int n_28 = 0;
    // int n_29 = 0;
    // int n_30 = 0;
    // String n_01_c = '';
    // String n_02_c = '';
    // String n_03_c = '';
    // String n_04_c = '';
    // String n_05_c = '';
    // String n_06_c = '';
    // String n_07_c = '';
    // String n_08_c = '';
    // String n_09_c = '';
    // String n_10_c = '';
    // String n_11_c = '';
    // String n_12_c = '';
    // String n_13_c = '';
    // String n_14_c = '';
    // String n_15_c = '';
    // String n_16_c = '';
    // String n_17_c = '';
    // String n_18_c = '';
    // String n_19_c = '';
    // String n_20_c = '';
    // String n_21_c = '';
    // String n_22_c = '';
    // String n_23_c = '';
    // String n_24_c = '';
    // String n_25_c = '';
    // String n_26_c = '';
    // String n_27_c = '';
    // String n_28_c = '';
    // String n_29_c = '';
    // String n_30_c = '';
    //
    // if (index == 0) {
    //   column_name = 'n_01';
    //   n_01 = point;
    //   column_name_c = 'n_01_c';
    //   n_01_c = bad_act;
    // } else if (index == 1) {
    //   column_name = 'n_02';
    //   n_02 = point;
    //   column_name_c = 'n_02_c';
    //   n_02_c = bad_act;
    // } else if (index == 2) {
    //   column_name = 'n_03';
    //   n_03 = point;
    //   column_name_c = 'n_03_c';
    //   n_03_c = bad_act;
    // } else if (index == 3) {
    //   column_name = 'n_04';
    //   n_04 = point;
    //   column_name_c = 'n_04_c';
    //   n_04_c = bad_act;
    // } else if (index == 4) {
    //   column_name = 'n_05';
    //   n_05 = point;
    //   column_name_c = 'n_05_c';
    //   n_05_c = bad_act;
    // } else if (index == 5) {
    //   column_name = 'n_06';
    //   n_06 = point;
    //   column_name_c = 'n_06_c';
    //   n_06_c = bad_act;
    // } else if (index == 6) {
    //   column_name = 'n_07';
    //   n_07 = point;
    //   column_name_c = 'n_07_c';
    //   n_07_c = bad_act;
    // } else if (index == 7) {
    //   column_name = 'n_08';
    //   n_08 = point;
    //   column_name_c = 'n_08_c';
    //   n_08_c = bad_act;
    // } else if (index == 8) {
    //   column_name = 'n_09';
    //   n_09 = point;
    //   column_name_c = 'n_09_c';
    //   n_09_c = bad_act;
    // } else if (index == 9) {
    //   column_name = 'n_10';
    //   n_10 = point;
    //   column_name_c = 'n_10_c';
    //   n_10_c = bad_act;
    // } else if (index == 10) {
    //   column_name = 'n_11';
    //   n_11 = point;
    //   column_name_c = 'n_11_c';
    //   n_11_c = bad_act;
    // } else if (index == 11) {
    //   column_name = 'n_12';
    //   n_12 = point;
    //   column_name_c = 'n_12_c';
    //   n_12_c = bad_act;
    // } else if (index == 12) {
    //   column_name = 'n_13';
    //   n_13 = point;
    //   column_name_c = 'n_13_c';
    //   n_13_c = bad_act;
    // } else if (index == 13) {
    //   column_name = 'n_14';
    //   n_14 = point;
    //   column_name_c = 'n_14_c';
    //   n_14_c = bad_act;
    // } else if (index == 14) {
    //   column_name = 'n_15';
    //   n_15 = point;
    //   column_name_c = 'n_15_c';
    //   n_15_c = bad_act;
    // } else if (index == 15) {
    //   column_name = 'n_16';
    //   n_16 = point;
    //   column_name_c = 'n_16_c';
    //   n_16_c = bad_act;
    // } else if (index == 16) {
    //   column_name = 'n_17';
    //   n_17 = point;
    //   column_name_c = 'n_17_c';
    //   n_17_c = bad_act;
    // } else if (index == 17) {
    //   column_name = 'n_18';
    //   n_18 = point;
    //   column_name_c = 'n_18_c';
    //   n_18_c = bad_act;
    // } else if (index == 18) {
    //   column_name = 'n_19';
    //   n_19 = point;
    //   column_name_c = 'n_19_c';
    //   n_19_c = bad_act;
    // } else if (index == 19) {
    //   column_name = 'n_20';
    //   n_20 = point;
    //   column_name_c = 'n_20_c';
    //   n_20_c = bad_act;
    // } else if (index == 20) {
    //   column_name = 'n_21';
    //   n_21 = point;
    //   column_name_c = 'n_21_c';
    //   n_21_c = bad_act;
    // } else if (index == 21) {
    //   column_name = 'n_22';
    //   n_22 = point;
    //   column_name_c = 'n_22_c';
    //   n_22_c = bad_act;
    // } else if (index == 22) {
    //   column_name = 'n_23';
    //   n_23 = point;
    //   column_name_c = 'n_23_c';
    //   n_23_c = bad_act;
    // } else if (index == 23) {
    //   column_name = 'n_24';
    //   n_24 = point;
    //   column_name_c = 'n_24_c';
    //   n_24_c = bad_act;
    // } else if (index == 24) {
    //   column_name = 'n_25';
    //   n_25 = point;
    //   column_name_c = 'n_25_c';
    //   n_25_c = bad_act;
    // } else if (index == 25) {
    //   column_name = 'n_26';
    //   n_26 = point;
    //   column_name_c = 'n_26_c';
    //   n_26_c = bad_act;
    // } else if (index == 26) {
    //   column_name = 'n_27';
    //   n_27 = point;
    //   column_name_c = 'n_27_c';
    //   n_27_c = bad_act;
    // } else if (index == 27) {
    //   column_name = 'n_28';
    //   n_28 = point;
    //   column_name_c = 'n_28_c';
    //   n_28_c = bad_act;
    // } else if (index == 28) {
    //   column_name = 'n_29';
    //   n_29 = point;
    //   column_name_c = 'n_29_c';
    //   n_29_c = bad_act;
    // } else if (index == 29) {
    //   column_name = 'n_30';
    //   n_30 = point;
    //   column_name_c = 'n_30_c';
    //   n_30_c = bad_act;
    // }

    await FirebaseFirestore.instance.collection('relation').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('number', isEqualTo: GetStorage().read('number')).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        await FirebaseFirestore.instance.collection('relation').doc(snapshot.docs.first.id).update({name_list[index]: point, c_name_list[index]: content});
      }else{
        await FirebaseFirestore.instance.collection('relation').add({'class_code': GetStorage().read('class_code'), 'date': DateTime.now(),
          'number': GetStorage().read('number'), 'name': GetStorage().read('name'),
          'n_01': value_list[0], 'n_02': value_list[1],'n_03': value_list[2],'n_04': value_list[3], 'n_05': value_list[4], 'n_06': value_list[5], 'n_07': value_list[6],
          'n_08': value_list[7],'n_09': value_list[8],'n_10': value_list[9], 'n_11': value_list[10],'n_12': value_list[11], 'n_13': value_list[12],'n_14': value_list[13],
          'n_15': value_list[14], 'n_16': value_list[15], 'n_17': value_list[16],'n_18': value_list[17], 'n_19': value_list[18],'n_20': value_list[19], 'n_21': value_list[20],
          'n_22': value_list[21], 'n_23': value_list[22],'n_24': value_list[23], 'n_25': value_list[24], 'n_26': value_list[25],'n_27': value_list[26],'n_28': value_list[27],
          'n_29': value_list[28],'n_30': value_list[29],
          'n_01_c': content_list[0], 'n_02_c': content_list[1],'n_03_c': content_list[2],'n_04_c': content_list[3], 'n_05_c': content_list[4],'n_06_c': content_list[5],
          'n_07_c': content_list[6],'n_08_c': content_list[7],'n_09_c': content_list[8], 'n_10_c': content_list[9], 'n_11_c': content_list[10],'n_12_c': content_list[11],
          'n_13_c': content_list[12],'n_14_c': content_list[13], 'n_15_c': content_list[14],'n_16_c': content_list[15], 'n_17_c': content_list[16],'n_18_c': content_list[17],
          'n_19_c': content_list[18], 'n_20_c': content_list[19],'n_21_c': content_list[20],'n_22_c': content_list[21], 'n_23_c': content_list[22],'n_24_c': content_list[23],
          'n_25_c': content_list[24],'n_26_c': content_list[25],'n_27_c': content_list[26],'n_28_c': content_list[27], 'n_29_c': content_list[28],'n_30_c': content_list[29],
          'bad_act': bad_act
        });
      }
    });

  }

  void updBadAct() async{
    await FirebaseFirestore.instance.collection('relation').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('number', isEqualTo: GetStorage().read('number')).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        await FirebaseFirestore.instance.collection('relation').doc(snapshot.docs.first.id).update({'bad_act': bad_act});
      }
    });
    RelationController.to.bad_act = '';

  }



}






