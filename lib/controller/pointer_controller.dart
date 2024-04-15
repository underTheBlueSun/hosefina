import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class PointerController extends GetxController {
  static PointerController get to => Get.find();

  String pointer_name = '';
  int pointer_number = 0;
  String role = '';
  String upd_role = '';
  List my_pointer_docs = [];

  @override
  void onInit() async {

  }

  void addRole() async{
    await FirebaseFirestore.instance.collection('pointer').add({'date': DateTime.now(), 'class_code': GetStorage().read('class_code'),
      'pointer_number': pointer_number, 'pointer_name': pointer_name, 'role': role, 'pointeds': [] });
  }

  void updRole() async{
    await FirebaseFirestore.instance.collection('pointer').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('pointer_number', isEqualTo: pointer_number).where('role', isEqualTo: role).get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        FirebaseFirestore.instance.collection('pointer').doc(snapshot.docs.first.id).update({'role': upd_role});
      }
      // else {
      //   FirebaseFirestore.instance.collection('pointer').add({'date': DateTime.now(), 'class_code': GetStorage().read('class_code'),
      //     'pointer_number': pointer_number, 'pointer_name': pointer_name, 'role': role, 'pointeds': [pointed_number] });
      // }
    });
  }

  void addPointed(pointed_number, pointed_name) async{
    await FirebaseFirestore.instance.collection('pointer').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('pointer_number', isEqualTo: pointer_number).where('role', isEqualTo: role).get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        List pointeds = snapshot.docs.first['pointeds'];
        pointeds.add(pointed_number.toString() + '/' + pointed_name);
        FirebaseFirestore.instance.collection('pointer').doc(snapshot.docs.first.id).update({'role': role, 'pointeds': pointeds});
      }
      // else {
      //   FirebaseFirestore.instance.collection('pointer').add({'date': DateTime.now(), 'class_code': GetStorage().read('class_code'),
      //     'pointer_number': pointer_number, 'pointer_name': pointer_name, 'role': role, 'pointeds': [pointed_number] });
      // }
    });
  }

  void delPointed(pointed_number) async{
    await FirebaseFirestore.instance.collection('pointer').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('pointer_number', isEqualTo: pointer_number).where('role', isEqualTo: role).get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        List pointeds = snapshot.docs.first['pointeds'];
        pointeds.remove(pointed_number);
        FirebaseFirestore.instance.collection('pointer').doc(snapshot.docs.first.id).update({'role': role, 'pointeds': pointeds});
      }
    });
  }

  void delPointer(doc_id) async{
    await FirebaseFirestore.instance.collection('pointer').doc(doc_id).delete();
  }

  void getMyPointer() async{
    my_pointer_docs = [];
    await FirebaseFirestore.instance.collection('pointer').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('pointer_number', isEqualTo: GetStorage().read('number')).get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        snapshot.docs.forEach((doc) {
          my_pointer_docs.add(doc);
        });

      }
    });
  }

}






