import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Screen',
          style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              decorationThickness: 4.0),
        ),
      ),
    );
  }
}
