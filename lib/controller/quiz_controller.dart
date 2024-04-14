import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:collection/collection.dart';

class QuizController extends GetxController {
  static QuizController get to => Get.find();

  String quiz_id = '';
  String score_doc_id = '';
  RxBool is_visible_loading = true.obs;
  RxBool is_visible_count_down = false.obs;
  // RxString active_screen_quiz = 'entrance'.obs;
  String start_date = '';
  RxBool is_visible_timer = false.obs;
  RxString quiz_indi_timer = 'X'.obs;
  RxString quiz_modum_total_timer = '1'.obs;
  RxString quiz_modum_indi_timer = '10'.obs;
  RxString quiz_type = '개인'.obs;
  RxString quiz_title = ''.obs;
  double remain_time = 0.0;
  int number = 0;
  RxString answer = ''.obs;
  String end_date = '';
  RxBool is_visible_score = false.obs;
  RxInt question_number = 1.obs;  /// 모둠에서 필요
  RxInt select_answer = 0.obs;  /// 모둠에서 답지선택시
  List submitters = [];
  String question_type = '선택형';

  String school_year = '';
  RxString search_grade = '학년'.obs;
  RxString search_semester = '학기'.obs;
  RxString search_subject = '과목'.obs;
  RxString active_screen = 'all'.obs;
  RxInt is_hover_start = 99999.obs;
  RxInt is_hover_edit = 99999.obs;

  String quiz_description = '';
  RxString quiz_grade = '1학년'.obs;
  RxString quiz_semester = '1학기'.obs;
  RxString quiz_subject = '국어'.obs;
  RxString quiz_quiz_type = '개인'.obs;
  RxString quiz_quiz_title = ''.obs;

  RxBool is_visible_indi_timer = true.obs;
  RxBool is_visible_modum_total_timer = false.obs;
  RxBool is_visible_modum_indi_timer = false.obs;
  RxString quiz_public_type = '공개'.obs;
  DateTime quiz_date = DateTime.now();
  DateTime question_date = DateTime.now();
  RxBool is_visible_answer = false.obs;

  // String question_id = '';
  // RxString question = ''.obs;
  // RxString answer1 = ''.obs;
  // RxString answer2 = ''.obs;
  // RxString answer3 = ''.obs;
  // RxString answer4 = ''.obs;
  // RxString question_tex = ''.obs;
  // RxString answer1_tex = ''.obs;
  // RxString answer2_tex = ''.obs;
  // RxString answer3_tex = ''.obs;
  // RxString answer4_tex = ''.obs;
  // RxString question_image_url = ''.obs;
  // String answer1_image_url = '';
  // String answer2_image_url = '';
  // String answer3_image_url = '';
  // String answer4_image_url = '';
  // RxBool is_visible_start_btn = false.obs;

  // List grades = ['1학년', '2학년', '3학년', '4학년', '5학년', '6학년'];
  // List semesters = ['1학기', '2학기'];
  // List subjects = ['국어', '수학', '사회', '과학', '영어', '실과', '체육', '음악', '미술', '창체'];
  // List subjects1 = ['국어', '수학', '사회', '과학', '영어', '실과'];
  // List subjects2 = ['체육', '음악', '미술', '창체'];
  // List quiz_types = ['개인', '모둠'];
  // List question_types = ['선택형', 'OX형', '시험지 배부형'];
  // List indi_timers = ['5', '10', '15', '20', '25', '30', '40', '50', '60'];
  // List modum_total_timers = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  // List modum_indi_timers = ['10', '20', '30', '40', '50', '60'];
  // List public_types = ['공개', '비공개'];




  @override
  void onInit() async {

  }

  List questions = [];
  void createQuestionList() async{
    // questions = [];  // 이것 때문에 no element 에러남
    if (quiz_id.length > 0) {
      // await FirebaseFirestore.instance.collection('quiz_question').where('quiz_id', isEqualTo: 'hQJfjK1MwxIai4UbdYtP').get().then((QuerySnapshot snapshot) async {
      await FirebaseFirestore.instance.collection('quiz_question').where('quiz_id', isEqualTo: quiz_id).get().then((QuerySnapshot snapshot) async {
        if (!snapshot.docs.isEmpty) {
          questions = snapshot.docs.toList();
        }
      });
    }

  }

