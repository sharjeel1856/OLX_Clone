import 'package:flutter/material.dart';

class TextFeildContainer extends StatelessWidget {
  final Widget child;
  TextFeildContainer({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
