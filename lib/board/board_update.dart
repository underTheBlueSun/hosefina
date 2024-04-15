// import '../../controller/board_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter/services.dart';
//
// // import 'auction/auction_indi.dart';
// import 'board_indi.dart';
// // import 'board_modum.dart';
//
// class BoardUpdate extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       SingleChildScrollView(
//         child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
//                 child: SizedBox(
//                   height: 30,
//                   child: TextField(
//                     controller: TextEditingController(text: BoardController.to.indi_title),
//                     onChanged: (value) {
//                       BoardController.to.indi_title = value;
//                     },
//                     style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
//                     maxLines: 1,
//                     decoration: InputDecoration(
//                       hintText: '제목을 입력하세요',
//                       hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
//                       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
//                       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 18, right: 18),
//                 child: Divider(color: Colors.grey.withOpacity(0.3),),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 18, right: 18, bottom: 10),
//                 child: SizedBox(
//                   height: 250,
//                   child: TextField(
//                     controller: TextEditingController(text: BoardController.to.indi_content),
//                     onChanged: (value) {
//                       BoardController.to.indi_content = value;
//                     },
//                     style: TextStyle(fontFamily: 'Jua', color: Colors.white , fontSize: 17, ),
//                     minLines: 10,
//                     maxLines: null,
//                     decoration: InputDecoration(
//                       hintText: '내용을 입력하세요',
//                       hintStyle: TextStyle(fontSize: 17, color: Colors.grey.withOpacity(0.5)),
//                       focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent ),),
//                       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.transparent, ),),
//                     ),
//                   ),
//                 ),
//               ),
//
//               Obx(() => Column(
//                 children: [
//                   SizedBox(height: 5,),
//                   BoardController.to.image_url.length == 0 && BoardController.to.imageModel.value.imageInt8 == null ?
//                   SizedBox() :
//                   Padding(
//                     padding: const EdgeInsets.only(top: 8, bottom: 8, right: 15, left: 15),
//                     child: Container(
//                       width: MediaQuery.of(context).size.width,
//                       child: BoardController.to.imageModel.value.imageInt8 == null ?
//                       ClipRRect(
//                           borderRadius: BorderRadius.circular(8.0),
//                           child: Image.network(BoardController.to.image_url, fit: BoxFit.cover)) :
//                       ClipRRect(
//                           borderRadius: BorderRadius.circular(8.0),
//                           child: Image.memory(BoardController.to.imageModel.value.imageInt8!, fit: BoxFit.cover)),
//                     ),
//                   ),
//                   Text(BoardController.to.dummy.value.toString(), style: TextStyle(fontSize: 0),),
//                 ],
//               ),
//               ),
//
//               InkWell(
//                 highlightColor: Colors.transparent,
//                 hoverColor: Colors.transparent,
//                 splashColor: Colors.transparent,
//                 onTap: () {
//                   // if(Get.arguments['type'] == 'indi') {
//                   //   BoardController.to.delBoardIndi(Get.arguments['indiDoc']);
//                   //   if (BoardController.to.param_gubun == 'board') {
//                   //     Get.off(() => BoardIndi(), arguments: {'title' : Get.arguments['title'], 'main_id' : Get.arguments['main_id'], 'background': Get.arguments['background'],
//                   //       'content': Get.arguments['content'], 'id': Get.arguments['id'], 'gubun': Get.arguments['gubun']});
//                   //   }else {
//                   //     Get.off(() => AuctionIndi(), arguments: {'title' : Get.arguments['title'], 'main_id' : Get.arguments['main_id'], 'background': Get.arguments['background'],
//                   //       'content': Get.arguments['content'], 'id': Get.arguments['id'], 'gubun': Get.arguments['gubun']});
//                   //   }
//                   //
//                   // }else {
//                   //   BoardController.to.delBoardModum(Get.arguments['indiDoc']);
//                   //   Get.off(() => BoardModum(), arguments: {'title' : Get.arguments['title'], 'main_id' : Get.arguments['main_id'], 'background': Get.arguments['background'],
//                   //     'content': Get.arguments['content'], 'id': Get.arguments['id'], 'modums': Get.arguments['modums'], 'gubun': Get.arguments['gubun']});
//                   // }
//                   // BoardController.to.imageModel.value.imageInt8 == null;
//                 },
//                 child: Image.asset('assets/images/font_delete.png', height: 32),
//               ),
//               SizedBox(height: 50,),
//
//
//             ]
//         ),
//       );
//
//   }
// }
//
//
