import 'package:flutter/material.dart';
import 'package:quiz_app/utils/colors.dart';

class ForgotAppBar extends StatelessWidget {
  const ForgotAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints.expand(height: 60),
        decoration: const BoxDecoration(color: appBarColor),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                )),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Forgot Password',
              style: TextStyle(
                  fontFamily: 'Poppins', color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
