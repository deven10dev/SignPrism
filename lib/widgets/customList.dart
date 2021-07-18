import 'package:flutter/material.dart';

Widget CustomList({required String title, required String cover}) {
  return Container(
    padding: EdgeInsets.all(10),
    child: Row(
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.black,
            fontSize: 50,
            fontWeight: FontWeight.bold,
            fontFamily: 'Yomogi',
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(
                cover,
              ),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    ),
  );
}
