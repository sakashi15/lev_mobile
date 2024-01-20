import 'package:flutter/material.dart';
import 'package:lev_mobile/styling/colors.dart';

Widget simpleCard(String title, String value) {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(value, style: TextStyle(fontSize: 28, color: AppColors.primary, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(title, style: TextStyle(fontSize: 15, color: AppColors.primaryLess2)),
      ],
    ),
  );
}

String reverseDate(String date) {
  return date.split("-").reversed.join("-");
}