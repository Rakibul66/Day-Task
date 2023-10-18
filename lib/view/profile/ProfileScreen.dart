import 'package:deveflutter/common/AppImages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../common/AppColors.dart';
import '../../common/AppRoutes.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              Get.offNamed(AppRoutes.login);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: _currentUser.photoURL != null
                  ? NetworkImage(_currentUser.photoURL!)
                  : AssetImage(AppImages.pana) as ImageProvider<Object>,
            ),


            SizedBox(height: 20),
            Text(
              'Name: ${_currentUser.displayName}',
              style: TextStyle(fontSize: 18,color: Colors.white70),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${_currentUser.email}',
              style: TextStyle(fontSize: 18,color: Colors.white70),
            ),
            SizedBox(height: 10),
            Text(
              'Phone Number: ${_currentUser.phoneNumber ?? 'N/A'}',
              style: TextStyle(fontSize: 18,color: Colors.white70),
            ),
            SizedBox(height: 10),
            Text(
              'UID: ${_currentUser.uid}',
              style: TextStyle(fontSize: 18,color: Colors.white70),
            ),
            // Add more user data fields as needed
          ],
        ),
      ),
    );
  }
}