  void updIsActiveTrue() async {
    /// number 가 string 임
    await FirebaseFirestore.instance.collection('quiz_player').where('class_code', isEqualTo: GetStorage().read('class_code')).where('number', isEqualTo: GetStorage().read('number').toString())
        .get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        FirebaseFirestore.instance.collection('quiz_player').doc(snapshot.docs.first.id).update({'is_active': true});
      }
    });

  }

  void updIsActiveFalse() async {
    await FirebaseFirestore.instance.collection('quiz_player').where('class_code', isEqualTo: GetStorage().read('class_code')).where('number', isEqualTo: GetStorage().read('number').toString())
        .get().then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        FirebaseFirestore.instance.collection('quiz_player').doc(snapshot.docs.first.id).update({'is_active': false});
      }
    });

  }

  /// 사용자 점수 입력
  void updUserScore(select_answer, answer) { // 버튼 연타때문에 async 뺌
    Duration dif = DateTime.parse(end_date).difference(DateTime.parse(start_date));
    int score = 0;

    if (question_type == '단답형') {
      if (answer.split(',').contains(select_answer)) {
        score = 1;
      }
    } else {
      if (select_answer == answer) {
        score = 1;
        // PointController.to.addPoint(GetStorage().read('number'), GetStorage().read('name'));
      }
    }


    submitters.forEach((submitter) {
      if (submitter['name'] == GetStorage().read(('name'))) {
        FirebaseFirestore.instance.collection('quiz_question_score').doc(score_doc_id)
            .update({ 'submitter': FieldValue.arrayRemove([submitter]) });
      }
    });

    FirebaseFirestore.instance.collection('quiz_question_score').doc(score_doc_id)
        .update({ 'submitter': FieldValue.arrayUnion([{'name': GetStorage().read('name'), 'time': dif.toString(), 'select_answer': select_answer, 'score': score}]) });

  }

  /// 문제별 순위
  List score_question_list = [];
  Future<void> scoreQuestion(number, answer) async{
    score_question_list = [];
    await FirebaseFirestore.instance.collection('quiz_question_score').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('quiz_id', isEqualTo: quiz_id).where('question_number', isEqualTo: number).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.first['submitter'].length > 0) {
        snapshot.docs.first['submitter'].forEach((data) {
          score_question_list.add({'name': data['name'], 'score': data['score'], 'correct': data['score'] == 1 ? 'O' : 'X' , 'time': data['time'],});
          // score_question_list.add({'name': data['name'], 'score': data['score'], 'correct': answer == data['select_answer'] ? 'O' : 'X' , 'time': data['time'],});
        });

      }
    });

    /// 같은 이름은 삭제
    score_question_list.removeWhere((a) => a != score_question_list.firstWhere((b) => b['name'] == a['name'] ));

    /// 정렬
    score_question_list.sort((a, b) {
      int correctComp = a['correct'].compareTo(b['correct']);
      if (correctComp == 0) {
        return a['time'].compareTo(b['time']);
      }
      return correctComp;
    });
  }

  /// 전체 순위
  List total_list = [];
  Future<void> scoreTotal() async{
    total_list = [];
    await FirebaseFirestore.instance.collection('quiz_question_score').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('quiz_id', isEqualTo: quiz_id).get().then((QuerySnapshot snapshot) async {
      if (!snapshot.docs.isEmpty) {
        List<Map> list_map = [];
        snapshot.docs.forEach((doc) {
          /// 같은 이름은 삭제(버튼 연타 대비)
          List remove_dupli_list = [];
          remove_dupli_list = doc['submitter'];
          if (remove_dupli_list.length > 1) {
            remove_dupli_list.removeWhere((a) => a != remove_dupli_list.firstWhere((b) => b['name'] == a['name'] ));
          }

          /// score = 0 제외
          // remove_dupli_list.removeWhere((a) => a['score'] == 0 );

          for (int index = 0; index < remove_dupli_list.length; index++) {
            list_map.add(remove_dupli_list[index]);
          }

        });

        var total_map = groupBy(list_map, (Map obj) => obj['name']).map(
                (k, v) => MapEntry(k, v.map((item) { item.remove('name'); return item;}).toList()));

        total_map.forEach((key, value) {
          int? score = 0;
          int? score_sum = 0;
          // String? time = '';
          double time_sum = 0.0;
          for (int index = 0; index < value.length; index++) {
            score = value[index]['score'] as int;
            score_sum = (score! + score_sum!);
            if (score == 1) {
              time_sum = double.parse(value[index]['time'].substring(5,11))! + time_sum!;
            }

          }
          total_list.add({'name': key, 'score': score_sum, 'time': time_sum,});
        });
      } // if
    }); // then

    /// 정렬
    total_list.sort((a, b) {
      int scoreComp = b['score'].compareTo(a['score']);
      if (scoreComp == 0) {
        return a['time'].compareTo(b['time']);
      }
      return scoreComp;
    });

  }

  var rank_question_index = 0;
  var correct = '';
  var rank_tatal_index = 0;
  Future<void> scoreMobile() async{
    rank_question_index = score_question_list.indexWhere((e) => e['name'] == GetStorage().read('name'));
    if (score_question_list.where((e) => e['name'] == GetStorage().read('name')).length > 0) {
      correct = score_question_list.where((e) => e['name'] == GetStorage().read('name')).first['correct'];
    }else {
      correct = 'X';
    }

    if (rank_question_index != -1) {
      rank_question_index = rank_question_index + 1;
    }
    rank_tatal_index = total_list.indexWhere((e) => e['name'] == GetStorage().read('name'));
    if (rank_tatal_index != -1) {
      rank_tatal_index = rank_tatal_index + 1;
    }

  }

  /// 모둠에서 맞춘 갯수 보여주기
  int score = 0;
  Future<void> getScore() async{
    score = 0;
    await FirebaseFirestore.instance.collection('quiz_question_score').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('quiz_id', isEqualTo: quiz_id).get().then((QuerySnapshot snapshot) async {
      if (!snapshot.docs.isEmpty) {
        snapshot.docs.forEach((doc) {
          if (doc['submitter'].length > 0) {
            score = score + doc['submitter'].where((map) => map['name'] == GetStorage().read('name')).first['score'] as int;
          }

        });
      } // if
    }); // then

  }

  void delQuiz() async {
    await FirebaseFirestore.instance.collection('quiz_main').doc(quiz_id).delete();

    await FirebaseFirestore.instance.collection('quiz_question').where('quiz_id', isEqualTo: quiz_id).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        /// 이미지 삭제
        List images = [doc['question_image_url'], doc['answer1_image_url'], doc['answer2_image_url'], doc['answer3_image_url'], doc['answer4_image_url']];
        for (int index = 0; index < images.length; index++) {
          if (images[index].length > 0) {
            var fileRef = FirebaseStorage.instance.refFromURL(images[index]);
            fileRef.delete();
          }
        }
        /// db 삭제
        doc.reference.delete();
      });
    });

  }

  void updQuiz() async {
    await FirebaseFirestore.instance.collection('quiz_main').doc(quiz_id).update({'email': GetStorage().read('email'), 'class_code': GetStorage().read('class_code'),
      'date': quiz_date, 'school_year': school_year, 'title': quiz_title, 'description': quiz_description, 'grade': quiz_grade.value, 'semester': quiz_semester.value,
      'subject': quiz_subject.value, 'quiz_type': quiz_quiz_type.value, 'indi_timer': quiz_indi_timer.value, 'modum_total_timer': quiz_modum_total_timer.value, 'modum_indi_timer': quiz_modum_indi_timer.value, 'public': quiz_public_type.value
    }).catchError((error) {
      print("정상적으로 업데이트가 되지 않았습니다.");
    });
  }

  int question_cnt = 0;
  void getQuestionCnt() async{
    await FirebaseFirestore.instance.collection('quiz_question').where('quiz_id', isEqualTo: quiz_id).get().then((QuerySnapshot snapshot) async {
      if (!snapshot.docs.isEmpty) {
        question_cnt = snapshot.docs.length;
      }
    });
  }

  /// 준비버튼 클릭하면 모두 삭제
  void delScore() async{
    await FirebaseFirestore.instance.collection('quiz_question_score').where('class_code', isEqualTo: GetStorage().read('class_code')).get().then((QuerySnapshot snapshot) async {
      if (!snapshot.docs.isEmpty) {
        List docs = snapshot.docs.toList();
        for (int index = 0; index < docs.length; index++) {
          await FirebaseFirestore.instance.collection('quiz_question_score').doc(docs[index].id).delete();
        }
      }
    });
  }

}






