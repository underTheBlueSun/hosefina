
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../controller/board_controller.dart';
import '../controller/main_controller.dart';

class BoardIndi extends StatelessWidget {
  // CustomPopupMenuController popupSettingController = CustomPopupMenuController();
  // CustomPopupMenuController addController = CustomPopupMenuController();
  TextEditingController titleSettingController = TextEditingController();
  TextEditingController contentSettingController = TextEditingController();
  // List addControllers = [];
  List updIndiControllers = [];
  List updCommentControllers = [];
  List addCommentControllers = [];
  List updTitleInputControllers = [];
  List updContentInputControllers = [];
  List updCommentInputControllers = [];
  int indiCnt = 0;
  int commentCnt = 0;
  int addCommentCnt = 0;
  int updTitleCnt = 0;
  int updContentCnt = 0;
  int updCommentInputCnt = 0;
  /// 전체 스탬프 찍기 위해  전체 인텍스 가져오기
  List allIndexs = [];

  void addCommentDialog(context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            height: 120,
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.grey.withOpacity(0.5),size: 30,),),
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    autofocus: true,
                    onSubmitted: (value) {
                      if (value.trim().length > 0) {
                        BoardController.to.saveComment(value.trim(), 'board_indi');
                        Navigator.pop(context);
                      }
                    },
                    style: TextStyle(color: Colors.black, fontFamily: 'Jua' ),
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요',
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5), ),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                    ),
                  ),
                ],
              ),
            ),
          ),
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
                      // MainController.to.active_screen.value = 'board_indi';
                      Navigator.pop(context);
                    },
                    child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white,size: 30,),),
                ),
                Row(
                  children: [
                    /// 사진
                    GestureDetector(
                      onTap: () {
                        BoardController.to.selectImage();
                      },
                      child: Column(
                        children: [
                          Icon(Icons.photo_camera_back_outlined, size: 30, color: Colors.white,),
                          Text('사진', style: TextStyle(color: Colors.white, fontFamily: 'Jua', fontSize: 15),),
                        ],
                      ),
                    ),

                    // GestureDetector(
                    //   onTap: () {
                    //     BoardController.to.selectImage();
                    //   },
                    //   child: Container(width: 50, height: 40, color: Colors.transparent, child: Image.asset('assets/images/camera.png', ),),
                    // ),
                    SizedBox(width: 20,),
                    /// 삭제
                    GestureDetector(
                      onTap: () async{
                        await BoardController.to.delBoardIndi();
                        BoardController.to.imageModel.value.imageInt8 == null;
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
                    padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
                    child: SizedBox(
                      height: 30,
                      child: TextField(
                        controller: TextEditingController(text: BoardController.to.indi_title),
                        onChanged: (value) {
                          BoardController.to.indi_title = value;
                        },
                        style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17,),
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: '제목을 입력하세요',
                          hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18),
                    child: Divider(color: Colors.grey.withOpacity(0.3),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18, right: 18, bottom: 10),
                    child: SizedBox(
                      // height: 250,
                      child: TextField(
                        controller: TextEditingController(text: BoardController.to.indi_content),
                        onChanged: (value) {
                          BoardController.to.indi_content = value;
                        },
                        style: TextStyle(color: Colors.white , fontFamily: 'Jua',),
                        minLines: 10,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: '내용을 입력하세요',
                          hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
                        ),
                      ),
                    ),
                  ),

                  Obx(() => Column(
                    children: [
                      SizedBox(height: 5,),
                      BoardController.to.image_url.length == 0 && BoardController.to.imageModel.value.imageInt8 == null ?
                      SizedBox() :
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8, right: 15, left: 15),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: BoardController.to.imageModel.value.imageInt8 == null ?
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(BoardController.to.image_url, fit: BoxFit.cover)) :
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.memory(BoardController.to.imageModel.value.imageInt8!, fit: BoxFit.cover)),
                        ),
                      ),
                      Text(BoardController.to.dummy.value.toString(), style: TextStyle(fontSize: 0),),
                    ],
                  ),
                  ),

                  /// 저장버튼
                  Container(
                    width: 120,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, ),
                      onPressed: () async{
                        if(BoardController.to.board_type == '개인') {
                          await BoardController.to.updBoardIndi();
                        }else {
                          await BoardController.to.updBoardModum();
                        }
                        BoardController.to.imageModel.value.imageInt8 == null;
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

  void updCommentDialog(context, comment) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Container(
            height: 120,
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.grey.withOpacity(0.5),size: 30,),),
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    controller: TextEditingController(text: comment['comment']),
                    onChanged: (value) {
                      BoardController.to.indi_comment = value;
                    },
                    style: TextStyle(fontFamily: 'Jua', color: Colors.black , fontSize: 15, ),
                    maxLines: 1,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(isDefaultAction: true, child: Text('삭제', style: TextStyle(color: Colors.red),), onPressed: () {
              BoardController.to.delComment(comment, 'board_indi');
              Navigator.pop(context);
            }),
            CupertinoDialogAction(isDefaultAction: true, child: Text('수정'), onPressed: () {
              BoardController.to.updComment(comment, 'board_indi');
              Navigator.pop(context);
            })

          ],
        );
      },
    );

  }

  // void updCommentDialog2(context, comment) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Color(0xFF5E5E5E),
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  //         content: Container(
  //           width: 150,
  //           height: 150,
  //           // color: Color(0xFF5E5E5E),
  //           child: IntrinsicWidth(
  //             child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Text('댓글 수정' ,style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 14, )),
  //                   Divider(color: Colors.white.withOpacity(0.3),),
  //                   Container(
  //                     height: 110,
  //                     child: TextField(
  //                       controller: TextEditingController(text: comment['comment']),
  //                       onChanged: (value) {
  //                         BoardController.to.indi_comment = value;
  //                       },
  //                       style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 15, ),
  //                       maxLines: 10,
  //                       decoration: InputDecoration(
  //                         focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
  //                         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
  //                       ),
  //                     ),
  //                   ),
  //
  //                 ]
  //             ),
  //           ),
  //         ),
  //         actions: <Widget>[
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(5),
  //                 child: TextButton(
  //                   style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
  //                   onPressed: () async{
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text('닫기',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.white, ),),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(5),
  //                 child: TextButton(
  //                   style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
  //                   onPressed: () async{
  //                     BoardController.to.delComment(comment, 'board_indi');
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text('삭제',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.red, ),),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(5),
  //                 child: TextButton(
  //                   style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
  //                   onPressed: () async{
  //                     BoardController.to.updComment(comment, 'board_indi');
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text('수정',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.white, ),),
  //                 ),
  //               ),
  //             ],
  //           ),
  //
  //         ],
  //       );
  //     },
  //   );
  //
  // }

  void imageDialog(context, id, imageUrl, isDelete) {
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
                    Navigator.pop(context);
                  },
                  child: Container(width: 50, height: 30, color: Colors.transparent, child: Icon(Icons.cancel, color: Colors.white,size: 30,),),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // width: MediaQuery.of(context).size.width < 600 ? 400 : 800,
                  // height: MediaQuery.of(context).size.width < 600 ? 400 : 800,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.network(imageUrl),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              /// 삭제버튼
              Container(
                width: 120,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, ),
                  onPressed: () async{
                    BoardController.to.board_indi_modum_id = id;
                    BoardController.to.delImage(imageUrl, 'board_indi');
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete, color: Colors.white,),
                      SizedBox(width: 5,),
                      Text('삭제', style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

  }

  void imageDialog2(context, id, imageUrl, isDelete) {
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF4C4C4C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: MediaQuery.of(context).size.width < 600 ? 400 : 800,
            height: MediaQuery.of(context).size.width < 600 ? 400 : 800,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.network(imageUrl),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
              onPressed: () async{
                Navigator.pop(context);
              },
              child: Text('닫기',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.white, ),),
            ),
            SizedBox(width: 20,),
            Visibility(
              // visible: true,
              visible: isDelete,
              child: TextButton(
                style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                onPressed: () async{
                  BoardController.to.board_indi_modum_id = id;
                  BoardController.to.delImage(imageUrl, 'board_indi');
                  Navigator.pop(context);
                },
                child: Text('삭제',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.red, ),),
              ),
            ),
          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      /// 길이가 10이면 배경색깔
      decoration: BoardController.to.background.value.length == 10 ?
      BoxDecoration(color: Color(int.parse(BoardController.to.background.value))) :
      BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/' + BoardController.to.background.value + '.png'), fit: BoxFit.cover, ),),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(left: 10, right: 10),
            //   child: Text(BoardController.to.board_title, style: TextStyle(fontFamily: 'Jua', color: Colors.white, fontSize: 20),),
            // ),
            /// 본문 내용
            Padding(
              padding: const EdgeInsets.only(left:40, right:40, top:20, bottom: 40),
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
                        stream: FirebaseFirestore.instance.collection('board_indi').where('class_code', isEqualTo: GetStorage().read('class_code'))
                            .where('main_id', isEqualTo: BoardController.to.board_main_id).where('number', isEqualTo: attendanceDoc['number'])
                            .orderBy('date', descending: true).snapshots(),
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
                                /// 번호, 이름, 추가아이콘
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
                                    // itemCount: indiDocs.length,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (_, index) {
                                      // DocumentSnapshot indiDoc = indiDocs[index];
                                      DocumentSnapshot indiDoc = snapshot.data!.docs[index];

                                      // 댓글 날짜순 정렬
                                      List commentList = indiDoc['comment'];
                                      commentList.sort((a, b) => a['date'].compareTo(b['date']));
                                      // indiCnt ++;
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

                                      return Padding(
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
                                                /// 제목
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        // width: 200,
                                                        child: Text(indiDoc['title'],  style: TextStyle(fontFamily: 'Jua', fontSize: 16, color: Colors.black),),
                                                      ),
                                                    ),
                                                    GetStorage().read('number') == indiDoc['number'] || GetStorage().read('job') == 'teacher' ?
                                                    /// 수정아이콘
                                                    GestureDetector(
                                                      onTap: () {
                                                        /// 이거안하면 텍스트필드 onchange없으면 널값 됨
                                                        BoardController.to.board_indi_modum_id = indiDoc.id;
                                                        BoardController.to.indi_title = indiDoc['title'];
                                                        BoardController.to.indi_content = indiDoc['content'];
                                                        BoardController.to.image_url = indiDoc['imageUrl'];

                                                        // MainController.to.active_screen.value = 'board_update';
                                                        updContentDialog(context);

                                                        // Get.off(() => BoardUpdMoblie(), arguments: {'indiDoc' : indiDoc, 'type': 'indi', 'title' : Get.arguments['title'], 'main_id' : BoardController.to.selected_main_id, 'background': Get.arguments['background'],
                                                        //   'content': Get.arguments['content'], 'id': Get.arguments['id'], 'gubun': Get.arguments['gubun'],}, );
                                                      },
                                                      child: Container(
                                                          alignment: Alignment.centerRight,
                                                          width: 30,
                                                          child: Icon(Icons.edit_outlined, size: 20, color: Colors.black.withOpacity(0.3),)),
                                                    ) :
                                                    SizedBox(),

                                                  ],
                                                ),
                                                SizedBox(height: 5,),
                                                /// 전체화면 선택할때만 내용, 이미지 보이게
                                                Column(children: [
                                                  indiDoc['content'].length > 0 ?
                                                  Text(indiDoc['content'],  style: TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.6), fontFamily: 'Jua',),) : SizedBox(),
                                                  // /// 내용, 이미지로딩중
                                                  // Obx(() => Stack(children: [
                                                  //     indiDoc['content'].length > 0 ?
                                                  //     Text(indiDoc['content'],  style: TextStyle(fontSize: 15, color: Colors.black,),) : SizedBox(),
                                                  //     BoardController.to.isImageLoading.value == true && indiDoc['number'] == GetStorage().read('number') && index == 0 ?
                                                  //     Center(child: Container(
                                                  //       height: 40,
                                                  //       child: LoadingIndicator(
                                                  //           indicatorType: Indicator.ballPulse,
                                                  //           colors: MainController.to.kDefaultRainbowColors,
                                                  //           strokeWidth: 2,
                                                  //           backgroundColor: Colors.transparent,
                                                  //           pathBackgroundColor: Colors.transparent
                                                  //       ),
                                                  //     ),) : SizedBox(),
                                                  //   ],),
                                                  // ),
                                                  SizedBox(height: 5,),
                                                  /// 이미지
                                                  indiDoc['imageUrl'].length != 0 ?
                                                  GestureDetector(
                                                    onTap: () {
                                                      if (GetStorage().read('number') == indiDoc['number']) {
                                                        imageDialog(context, indiDoc.id, indiDoc['imageUrl'], true);
                                                      }else {
                                                        imageDialog(context, indiDoc.id, indiDoc['imageUrl'], false);
                                                      }

                                                    },
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(5.0),
                                                      child: Image.network(indiDoc['imageUrl']),
                                                    ),
                                                  )
                                                      : SizedBox(),
                                                ],),

                                                /// 이모티콘
                                                indiDoc['stamp'] == '' ? SizedBox() :
                                                Row(
                                                  children: [
                                                    Expanded(child: SizedBox()),
                                                    Container(
                                                      height: 32,
                                                      child: Image.asset('assets/images/${indiDoc['stamp']}'),
                                                    ),
                                                  ],
                                                ),

                                                Divider(color: Colors.black,),
                                                /// 좋아요
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            BoardController.to.board_indi_modum_id = indiDoc.id;
                                                            if (indiDoc['like'].contains(GetStorage().read('number'))) {
                                                              BoardController.to.delLike(GetStorage().read('number'), 'board_indi');
                                                            }else {
                                                              BoardController.to.addLike(GetStorage().read('number'), 'board_indi');
                                                            }
                                                          },
                                                          child: Container(
                                                            width: 30,
                                                            child: indiDoc['like'].contains(GetStorage().read('number')) == true ?
                                                            Icon(Icons.favorite, size: 20, color: Colors.red,) :
                                                            Icon(Icons.favorite_border_outlined, size: 20, color: Colors.black,),
                                                          ),
                                                        ),
                                                        Text(indiDoc['like'].length.toString(), style: TextStyle(color: Colors.black),),
                                                      ],
                                                    ),
                                                    GetStorage().read('job') == 'teacher' ?
                                                    /// 스탬프아이콘
                                                    InkWell(
                                                      highlightColor: Colors.transparent,
                                                      hoverColor: Colors.transparent,
                                                      splashColor: Colors.transparent,
                                                      onTap: () {
                                                        if (indiDoc['stamp'] == '') {
                                                          BoardController.to.selectedStamp.value = 'stamp1.png';
                                                          BoardController.to.addStamp(indiDoc.id, 'board_indi');
                                                        }else if (indiDoc['stamp'] == 'stamp1.png') {
                                                          BoardController.to.selectedStamp.value = 'stamp2.png';
                                                          BoardController.to.addStamp(indiDoc.id, 'board_indi');
                                                        }else if (indiDoc['stamp'] == 'stamp2.png') {
                                                          BoardController.to.selectedStamp.value = 'stamp3.png';
                                                          BoardController.to.addStamp(indiDoc.id, 'board_indi');
                                                        }else if (indiDoc['stamp'] == 'stamp3.png') {
                                                          BoardController.to.selectedStamp.value = 'stamp4.png';
                                                          BoardController.to.addStamp(indiDoc.id, 'board_indi');
                                                        }else if (indiDoc['stamp'] == 'stamp4.png') {
                                                          BoardController.to.selectedStamp.value = 'stamp5.png';
                                                          BoardController.to.addStamp(indiDoc.id, 'board_indi');
                                                        }else if (indiDoc['stamp'] == 'stamp5.png') {
                                                          BoardController.to.selectedStamp.value = 'stamp6.png';
                                                          BoardController.to.addStamp(indiDoc.id, 'board_indi');
                                                        } else {
                                                          BoardController.to.selectedStamp.value = '';
                                                          BoardController.to.delStamp(indiDoc.id, 'board_indi');
                                                        }
                                                      },
                                                      child:  Image.asset('assets/images/stamp.png', width: 20,),
                                                    ) : SizedBox(),
                                                  ],
                                                ),
                                                SizedBox(height: 15,),
                                                /// 댓글허용 여부
                                                StreamBuilder<QuerySnapshot>(
                                                    stream: FirebaseFirestore.instance.collection('board_main').where('class_code', isEqualTo: GetStorage().read('class_code'))
                                                        .where('main_id', isEqualTo: BoardController.to.board_main_id).snapshots(),
                                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return SizedBox();
                                                      }
                                                      return
                                                        Visibility(
                                                          visible: snapshot.data!.docs.first['isAcceptComment'],
                                                          child: Column(
                                                            children: [
                                                              /// 댓글리스트
                                                              ListView.builder(
                                                                  shrinkWrap: true,
                                                                  itemCount: commentList.length,
                                                                  itemBuilder: (_, index) {
                                                                    commentCnt ++;
                                                                    updCommentInputCnt ++;
                                                                    updCommentInputControllers.add(TextEditingController());
                                                                    return Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Text(commentList[index]['name'], style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 11),),
                                                                                SizedBox(width: 2,),
                                                                                Text('('+commentList[index]['date'].toDate().month.toString()+'.'+commentList[index]['date'].toDate().day.toString()+' '+
                                                                                    commentList[index]['date'].toDate().hour.toString()+':'+commentList[index]['date'].toDate().minute.toString()+')',
                                                                                  style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 11),),
                                                                              ],
                                                                            ),
                                                                            GetStorage().read('name') == commentList[index]['name'] || GetStorage().read('job') == 'teacher' ?
                                                                            /// 댓글수정아이콘
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                BoardController.to.board_indi_modum_id = indiDoc.id;
                                                                                updCommentDialog(context, commentList[index]);
                                                                              },
                                                                              child: Icon(Icons.edit_outlined, size: 17, color: Colors.black.withOpacity(0.3),),
                                                                            ) : SizedBox(),
                                                                          ],
                                                                        ),
                                                                        Text(commentList[index]['comment'], style: TextStyle(fontSize: 12, color: Colors.black,),),
                                                                        SizedBox(height: 3,),
                                                                      ],
                                                                    );
                                                                  }
                                                              ),
                                                              /// 이거 안해주면 index 에러남
                                                              Text((addCommentCnt++).toString(), style: TextStyle(fontSize: 0),),
                                                              SizedBox(height: 10,),
                                                              /// 댓글입력
                                                              GestureDetector(
                                                                onTap: () {
                                                                  BoardController.to.board_indi_modum_id = indiDoc.id;
                                                                  addCommentDialog(context);
                                                                },
                                                                child: Container(
                                                                  height: 28,
                                                                  width: MediaQuery.of(context).size.width,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(10),
                                                                    color: Colors.white,
                                                                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(4),
                                                                    child: Text('댓글 입력', style: TextStyle(color: Colors.grey.withOpacity(0.5),  ),),
                                                                  ),
                                                                ),
                                                              ),
                                                              // Container(
                                                              //   height: 28,
                                                              //   child: TextField(
                                                              //     controller: addCommentControllers[addCommentCnt - 1],
                                                              //     textAlignVertical: TextAlignVertical.center,
                                                              //     onSubmitted: (value) {
                                                              //       BoardController.to.board_indi_modum_id = indiDoc.id;
                                                              //       if (value.trim().length > 0) {
                                                              //         BoardController.to.saveComment(value.trim(), 'board_indi');
                                                              //         for(var con in addCommentControllers)
                                                              //           con.clear();
                                                              //       }
                                                              //
                                                              //     },
                                                              //
                                                              //     style: TextStyle(fontFamily: 'Jua', color: Colors.black, fontSize: 14, ),
                                                              //     // minLines: 1,
                                                              //     maxLines: 1,
                                                              //     decoration: InputDecoration(
                                                              //       hintText: '댓글 입력',
                                                              //       hintStyle: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.5)),
                                                              //       // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
                                                              //       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                                                              //       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
                                                              //       contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                                              //
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                            ],
                                                          ),
                                                        );
                                                    }
                                                ),

                                              ],
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
}







