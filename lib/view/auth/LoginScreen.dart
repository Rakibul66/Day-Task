import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../common/AppColors.dart';
import '../../common/AppFonts.dart';
import '../../common/AppImages.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../common/AppRoutes.dart';
import '../../viewmodel/LoginViewModel.dart';
class LoginScreen extends StatelessWidget {
  final LoginViewModel loginController = Get.put(LoginViewModel());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  void loginUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      // User's email is verified, allow login and navigate to home screen.
      Get.offNamed(AppRoutes.home);
    } else {
      // User's email is not verified, navigate to the VerificationScreen for verification.
      Get.offNamed(AppRoutes.Verify);
    }
  }

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
                'Welcome back!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 0.06.sw,
                  fontFamily: AppFonts.firma,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 0.03.sh),
              _buildTextField(label: 'Email Address',
                controller: emailController,
                icon: Icons.email,
                obscureText: false,),
              SizedBox(height: 0.02.sh),
              _buildTextField(
                  label: 'Password', icon: Icons.lock,controller: passwordController, obscureText: true),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Handle Forgot Password
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 0.035.sw,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 0.03.sh),
              ElevatedButton(
                onPressed: () {
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();
                  if (email.isNotEmpty && password.isNotEmpty) {
                    loginController.loginUser(email, password);
                  } else {
                    // Show an error message to the user if email or password is empty
                    Get.snackbar('Error', 'Please enter valid email and password');
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      AppColors.buttonColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.01.sw),
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.02.sh,horizontal: 0.14.sh),
                  child: Text(
                    'Log In',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 0.2.sw,
                    height: 0.005.sh,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.02.sw),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 0.035.sw,
                      ),
                    ),
                  ),
                  Container(
                    width: 0.2.sw,
                    height: 0.005.sh,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 0.03.sh),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(FontAwesomeIcons.google),
                  SizedBox(width: 30),
                  _buildSocialIcon(FontAwesomeIcons.facebook),
                ],
              ),
              SizedBox(height: 0.03.sh),
              TextButton(
                onPressed: () {
                  Get.offNamed(AppRoutes.signup);
                },
                child: Text(
                  'Don’t have an account? Sign Up',
                  style: TextStyle(
                    color: AppColors.buttonColor,
                    fontSize: 0.035.sw,
                    fontWeight: FontWeight.bold,
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
        fillColor: Colors.grey[700], // Change the color as needed
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.blueAccent), // Change the color as needed
        ),
      ),
    );
  }
}
Widget _buildSocialIcon(IconData icon) {
  return CircleAvatar(
    radius: 25,
    backgroundColor: AppColors.buttonColor,
    child: Icon(icon, color: Colors.black, size: 30),
  );
}
