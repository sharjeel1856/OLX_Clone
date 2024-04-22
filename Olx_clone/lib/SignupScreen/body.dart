// import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_clone/DialogBox/error_dialog.dart';
import 'package:olx_clone/ForgetPassword/forget_password.dart';
import 'package:olx_clone/HomeScreen/home_screen.dart';
import 'package:olx_clone/LoginScreen/login_screen.dart';
import 'package:olx_clone/SignupScreen/background.dart';
import 'package:olx_clone/Widgets/already_have_an_account_check.dart';
import 'package:olx_clone/Widgets/global_varibale.dart';
import 'package:olx_clone/Widgets/rounded_button.dart';
import 'package:olx_clone/Widgets/rounded_password_feild.dart';
import 'package:olx_clone/Widgets/rounede_input_feild.dart';

class SignupBody extends StatefulWidget {
  @override
  State<SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {
  String userPhotoUrl = '';

  File? _image;
  bool _isLoading = false;
  final signUPFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  //picking image from the camera

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _getFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!
        .path); //Picked the image and then crop according to the Given Height
    Navigator.pop(context);
  }

  //Pick image from Gallery
  void _getFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!
        .path); //Picked the image and then crop according to the Given Height
    Navigator.pop(context);
  }

  //Croping the image
  void _cropImage(filePath) async {
    CroppedFile? croppedImage = await ImageCropper()
        .cropImage(sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);

    if (croppedImage != null) {
      setState(() {
        _image = File(croppedImage.path);
      });
    }
  }

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select Image From'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/icons/camera.png',
                            height: 60,
                            width: 60,
                          ),
                          Text('Camera')
                        ],
                      ),
                    ),
                  ),
                  // child: const Row(
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.all(4.0),
                  //       // child: Icon(
                  //       //   Icons.camera,
                  //       //   color: Colors.purple,
                  //       // ),
                  //       child: Image.asset(
                  //         'assets/icons/camera.png',
                  //         width: 24,
                  //         height: 24,
                  //       ),
                  //     ),
                  //     Text(
                  //       'Camera',
                  //       style: TextStyle(color: Colors.purple),
                  //     )
                  //   ],
                  // ),
                ),
                InkWell(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/icons/gallery.png',
                            height: 60,
                            width: 60,
                          ),
                          Text('Gallery')
                        ],
                      ),
                    ),
                  ),

                  // child: const Row(
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.all(4.0),
                  //       child: Icon(
                  //         Icons.image,
                  //         color: Colors.purple,
                  //       ),
                  //     ),
                  //     Text(
                  //       'Gallery',
                  //       style: TextStyle(color: Colors.purple),
                  //     )
                  //   ],
                  // ),
                )
              ],
            ),
          );
        });
  }

  void submitFormOnSignup() async {
    final isValid = signUPFormKey.currentState!.validate();
    {
      final isValid = signUPFormKey.currentState!.validate();
      if (_image == null) {
        showDialog(
            context: context,
            builder: (context) {
              return const ErrorAlertDialog(
                message: 'Please pick an image ',
              );
            });
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        //connect with firebase and pick image and upload image on it
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text.trim(),
        );
        final User? user = _auth.currentUser;
        uid = user!.uid;

        //specific user who will signup it data will be uploaded into firebase Firestore along with
        // name , email , phonenumber , image etc
        final ref = FirebaseStorage.instance
            .ref()
            .child('userImage')
            .child(uid + '.jpg');
        await ref.putFile(_image!);
        userPhotoUrl = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection('user').doc(uid).set({
          //In this line a folder is create in firebase Storage named as 'User' where a Image is stored .
          'userName': _nameController.text.trim(),
          'id': uid,
          'userNumber': _phoneController.text.trim(),
          'userEmail': _emailController.text.trim(),
          'userImage': userPhotoUrl,
          'time': DateTime.now(),
          'status': 'approved',
        });
        // backend functionality of user signup

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        ErrorAlertDialog(
          message: error.toString(),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;
    return SignupBackground(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: signUPFormKey,
          child: InkWell(
            onTap: () {
              _showImageDialog();
            },
            child: CircleAvatar(
              radius: screenWidth * 0.20,
              backgroundColor: Colors.white24,
              backgroundImage: _image == null ? null : FileImage(_image!),
              child: _image == null
                  ? Icon(
                      Icons.camera_enhance,
                      size: screenWidth * 0.18,
                      color: Colors.black54,
                    )
                  : null,
            ),
          ),
        ),
        SizedBox(
          height: screenHeight * 0.02,
        ),
        RoundedInputFeild(
          hintText: 'Name',
          icon: Icons.person,
          onChanged: (value) {
            _nameController.text = value;
          },
        ),
        RoundedInputFeild(
          hintText: 'Email',
          icon: Icons.email,
          onChanged: (value) {
            _emailController.text = value;
          },
        ),
        RoundedInputFeild(
          hintText: 'Phone Number',
          icon: Icons.phone,
          onChanged: (value) {
            _phoneController.text = value;
          },
        ),
        RoundedPasswordField(
          onChanged: (value) {
            _passwordController.text = value;
          },
        ),
        const SizedBox(
          height: 5,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ForgetPassword()));
            },
            child: const Center(
              child: Text(
                'Forget Password?',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  decorationThickness: 4.0,
                ),
              ),
            ),
          ),
        ),
        _isLoading
            ? Center(
                child: Container(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(),
                ),
              )
            : RoundedButton(
                text: 'SIGNUP',
                press: () {
                  submitFormOnSignup();
                }),
        SizedBox(
          height: screenHeight * 0.03,
        ),
        AlreadyHaveANAccountCheck(
          login: false,
          press: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        )
      ],
    ));
  }
}
// color: Colors.black54,
// fontSize: 15,
// fontWeight: FontWeight.bold,
// fontStyle: FontStyle.normal,
// decorationThickness: 4.0),
