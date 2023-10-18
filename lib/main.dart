
import 'package:deveflutter/provider/task_priority_provider.dart';
import 'package:deveflutter/provider/task_provider.dart';
import 'package:deveflutter/view/auth/LoginScreen.dart';
import 'package:deveflutter/view/auth/SignUpScreen.dart';
import 'package:deveflutter/view/auth/VerificationScreen.dart';
import 'package:deveflutter/view/home/HomeScreen.dart';
import 'package:deveflutter/view/home/SplashScreen.dart';
import 'package:deveflutter/view/profile/ProfileScreen.dart';
import 'package:deveflutter/view/task/TaskScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:provider/provider.dart';
import 'common/AppRoutes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider(FirebaseDatabase.instance.reference().child('tasks'))),
        ChangeNotifierProvider(create: (_) => TaskPriorityProvider()),

      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Taskify',
        initialRoute: AppRoutes.splash,
        getPages: [
          GetPage(
            name: AppRoutes.splash,
            page: () => SplashScreen(),
          ),
          GetPage(
            name: AppRoutes.login,
            page: () => LoginScreen(),
          ),
          GetPage(
            name: AppRoutes.home,
            page: () => HomeScreen(),
          ),
          GetPage(
            name: AppRoutes.signup,
            page: () => SignUpScreen(),
          ),
          GetPage(
            name: AppRoutes.taskCreation,
            page: () => TaskScreen(),
          ),
          GetPage(
            name: AppRoutes.Profile,
            page: () => ProfileScreen(),
          ),
          GetPage(
            name: AppRoutes.Verify,
            page: () => VerificationScreen(),
          ),
        ],
      ),
    );
  }
}