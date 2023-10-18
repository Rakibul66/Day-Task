
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileController extends GetxController {
  var _name = "John Doe".obs;
  var _designation = "Software Engineer".obs;
  var imageUrl = "".obs;

  set name(String newName) => _name.value = newName;
  String get name => _name.value;

  set designation(String newDesignation) => _designation.value = newDesignation;
  String get designation => _designation.value;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Reference _storageReference = FirebaseStorage.instance.ref().child('profile_images');
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference(); // Define _databaseReference here

  Future<void> changeProfileImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        // Upload the image to Firebase Storage
        UploadTask uploadTask = _storageReference.child('${_auth.currentUser?.uid}.jpg').putFile(imageFile);

        // Get the download URL once the upload is complete
        String imageUrl = await (await uploadTask).ref.getDownloadURL();

        // Set the imageUrl in the controller
        this.imageUrl.value = imageUrl;
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> saveUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        // User is authenticated, perform database operations
        String userUid = user.uid;
        String tasksPath = 'tasks/$userUid'; // Example tasks path based on security rules
        String usersPath = 'users/$userUid'; // Example users path based on security rules

        // Perform database operations using tasksPath and usersPath
        await _databaseReference.child(tasksPath).set({
          // Add tasks data here if needed
        });

        await _databaseReference.child(usersPath).set({
          'name': name,
          'designation': designation,
          'imageUrl': imageUrl,
        });
      } else {
        // User is not authenticated, handle accordingly (redirect to login page, show error message, etc.)
        print('User is not authenticated.');
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }


  void updateUI() {
    // Implement the logic to update the UI with the saved user data
    // For example, update profile screen widgets with the new name, designation, and imageUrl
    // This logic depends on how your UI is structured
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // You can perform any additional tasks after signing out here
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
