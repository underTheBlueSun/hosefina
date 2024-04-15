import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:hosefina/app_bar_widget.dart';
import 'package:hosefina/attendance.dart';
import 'package:hosefina/auction/auction_main.dart';
import 'package:hosefina/board/board_add.dart';
import 'package:hosefina/board/board_indi.dart';
import 'package:hosefina/board/board_main.dart';
import 'package:hosefina/class_code_add.dart';
import 'package:hosefina/controller/main_controller.dart';
import 'package:hosefina/coupon/coupon_main_teacher.dart';
import 'package:hosefina/exam/exam_main.dart';
import 'package:hosefina/point/point_main.dart';
import 'package:hosefina/point/point_main_student.dart';
import 'package:hosefina/point/pointer_add.dart';
import 'package:hosefina/point/pointer_detail.dart';
import 'package:hosefina/point/pointer_main.dart';
import 'package:hosefina/pokemon/pokemon_main.dart';
import 'package:hosefina/pokemon/pokemon_roulette.dart';
import 'package:hosefina/quiz/quiz_myquiz.dart';
import 'package:hosefina/quiz/quiz_next_person.dart';
import 'package:hosefina/quiz/quiz_play.dart';
import 'package:hosefina/quiz/quiz_ready.dart';
import 'package:hosefina/quiz/quiz_score.dart';
import 'package:hosefina/relation/relation_main.dart';
import 'package:hosefina/subject/subject_add.dart';
import 'package:hosefina/subject/subject_edit.dart';
import 'package:hosefina/subject/subject_main.dart';
import 'package:hosefina/temper/temper_donation.dart';
import 'package:hosefina/temper/temper_edit.dart';
import 'package:hosefina/temper/temper_main.dart';
import 'package:hosefina/test.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'board/board_modum.dart';
import 'board/board_update.dart';
import 'controller/auction_controller.dart';
import 'controller/board_controller.dart';
import 'controller/diary_controller.dart';
import 'controller/exam_controller.dart';
import 'controller/pointer_controller.dart';
import 'controller/point_controller.dart';
import 'controller/quiz_controller.dart';
import 'controller/coupon_controller.dart';
import 'controller/relation_controller.dart';
import 'controller/subject_controller.dart';
import 'controller/temper_controller.dart';
import 'coupon/coupon_add.dart';
import 'coupon/coupon_buy.dart';
import 'coupon/coupon_main.dart';
import 'diary/diary_main.dart';
import 'diary/diary_main_teacher.dart';
import 'diary/emotion_list.dart';
import 'exam/exam_sheet.dart';
import 'firebase_options.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'main_list.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async{
  /// 밑에 적으면 null 반환함
  await GetStorage.init();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  /// 로컬 설정 (요일때문에)
  initializeDateFormatting();

  Get.put(MainController());
  Get.put(BoardController());
  Get.put(QuizController());
  Get.put(AuctionController());
  Get.put(TemperController());
  Get.put(PointController());
  Get.put(PointerController());
  Get.put(DiaryController());
  Get.put(CouponController());
  Get.put(SubjectController());
  Get.put(ExamController());
  Get.put(RelationController());

  /// 유무료 체크
  await MainController.to.checkFreePay();

  if (GetStorage().read('class_code') != null && GetStorage().read('number') != null) {
    MainController.to.checkClassCode(GetStorage().read('class_code'));
    // MainController.to.getAttendance();
    MainController.to.active_screen.value = 'main_list';
  }else{
    MainController.to.active_screen.value = 'class_code_add';
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // 디버그 표시를 없앤다.
      debugShowCheckedModeBanner: false,
      title: '호세피나',
      locale: Get.deviceLocale,
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white,), /// 텍스트필드 커서 색깔
        appBarTheme: AppBarTheme(surfaceTintColor: Colors.transparent, backgroundColor: Color(0xFF5E5E5E)), // surfaceTintColor:스크롤시 색깔 안변하게
        scaffoldBackgroundColor: Color(0xFF76B8C3),
        // scaffoldBackgroundColor: Color(0xFF5CC9E7),
        // scaffoldBackgroundColor: Color(0xFFBECEDE),
        // scaffoldBackgroundColor: Color(0xFF5E5E5E),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF5E5E5E), primary: Color(0xFF5E5E5E),),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '호세피나'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void donationDialog(context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                Text('별포인트 몇 개를 기부하시겠습니까?'),
                SizedBox(height: 20,),
                SizedBox(
                  width: 200,
                  height: 60,
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    cursorColor: Colors.black,
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: (value) {
                      TemperController.to.donation_point = int.parse(value);
                    },
                    style: TextStyle(fontFamily: 'Jua', fontSize: 20, ),
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: '별포인트 입력',
                      hintStyle: TextStyle(fontSize: 19, color: Colors.grey.withOpacity(0.5)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey ),),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey, ),),
                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('기부'), onPressed: () {
              if (PointController.to.point_total >= TemperController.to.donation_point) {
                TemperController.to.donationPoint();
                Navigator.pop(context);
              }else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(duration: Duration(milliseconds: 1000),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('별포인트 점수보다 더 많이 기부할 수 없습니다.', style: TextStyle(color: Colors.orangeAccent, fontFamily: 'Jua', fontSize: 18),),
                      ],
                    ),),);
              }

            })

          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {

    return Obx(() => Scaffold(

        appBar: AppBar(
          /// 보드 색깔
          backgroundColor: (MainController.to.active_screen.value == 'board_indi' || MainController.to.active_screen.value == 'board_modum')  && BoardController.to.background.value.length == 10 ?
          Color(int.parse(BoardController.to.background.value)) : Colors.transparent,
          title: AppBarWidget(),
        ),

        body: MainController.to.active_screen.value == 'class_code_add' ? Center(child: ClassCodeAdd()) :
        MainController.to.active_screen.value == 'attendance' ? Attendance() :
        MainController.to.active_screen.value == 'diary_main' ? DiaryMain() :
        MainController.to.active_screen.value == 'diary_main_teacher' ? DiaryMainTeacher() :
        MainController.to.active_screen.value == 'diary_emotion' ? EmotionList() :
        MainController.to.active_screen.value == 'board_main' ? BoardMain() :
        MainController.to.active_screen.value == 'board_indi' ? BoardIndi() :
        MainController.to.active_screen.value == 'board_modum' ? BoardModum() :
        MainController.to.active_screen.value == 'board_add' ? BoardAdd() :
        MainController.to.active_screen.value == 'quiz_ready' ? QuizReady() :
        MainController.to.active_screen.value == 'quiz_myquiz' ? QuizMyQuiz() :
        MainController.to.active_screen.value == 'quiz_play' ? QuizPlay() :
        MainController.to.active_screen.value == 'quiz_score' ? QuizScore() :
        MainController.to.active_screen.value == 'quiz_next_person' ? QuizNextPerson() :
        MainController.to.active_screen.value == 'temper_main' ? TemperMain() :
        MainController.to.active_screen.value == 'temper_edit' ? TemperEdit() :
        MainController.to.active_screen.value == 'temper_donation' ? TemperDonation() :
        MainController.to.active_screen.value == 'pokemon_main' ? PokemonMain() :
        MainController.to.active_screen.value == 'pokemon_roulette' ? PokemonRoulette() :
        MainController.to.active_screen.value == 'point_main' ? PointMain() :
        // MainController.to.active_screen.value == 'point_main_student' ? PointMainStudent() :
        MainController.to.active_screen.value == 'pointer_main' ? PointerMain() :
        MainController.to.active_screen.value == 'pointer_add' ? PointerAdd() :
        MainController.to.active_screen.value == 'pointer_detail' ? PointerDetail() :
        MainController.to.active_screen.value == 'auction_main' ? AuctionMain() :
        MainController.to.active_screen.value == 'coupon_main' ? CouponMain() :
        MainController.to.active_screen.value == 'coupon_main_teacher' ? CouponMainTeacher() :
        MainController.to.active_screen.value == 'coupon_add' ? CouponAdd() :
        MainController.to.active_screen.value == 'coupon_buy' ? CouponBuy() :
        MainController.to.active_screen.value == 'subject_main' ? SubjectMain() :
        MainController.to.active_screen.value == 'subject_add' ? SubjectAdd() :
        MainController.to.active_screen.value == 'subject_edit' ? SubjectEdit() :
        MainController.to.active_screen.value == 'exam_main' ? ExamMain() :
        MainController.to.active_screen.value == 'exam_sheet' ? ExamSheet() :
        MainController.to.active_screen.value == 'relation_main' ? RelationMain() :
        MainController.to.active_screen.value == 'main_list' ? MainList() : SizedBox(),

        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,  /// 왼쪽 정렬
        floatingActionButton:
        MainController.to.active_screen.value == 'board_indi'  ?
        FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: () {
            MainController.to.active_screen.value = 'board_add';
            BoardController.to.indi_title = '';
            BoardController.to.indi_content = '';
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.orangeAccent, border: Border.all(color: Colors.white, width: 3), shape: BoxShape.circle,),
            height: 70.0,
            width: 70.0,
            child: Icon(Icons.add, size: 40, color: Colors.white),
          ),) :
        MainController.to.active_screen.value == 'quiz_play' && QuizController.to.quiz_type.value == '개인' ?
        FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: () {
            // QuizController.to.question_number.value = QuizController.to.question_number.value + 1;
          },
          child: Countdown(
            seconds: int.parse(QuizController.to.quiz_indi_timer.value),
            build: (BuildContext context, double time) {
              QuizController.to.remain_time = time;  /// 타이머 다 돌기전에 선택지 클릭시
              return Row(
                children: [
                  Icon(Icons.access_alarm, color: Colors.white,),
                  SizedBox(width: 5,),
                  Text(time.toInt().toString(), style: TextStyle(color: Colors.white, fontSize: 18),),
                ],);
            },
            interval: Duration(milliseconds: 1000),
            onFinished: () {
              MainController.to.active_screen.value = 'quiz_score';
            },
          ),) :
        MainController.to.active_screen.value == 'quiz_play' && QuizController.to.quiz_type.value == '모둠' ?
        Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                /// 카운트타운
                FloatingActionButton(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    // QuizController.to.question_number.value = QuizController.to.question_number.value + 1;
                  },
                  child: SlideCountdown(
                    duration: Duration(seconds: int.parse(QuizController.to.quiz_modum_indi_timer.value)),
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    padding: EdgeInsets.all(5),
                    icon: Icon(Icons.alarm, color: Colors.white, size: 20,),
                    decoration: BoxDecoration(color: Colors.transparent,),
                    // decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(5)),),
                    onDone: () {
                      MainController.to.active_screen.value = 'quiz_next_person';
                    },
                  ),),
                Row(
                  children: [
                  FloatingActionButton(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      if (QuizController.to.question_number.value > 1) {
                        QuizController.to.question_number.value = QuizController.to.question_number.value - 1;
                      }

                    },
                    child: Container(
                      decoration: BoxDecoration(color: QuizController.to.question_number.value > 1 ? Colors.orangeAccent : Colors.grey, shape: BoxShape.circle,),
                      // decoration: BoxDecoration(color: Colors.orangeAccent, border: Border.all(color: Colors.white, width: 3), shape: BoxShape.circle,),
                      height: 70.0,
                      width: 70.0,
                      child: Icon(Icons.arrow_back, size: 40, color: Colors.white),
                    ),),
                  SizedBox(width: 30,),
                    /// 문제번호가 끝이 아니면
                    QuizController.to.question_number.value != QuizController.to.questions.length ?
                  FloatingActionButton(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      QuizController.to.question_number.value = QuizController.to.question_number.value + 1;

                    },
                    child: Container(
                      decoration: BoxDecoration(color: Colors.orangeAccent ,  shape: BoxShape.circle,),
                      height: 70.0,
                      width: 70.0,
                      child: Icon(Icons.arrow_forward, size: 40, color: Colors.white),
                    ),) :
                    /// 문제번호가 끝이면
                    FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      onPressed: () async{
                        await QuizController.to.getScore();
                        MainController.to.active_screen.value = 'quiz_score';

                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.teal,  shape: BoxShape.circle,),
                        height: 70.0,
                        width: 70.0,
                        child: Icon(Icons.keyboard_tab, size: 40, color: Colors.white),
                      ),),
                ],),
              ],
            ) :
        MainController.to.active_screen.value == 'pokemon_main' && PointController.to.point_doc_id.length > 0 ?
        FloatingActionButton.large(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: () {
            MainController.to.active_screen.value = 'pokemon_roulette';

          },
          child: Image.asset('assets/images/roulette.gif', ),
        )
            :
        MainController.to.active_screen.value == 'coupon_main' && GetStorage().read('job') == 'student' ?
        FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.black,
          onPressed: () {
            MainController.to.active_screen.value = 'coupon_buy';

          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.airplane_ticket, color: Colors.white,),
              Text('쿠폰구매', style: TextStyle(fontFamily: 'Jua', color: Colors.white),)
            ],
          ),
        )
            :
        MainController.to.active_screen.value == 'subject_main' && GetStorage().read('job') == 'student' ?
        FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onPressed: () {
            MainController.to.active_screen.value = 'subject_add';
            SubjectController.to.content = '';
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.orangeAccent, border: Border.all(color: Colors.white, width: 3), shape: BoxShape.circle,),
            height: 70.0,
            width: 70.0,
            child: Icon(Icons.add, size: 40, color: Colors.white),
          ),)
            :
        MainController.to.active_screen.value == 'temper_main' && GetStorage().read('job') == 'student' ?
        FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.white,
          onPressed: () {
            donationDialog(context);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.volunteer_activism, color: Colors.orangeAccent,),
              Text('기부하기', style: TextStyle(fontFamily: 'Jua', color: Colors.black.withOpacity(0.6)),)
            ],
          ),)
        :
        SizedBox()
      ),
    );
  }
}
