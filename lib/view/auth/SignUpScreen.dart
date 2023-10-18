import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../common/AppColors.dart';
import '../../common/AppFonts.dart';
import '../../common/AppImages.dart';
import '../../common/AppRoutes.dart';
import '../../viewmodel/RegistrationViewModel.dart';
import 'VerificationScreen.dart';

class SignUpScreen extends StatelessWidget {
  final RegistrationViewModel registrationController =
      Get.put(RegistrationViewModel());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.logo,
                width: 0.3.sw,
                height: 0.3.sw,
              ),
              SizedBox(height: 0.05.sh),
              Text(
                'Create your account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 0.06.sw,
                  fontFamily: AppFonts.firma,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 0.03.sh),
              _buildTextField(
                  label: 'Full Name',
                  controller: nameController,
                  icon: Icons.person,
                  obscureText: false),
              SizedBox(height: 0.02.sh),
              _buildTextField(
                  label: 'Email Address',
                  controller: emailController,
                  icon: Icons.email,
                  obscureText: false),
              SizedBox(height: 0.02.sh),
              _buildTextField(
                  label: 'Password',
                  controller: passwordController,
                  icon: Icons.lock,
                  obscureText: true),
              SizedBox(height: 0.03.sh),
              ElevatedButton(
                onPressed: () async {
                  String name = nameController.text.trim();
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();
                  if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
                    try {
                      UserCredential userCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );

                      // Send email verification
                      await userCredential.user!.sendEmailVerification();

                      Get.snackbar(
                        'Success',
                        'A verification email has been sent to your email address. Please verify your email before logging in.',
                      );

                      Get.offNamed(AppRoutes.Verify);
                    } catch (e) {
                      print("Error: $e");
                      Get.snackbar('Error', 'Error occurred while registering.');
                    }
                  } else {
                    Get.snackbar('Error', 'Please fill out all fields');
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppColors.buttonColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.01.sw),
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.02.sh),
                  child: Text(
                    'Register Now',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 0.04.sw,
                      fontFamily: AppFonts.firma,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 0.03.sh),
              TextButton(
                onPressed: () {
                  Get.offNamed(AppRoutes.login);
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 0.035.sw,
                    ),
                    children: [
                      TextSpan(
                        text: 'Log In',
                        style: TextStyle(
                          color: AppColors.buttonColor,
                          fontSize: 0.035.sw,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool obscureText,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: AppColors.textFieldColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: AppColors.buttonColor),
        ),
      ),
    );
  }
}
