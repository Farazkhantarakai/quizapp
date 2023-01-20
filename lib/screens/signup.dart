import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quiz_app/providers/firebase_service.dart';
import 'package:quiz_app/screens/signin.dart';
import 'package:quiz_app/utils/colors.dart';
import 'package:quiz_app/utils/util.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  static const routName = 'SignUp';
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Uint8List? image;
  TextEditingController titleController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addresController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  bool isLoading = false;
  bool isClick = false;
  void pickImageFile() async {
    XFile? file = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (file != null) {
      Uint8List imageFile = await file.readAsBytes();

      setState(() {
        image = imageFile;
      });
    } else {
      if (kDebugMode) {
        print('image not picked because file is null');
      }
    }
  }

  void saveData() async {
    FirebaseService fs = FirebaseService();
    if (key.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        String result = await fs.signUpWithEmailAndPassword(
            context,
            nameController.text.toString(),
            titleController.text.toString(),
            passwordController.text.toString(),
            addresController.text.toString(),
            image!);

        if (result == 'success') {
          setState(() {
            isLoading = false;
          });
          showSnackBar(context, 'userRegistered Succefully');
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return SignIn();
          }), (route) => false);
        }
      } catch (err) {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, err.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: mobileBackgroundColor,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.white,
              ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Center(
                      child: Text(
                    'SignUp',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  )),
                  Stack(
                    children: [
                      image != null
                          ? CircleAvatar(
                              maxRadius: 50,
                              backgroundImage: MemoryImage(image!),
                            )
                          : CircleAvatar(
                              maxRadius: 50,
                              child: SizedBox(
                                  child: ClipOval(
                                child: Image.asset('assets/icons/user.png'),
                              )),
                            ),
                      Positioned(
                        bottom: 3,
                        right: -15,
                        child: IconButton(
                            onPressed: pickImageFile,
                            icon: const Icon(
                              Icons.photo_camera,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Form(
                        key: key,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextFormField(
                              controller: nameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: inputBorderDecoration(
                                  'Enter Your Name',
                                  const Icon(
                                    Icons.perm_identity,
                                    color: Colors.white,
                                  )),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'value can not empty';
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
                              style: const TextStyle(color: Colors.white),
                              controller: titleController,
                              decoration: inputBorderDecoration(
                                  'Enter Your Email',
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
                              style: const TextStyle(color: Colors.white),
                              obscureText: true,
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
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: addresController,
                              style: const TextStyle(color: Colors.white),
                              decoration: inputBorderDecoration(
                                  'Enter your Adress',
                                  const Icon(
                                    Icons.location_city,
                                    color: Colors.white,
                                  )),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'address cannot be empty';
                                }
                                if (value.length < 6) {
                                  return 'length should not be less than 6 characters';
                                }
                                return null;
                              },
                            ),
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: saveData,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          'SignUp',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text.rich(TextSpan(
                      text: 'Already have Account?',
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                            text: 'SignIn',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, SignIn.routName);
                              },
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold))
                      ]))
                ],
              ),
      ),
    );
  }
}
