import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/providers/firebase_service.dart';
import 'package:quiz_app/resources/shared.dart';
import 'package:quiz_app/screens/forgot_password.dart';
import 'package:quiz_app/screens/home_screen.dart';
import 'package:quiz_app/screens/signup.dart';
import 'package:quiz_app/utils/colors.dart';
import 'package:quiz_app/utils/util.dart';
import 'package:quiz_app/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  static const routName = 'SignIn';

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isRememberMe = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  bool isLoading = false;
  bool isClick = false;

  @override
  void initState() {
    super.initState();
    getPrefsData();
  }

  getPrefsData() async {
    SharedPreferences spf = await SharedPreferences.getInstance();
    var isRemember = spf.getBool('isRemember');
    if (isRemember == true) {
      var email = spf.get('email');
      var password = spf.get('password');

      titleController.text = email.toString();
      passwordController.text = password.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: mobileBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Center(
                        child: Text(
                      'SignIn',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Form(
                          key: key,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextFormField(
                                controller: titleController,
                                style: const TextStyle(color: Colors.white),
                                decoration: inputBorderDecoration(
                                    'enter your email',
                                    const Icon(
                                      Icons.email,
                                      color: Colors.white,
                                    )),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'value can not empty';
                                  }
                                  if (!value.endsWith('@gmail.com')) {
                                    return 'please enter a valid email';
                                  }
                                  if (value.length < 6) {
                                    return 'email length should be greater than 6';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: passwordController,
                                obscureText: isClick ? false : true,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isClick = !isClick;
                                          });
                                        },
                                        icon: Icon(
                                          isClick
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.white,
                                        )),
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    hintText: 'enter your password',
                                    hintStyle:
                                        const TextStyle(color: Colors.white),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 2)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 2))),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'password cannot be empty';
                                  }
                                  if (value.length < 6) {
                                    return 'length should not be less than 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Checkbox(
                                      value: isRememberMe,
                                      side:
                                          const BorderSide(color: Colors.white),
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                      onChanged: (value) {
                                        setState(() {
                                          setState(() {
                                            isRememberMe = value!;
                                          });
                                        });
                                      }),
                                  const Text(
                                    'Remember Me',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, ForgotPassword.rout);
                                    },
                                    child: const Text(
                                      'Forgot Password',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                    GestureDetector(
                        onTap: () async {
                          if (key.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              String result = await FirebaseService()
                                  .signInWithEmailAndPassword(
                                      context,
                                      titleController.text.toString(),
                                      passwordController.text.toString());
                              Shared().saveUserCredentials(
                                  titleController.text.toString(),
                                  passwordController.text.toString(),
                                  isRememberMe);
                              if (kDebugMode) {
                                print(result);
                              }
                              setState(() {
                                isLoading = false;
                              });
                              if (result == 'success') {
                                if (kDebugMode) {
                                  print('i am inside signin');
                                }
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (context) {
                                  return HomeScreen();
                                }), (route) => false);
                              }
                            } catch (err) {
                              setState(() {
                                isLoading = false;
                              });
                              showSnackBar(context, err.toString());
                            }
                          }
                        },
                        child: const CustomButton()),
                    const SizedBox(
                      height: 15,
                    ),
                    Text.rich(TextSpan(
                        text: 'Donot have Account?',
                        style: const TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                              text: 'SignUp',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, SignUp.routName);
                                },
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))
                        ]))
                  ],
                ),
        ),
      ),
    );
  }
}
