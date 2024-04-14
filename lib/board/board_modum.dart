
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../controller/board_controller.dart';
import '../controller/main_controller.dart';

class BoardModum extends StatelessWidget {
  // CustomPopupMenuController popupSettingController = CustomPopupMenuController();
  // CustomPopupMenuController stampController = CustomPopupMenuController();
  TextEditingController titleSettingController = TextEditingController();
  TextEditingController contentSettingController = TextEditingController();
  List addControllers = [];
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

  void updContentDialog(context) {
    /// 전체화면에서 다이어로그 띄우기
    showGeneralDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      pageBuilder: (_,__,___) {
        return Scaffold(
          // backgroundColor: Color(0xFF5E5E5E),
          appBar: AppBar(
            centerTitle: false, // 왼쪽에 두기위해
            automaticallyImplyLeading: false,
            elevation: 0,
            // backgroundColor: Color(0xFF5E5E5E),
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
                      child: Container(width: 50, height: 40, color: Colors.transparent, child: Image.asset('assets/images/camera.png', ),),
                    ),
                    SizedBox(width: 20,),
                    /// 수정
                    GestureDetector(
                      onTap: () async{
                        if(BoardController.to.board_type == '개인') {
                          await BoardController.to.updBoardIndi();
                        }else {
                          await BoardController.to.updBoardModum();
                        }
                        BoardController.to.imageModel.value.imageInt8 == null;
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 80, height: 36,
                        decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(15)),
                        child: Center(child: Text('저장', style: TextStyle(fontFamily: 'Jua', color: Colors.white),),),
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
                        style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
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
                        style: TextStyle(color: Colors.white , ),
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

                  GestureDetector(
                    onTap: () async{
                      await BoardController.to.delBoardModum();
                      BoardController.to.imageModel.value.imageInt8 == null;
                      Navigator.pop(context);

                    },
                    child: Container(
                      width: 100, height: 40,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(15)),
                      child: Center(child: Text('삭제', style: TextStyle(fontSize: 17, fontFamily: 'Jua', color: Colors.white),),),
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
    showDialog(
      context: context,
      barrierDismissible: false, // 다이얼로그 밖 클릭시 안사라지게
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF5E5E5E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: Container(
            width: 150,
            height: 150,
            // color: Color(0xFF5E5E5E),
            child: IntrinsicWidth(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('댓글 수정' ,style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 14, )),
                    Divider(color: Colors.white.withOpacity(0.3),),
                    Container(
                      height: 110,
                      child: TextField(
                        controller: TextEditingController(text: comment['comment']),
                        onChanged: (value) {
                          BoardController.to.indi_comment = value;
                        },
                        style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 15, ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextButton(
                    style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                    onPressed: () async{
                      Navigator.pop(context);
                    },
                    child: Text('닫기',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.white, ),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextButton(
                    style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                    onPressed: () async{
                      BoardController.to.delComment(comment, 'board_modum');
                      Navigator.pop(context);
                    },
                    child: Text('삭제',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.red, ),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextButton(
                    style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                    onPressed: () async{
                      BoardController.to.updComment(comment, 'board_modum');
                      Navigator.pop(context);
                    },
                    child: Text('수정',style: TextStyle(fontFamily: 'Jua', fontSize: 17,  color: Colors.white, ),),
                  ),
                ),
              ],
            ),

          ],
        );
      },
    );

  }

  void imageDialog(context, id, imageUrl, isDelete) {
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
              visible: isDelete,
              child: TextButton(
                style: ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.5))),
                onPressed: () async{
                  BoardController.to.board_indi_modum_id = id;
                  BoardController.to.delImage(imageUrl, 'board_modum');
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
            /// 본문 내용
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('board_main').where('class_code', isEqualTo: GetStorage().read('class_code'))
                    .where('main_id', isEqualTo: BoardController.to.board_main_id).snapshots(),
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
                  List modums = snapshot.data!.docs.first['modums'];
                  modums.sort((a,b)=> a['number'].compareTo(b['number']));
                  BoardController.to.modumLastNumber = modums.last['number'];
                  return
                    CarouselSlider.builder(
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          initialPage: 0,
                          onPageChanged: (int, CarouselPageChangedReason) {
                          },
                            /// 아이패드가 가로면? 세로면? 아이폰이면
                          viewportFraction: MediaQuery.of(context).size.width > 1000 ? 0.35 : MediaQuery.of(context).size.width > 600 ? 0.45 : 0.8,
                          height: MediaQuery.of(context).size.height,
                        ),
                        itemCount: modums.length,
                        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                          var modum = modums[itemIndex];
                          return Padding(
                            padding: const EdgeInsets.only(left:40, right:40, bottom: 40, top: 20),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// 모둠 이름
                                  Container(
                                    height: 30,
                                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(8)),
                                    child: Center(child: Text(modum['name'],  maxLines:1,overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: 'Jua', fontSize: 16, color: Colors.white),),),
                                  ),
                                  Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          MainController.to.active_screen.value = 'board_add';
                                          BoardController.to.modum_number = modum['number'];
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(Icons.add_circle, color: Colors.orangeAccent,),
                                        ),
                                      ),
                                  ),

                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance.collection('board_modum').where('class_code', isEqualTo: GetStorage().read('class_code'))
                                          .where('main_id', isEqualTo: BoardController.to.board_main_id).where('modum_number', isEqualTo: modum['number'])
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
                                          ListView.builder(
                                              shrinkWrap: true,
                                              primary: false,
                                              itemCount: snapshot.data!.docs.length,
                                              itemBuilder: (_, index) {
                                                DocumentSnapshot indiDoc = snapshot.data!.docs[index];
                                                /// 스탬프 전체찍기 위해
                                                if (!allIndexs.contains('${modum['number']}-${index}')) {
                                                  allIndexs.add('${modum['number']}-${index}');
                                                }

                                                // 댓글 날짜순 정렬
                                                List commentList = indiDoc['comment'];
                                                commentList.sort((a, b) => a['date'].compareTo(b['date']));
                                                indiCnt ++;
                                                updTitleCnt ++;
                                                updContentCnt ++;
                                                /// 겹치는거 때문에 obx 처리한 후로 addCommentCnt를 제대로 못가져와서 아래와 같이 처리함
                                                ///  여기서 addCommentCnt ++ 하면 모든 addCommentCnt가 같은 값 가짐.
                                                ///  addCommentCnt = 0을 해줘야 리로드시마다 1부터 올라감
                                                // addCommentCnt ++;
                                                addCommentCnt = 0;
                                                // updIndiControllers.add(CustomPopupMenuController());
                                                updTitleInputControllers.add(TextEditingController());
                                                updContentInputControllers.add(TextEditingController());
                                                addCommentControllers.add(TextEditingController());

                                                return Padding(
                                                  padding: EdgeInsets.only(top: 10, right: 0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.7), spreadRadius: 0, blurRadius: 2.0, offset: Offset(0, 3), ),],
                                                      color: Colors.white, borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(15.0),
                                                      child:
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          /// 제목
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Text(indiDoc['stu_name'] + ' ('+indiDoc['date'].toDate().month.toString()+'.'+indiDoc['date'].toDate().day.toString()+' '+
                                                                      indiDoc['date'].toDate().hour.toString()+':'+indiDoc['date'].toDate().minute.toString()+')',
                                                                    style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.5)),),
                                                                  GetStorage().read('number') == indiDoc['stu_number'] || GetStorage().read('job') == 'teacher' ?
                                                                  /// 수정아이콘
                                                                  GestureDetector(
                                                                      onTap: () {
                                                                        BoardController.to.board_indi_modum_id = indiDoc.id;
                                                                        BoardController.to.indi_title = indiDoc['title'];
                                                                        BoardController.to.indi_content = indiDoc['content'];
                                                                        updContentDialog(context);
                                                                        BoardController.to.image_url = indiDoc['imageUrl'];
                                                                        /// boardModum에서 이미지로딩시 식별하기위해, 이거 안하면 같은 번호 모두 로딩이미지 보여짐
                                                                        // BoardController.to.modumIndex.value = itemIndex;
                                                                      },
                                                                      child: Icon(Icons.edit_outlined, size: 20, color: Colors.black.withOpacity(0.3),)) : SizedBox(),
                                                                ],
                                                              ),
                                                              SizedBox(height: 5,),
                                                              Text(indiDoc['title'],  style: TextStyle(fontFamily: 'Jua', fontSize: 16,  color: Colors.black),),
                                                            ],
                                                          ),
                                                          SizedBox(height: 5,),
                                                          indiDoc['content'].length > 0 ?
                                                          Text(indiDoc['content'],  style: TextStyle(fontSize: 15, color: Colors.black,),) : SizedBox(),
                                                          /// 내용, 이미지로딩중
                                                          // Obx(() => Stack(children: [
                                                          //   indiDoc['content'].length > 0 ?
                                                          //   Text(indiDoc['content'],  style: TextStyle(fontFamily: 'Jua', fontSize: 15, color: Colors.black,),) : SizedBox(),
                                                          //   BoardController.to.isImageLoading.value == true && indiDoc['stu_number'] == GetStorage().read('number')
                                                          //       && index == 0 && BoardController.to.modumIndex == itemIndex ?
                                                          //   Center(child: Container(
                                                          //     height: 40,
                                                          //     child: LoadingIndicator(
                                                          //         indicatorType: Indicator.ballPulse,
                                                          //         colors: MainController.to.kDefaultRainbowColors,
                                                          //         strokeWidth: 2,
                                                          //         backgroundColor: Colors.transparent,
                                                          //         pathBackgroundColor: Colors.transparent
                                                          //     ),
                                                          //   ),) : SizedBox(),
                                                          // ],),
                                                          // ),
                                                          SizedBox(height: 5,),
                                                          /// 이미지
                                                          indiDoc['imageUrl'].length != 0 ?
                                                          GestureDetector(
                                                            onTap: () {
                                                              if (GetStorage().read('number') == indiDoc['stu_number']) {
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
                                                          indiDoc['stamp'] == '' ? SizedBox() :
                                                          /// 이모티콘
                                                          Visibility(
                                                            visible: indiDoc['stamp'].length > 0,
                                                            child: Row(
                                                              children: [
                                                                Expanded(child: SizedBox()),
                                                                Container(
                                                                  height: 32,
                                                                  child: Image.asset('assets/images/${indiDoc['stamp']}'),
                                                                ),
                                                              ],
                                                            ),
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
                                                                        BoardController.to.delLike(GetStorage().read('number'), 'board_modum');
                                                                      }else {
                                                                        BoardController.to.addLike(GetStorage().read('number'), 'board_modum');
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
                                                            ],
                                                          ),
                                                          SizedBox(height: 5,),
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
                                                                              // updCommentControllers.add(CustomPopupMenuController());
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
                                                                        /// 댓글입력
                                                                        Container(
                                                                          height: 28,
                                                                          child: TextField(
                                                                            controller: addCommentControllers[addCommentCnt - 1],
                                                                            textAlignVertical: TextAlignVertical.center,
                                                                            onSubmitted: (value) {
                                                                              BoardController.to.board_indi_modum_id = indiDoc.id;
                                                                              BoardController.to.saveComment(value.trim(), 'board_modum');
                                                                              for(var con in addCommentControllers)
                                                                                con.clear();
                                                                            },


                                                                            style: TextStyle(fontFamily: 'Jua', color: Colors.black, fontSize: 14, ),
                                                                            // minLines: 1,
                                                                            maxLines: 1,
                                                                            decoration: InputDecoration(
                                                                              hintText: '댓글 입력',
                                                                              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.5)),
                                                                              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey, ),),
                                                                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5) ),),
                                                                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), ),),
                                                                              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),

                                                                            ),
                                                                          ),
                                                                        ),
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
                                          );
                                      }
                                  ),
                                  SizedBox(height: 100,),
                                ],
                              ),
                            ),
                          );
                        }

                    );
                }
            ),
            SizedBox(height: 100,),
          ],
        ),
      ),


    );

  }
}







