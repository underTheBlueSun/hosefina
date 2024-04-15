import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'main_controller.dart';

// class Diary_day {
//   int id;
//   String mmdd_yoil;
//   Diary_day(this.id, this.mmdd_yoil);
// }


class DiaryController extends GetxController {
  static DiaryController get to => Get.find();

  List diary_days = [];
  RxString mmdd_yoil = ''.obs;
  RxInt current_page_index = 0.obs;
  String morning_emotion_icon = '';
  String morning_emotion_name = '';
  String morning_emotion_content = '';
  List checklist_points = [0,0,0,0,0,0,0,0,0,0];
  String learning = '';
  String after_emotion_icon = '';
  String after_emotion_name = '';
  String after_emotion_content = '';
  String notice = '';
  String emotion_gubun = 'morning';
  String today = '';
  List morning_charts = [];
  List checklist_charts = [];
  List after_charts = [];
  String chart_morning_start_date = '';
  String chart_morning_middle_date = '';
  String chart_morning_end_date = '';
  String chart_checklist_start_date = '';
  String chart_checklist_middle_date = '';
  String chart_checklist_end_date = '';
  String chart_after_start_date = '';
  String chart_after_middle_date = '';
  String chart_after_end_date = '';
  String name = '';
  int number = 0;
  RxString diary_gubun = '아침감정내용'.obs;


  List emotion_file_names = ['pleasant','happy','funny','comfort','confident','touched','grateful','glad','expect','sorry','tired','boring','lonely','sad', 'anxious','upset','sore','scary','annoyed','angry'];
  List emotion_names = ['즐거운','기쁜','재밌는','편안한','자신있는','감동한','고마운','반가운','기대되는','미안한','지친','지루한','외로운','슬픈','불안한','속상한','아픈','무서운','짜증나는','화나는'];

  List emotion_goods = ['pleasant','happy','funny','comfort','confident','touched','grateful','glad','expect'];
  List emotion_bads = ['sorry','tired','boring','lonely','sad', 'anxious','upset','sore','scary','annoyed','angry'];

  List checklist = ['아침활동을 성실히 했나요?', '과제/일기/배움공책/독서록을 했나요?', '우유를 잘 먹었나요?', '줄을 서서 이동시 질서를 잘 지켰나요?', '친구랑 사이좋게 지냈나요?',
    '수업시간에 집중하여 경청했나요?', '교실이나 복도에서 질서를 잘 지켰나요?',  '1인1역등 자기역할을 잘 수행했나요?'];

  @override
  void onInit() async {

    /// 생활공책 기간은 올해 1월 ~ 내년 3.1 까지
    DateTime start_date = DateTime(DateTime.now().year, 1, 1);
    DateTime end_date = DateTime(DateTime.now().year + 1, 3, 0);
    for (int i = 0; i <= end_date.difference(start_date).inDays; i++) {
      DateTime day_datetime = start_date.add(Duration(days: i));
      String month = DateFormat('MM').format(day_datetime);
      String day = DateFormat('dd').format(day_datetime);
      String dayofweek = DateFormat('EEE', 'ko_KR').format(day_datetime);
      diary_days.add('${month}월 ${day}일(${dayofweek})');
      // diary_days.add(Diary_day(i, '${month}월 ${day}일(${dayofweek})'));
    }

  }

