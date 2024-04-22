import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/ProfileScreen/profile_screen.dart';
import 'package:olx_clone/SearchProduct/search_product.dart';
import 'package:olx_clone/UploadAddScreen/upload_add_screen.dart';
import 'package:olx_clone/WelcomeScreen/welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal,
      ),
      child: Scaffold(
        backgroundColor: Colors.teal,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SearchProduct()));
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            )
          ],
          backgroundColor: Colors.purple,
          title: const Text(
            'Home Screen',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                decorationThickness: 4.0),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add Post',
          child: Icon(
            Icons.cloud_upload,
            color: Colors.green,
          ),
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => UploadAddScreen()));
          },
        ),
      ),
    );
  }
}

// leading: GestureDetector(
// onTap: () {
// FirebaseAuth.instance.signOut();
// Navigator.pushReplacement(context,
// MaterialPageRoute(builder: (context) => LoginScreen()));
// },
// child: const Icon(
// Icons.logout,
// ),
// ),
