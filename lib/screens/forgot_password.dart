import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/utils/colors.dart';
import 'package:quiz_app/utils/util.dart';

import 'package:quiz_app/widgets/forgot_appbar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  static const rout = 'forgotpassword';

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController emailController = TextEditingController();

  void resetAccount() async {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    if (formKey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          });
      try {
        await _firebaseAuth.sendPasswordResetEmail(
            email: emailController.text.toString());
        showSnackBar(context, 'email sent succefully');
        Navigator.pop(context);
      } on FirebaseAuthException catch (erro) {
        Navigator.pop(context);
        showSnackBar(context, erro.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: mobileBackgroundColor,
        body: Column(
          children: [
            const ForgotAppBar(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              constraints: const BoxConstraints(
                  maxHeight: double.infinity, maxWidth: double.infinity),
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputBorderDecoration('enter your email'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'field cannot be empty';
                        }
                        if (!value.endsWith('@gmail.com')) {
                          return 'please enter @gmail.com';
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: resetAccount,
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      constraints: const BoxConstraints.expand(
                          width: double.infinity, height: 60),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: const Center(
                        child: Text(
                          'Reset',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
