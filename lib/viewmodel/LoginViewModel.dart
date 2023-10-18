import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../common/AppRoutes.dart';

class LoginViewModel extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
       Get.offNamed(AppRoutes.home);
    } catch (e) {
      // Handle login errors (e.g., wrong password, user not found)
      print("Error: $e");
    }
  }
}
