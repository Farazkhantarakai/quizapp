import 'package:flutter/material.dart';
import 'package:quiz_app/utils/colors.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 60,
      backgroundColor: appBarColor,
    );
  }
}