  void updPoint() async{
    await FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('date', isEqualTo: diary_days[DiaryController.to.current_page_index.value])
        .where('number', isEqualTo: GetStorage().read('number')).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        int point = snapshot.docs.first['checklist_01']+snapshot.docs.first['checklist_02']+snapshot.docs.first['checklist_03']+snapshot.docs.first['checklist_04']+
            snapshot.docs.first['checklist_05']+snapshot.docs.first['checklist_06']+snapshot.docs.first['checklist_07']+snapshot.docs.first['checklist_08']
            +snapshot.docs.first['checklist_09']+snapshot.docs.first['checklist_10'];
        await FirebaseFirestore.instance.collection('point').where('class_code', isEqualTo: GetStorage().read('class_code'))
            .where('number', isEqualTo: GetStorage().read('number')).get().then((QuerySnapshot snapshot) {
          if (snapshot.docs.length > 0) {
            FirebaseFirestore.instance.collection('point').doc(snapshot.docs.first.id).update({'point': FieldValue.increment(point)});
          }else {
            FirebaseFirestore.instance.collection('point').add({'date': DateTime.now(), 'class_code': GetStorage().read('class_code'),
              'number': GetStorage().read('number'), 'name': name, 'point': point, 'pokemons': [] });
          }
        });
      }
    });

  }

  /// CarouselSlider 슬라이더로 하니 버벅거려서 안함
  // Future<void> getCurrentPage() async{
  //   current_page_index.value = DiaryController.to.diary_days.indexOf(mmdd_yoil.value);
  // }

  void addMorningEmotion() async{
    await FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('date', isEqualTo: diary_days[DiaryController.to.current_page_index.value])
        .where('number', isEqualTo: GetStorage().read('number')).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        await FirebaseFirestore.instance.collection('diary').doc(snapshot.docs.first.id)
            .update({'morning_emotion_icon': morning_emotion_icon,'morning_emotion_name': morning_emotion_name,'morning_emotion_content': morning_emotion_content });
      }else{
        await FirebaseFirestore.instance.collection('diary').add({'class_code': GetStorage().read('class_code'), 'date': diary_days[DiaryController.to.current_page_index.value],
          'number': GetStorage().read('number'), 'name': GetStorage().read('name'), 'morning_emotion_icon': morning_emotion_icon,'morning_emotion_name': morning_emotion_name,
          'morning_emotion_content': morning_emotion_content, 'checklist_01': 0, 'checklist_02': 0,'checklist_03': 0,'checklist_04': 0,
          'checklist_05': 0,'checklist_06': 0, 'checklist_07': 0,'checklist_08': 0,'checklist_09': 0,'checklist_10': 0,
          'learning': '','after_emotion_icon': '','after_emotion_name': '', 'after_emotion_content': '','notice': ''});
      }
    });

    MainController.to.active_screen.value = 'diary_main';

  }

  List column_name_list = ['checklist_01','checklist_02','checklist_03','checklist_04','checklist_05','checklist_06','checklist_07','checklist_08','checklist_09','checklist_10',];
  List column_value_list = [0,0,0,0,0,0,0,0,0,0];
  void addChecklist(index, point) async{
    column_value_list = [0,0,0,0,0,0,0,0,0,0];
    column_value_list[index] = point;
    // String column_name = '';
    // int checklist_01 = 0;
    // int checklist_02 = 0;
    // int checklist_03 = 0;
    // int checklist_04 = 0;
    // int checklist_05 = 0;
    // int checklist_06 = 0;
    // int checklist_07 = 0;
    // int checklist_08 = 0;
    // int checklist_09 = 0;
    // int checklist_10 = 0;
    // if (index == 0) {
    //   column_name = 'checklist_01';
    //   checklist_01 = point;
    // } else if (index == 1) {
    //   column_name = 'checklist_02';
    //   checklist_02 = point;
    // } else if (index == 2) {
    //   column_name = 'checklist_03';
    //   checklist_03 = point;
    // } else if (index == 3) {
    //   column_name = 'checklist_04';
    //   checklist_04 = point;
    // } else if (index == 4) {
    //   column_name = 'checklist_05';
    //   checklist_05 = point;
    // } else if (index == 5) {
    //   column_name = 'checklist_06';
    //   checklist_06 = point;
    // } else if (index == 6) {
    //   column_name = 'checklist_07';
    //   checklist_07 = point;
    // } else if (index == 7) {
    //   column_name = 'checklist_08';
    //   checklist_08 = point;
    // } else if (index == 8) {
    //   column_name = 'checklist_09';
    //   checklist_09 = point;
    // } else if (index == 9) {
    //   column_name = 'checklist_10';
    //   checklist_10 = point;
    // }

    await FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('date', isEqualTo: diary_days[DiaryController.to.current_page_index.value])
        .where('number', isEqualTo: GetStorage().read('number')).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        await FirebaseFirestore.instance.collection('diary').doc(snapshot.docs.first.id).update({column_name_list[index]: point});
      }else{
        await FirebaseFirestore.instance.collection('diary').add({'class_code': GetStorage().read('class_code'), 'date': diary_days[DiaryController.to.current_page_index.value],
          'number': GetStorage().read('number'), 'name': GetStorage().read('name'), 'morning_emotion_icon': '','morning_emotion_name': '',
          'morning_emotion_content': '', 'checklist_01': column_value_list[0], 'checklist_02': column_value_list[1],'checklist_03': column_value_list[2],'checklist_04': column_value_list[3],
          'checklist_05': column_value_list[4],'checklist_06': column_value_list[5], 'checklist_07': column_value_list[6],'checklist_08': column_value_list[7],
          'checklist_09': column_value_list[8],'checklist_10': column_value_list[9],
          'learning': '','after_emotion_icon': '','after_emotion_name': '', 'after_emotion_content': '','notice': ''});
      }
    });

  }

  void addAfterEmotion() async{
    await FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('date', isEqualTo: diary_days[DiaryController.to.current_page_index.value])
        .where('number', isEqualTo: GetStorage().read('number')).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        await FirebaseFirestore.instance.collection('diary').doc(snapshot.docs.first.id)
            .update({'after_emotion_icon': after_emotion_icon,'after_emotion_name': after_emotion_name,'after_emotion_content': after_emotion_content });
      }else{
        await FirebaseFirestore.instance.collection('diary').add({'class_code': GetStorage().read('class_code'), 'date': diary_days[DiaryController.to.current_page_index.value],
          'number': GetStorage().read('number'), 'name': GetStorage().read('name'), 'morning_emotion_icon': '','morning_emotion_name': '',
          'morning_emotion_content': '', 'checklist_01': 0, 'checklist_02': 0,'checklist_03': 0,'checklist_04': 0,
          'checklist_05': 0,'checklist_06': 0, 'checklist_07': 0,'checklist_08': 0,'checklist_09': 0,'checklist_10': 0,
          'learning': '','after_emotion_icon': after_emotion_icon,'after_emotion_name': after_emotion_name, 'after_emotion_content': after_emotion_content,'notice': ''});
      }
    });

    MainController.to.active_screen.value = 'diary_main';

  }

  void addLearning() async{
    await FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('date', isEqualTo: diary_days[DiaryController.to.current_page_index.value])
        .where('number', isEqualTo: GetStorage().read('number')).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        await FirebaseFirestore.instance.collection('diary').doc(snapshot.docs.first.id).update({'learning': learning });
      }else{
        await FirebaseFirestore.instance.collection('diary').add({'class_code': GetStorage().read('class_code'), 'date': diary_days[DiaryController.to.current_page_index.value],
          'number': GetStorage().read('number'), 'name': GetStorage().read('name'), 'morning_emotion_icon': '','morning_emotion_name': '',
          'morning_emotion_content': '', 'checklist_01': 0, 'checklist_02': 0,'checklist_03': 0,'checklist_04': 0,
          'checklist_05': 0,'checklist_06': 0, 'checklist_07': 0,'checklist_08': 0,'checklist_09': 0,'checklist_10': 0,
          'learning': learning,'after_emotion_icon': '','after_emotion_name': '', 'after_emotion_content': '','notice': ''});
      }
    });

    MainController.to.active_screen.value = 'diary_main';

  }

  void addNotice() async{
    await FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('date', isEqualTo: diary_days[DiaryController.to.current_page_index.value])
        .where('number', isEqualTo: GetStorage().read('number')).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        await FirebaseFirestore.instance.collection('diary').doc(snapshot.docs.first.id).update({'notice': notice });
      }else{
        await FirebaseFirestore.instance.collection('diary').add({'class_code': GetStorage().read('class_code'), 'date': diary_days[DiaryController.to.current_page_index.value],
          'number': GetStorage().read('number'), 'name': GetStorage().read('name'), 'morning_emotion_icon': '','morning_emotion_name': '',
          'morning_emotion_content': '', 'checklist_01': 0, 'checklist_02': 0,'checklist_03': 0,'checklist_04': 0,
          'checklist_05': 0,'checklist_06': 0, 'checklist_07': 0,'checklist_08': 0,'checklist_09': 0,'checklist_10': 0,
          'learning': '','after_emotion_icon': '','after_emotion_name': '', 'after_emotion_content': '','notice': notice});
      }
    });

    MainController.to.active_screen.value = 'diary_main';

  }

  Future<void> getMorningEmotionChart() async{
    morning_charts = [];
    chart_morning_start_date = '';
    chart_morning_middle_date = '';
    chart_morning_end_date = '';
    await FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('number', isEqualTo: number).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        /// index를 받기위해 asMap() 함
        List sort_docs = snapshot.docs;
        sort_docs.sort((a, b) => a['date'].compareTo(b['date']));
        sort_docs.asMap().forEach((index, doc) {
          String date = doc['date'].substring(0,2) + '.' + doc['date'].substring(4,6);
          if (emotion_goods.contains(doc['morning_emotion_icon'])) {
            morning_charts.add({'date': date, 'index': index, 'point': 5});
          }else {
            morning_charts.add({'date': date, 'index': index, 'point': 1});
          }
        });
        chart_morning_start_date = morning_charts[0]['date'];
        chart_morning_middle_date = morning_charts[(morning_charts.length/2).floor()]['date'];
        chart_morning_end_date = morning_charts[morning_charts.length - 1]['date'];

      }
    });

  }

  Future<void> getChecklistEmotionChart() async{
    checklist_charts = [];
    chart_checklist_start_date = '';
    chart_checklist_middle_date = '';
    chart_checklist_end_date = '';
    await FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('number', isEqualTo: number).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        /// index를 받기위해 asMap() 함
        List sort_docs = snapshot.docs;
        sort_docs.sort((a, b) => a['date'].compareTo(b['date']));
        sort_docs.asMap().forEach((index, doc) {
          String date = doc['date'].substring(0,2) + '.' + doc['date'].substring(4,6);
          int point = doc['checklist_01'] + doc['checklist_02'] + doc['checklist_03'] + doc['checklist_04'] + doc['checklist_05'] + doc['checklist_06']
              + doc['checklist_07'] + doc['checklist_08'] + doc['checklist_09'] + doc['checklist_10'];
          checklist_charts.add({'date': date, 'index': index, 'point': point});
        });
        chart_checklist_start_date = checklist_charts[0]['date'];
        chart_checklist_middle_date = checklist_charts[(checklist_charts.length/2).floor()]['date'];
        chart_checklist_end_date = checklist_charts[checklist_charts.length - 1]['date'];

      }
    });

  }

  Future<void> getAfterEmotionChart() async{
    after_charts = [];
    chart_after_start_date = '';
    chart_after_middle_date = '';
    chart_after_end_date = '';
    await FirebaseFirestore.instance.collection('diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
        .where('number', isEqualTo: number).get().then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        /// index를 받기위해 asMap() 함
        List sort_docs = snapshot.docs;
        sort_docs.sort((a, b) => a['date'].compareTo(b['date']));
        sort_docs.asMap().forEach((index, doc) {
          String date = doc['date'].substring(0,2) + '.' + doc['date'].substring(4,6);
          if (emotion_goods.contains(doc['after_emotion_icon'])) {
            after_charts.add({'date': date, 'index': index, 'point': 5});
          }else {
            after_charts.add({'date': date, 'index': index, 'point': 1});
          }
        });
        chart_after_start_date = after_charts[0]['date'];
        chart_after_middle_date = after_charts[(after_charts.length/2).floor()]['date'];
        chart_after_end_date = after_charts[after_charts.length - 1]['date'];

      }
    });

  }



}






