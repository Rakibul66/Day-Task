import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/AppColors.dart';
import '../../common/AppFonts.dart';
import '../../common/AppRoutes.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool isEmailVerified = false;
  bool isButtonEnabled = true;
  bool isNavigated = false; // Flag to track if user has been navigated to home screen

  @override
  void initState() {
    super.initState();
    checkEmailVerificationStatus();
  }

  Future<void> checkEmailVerificationStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      setState(() {
        isEmailVerified = user.emailVerified;
        if (isEmailVerified && !isNavigated) {
          // If email is verified and not already navigated, navigate to home screen
          isButtonEnabled = false; // Disable the button
          isNavigated = true; // Set the flag to true to avoid multiple navigations
          Get.offNamed(AppRoutes.home); // Navigate to home screen after verification
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text('Email Verification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Verify your email',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white70
              ),
            ),
            ElevatedButton(
              onPressed: isButtonEnabled
                  ? () async {
                await checkEmailVerificationStatus();
                if (!isNavigated) {
                  Get.snackbar('Error', 'Email not verified yet.');
                }
              }
                  : null,
              child: Text(isNavigated ? 'Open App Again' : 'Verify'),
              style: ElevatedButton.styleFrom(
                primary: isNavigated ? Colors.green : Colors.grey,
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



