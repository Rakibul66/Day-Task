import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../common/AppRoutes.dart';

class RegistrationViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offNamed(AppRoutes.login);
    } catch (e) {
      // Handle registration errors (e.g., weak password, email already in use)
      print("Error: $e");
    }
  }
}
