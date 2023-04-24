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
            quizes: []);
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

  Future<DocumentSnapshot<Map<String, dynamic>>>
      getQuestionCountAndRank() async {
    var data;
    try {
      // data = await firebaseFirestore
      //     .collection('quizCount')
      //     .doc(firebaseAuth.currentUser!.uid)
      //     .get();
      // return data;
    } catch (err) {
      rethrow;
    }
    return data;
  }

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
        .collection('user')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('scores')
        .doc()
        .set({
      "score": FieldValue.arrayUnion([scoreInstance.toMap()])
    });
  }

  logOut() async {
    await firebaseAuth.signOut();
  }
}
