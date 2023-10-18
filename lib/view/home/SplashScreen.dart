import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../common/AppFonts.dart';
import '../../common/AppRoutes.dart';
import '../../common/AppColors.dart'; // Import your common app color file
import '../../common/AppImages.dart'; // Import your common image path file

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadSplash();
  }

  _loadSplash() async {
    await Future.delayed(Duration(seconds: 3)); // Delay for 3 seconds
    // Check if the user is already logged in
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // User is logged in, navigate to the home screen
        Get.offNamed(AppRoutes.home);
      } else {
        // User is not logged in, navigate to the login screen
        Get.offNamed(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0.05.sw),
              child: Image.asset(
                AppImages.logo,
                width: 0.2.sw,
                height: 0.2.sw,
              ),
            ),
            SizedBox(height: 0.02.sh),
            Image.asset(
              AppImages.pana,
              width: 0.3.sw,
              height: 0.3.sw,
            ),
            SizedBox(height: 0.02.sh),
            Text(
              'Manage your tasks with',
              style: TextStyle(
                color: Colors.white,
                fontSize: 0.04.sw,
                fontFamily: AppFonts.firma,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 0.015.sh),
            Text(
              'DayTask',
              style: TextStyle(
                color: AppColors.buttonColor,
                fontSize: 0.05.sw,
                fontFamily: AppFonts.firma,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 0.04.sh),

          ],
        ),
      ),
    );
  }
}
