import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthMethod {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<String> StoreMessage(String s, Uint8List image) async {
    Reference store =
        _firebaseStorage.ref(s).child(_firebaseAuth.currentUser!.uid);
    UploadTask uploadTask = store.putData(image);
    TaskSnapshot task = await uploadTask;
    String downloadUrl = await task.ref.getDownloadURL();
    return downloadUrl;
  }
}
