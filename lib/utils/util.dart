import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/utils/colors.dart';

inputBorderDecoration(String hintText, [icon]) {
  return InputDecoration(
      suffixIcon: icon,
      labelStyle: const TextStyle(color: Colors.white),
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white, width: 2)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white, width: 2)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white, width: 2)));
}

showToast(String message) {
  return Fluttertoast.showToast(msg: message, backgroundColor: appBarColor);
}

showSnackBar(BuildContext context, String message) {
  SnackBar snackBar = SnackBar(
    content: Text(message),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
