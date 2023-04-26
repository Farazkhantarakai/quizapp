import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:quiz_app/models/score.dart';
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
  late int rank = 0;
  int getRank() => rank;

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
        String imageUrl = await AuthMethod().storeMessage(
          'profilePic',
          image,
        );
        model.User userModel = model.User(
          name: name,
          email: email,
          address: address,
          image: imageUrl,
        );
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
    // log('$email and $password ');
    String err = 'Something went wrong';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        // ignore: use_build_context_synchronously
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

  getUserImage() async {
    DocumentSnapshot<Map<String, dynamic>> data = await firebaseFirestore
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    return data.data()!['image'];
  }

  // getQuestionCountAndRank() async {
  //   QuerySnapshot<Map<String, dynamic>> snapshot =
  //       await firebaseFirestore.collection('score').get();

  //   Map<String, int> score = {};
  //   snapshot.docs.forEach((element) {
  //     debugPrint(element.data()['score']);
  //   });
  // }

  Future<String> getAllQuizes() async {
    QuerySnapshot<Map<String, dynamic>> allData = await firebaseFirestore
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('quiz')
        .get();
    getQuiz = allData.docs.length;
    debugPrint(getQuiz.toString());
    return getQuiz.toString();
  }

  addQuiz(int count) async {
    count = count + 1;

    await firebaseFirestore
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('quiz')
        .doc()
        .set({
      "quizes": FieldValue.arrayUnion(['quiz $count  '])
    });
  }

// this will add score
  addScore(int iscore) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await firebaseFirestore
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    String name = snapshot.data()!['name'];
    String email = snapshot.data()!['email'];

    debugPrint(name);
    debugPrint(email);

    Score scoreInstance = Score(
        userId: firebaseAuth.currentUser!.uid,
        userEmail: email,
        userName: name,
        score: iscore);

    await firebaseFirestore
        .collection('score')
        .doc(firebaseAuth.currentUser!.uid)
        .set({
      "score": FieldValue.arrayUnion([scoreInstance.toMap()])
    });
  }

  Future<int> getScoreDocs() async {
    // this will get all the documents
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firebaseFirestore.collection('score').get();
    Map<String, int> userScore = {};
    int sum = 0;
    snapshot.docs.forEach((doc) {
      doc.data()['score'].forEach((innerDoc) {
        sum = sum + int.parse(innerDoc['score'].toString());
        String userId = innerDoc['userId'];
        if (kDebugMode) {
          print('$userId  $sum');
        }
        userScore[userId] = sum;
      });
    });
    List<MapEntry<String, int>> sortedEntries = userScore.entries.toList()
      ..sort((a, b) {
        return b.value.compareTo(a.value);
      });

    Map<String, int> sortedMap = Map.fromEntries(sortedEntries);
    // this will return the
    int index = sortedEntries
        .indexWhere((entry) => entry.key == firebaseAuth.currentUser!.uid);

    if (kDebugMode) {
      print('index here ${index + 1}');
    }
    rank = index;
    if (kDebugMode) {
      print(rank);
    }
    return rank;
  }
// be remember how to get collectionReference and querysnapshot from firebase firestore
//  this will give us collectionReference
// final collectionReference= firebaseFirestore.collection('user');
// this will give us collection snapshot for each
// QuerySnapshot<Map<String,dynamic>>  querySnapshot=firebaseFirestore.collection('user').get();
// this will give us document data for each item
// DocumentSnapshot<Map<String,dynamic>>  documentSnapshot=firebaseFiresotre.collection('user').get();

  logOut() async {
    await firebaseAuth.signOut();
  }
}
