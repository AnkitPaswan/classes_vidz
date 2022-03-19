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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(files.length),
                    SizedBox(
                      height: 12,
                    ),
                    Expanded(
                        child: GridView.builder(
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        final file = files[index];

                        return buildFile(context, file);
                      },
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20
                          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //   crossAxisCount: 2,
                          //   crossAxisSpacing: 5.0,
                          //   mainAxisSpacing: 5.0,
                          ),
                    ))
                  ],
                );
              }
          }
        },
      ),
    );
  }

  Widget buildFile(BuildContext context, FirebaseFile file) => GridView(
    physics: NeverScrollableScrollPhysics(),
        children: [
          InkWell(
            onTap: (() {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ImagePage(file: file)));
            }),
            child: Column(
              children: [
                Expanded(
                  child: Image.network(
                    file.url,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    file.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w300, color: Colors.blue),
                  ),
                )
              ],
            ),
          )
        ],
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
      );

  Widget buildHeader(int length) => ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 16),
        tileColor: Color(0xffff2d55),
        leading: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
            width: 70,
            height: 60,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Icon(
                Icons.file_copy,
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            '$length Files',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      );
}
