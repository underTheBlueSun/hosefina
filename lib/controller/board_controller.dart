import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class ImageModel {
  File? pickedImage;
  File?  thumbnailFile;
  Uint8List? imageInt8;
}


class BoardController extends GetxController {
  static BoardController get to => Get.find();

  var board_main_id;  // 타임스탬프
  String board_gubun = '보드';
  String board_title = '';
  String board_type = '개인';
  RxString background = 'bg01'.obs;
  String indi_title = '';
  String indi_content = '';
  String indi_comment = '';
  RxBool isImageLoading = false.obs;
  RxString selectedStamp = ''.obs;
  Rx<ImageModel> imageModel = ImageModel().obs;
  RxInt dummy = 0.obs;
  String image_url = '';
  String board_indi_modum_id = '';
  String school_year = '';
  double sizeKbs = 0;
  final int maxSizeKbs = 1024;
  var size = 0;
  String board_modum_id = '';
  RxList stamps = [].obs;
  RxString nowdate = ''.obs;

  String indiCommentInput = '';
  String popCloseType = 'nosave';
  RxInt modumIndex = 0.obs; /// boardModum에서 이미지로딩시 식별하기위해, 이거 안하면 같은 번호 모두 로딩이미지 보여짐
  RxDouble board_full_screen_text_size = 45.0.obs;

  int modumLastNumber = 6; // 모둠추가시 필요
  int modum_number = 1;

  @override
  void onInit() async {
    // 학년도 가져오기
    school_year = DateTime.now().toString().substring(0,4);
    if (DateTime.now().month == 1 || DateTime.now().month == 2) {
      school_year = (DateTime.now().year-1).toString();
    }

  }

  int main_cnt = 0;
  void retTest() async{
    await FirebaseFirestore.instance.collection('board_main').get()
        .then((QuerySnapshot querySnapshot) {
      main_cnt = querySnapshot.docs.length;
      print('main_cnt: ' + main_cnt.toString());
    });


  }

  Future<void> delComment(commment, gubun) async{
    await FirebaseFirestore.instance.collection(gubun).doc(board_indi_modum_id)
        .update({ 'comment': FieldValue.arrayRemove([commment]) });
        // .update({ 'comment': FieldValue.arrayRemove([{'date': commment['date'].toDate(), 'name': GetStorage().read('name'), 'comment': commment['comment']}]) });
  }

  void addLike(number, gubun) async{
    await FirebaseFirestore.instance.collection(gubun).doc(board_indi_modum_id)
        .update({ 'like': FieldValue.arrayUnion([number]) });
  }

  void addStamp(id, gubun) async{
    await FirebaseFirestore.instance.collection(gubun).doc(id).update({ 'stamp': selectedStamp.value });

  }

  void delStamp(id, gubun) async{
    if (gubun == 'board_indi') {
      await FirebaseFirestore.instance.collection('board_indi').doc(id).update({ 'stamp': '' });
    }else {
      await FirebaseFirestore.instance.collection('board_modum').doc(id).update({ 'stamp': '' });
    }

  }

  void addAllStamp(mainId, gubun) async{

    if (gubun == 'indi') {
      await FirebaseFirestore.instance.collection('board_indi').where('class_code', isEqualTo: GetStorage().read('class_code'))
          .where('main_id', isEqualTo: mainId.toDate()).get()
          .then((QuerySnapshot snapshot) {
        if (!snapshot.docs.isEmpty) {
          for (var doc in snapshot.docs) {
            FirebaseFirestore.instance.collection('board_indi').doc(doc.id).update({ 'stamp': selectedStamp.value });
          }
        }
      });
    }else{
      await FirebaseFirestore.instance.collection('board_modum').where('class_code', isEqualTo: GetStorage().read('class_code'))
          .where('main_id', isEqualTo: mainId.toDate()).get()
          .then((QuerySnapshot snapshot) {
        if (!snapshot.docs.isEmpty) {
          for (var doc in snapshot.docs) {
            FirebaseFirestore.instance.collection('board_modum').doc(doc.id).update({ 'stamp': selectedStamp.value });
          }
        }
      });
    }

  }

