import 'package:bon_voyage/constants.dart';
import 'package:bon_voyage/widgets/customList.dart';
import 'package:flutter/material.dart';

class ASLScreen extends StatefulWidget {
  static const String id = "asl_screen";

  @override
  State<ASLScreen> createState() => _ASLScreenState();
}

class _ASLScreenState extends State<ASLScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade300, Colors.white]),
      ),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          for (var i = 0; i < 26; i++)
            CustomList(
              title: Alphabets[i]['title'],
              cover: Alphabets[i]['coverUrl'],
            )
        ],
      ),
    );
  }
}
