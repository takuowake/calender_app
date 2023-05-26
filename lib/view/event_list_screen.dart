// import 'package:flutter/material.dart';
//
// class DialogPageView extends StatefulWidget {
//   @override
//   _DialogPageViewState createState() => _DialogPageViewState();
// }
//
//
// class _DialogPageViewState extends State<DialogPageView> {
//   int _currentDialog = 0;
//   final TextStyle defaultTextStyle = TextStyle(
//     fontSize: 15,
//     fontWeight: FontWeight.normal,
//     color: Colors.black,
//   );
//   late List<Widget> _dialogList;
//   @override
//   void initState() {
//     super.initState();
//     _dialogList = [
//       _buildCustomDialog('Dialog 1'),
//       _buildCustomDialog('Dialog 2'),
//       _buildCustomDialog('Dialog 3'),
//       // 追加したいダイアログをここに列挙
//     ];
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//           child: Text('Open Dialog'),
//           onPressed: () {
//             _showDialog(context);
//           },
//         ),
//       ),
//     );
//   }
//   Widget _buildCustomDialog(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 8.0, top: 200.0, right: 8.0, bottom: 10.0),
//       child: Container(
//         width: 200,  // コンテナの幅を変更
//         height: 300,  // コンテナの高さを変更
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '2023/05/25 (月)',
//                     style: defaultTextStyle,
//                   ),
//                   Icon(Icons.add, color: Colors.blue),
//                 ],
//               ),
//               Divider(),
//               Row(
//                 children: [
//                   Container(
//                     width: 40,
//                     child: Column(
//                       children: [
//                         Text(
//                           '10:00',
//                           style: defaultTextStyle,
//                         ),
//                         Text(
//                           '11:00',
//                           style: defaultTextStyle,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     width: 4.0,
//                     height: 50.0,
//                     color: Colors.blue, // 縦棒の色
//                     margin: EdgeInsets.symmetric(horizontal: 10.0), // 縦棒の左右の余白
//                   ),
//                   Text(
//                     title.length > 14 ? title.substring(0, 11) + '...' : title,
//                     style: defaultTextStyle,
//                   ),
//                 ],
//               ),
//               Divider(),
//               Row(
//                 children: [
//                   Container(
//                     width: 40,
//                     child: Text(
//                       '終日',
//                       style: defaultTextStyle,
//                     ),
//                   ),
//                   Container(
//                     width: 4.0,
//                     height: 50.0,
//                     color: Colors.blue, // 縦棒の色
//                     margin: EdgeInsets.symmetric(horizontal: 10.0), // 縦棒の左右の余白
//                   ),
//                   Text(
//                     title.length > 14 ? title.substring(0, 11) + '...' : title,
//                     style: defaultTextStyle,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _showDialog(BuildContext context) {
//     final pageController = PageController(viewportFraction: 0.8);
//
//     showDialog(
//       context: context,
//       builder: (context) {
//         return PageView.builder(
//           controller: pageController,  // ここで controller を設定
//           onPageChanged: (value) {
//             setState(() {
//               _currentDialog = value;
//             });
//           },
//           itemCount: _dialogList.length,
//           itemBuilder: (context, index) {
//             return _dialogList[index];
//           },
//         );
//       },
//     );
//   }
// }

