import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/DialogBox/error_dialog.dart';
import 'package:olx_clone/ForgetPassword/background.dart';
import 'package:olx_clone/LoginScreen/login_screen.dart';

class ForgetBody extends StatefulWidget {
  const ForgetBody({super.key});

  @override
  State<ForgetBody> createState() => _ForgetBodyState();
}

class _ForgetBodyState extends State<ForgetBody> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _forgetPassTextController =
      TextEditingController(text: '');

  void _forgetPassSubmitForm() async {
    try {
      await _auth.sendPasswordResetEmail(
        email: _forgetPassTextController.text,
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } catch (error) {
      ErrorAlertDialog(
        message: error.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ForgetBackground(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: ListView(
              children: [
                SizedBox(
                  height: size.height * 0.2,
                ),
                const Text(
                  'Forget Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 56,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Enter Email address to Reset ',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _forgetPassTextController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black38,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(
                          20.0), // Set the border radius here
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(
                          20.0), // Set the border radius here
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () {
                    _forgetPassSubmitForm();
                  },
                  color: Colors.black,
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Reset Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
