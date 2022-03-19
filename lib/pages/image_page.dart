// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:vidg/api/firebase_api.dart';

// import 'package:vidg/model/firebase_file.dart';

// class ImagePage extends StatelessWidget {
//   final FirebaseFile file;
//   const ImagePage({
//     Key key,
//     this.file,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(file.name),
//          backgroundColor: Color(0xffff2d55),
//         centerTitle: true,
//         actions: [
//           IconButton(
//               onPressed: () async {
//                 await FirebaseApi.downloadFile(file.ref);

//                 final snackBar =
//                     SnackBar(content: Text('Downloaded ${file.name}'));
//                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
//               },
//               icon: Icon(Icons.file_download)),
//           SizedBox(
//             width: 12,
//           )
//         ],
//       ),
//       body: Image.network(
//         file.url,
//         // height: double.infinity,
//         fit: BoxFit.cover,
//       ),
//     );
//   }
// }