  void delAllStamp(mainId, gubun) async{
    if (gubun == 'indi') {
      await FirebaseFirestore.instance.collection('board_indi').where('class_code', isEqualTo: GetStorage().read('class_code'))
          .where('main_id', isEqualTo: mainId.toDate()).get()
          .then((QuerySnapshot snapshot) {
        if (!snapshot.docs.isEmpty) {
          for (var doc in snapshot.docs) {
            FirebaseFirestore.instance.collection('board_indi').doc(doc.id).update({ 'stamp': '' });
          }

        }
      });
    }else {
      await FirebaseFirestore.instance.collection('board_modum').where('class_code', isEqualTo: GetStorage().read('class_code'))
          .where('main_id', isEqualTo: mainId.toDate()).get()
          .then((QuerySnapshot snapshot) {
        if (!snapshot.docs.isEmpty) {
          for (var doc in snapshot.docs) {
            FirebaseFirestore.instance.collection('board_modum').doc(doc.id).update({ 'stamp': '' });
          }

        }
      });
    }

  }

  Future<void> updComment(commment, gubun) async{
    await FirebaseFirestore.instance.collection(gubun).doc(board_indi_modum_id)
        .update({ 'comment': FieldValue.arrayRemove([commment]) });

    await FirebaseFirestore.instance.collection(gubun).doc(board_indi_modum_id)
        .update({ 'comment': FieldValue.arrayUnion([{'date': commment['date'].toDate(), 'name': GetStorage().read('name'), 'comment': indi_comment}]) });
  }

  void delImage(imageUrl, gubun) async{
    await FirebaseFirestore.instance.collection(gubun).doc(board_indi_modum_id).update({ 'imageUrl': '' });
    var fileRef = FirebaseStorage.instance.refFromURL(imageUrl);
    fileRef.delete();
  }

  void delLike(number, gubun) async{
    await FirebaseFirestore.instance.collection(gubun).doc(board_indi_modum_id)
        .update({ 'like': FieldValue.arrayRemove([number]) });

  }

  void saveComment(value, gubun) async{
    await FirebaseFirestore.instance.collection(gubun).doc(board_indi_modum_id)
        .update({ 'comment': FieldValue.arrayUnion([{'date': DateTime.now(), 'name': GetStorage().read('name'), 'comment': value}]) });
  }

  Future<void> delBoardIndi() async{
    FirebaseFirestore.instance.collection('board_indi').doc(board_indi_modum_id).delete();
    // PointController.to.delPoint(GetStorage().read('number'));
  }

  Future<void> delBoardModum() async{
    FirebaseFirestore.instance.collection('board_modum').doc(board_indi_modum_id).delete();

    // PointController.to.delPoint(GetStorage().read('number'));
  }

  void saveBoardIndi(number) async{
    DocumentReference doc = await FirebaseFirestore.instance.collection('board_indi')
        .add({'date': DateTime.now(), 'class_code': GetStorage().read('class_code'), 'school_year': school_year, 'main_id': board_main_id, 'number': number, 'title': indi_title,
      'content': indi_content, 'comment' : [], 'imageUrl' : '', 'thumbUrl' : '', 'like' : [], 'stamp' : '' })
        .catchError((error) { print('saveBoardIndi() : ${error}'); });

    /// 이미지 처리
    String imageName = DateTime.now().toString();

    if (imageModel.value.imageInt8 != null) {
      /// 이미지로딩중
      isImageLoading.value = true;
      await imageToStorage(imageName, imageModel.value.imageInt8!, doc.id, 'indi');
    }

    indi_title = '';
    indi_content = '';
  }

