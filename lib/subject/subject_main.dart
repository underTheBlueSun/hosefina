import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../controller/board_controller.dart';
import '../controller/main_controller.dart';
import '../controller/subject_controller.dart';

class SubjectMain extends StatelessWidget {
  TextEditingController titleSettingController = TextEditingController();
  TextEditingController contentSettingController = TextEditingController();
  List updIndiControllers = [];
  List updCommentControllers = [];
  List addCommentControllers = [];
  List updTitleInputControllers = [];
  List updContentInputControllers = [];
  List updCommentInputControllers = [];
  int subject_cnt = 0;
  int commentCnt = 0;
  int addCommentCnt = 0;
  int updTitleCnt = 0;
  int updContentCnt = 0;
  int updCommentInputCnt = 0;
  /// 전체 스탬프 찍기 위해  전체 인텍스 가져오기
  List allIndexs = [];

  void updCommentDialog(context, comment) {
    showCupertinoDialog(
      context: context,
      // barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            width: 150,
            height: 170,
            // color: Color(0xFF5E5E5E),
            child: Material(
              color: Colors.transparent,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          SubjectController.to.delComment(comment);
                          Navigator.pop(context);
                        },
                        child: Column(
                          children: [
                            Icon(Icons.delete_forever_outlined, ),
                            Text('삭제', style: TextStyle(fontFamily: 'Jua'),),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 110,
                      child: TextField(
                        autofocus: true,
                        controller: TextEditingController(text: comment['comment']),
                        onChanged: (value) {
                          SubjectController.to.comment = value;
                        },
                        style: TextStyle(fontFamily: 'Jua',  ),
                        maxLines: 10,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
                        ),
                      ),
                    ),

                  ]
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            // CupertinoDialogAction(isDefaultAction: true, child: Text('삭제', style: TextStyle(color: Colors.red),), onPressed: () {
            //   SubjectController.to.delComment(comment);
            //   Navigator.pop(context);
            // }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장', ), onPressed: () {
              SubjectController.to.updComment(comment);
              Navigator.pop(context);
            }),

          ],
        );
      },
    );

  }

  void updContentDialog(context) {
    /// 전체화면에서 다이어로그 띄우기
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      pageBuilder: (_,__,___) {
        return Scaffold(
          backgroundColor: Color(0xFF76B8C3),
          appBar: AppBar(
            centerTitle: false, // 왼쪽에 두기위해
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Color(0xFF76B8C3),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // MainController.to.active_screen.value = 'subject_diary';
                    Navigator.pop(context);
                  },
                  child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white,size: 30,),),
                ),
                Row(
                  children: [
                    /// 삭제
                    GestureDetector(
                      onTap: () async{
                        await SubjectController.to.delSubjectDiary();
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Icon(Icons.delete_forever_outlined, size: 30, color: Colors.white,),
                          Text('삭제', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 15),),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18, bottom: 10),
                    child: SizedBox(
                      // height: 250,
                      child: TextField(
                        autofocus: true,
                        controller: TextEditingController(text: SubjectController.to.content),
                        onChanged: (value) {
                          SubjectController.to.content = value;
                        },
                        style: TextStyle(color: Colors.white, fontFamily: 'Jua' ),
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: '내용을 입력하세요',
                          hintStyle: TextStyle(fontSize: 17, color: Colors.white.withOpacity(0.5)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
                        ),
                      ),
                    ),
                  ),

                  /// 저장버튼
                  Container(
                    width: 120,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, ),
                      onPressed: () async{
                        await SubjectController.to.updSubjectDiary();
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_alt_outlined, color: Colors.white,),
                          SizedBox(width: 5,),
                          Text('저장', style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 50,),


                ]
            ),
          ),
        );
      },
    );

  }

  void saveSubjectDialog(context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            width: 150,
            height: 150,
            // color: Color(0xFF5E5E5E),
            child: Material(
              color: Colors.transparent,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 150,
                      child: TextField(
                        autofocus: true,
                        controller: TextEditingController(text: SubjectController.to.subject),
                        onChanged: (value) {
                          SubjectController.to.subject = value;
                        },
                        style: TextStyle(fontFamily: 'Jua',  ),
                        maxLines: 10,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
                        ),
                      ),
                    ),

                  ]
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('닫기'), onPressed: () {
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('저장', ), onPressed: () async{
              await SubjectController.to.saveSubject();
              await SubjectController.to.getSubjects();
              SubjectController.to.dummy_date.value = DateTime.now().toString();
              Navigator.pop(context);
            }),

          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        options: CarouselOptions(
          initialPage: SubjectController.to.subject_id,
          onPageChanged: (int, CarouselPageChangedReason) {
            /// 이거 지우면 top의 날짜 안바뀜
            String yyyy_string = DateFormat('yyyy').format(DateTime.now());
            DateTime yyyymmdd_datetime = DateTime.parse(yyyy_string + SubjectController.to.subjects[int].mmdd);
            String month = DateFormat('MM').format(yyyymmdd_datetime);
            String day = DateFormat('dd').format(yyyymmdd_datetime);
            String dayofweek = DateFormat('EEE', 'ko_KR').format(yyyymmdd_datetime);
            SubjectController.to.mmdd_yoil.value = '${month}월 ${day}일(${dayofweek})';
          },
          viewportFraction: 1,
          height: MediaQuery.of(context).size.height,
        ),
        itemCount: SubjectController.to.subjects.length,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
          String yyyy_string = DateFormat('yyyy').format(DateTime.now());
          DateTime yyyymmdd_datetime = DateTime.parse(yyyy_string + SubjectController.to.subjects[itemIndex].mmdd);
          String month = DateFormat('MM').format(yyyymmdd_datetime);
          String day = DateFormat('dd').format(yyyymmdd_datetime);
          String dayofweek = DateFormat('EEE', 'ko_KR').format(yyyymmdd_datetime);
          var mmdd_yoil = '${month}월 ${day}일(${dayofweek})';
          // SubjectController.to.mmdd_yoil.value = '${month}월 ${day}일(${dayofweek})';  /// setState() 에러 남


          SubjectController.to.mmdd = SubjectController.to.subjects[itemIndex].mmdd;
          SubjectController.to.subject = SubjectController.to.subjects[itemIndex].subject;
          SubjectController.to.subject_id = SubjectController.to.subjects[itemIndex].id;
          return SingleChildScrollView(
            child: Obx(() => Column(
                children: [
                  /// 더미
                  Text(SubjectController.to.dummy_date.value, style: TextStyle(fontSize: 0),),
                  /// 주제 제목
                  GestureDetector(
                    onTap: () {
                      if (GetStorage().read('job') == 'teacher') {
                        saveSubjectDialog(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                      child: Text(SubjectController.to.subjects[itemIndex].subject, style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 20),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    // padding: const EdgeInsets.only(left:40, right:40, top:20, bottom: 40),
                    child: AlignedGridView.count(
                        shrinkWrap: true,
                        primary: false,
                        physics: NeverScrollableScrollPhysics(),
                        // crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 3,
                        crossAxisCount: MediaQuery.of(context).size.width > 1000 ? 4 : MediaQuery.of(context).size.width > 600 ? 3 : 1, /// 아이패드가 가로면? 세로면? 아이폰이면
                        // mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        itemCount: MainController.to.attendances.length,
                        itemBuilder: (_, index) {
                          DocumentSnapshot attendanceDoc = MainController.to.attendances[index];
                          return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('subject_diary').where('class_code', isEqualTo: GetStorage().read('class_code'))
                                  .where('date', isEqualTo: mmdd_yoil).where('number', isEqualTo: attendanceDoc['number']).snapshots(),
                              // .where('date', isEqualTo: SubjectController.to.mmdd_yoil.value).where('number', isEqualTo: attendanceDoc['number']).snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: Container(
                                    height: 40,
                                    child: LoadingIndicator(
                                        indicatorType: Indicator.ballPulse,
                                        colors: MainController.to.kDefaultRainbowColors,
                                        strokeWidth: 2,
                                        backgroundColor: Colors.transparent,
                                        pathBackgroundColor: Colors.transparent
                                    ),
                                  ),);
                                }
                                return
                                  Column(
                                    children: [
                                      /// 번호, 이름
                                      Container(
                                        height: 30,
                                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('${attendanceDoc['number']}번  ${attendanceDoc['name']}',  style: TextStyle(fontFamily: 'Jua', fontSize: 16, color: Colors.white),),
                                          ],
                                        ),
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          primary: false,
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (_, index) {
                                            DocumentSnapshot subject_doc = snapshot.data!.docs[index];

                                            // 댓글 날짜순 정렬
                                            List commentList = subject_doc['comment'];
                                            commentList.sort((a, b) => a['date'].compareTo(b['date']));
                                            subject_cnt ++;
                                            updTitleCnt ++;
                                            updContentCnt ++;
                                            /// 겹치는거 때문에 obx 처리한 후로 addCommentCnt를 제대로 못가져와서 아래와 같이 처리함
                                            ///  여기서 addCommentCnt ++ 하면 모든 addCommentCnt가 같은 값 가짐.
                                            ///  addCommentCnt = 0을 해줘야 리로드시마다 1부터 올라감
                                            // addCommentCnt ++;
                                            addCommentCnt = 0;
                                            updTitleInputControllers.add(TextEditingController());
                                            updContentInputControllers.add(TextEditingController());
                                            addCommentControllers.add(TextEditingController());

                                            return GestureDetector(
                                              onTap: () {
                                                if (GetStorage().read('number') == attendanceDoc['number'] || GetStorage().read('job') == 'teacher') {
                                                  SubjectController.to.subject_diary_id = subject_doc.id;
                                                  SubjectController.to.content = subject_doc['content'];
                                                  updContentDialog(context);
                                                }
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 10, right: 0),
                                                child: Container(
                                                  // width: 250,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(8),
                                                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7), spreadRadius: 0, blurRadius: 2.0, offset: Offset(0, 3), ),],
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(15.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        /// 전체화면 선택할때만 내용
                                                        Column(children: [
                                                          subject_doc['content'].length > 0 ?
                                                          Text(subject_doc['content'],  style: TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.7), fontFamily: 'Jua',),) : SizedBox(),
                                                        ],),

                                                        Divider(color: Colors.black,),
                                                        /// 좋아요
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    SubjectController.to.subject_diary_id = subject_doc.id;
                                                                    if (subject_doc['like'].contains(GetStorage().read('number'))) {
                                                                      SubjectController.to.delLike(GetStorage().read('number'));
                                                                    }else {
                                                                      SubjectController.to.addLike(GetStorage().read('number'));
                                                                    }
                                                                  },
                                                                  child: Container(
                                                                    width: 30,
                                                                    child: subject_doc['like'].contains(GetStorage().read('number')) == true ?
                                                                    Icon(Icons.favorite, size: 20, color: Colors.red,) :
                                                                    Icon(Icons.favorite_border_outlined, size: 20, color: Colors.black,),
                                                                  ),
                                                                ),
                                                                Text(subject_doc['like'].length.toString(), style: TextStyle(color: Colors.black),),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 15,),
                                                        /// 댓글허용 여부
                                                        /// /// 댓글 없애니 겹치는거 해결되어서 막음, 학급보드는 댓글이 필요해서 그냥 둠
                                                        // StreamBuilder<QuerySnapshot>(
                                                        //     stream: FirebaseFirestore.instance.collection('class_info').where('class_code', isEqualTo: GetStorage().read('class_code')).snapshots(),
                                                        //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                        //       if (!snapshot.hasData) {
                                                        //         return SizedBox();
                                                        //       }
                                                        //       return
                                                        //         Visibility(
                                                        //           visible: snapshot.data!.docs.first['subject_comment'],
                                                        //           child: Column(
                                                        //             children: [
                                                        //               /// 댓글리스트
                                                        //               ListView.builder(
                                                        //                   shrinkWrap: true,
                                                        //                   itemCount: commentList.length,
                                                        //                   itemBuilder: (_, index) {
                                                        //                     commentCnt ++;
                                                        //                     updCommentInputCnt ++;
                                                        //                     updCommentInputControllers.add(TextEditingController());
                                                        //                     return Column(
                                                        //                       crossAxisAlignment: CrossAxisAlignment.start,
                                                        //                       children: [
                                                        //                         Row(
                                                        //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        //                           children: [
                                                        //                             Row(
                                                        //                               children: [
                                                        //                                 Text(commentList[index]['name'], style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 11),),
                                                        //                                 SizedBox(width: 2,),
                                                        //                                 Text('('+commentList[index]['date'].toDate().month.toString()+'.'+commentList[index]['date'].toDate().day.toString()+' '+
                                                        //                                     commentList[index]['date'].toDate().hour.toString()+':'+commentList[index]['date'].toDate().minute.toString()+')',
                                                        //                                   style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 11),),
                                                        //                               ],
                                                        //                             ),
                                                        //                             GetStorage().read('name') == commentList[index]['name'] || GetStorage().read('job') == 'teacher' ?
                                                        //                             /// 댓글수정아이콘
                                                        //                             GestureDetector(
                                                        //                               onTap: () {
                                                        //                                 SubjectController.to.subject_diary_id = subject_doc.id;
                                                        //                                 updCommentDialog(context, commentList[index]);
                                                        //                               },
                                                        //                               child: Icon(Icons.edit_outlined, size: 17, color: Colors.black.withOpacity(0.3),),
                                                        //                             ) : SizedBox(),
                                                        //                           ],
                                                        //                         ),
                                                        //                         Text(commentList[index]['comment'], style: TextStyle(fontSize: 12, color: Colors.black,),),
                                                        //                         SizedBox(height: 3,),
                                                        //                       ],
                                                        //                     );
                                                        //                   }
                                                        //               ),
                                                        //               /// 이거 안해주면 index 에러남
                                                        //               Text((addCommentCnt++).toString(), style: TextStyle(fontSize: 0),),
                                                        //               SizedBox(height: 10,),
                                                        //               /// 댓글입력
                                                        //               Container(
                                                        //                 height: 28,
                                                        //                 child: TextField(
                                                        //                   controller: addCommentControllers[addCommentCnt - 1],
                                                        //                   textAlignVertical: TextAlignVertical.center,
                                                        //                   onSubmitted: (value) {
                                                        //                     SubjectController.to.subject_diary_id = subject_doc.id;
                                                        //                     if (value.trim().length > 0) {
                                                        //                       SubjectController.to.saveComment(value.trim());
                                                        //                       for(var con in addCommentControllers)
                                                        //                         con.clear();
                                                        //                     }
                                                        //
                                                        //                   },
                                                        //
                                                        //                   style: TextStyle(fontFamily: 'Jua', color: Colors.black, fontSize: 14, ),
                                                        //                   // minLines: 1,
                                                        //                   maxLines: 1,
                                                        //                   decoration: InputDecoration(
                                                        //                     hintText: '댓글 입력',
                                                        //                     hintStyle: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.5)),
                                                        //                     // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
                                                        //                     focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                                                        //                     enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
                                                        //                     contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                                        //
                                                        //                   ),
                                                        //                 ),
                                                        //               ),
                                                        //             ],
                                                        //           ),
                                                        //         );
                                                        //     }
                                                        // ),

                                                      ],
                                                    ),


                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                      ),
                                      SizedBox(height: 30,),
                                    ],
                                  );
                              }
                          );
                        }
                    ),
                  ),
                  SizedBox(height: 100,),
                ],
              ),
            ),
          );
        }

    );

  }
}



