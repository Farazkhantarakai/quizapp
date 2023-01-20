import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  saveUserCredentials(email, password, isRemember) async {
    SharedPreferences spf = await SharedPreferences.getInstance();
    if (isRemember) {
      spf.setString('email', email);
      spf.setString('password', password);
      spf.setBool('isRemember', isRemember);
    }
  }
}
