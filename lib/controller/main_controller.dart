import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MainController extends GetxController {
  static MainController get to => Get.find();
  var authentication = FirebaseAuth.instance;

  String email = '';
  String pwd = '';

  RxString active_screen = 'main_list'.obs;
  String school_year = '';
  RxString is_visible_not_email_message = ''.obs;
  // RxBool is_visible_not_email_message = false.obs;

  List<Color> kDefaultRainbowColors =  [Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue, Colors.indigo, Colors.purple,];

  @override
  void onInit() async {
    /// 학년도 가져오기
    // school_year = DateTime.now().toString().substring(0,4);
    // if (DateTime.now().month == 1 || DateTime.now().month == 2) {
    //   school_year = (DateTime.now().year-1).toString();
    // }

  }

  Future<void>  loginTeacher(context) async{

    await FirebaseFirestore.instance.collection('class_info').where('class_code', isEqualTo: GetStorage().read(('class_code'))).where('email', isEqualTo: email).get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        authentication.signInWithEmailAndPassword(email: email, password: pwd).then((UserCredential userCredential) async {
          // GetStorage().write('email', userCredential.user!.email);
          GetStorage().write('number', 0);
          await getAttendance('teacher');
          Navigator.pop(context);
        }).catchError((error) {
          is_visible_not_email_message.value = '비밀번호가 일치하지 않습니다';
          // is_visible_not_email_message.value = true;
          // print(error);
        });
      }else {
        is_visible_not_email_message.value = '이메일과 맞는 반코드가 존재하지 않습니다';
        // is_visible_not_email_message.value = true;
      }
    });
  }

  // void checkEmail(email, context) async{
  //   await FirebaseFirestore.instance.collection('class_info').where('class_code', isEqualTo: GetStorage().read(('class_code'))).where('email', isEqualTo: email).get()
  //       .then((QuerySnapshot snapshot) {
  //     if (snapshot.docs.length > 0) {
  //       GetStorage().write('class_code', snapshot.docs.first['class_code']);
  //       email = email;
  //       GetStorage().write('number', 0);
  //       getAttendance('teacher');
  //       Navigator.pop(context);
  //     }else {
  //       is_visible_not_email_message.value = true;
  //     }
  //   });
  //
  // }

  /// 반코드 입력
  RxBool is_visible_not_class_code_message = false.obs;
  void checkClassCode(class_code) async{
    await FirebaseFirestore.instance.collection('class_info').where('class_code', isEqualTo: class_code).get()
        .then((QuerySnapshot snapshot) async {
          if (snapshot.docs.length > 0) {
            GetStorage().write('class_code', snapshot.docs.first['class_code']);
            email = snapshot.docs.first['email'];
            /// (24.3.5) 과거의 반코드로 조회시 필요
            MainController.to.school_year = snapshot.docs.first['school_year'];
            await getAttendance('student');
          }else {
            is_visible_not_class_code_message.value = true;
          }
    });

  }

  List attendances = [];
  Future<void> getAttendance(job) async{
    await FirebaseFirestore.instance.collection('attendance').where('email', isEqualTo: email).where('yyyy', isEqualTo: school_year).get()
        .then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        attendances = snapshot.docs.toList();
        attendances.sort((a, b) => a['number'].compareTo(b['number']));
        if (GetStorage().read('number') == null) {
          active_screen.value = 'attendance';
        }else{
          if (job == 'teacher') {
            GetStorage().write('name', '선생님');
            GetStorage().write('email', email);
            GetStorage().write('job', 'teacher');
          }
          active_screen.value = 'main_list';
        }

      }
    });
  }

  // void goToMainMenu(number, name) async{
  //   GetStorage().write('number', number);
  //   GetStorage().write('name', name);
  //   GetStorage().write('email', email);
  //   GetStorage().write('job', 'student');
  //   active_screen.value = 'main_list';
  // }

  void addVisit(id, number, name) async{
    await FirebaseFirestore.instance.collection('class_info').doc(id)
        .update({ 'visit': FieldValue.arrayUnion([{'number': number, 'name': name}]) });

    GetStorage().write('number', number);
    GetStorage().write('name', name);
    GetStorage().write('email', email);
    GetStorage().write('job', 'student');
    GetStorage().write('class_info_id', id);
    active_screen.value = 'main_list';

  }

  void exitClass() async{
    if (GetStorage().read('job') == 'student') {
      await FirebaseFirestore.instance.collection('class_info').doc(GetStorage().read('class_info_id'))
          .update({ 'visit': FieldValue.arrayRemove([{'number': GetStorage().read('number'), 'name': GetStorage().read('name')}]) })
          .catchError((error) {print(error);});
    }


    GetStorage().remove('class_code');
    GetStorage().remove('number');
    GetStorage().remove('name');
    GetStorage().remove('email');
    GetStorage().remove('job');
    GetStorage().remove('class_info_id');
    MainController.to.active_screen.value = 'class_code_add';

  }

  String pay_gubun = '무료';
  // int free_period = 30;
  void payment() async{
    var date = DateTime.now().toString().substring(0,10);
    // var free_end_date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + free_period).toString().substring(0,10);
    await FirebaseFirestore.instance.collection('payment').get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        await FirebaseFirestore.instance.collection('payment').doc(snapshot.docs.first.id)
            .update({'date': date, 'pay_gubun': pay_gubun, 'free_period': 30 });
      }else{
        await FirebaseFirestore.instance.collection('payment').add({'date': date, 'pay_gubun': pay_gubun, 'free_period': 30 });
      }
    });
  }

  String payment_pay_gubun = '무료';
  int payment_free_period = 30;
  String purchase = 'no';
  String free_end_date = '';
  Future<void> checkFreePay() async{
    String date = DateTime.now().toString().substring(0,10);
    await FirebaseFirestore.instance.collection('payment').get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        payment_pay_gubun = snapshot.docs.first['pay_gubun'];
        payment_free_period = snapshot.docs.first['free_period'];
        free_end_date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + payment_free_period).toString().substring(0,10);
      }
    });
    await FirebaseFirestore.instance.collection('class_info').where('class_code', isEqualTo: GetStorage().read(('class_code'))).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        if (payment_pay_gubun == '유료') {
          if (snapshot.docs.first['temp2'] == '9999-12-30') {
            await FirebaseFirestore.instance.collection('class_info').doc(snapshot.docs.first.id).update({'gubun': payment_pay_gubun, 'temp1': date, 'temp2': free_end_date});
          }else {
            await FirebaseFirestore.instance.collection('class_info').doc(snapshot.docs.first.id).update({'gubun': payment_pay_gubun, 'temp1': date});
          }
        }else if (payment_pay_gubun == '무료') {
          await FirebaseFirestore.instance.collection('class_info').doc(snapshot.docs.first.id).update({'gubun': payment_pay_gubun, 'temp1': date, 'temp2': '9999-12-30'});
        }
        purchase = snapshot.docs.first['purchase'];
        free_end_date = snapshot.docs.first['temp2'];
      }

    });
  }

}






