import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lev_mobile/styling/colors.dart';

Widget simpleCard(String title, String value) {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(value, style: TextStyle(fontSize: 28, color: AppColors.primary, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(title, style: TextStyle(fontSize: 15, color: AppColors.primaryLess2), textAlign: TextAlign.center,),
      ],
    ),
  );
}

String reverseDate(String date) {
  initializeDateFormatting();
  return DateFormat('dd MMM yyyy hh:mm', 'fr')
      .format(DateTime.tryParse(date) ?? DateTime.now());
}