import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:web_app/Screens/Entry_Screen/Model/locationModel.dart';
import 'package:web_app/Screens/Entry_Screen/Model/vehicleRateModel.dart';
import 'package:web_app/Screens/Login_Screen/View/login_screen.dart';

import '../../../Services/firestore_service.dart';

class EntryController extends GetxController {
  FirestoreService firestoreService = FirestoreService();
  RxList<GetVehicleRate> vehicleRates = <GetVehicleRate>[].obs;
  RxList<GetOfficeModel> locationTypeList = <GetOfficeModel>[].obs;
  TextEditingController vehicleNoController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  String? locationType;
  RxBool loading = false.obs;
  RxInt selectedVehicle = 0.obs;
  final db = FirebaseFirestore.instance.collection('vehicleEntry').obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
    fetchVehicleRates();
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.to(() => const LoginForm());
      log("User successfully signed out.");
    } catch (e) {
      log("Error signing out: $e");
    }
  }

  void selectVehicle(String vehicleType) {
    selectedVehicle.value = vehicleType == 'bike' ? 2 : 4;
    log('selected vehicle value is ${selectedVehicle.value}');
    update(["typeOfVehicle"]);
  }

  void fetchVehicleRates() async {
    isLoading.value = true;

    vehicleRates.value = await firestoreService.getVehicleRates();
    isLoading.value = false;
    update(['rate']);
  }

  void fetchLocations() async {
    locationTypeList.value = await firestoreService.getLocations();
    update(['loc']);
  }

  void insert() {
    loading.value = true;
    update(['home']);
    Future.delayed(const Duration(seconds: 3));
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    int uid = 1;
    String qrNumber =
        "${vehicleNoController.text.trim().toUpperCase()}${DateFormat("ddMMyyyyhhmmss").format(DateTime.now())}";
    log('uid is $uid\n vehicletype is ${selectedVehicle.value}\n vehicl no is ${vehicleNoController.text}\n locaitn is $locationType');
    db.value.doc(id).set({
      "userID": uid,
      "vehicleType": selectedVehicle.value,
      "vehicleNo": vehicleNoController.text.trim().toUpperCase(),
      "qrImage": "",
      "qrNumber": qrNumber,
      "location": locationType,
      "entryTime": DateFormat('hh:mm:ss a').format(DateTime.now()),
      "entryDate": DateFormat('dd-MMM-yyyy').format(DateTime.now()),
    }).then((value) {
      loading.value = false;
      update(['home']);
      Get.snackbar(
        'Data inserted',
        'Thank You',
        snackPosition: SnackPosition.BOTTOM,
      );
    }).onError((error, stackTrace) {
      loading.value = false;
      update(['home']);
      Get.snackbar(
        'Error',
        'Try again',
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }
}
