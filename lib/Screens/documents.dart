import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:vidg/pages/image_page.dart';
import 'package:vidg/Screens/uploadfiles.dart';
import 'package:vidg/api/firebase_api.dart';
import 'package:vidg/model/firebase_file.dart';

class DocumentSection extends StatefulWidget {
  const DocumentSection({Key key}) : super(key: key);

  @override
  State<DocumentSection> createState() => _DocumentSectionState();
}

class _DocumentSectionState extends State<DocumentSection> {
  Future<List<FirebaseFile>> futureFiles;
  @override
  void initState() {
    super.initState();

    futureFiles = FirebaseApi.listAll('files/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffff2d55),
        title: Text('Uploaded Documents'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Uploadfiles()));
        },
        child: const Icon(Icons.add),
        backgroundColor: Color(0xffff2d55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: FutureBuilder<List<FirebaseFile>>(
        future: futureFiles,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text('Some error occurred'),
                );
              } else {
                final files = snapshot.data;

                return Column(
                  children: [
                    buildHeader(files.length),
                    Expanded(
                        child: ListView.builder(
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        final file = files[index];

                        return buildFile(context, file);
                      },
                      shrinkWrap: true,
                    ))
                  ],
                );
              }
          }
        },
      ),
    );
  }

  Widget buildFile(BuildContext context, FirebaseFile file) => Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: ListTile(
          title: Text(
            file.name,
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blue),
          ),
          trailing: IconButton(
              onPressed: () async {
                await FirebaseApi.downloadFile(file.ref);

                final snackBar =
                    SnackBar(content: Text('Downloaded ${file.name}'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: Icon(Icons.file_download, color: Color(0xffff2d55))),
        ),
      );

  Widget buildHeader(int length) => ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 16),
        tileColor: Color(0xffff2d55),
        leading: Container(
          width: 52,
          height: 20,
          child: Icon(
            Icons.file_copy,
            color: Colors.white,
          ),
        ),
        title: Text(
          '$length Files',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );
}
