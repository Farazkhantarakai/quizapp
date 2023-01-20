import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app/resources/auth_method.dart';
import 'package:quiz_app/utils/util.dart';
import '../models/user_model.dart' as model;

class FirebaseService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  int quizCount = 0;
  int getQuiz = 0;
  bool isLoading = true;
  int get getQuizCount => getQuiz;
  Future<String> signUpWithEmailAndPassword(BuildContext context, name, email,
      password, address, Uint8List image) async {
    String err = 'Something went wrong';
    if (kDebugMode) {
      print(image);
    }
    try {
      if (email != null ||
          password != null ||
          address != null ||
          image != null) {
        UserCredential user = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        String imageUrl = await AuthMethod().StoreMessage(
          'profilePic',
          image,
        );
        model.User userModel = model.User(
            name: name, email: email, address: address, image: imageUrl);
        firebaseFirestore
            .collection('user')
            .doc(user.user!.uid)
            .set(userModel.toMap());
        err = 'success';
      } else {
        showSnackBar(context, 'a field or fields is null');
      }
    } on FirebaseAuthException catch (err) {
      showSnackBar(context, err.toString());
    } catch (err) {
      showSnackBar(context, err.toString());
    }
    return err;
  }

  Future<String> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    log('$email and $password ');
    String err = 'Something went wrong';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        showSnackBar(context, "Log In Succefull");
        err = 'success';
      }
    } on FirebaseAuthException catch (err) {
      showSnackBar(context, err.toString());
    } catch (err) {
      showSnackBar(context, err.toString());
    }
    return err;
  }

  Future<String> getUserImage() async {
    DocumentSnapshot<Map<String, dynamic>> data = await firebaseFirestore
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    return data.data()!['image'];
  }

  Future<void> countUserQuizAndStore(double result, int win) async {
    quizCount++;
    firebaseFirestore
        .collection('quizCount')
        .doc(firebaseAuth.currentUser!.uid)
        .update({'count': quizCount, 'wins': win});
  }

  Future<DocumentSnapshot<Map<String, dynamic>>>
      getQuestionCountAndRank() async {
    var data;
    try {
      data = await firebaseFirestore
          .collection('quizCount')
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      // return data;
    } catch (err) {
      rethrow;
    }
    return data;
  }

  getCounter() async {
    // int count = 0;
    // DocumentSnapshot<Map<String, dynamic>> data = await firebaseFirestore
    //     .collection('quizCount')
    //     .doc(firebaseAuth.currentUser!.uid)
    //     .get();
    // count = data.data()!['count'];
    // print(count);
    // return count;
  }

  logOut() async {
    await firebaseAuth.signOut();
  }
}
