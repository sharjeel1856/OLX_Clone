import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_clone/Widgets/global_varibale.dart';
import 'package:path/path.dart' as Path;

class UploadAddScreen extends StatefulWidget {
  const UploadAddScreen({Key? key}) : super(key: key);

  @override
  State<UploadAddScreen> createState() => _UploadAddScreenState();
}

class _UploadAddScreenState extends State<UploadAddScreen> {
  bool uploading = false, next = false;

  final List<File> _image = [];

  List<String> urlList = [];

  String name = '';
  String phoneNo = '';

  double val = 0;

  CollectionReference? imgRef;

  String itemPrice = '';
  String itemModel = '';
  String itemColor = '';
  String description = '';
  //User choose image for gallery to show add on the screen
  chooseImage() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
  }

  Future uploadFile() async {
    int i = 1;
    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      var ref = FirebaseStorage.instance
          .ref()
          .child('image/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          urlList.add(value);
          i++;
        });
      });
    }
  }

  getNameOfUser() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          name = snapshot.data()!['userName'];
          phoneNo = snapshot.data()!['userNumber'];
        });
      }
    });

    @override
    void initState() {
      //TODO : implement initState
      super.initState();
      // getNameOfUser();
      imgRef = FirebaseFirestore.instance.collection('imageUrls');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.green,
      ),
      child: Scaffold(
        backgroundColor: Colors.teal,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
          ),
          title: Text(
            next ? 'Please write Items Info' : 'Choose Item Images',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              decorationThickness: 4.0,
            ),
          ),
          actions: [
            next
                ? Container()
                : ElevatedButton(
                    onPressed: () {
                      // Agher user na 5 images select kee tab next process ho ga
                      if (_image.length == 5) {
                        setState(() {
                          uploading = true;
                          next = true;
                        });
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Please select 5 images only',
                          gravity: ToastGravity.CENTER,
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor:
                              Colors.green, // Set the background color here
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(fontSize: 19, color: Colors.white),
                    ),
                  )
          ],
        ),
        body: next
            ? SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 5.0,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                            hintText: 'Enter Item Price',
                            hintStyle: TextStyle(color: Colors.white)),
                        onChanged: (value) {
                          itemPrice = value;
                        },
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                            hintText: 'Enter Item Name',
                            hintStyle: TextStyle(color: Colors.white)),
                        onChanged: (value) {
                          itemModel = value;
                        },
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                            hintText: 'Enter Item Color',
                            hintStyle: TextStyle(color: Colors.white)),
                        onChanged: (value) {
                          itemColor = value;
                        },
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                            hintText: 'Write some items description',
                            hintStyle: TextStyle(color: Colors.white)),
                        onChanged: (value) {
                          description = value;
                        },
                      )
                    ],
                  ),
                ),
              )
            : Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: GridView.builder(
                      itemCount: _image.length + 1,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) {
                        return index == 0
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        !uploading ? chooseImage() : null;
                                      },
                                    ),
                                    const Text(
                                      'Select image',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        decorationThickness: 4.0,
                                      ), // Set text color here
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(_image[index - 1]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                  uploading
                      ? Center(
                          child: Column(
                            children: [
                              const Text(
                                'Uploading....',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CircularProgressIndicator(
                                value: val,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.green),
                              )
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
      ),
    );
  }
}
