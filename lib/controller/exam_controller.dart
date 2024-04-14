import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ExamController extends GetxController {
  static ExamController get to => Get.find();

  String subject = '국어';
  RxList answer_list = [Answer(1,0),Answer(2,0),Answer(3,0),Answer(4,0),Answer(5,0),Answer(6,0),Answer(7,0),Answer(8,0),Answer(9,0),Answer(10,0),
    Answer(11,0),Answer(12,0),Answer(13,0),Answer(14,0),Answer(15,0),Answer(16,0),Answer(17,0),Answer(18,0),Answer(19,0),Answer(20,0),
    Answer(21,0),Answer(22,0),Answer(23,0),Answer(24,0),Answer(25,0)].obs;
  RxString dummy_date = DateTime.now().toString().obs;

  // List complete_subject_list = [];

  @override
  void onInit() async {

  }

  // void addAnswer() async{
  //   FirebaseFirestore.instance.collection('exam_answer').add({'subject': '국어',
  //     'a1': 0,'a2': 0,'a3': 0,'a4': 0,'a5': 0,'a6': 0,'a7': 0,'a8': 0,'a9': 0,'a10': 0,'a11': 0,'a12': 0,'a13': 0,'a14': 0,'a15': 0,'a16': 0,'a17': 0,
  //     'a18': 0,'a19': 0,'a20': 0, 'a21': 0,'a22': 0,'a23': 0,'a24': 0,'a25': 0,});
  //
  //   FirebaseFirestore.instance.collection('exam_answer').add({'subject': '수학',
  //     'a1': 0,'a2': 0,'a3': 0,'a4': 0,'a5': 0,'a6': 0,'a7': 0,'a8': 0,'a9': 0,'a10': 0,'a11': 0,'a12': 0,'a13': 0,'a14': 0,'a15': 0,'a16': 0,'a17': 0,
  //     'a18': 0,'a19': 0,'a20': 0, 'a21': 0,'a22': 0,'a23': 0,'a24': 0,'a25': 0,});
  //
  //   FirebaseFirestore.instance.collection('exam_answer').add({'subject': '사회',
  //     'a1': 0,'a2': 0,'a3': 0,'a4': 0,'a5': 0,'a6': 0,'a7': 0,'a8': 0,'a9': 0,'a10': 0,'a11': 0,'a12': 0,'a13': 0,'a14': 0,'a15': 0,'a16': 0,'a17': 0,
  //     'a18': 0,'a19': 0,'a20': 0, 'a21': 0,'a22': 0,'a23': 0,'a24': 0,'a25': 0,});
  //
  //   FirebaseFirestore.instance.collection('exam_answer').add({'subject': '과학',
  //     'a1': 0,'a2': 0,'a3': 0,'a4': 0,'a5': 0,'a6': 0,'a7': 0,'a8': 0,'a9': 0,'a10': 0,'a11': 0,'a12': 0,'a13': 0,'a14': 0,'a15': 0,'a16': 0,'a17': 0,
  //     'a18': 0,'a19': 0,'a20': 0, 'a21': 0,'a22': 0,'a23': 0,'a24': 0,'a25': 0,});
  //
  //   FirebaseFirestore.instance.collection('exam_answer').add({'subject': '영어',
  //     'a1': 0,'a2': 0,'a3': 0,'a4': 0,'a5': 0,'a6': 0,'a7': 0,'a8': 0,'a9': 0,'a10': 0,'a11': 0,'a12': 0,'a13': 0,'a14': 0,'a15': 0,'a16': 0,'a17': 0,
  //     'a18': 0,'a19': 0,'a20': 0, 'a21': 0,'a22': 0,'a23': 0,'a24': 0,'a25': 0,});
  //
  // }

  void addSheet() async{
    int id = 0;
    if (subject == '국어') { id = 1;}
    else if(subject == '사회') { id = 2;}
    else if(subject == '수학') { id = 3;}
    else if(subject == '과학') { id = 4;}
    else if(subject == '영어') { id = 5;}

    await FirebaseFirestore.instance.collection('exam_sheet').add({'class_code': GetStorage().read('class_code'), 'date': DateTime.now().toString(),
      'number': GetStorage().read('number'), 'name': GetStorage().read('name'),'id': id,'subject': subject,
      'a1': answer_list.value[0].answer, 'a1_score': 0,'a2': answer_list.value[1].answer,'a2_score': 0,'a3': answer_list.value[2].answer,'a3_score': 0,
      'a4': answer_list.value[3].answer, 'a4_score': 0,'a5': answer_list.value[4].answer,'a5_score': 0,'a6': answer_list.value[5].answer,'a6_score': 0,
      'a7': answer_list.value[6].answer, 'a7_score': 0,'a8': answer_list.value[7].answer,'a8_score': 0,'a9': answer_list.value[8].answer,'a9_score': 0,
      'a10': answer_list.value[9].answer, 'a10_score': 0,'a11': answer_list.value[10].answer,'a11_score': 0,'a12': answer_list.value[11].answer,'a12_score': 0,
      'a13': answer_list.value[12].answer, 'a13_score': 0,'a14': answer_list.value[13].answer,'a14_score': 0,'a15': answer_list.value[14].answer,'a15_score': 0,
      'a16': answer_list.value[15].answer, 'a16_score': 0,'a17': answer_list.value[16].answer,'a17_score': 0,'a18': answer_list.value[17].answer,'a18_score': 0,
      'a19': answer_list.value[18].answer, 'a19_score': 0,'a20': answer_list.value[19].answer,'a20_score': 0,'a21': answer_list.value[20].answer,'a21_score': 0,
      'a22': answer_list.value[21].answer, 'a22_score': 0,'a23': answer_list.value[22].answer,'a23_score': 0,'a24': answer_list.value[23].answer,'a24_score': 0,
      'a25': answer_list.value[24].answer,'a25_score': 0,
    });

    answer_list.value = [Answer(1,0),Answer(2,0),Answer(3,0),Answer(4,0),Answer(5,0),Answer(6,0),Answer(7,0),Answer(8,0),Answer(9,0),Answer(10,0),
      Answer(11,0),Answer(12,0),Answer(13,0),Answer(14,0),Answer(15,0),Answer(16,0),Answer(17,0),Answer(18,0),Answer(19,0),Answer(20,0),
      Answer(21,0),Answer(22,0),Answer(23,0),Answer(24,0),Answer(25,0)].obs;

  }

  // Future<void> addSheet() async{
  //   await FirebaseFirestore.instance.collection('exam_answer').where('subject', isEqualTo: subject).get().then((QuerySnapshot snapshot) {
  //     if (snapshot.docs.length > 0) {
  //       var a1_score = snapshot.docs.first['a1'] == answer_list.value[0].answer ? 1 : 0;
  //       var a2_score = snapshot.docs.first['a2'] == answer_list.value[1].answer ? 1 : 0;
  //       var a3_score = snapshot.docs.first['a3'] == answer_list.value[2].answer ? 1 : 0;
  //       var a4_score = snapshot.docs.first['a4'] == answer_list.value[3].answer ? 1 : 0;
  //       var a5_score = snapshot.docs.first['a5'] == answer_list.value[4].answer ? 1 : 0;
  //       var a6_score = snapshot.docs.first['a6'] == answer_list.value[5].answer ? 1 : 0;
  //       var a7_score = snapshot.docs.first['a7'] == answer_list.value[6].answer ? 1 : 0;
  //       var a8_score = snapshot.docs.first['a8'] == answer_list.value[7].answer ? 1 : 0;
  //       var a9_score = snapshot.docs.first['a9'] == answer_list.value[8].answer ? 1 : 0;
  //       var a10_score = snapshot.docs.first['a10'] == answer_list.value[9].answer ? 1 : 0;
  //       var a11_score = snapshot.docs.first['a11'] == answer_list.value[10].answer ? 1 : 0;
  //       var a12_score = snapshot.docs.first['a12'] == answer_list.value[11].answer ? 1 : 0;
  //       var a13_score = snapshot.docs.first['a13'] == answer_list.value[12].answer ? 1 : 0;
  //       var a14_score = snapshot.docs.first['a14'] == answer_list.value[13].answer ? 1 : 0;
  //       var a15_score = snapshot.docs.first['a15'] == answer_list.value[14].answer ? 1 : 0;
  //       var a16_score = snapshot.docs.first['a16'] == answer_list.value[15].answer ? 1 : 0;
  //       var a17_score = snapshot.docs.first['a17'] == answer_list.value[16].answer ? 1 : 0;
  //       var a18_score = snapshot.docs.first['a18'] == answer_list.value[17].answer ? 1 : 0;
  //       var a19_score = snapshot.docs.first['a19'] == answer_list.value[18].answer ? 1 : 0;
  //       var a20_score = snapshot.docs.first['a20'] == answer_list.value[19].answer ? 1 : 0;
  //       var a21_score = snapshot.docs.first['a21'] == answer_list.value[20].answer ? 1 : 0;
  //       var a22_score = snapshot.docs.first['a22'] == answer_list.value[21].answer ? 1 : 0;
  //       var a23_score = snapshot.docs.first['a23'] == answer_list.value[22].answer ? 1 : 0;
  //       var a24_score = snapshot.docs.first['a24'] == answer_list.value[23].answer ? 1 : 0;
  //       var a25_score = snapshot.docs.first['a25'] == answer_list.value[24].answer ? 1 : 0;
  //
  //       int id = 0;
  //       if (subject == '국어') { id = 1;}
  //       else if(subject == '사회') { id = 2;}
  //       else if(subject == '수학') { id = 3;}
  //       else if(subject == '과학') { id = 4;}
  //       else if(subject == '영어') { id = 5;}
  //
  //       FirebaseFirestore.instance.collection('exam_sheet').add({'class_code': GetStorage().read('class_code'), 'date': DateTime.now().toString(),
  //         'number': GetStorage().read('number'), 'name': GetStorage().read('name'),'id': id,'subject': subject,
  //         'a1': answer_list.value[0].answer, 'a1_score': a1_score,'a2': answer_list.value[1].answer,'a2_score': a2_score,'a3': answer_list.value[2].answer,'a3_score': a3_score,
  //         'a4': answer_list.value[3].answer, 'a4_score': a4_score,'a5': answer_list.value[4].answer,'a5_score': a5_score,'a6': answer_list.value[5].answer,'a6_score': a6_score,
  //         'a7': answer_list.value[6].answer, 'a7_score': a7_score,'a8': answer_list.value[7].answer,'a8_score': a8_score,'a9': answer_list.value[8].answer,'a9_score': a9_score,
  //         'a10': answer_list.value[9].answer, 'a10_score': a10_score,'a11': answer_list.value[10].answer,'a11_score': a11_score,'a12': answer_list.value[11].answer,'a12_score': a12_score,
  //         'a13': answer_list.value[12].answer, 'a13_score': a13_score,'a14': answer_list.value[13].answer,'a14_score': a14_score,'a15': answer_list.value[14].answer,'a15_score': a15_score,
  //         'a16': answer_list.value[15].answer, 'a16_score': a16_score,'a17': answer_list.value[16].answer,'a17_score': a17_score,'a18': answer_list.value[17].answer,'a18_score': a18_score,
  //         'a19': answer_list.value[18].answer, 'a19_score': a19_score,'a20': answer_list.value[19].answer,'a20_score': a20_score,'a21': answer_list.value[20].answer,'a21_score': a21_score,
  //         'a22': answer_list.value[21].answer, 'a22_score': a22_score,'a23': answer_list.value[22].answer,'a23_score': a23_score,'a24': answer_list.value[23].answer,'a24_score': a24_score,
  //         'a25': answer_list.value[24].answer,'a25_score': a25_score,
  //       });
  //     }
  //   });
  //
  //   answer_list.value = [Answer(1,0),Answer(2,0),Answer(3,0),Answer(4,0),Answer(5,0),Answer(6,0),Answer(7,0),Answer(8,0),Answer(9,0),Answer(10,0),
  //     Answer(11,0),Answer(12,0),Answer(13,0),Answer(14,0),Answer(15,0),Answer(16,0),Answer(17,0),Answer(18,0),Answer(19,0),Answer(20,0),
  //     Answer(21,0),Answer(22,0),Answer(23,0),Answer(24,0),Answer(25,0)].obs;
  //
  // }

  void deleteSheet() async{
    await FirebaseFirestore.instance.collection('exam_sheet').get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        FirebaseFirestore.instance.collection('exam_sheet').doc(doc.id).delete();
      });
    });

  }



}

class Answer {
  int number;
  int answer;
  Answer(this.number, this.answer);
}