  void saveBoardModum() async{
    DocumentReference doc = await FirebaseFirestore.instance.collection('board_modum')
        .add({'date': DateTime.now(), 'class_code': GetStorage().read('class_code'), 'school_year': school_year, 'main_id': board_main_id,
      'modum_number' : modum_number, 'stu_number': GetStorage().read('number'), 'stu_name': GetStorage().read('name'), 'title': indi_title,
      'content': indi_content, 'comment' : [], 'imageUrl' : '', 'thumbUrl' : '', 'like' : [], 'stamp' : '' })
        .catchError((error) { print('saveBoardModum() : ${error}'); });

    /// 이미지 처리
    String imageName = DateTime.now().toString();

    if (imageModel.value.imageInt8 != null) {
      popCloseType = 'save';
      /// 이미지로딩중
      isImageLoading.value = true;
      await imageToStorage(imageName, imageModel.value.imageInt8!, doc.id, 'modum');
    }
    /// indiTitleInput: indi 이름 고치기 귀찮아서 그냥 놔둠
    indi_title = '';
    indi_content = '';

  }

  void selectImage() async{
    final XFile? image =  await ImagePicker().pickImage(source: ImageSource.gallery);

    imageModel.value.imageInt8 = await image?.readAsBytes();
    ///  변하는 상태값을 하나 더 안주면 이미지가 상태 반영이 안됨. 조건문이 있으면 바로 인식못하는것 같음
    dummy.value  = dummy.value + 1;
  }

  /// 파이어베이스 스토리지에 저장
  Future<void> imageToStorage(String filename, Uint8List imageInt8, id, gubun) async{
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref()
        .child('board/${GetStorage().read('class_code')}')
        .child('/$filename.jpg');
    final metadata = firebase_storage.SettableMetadata(contentType: 'image/jpeg');

    var uploadTask;

    uploadTask = ref.putData(imageInt8, metadata);

    await uploadTask.whenComplete(() => null);
    String imageUrl = await ref.getDownloadURL();
    imageModel.value.imageInt8 = null;


    Future.delayed(const Duration(milliseconds: 4000), () async{
      final desertRef = FirebaseStorage.instance.ref('board/${GetStorage().read('class_code')}/$filename.jpg');
      await desertRef.delete();
      List imageUrls = imageUrl.split('.jpg');
      String new_imageUrl = imageUrls[0] + '_2000x2000.jpg' + imageUrls[1];
      if (gubun == 'main') {
        await FirebaseFirestore.instance.collection('board_main').doc(id).update({ 'imageUrl': new_imageUrl}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
      }else if(gubun == 'indi') {
        await FirebaseFirestore.instance.collection('board_indi').doc(id).update({ 'imageUrl': new_imageUrl}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
      }else {
        await FirebaseFirestore.instance.collection('board_modum').doc(id).update({ 'imageUrl': new_imageUrl}).catchError((error) {print("정상적으로 업데이트가 되지 않았습니다.");});
      }
      isImageLoading.value = false;
    });

  }

  Future<void> updBoardIndi() async{
    await FirebaseFirestore.instance.collection('board_indi').doc(board_indi_modum_id)
        .update({ 'title': indi_title, 'content': indi_content});

    /// 이미지 처리
    String imageName = DateTime.now().toString();
    if (imageModel.value.imageInt8 != null) {
      /// 이미지로딩중
      isImageLoading.value = true;
      imageToStorage(imageName, imageModel.value.imageInt8!, board_indi_modum_id, 'indi');
    }

    indi_title = '';
    indi_content = '';
  }

  Future<void> updBoardModum() async{
    await FirebaseFirestore.instance.collection('board_modum').doc(board_indi_modum_id)
        .update({ 'title': indi_title, 'content': indi_content});

    /// 이미지 처리
    String imageName = DateTime.now().toString();
    if (imageModel.value.imageInt8 != null) {
      /// 이미지로딩중
      isImageLoading.value = true;
      imageToStorage(imageName, imageModel.value.imageInt8!, board_indi_modum_id, 'modum');
    }

    indi_title = '';
    indi_content = '';
  }




}






