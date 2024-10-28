import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:web_app/Constant/constColors.dart';
import 'package:web_app/Constant/toast.dart';
import 'package:web_app/Screens/Login_Screen/View/login_screen.dart';

class LoginController extends GetxController {
  final GetStorage box = GetStorage();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final userNameController = TextEditingController();
  RxBool loading = false.obs;
  RxBool isVisible1 = false.obs;
  RxBool isVisible2 = false.obs;
  RxBool isVisible = false.obs;
  RxBool signupLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final users = FirebaseFirestore.instance.collection('userData').obs;

  // Method to sign up the user
  void signUp(BuildContext context, String email, String password,
      String userName) async {
    signupLoading.value = true;
    update(['signUp']);

    // Check if user already exists
    final existingUser =
        await users.value.where("email", isEqualTo: email).get();
    if (existingUser.docs.isNotEmpty) {
      signupLoading.value = false;
      update(['signUp']);
      Get.snackbar('Error', 'User already exists',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Create user in Firebase Auth
    _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      int uid = await _getNextUserId();

      // Insert user data into Firestore
      await users.value.doc(value.user!.uid).set({
        "userName": userNameController.text,
        "userId": uid,
        "email": email,
        "entryTime": DateFormat('hh:mm:ss a').format(DateTime.now()),
        "entryDate": DateFormat('dd-MMM-yyyy').format(DateTime.now()),
      });

      Toast().toastMessage(
        message: "Signup Successful",
        bgColor: ConstColors.green,
        textColor: ConstColors.white,
        textsize: 12.sp,
      );

      Get.to(() => const LoginForm());
      signupLoading.value = false;
      update(['signUp']);
    }).onError((error, stackTrace) {
      String errorMessage = parseFirebaseAuthError(error);
      Toast().toastMessage(
        message: errorMessage,
        bgColor: ConstColors.red,
        textColor: ConstColors.white,
        textsize: 12.sp,
      );

      signupLoading.value = false;
      update(['signUp']);
    });
  }

  // Method to get the next available user ID
  Future<int> _getNextUserId() async {
    final querySnapshot =
        await users.value.orderBy("userId", descending: true).limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first["userId"] + 1;
    } else {
      return 1; // Start user ID from 1 if there are no users
    }
  }

  // Method to log in the user
  void emailLogin(BuildContext context, String email, String password) async {
    loading.value = true;
    update(['login']);

    try {
      // Attempt to sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the user is not null
      if (userCredential.user != null) {
        final userDoc = await users.value.doc(userCredential.user!.uid).get();

        if (userDoc.exists) {
          // Fetch and store user data
          await box.write('userName', userDoc["userName"]);
          await box.write('userId', userDoc["userId"]);
          await box.write('login', true);
          log("Username is : ${box.read('userName')}, UserId is : ${box.read('userId')}");
          Toast().toastMessage(
            message: "Login Successful",
            bgColor: ConstColors.green,
            textColor: ConstColors.white,
            textsize: 12.sp,
          );

          Get.offAllNamed('/home_screen');
        } else {
          Get.snackbar('Error', 'User data not found',
              snackPosition: SnackPosition.TOP);
        }
      } else {
        Get.snackbar('Error', 'User not found',
            snackPosition: SnackPosition.TOP);
      }
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase authentication errors
      String errorMessage = parseFirebaseAuthError(e.code);
      Toast().toastMessage(
        message: errorMessage,
        bgColor: ConstColors.red,
        textColor: ConstColors.white,
        textsize: 12.sp,
      );
      log('Email login error: $errorMessage');
    } catch (e) {
      // Handle any other errors
      Toast().toastMessage(
        message: 'An unexpected error occurred: $e',
        bgColor: ConstColors.red,
        textColor: ConstColors.white,
        textsize: 12.sp,
      );
      log('Email login error: $e');
    } finally {
      loading.value = false; // Ensure loading is false at the end
    }
  }

  // Method to parse Firebase Auth errors
  String parseFirebaseAuthError(error) {
    String errorMessage = error.toString();
    if (errorMessage.contains('] ')) {
      return errorMessage.split('] ')[1];
    } else {
      return errorMessage;
    }
  }

  // Other existing methods remain the same...
}
