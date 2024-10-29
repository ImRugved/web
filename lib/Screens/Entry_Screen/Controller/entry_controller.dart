import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
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

  Future<void> insert() async {
    loading.value = true;
    update(['home']);
    Future.delayed(const Duration(seconds: 2));

    String id = DateTime.now().millisecondsSinceEpoch.toString();
    int uid = 1;
    String qrNumber =
        "${vehicleNoController.text.trim().toUpperCase()}${DateFormat("ddMMyyyyhhmmss").format(DateTime.now())}";
    String tokenName = selectedVehicle.value == 2 ? 'Bike' : 'Car';

    try {
      // Query Firestore to get the current count of entries for the selected vehicle type
      QuerySnapshot snapshot = await db.value
          .where('vehicleType', isEqualTo: selectedVehicle.value)
          .get();

      // Set the next token number based on the count of existing entries for the vehicle type
      int tokenNumber = snapshot.docs.length + 1; // Increment for new entry

      await db.value.doc(id).set({
        "userID": uid,
        "vehicleType": selectedVehicle.value,
        "vehicleNo": vehicleNoController.text.trim().toUpperCase(),
        "qrImage": "",
        "qrNumber": qrNumber,
        "location": locationType,
        "entryTime": DateFormat('hh:mm:ss a').format(DateTime.now()),
        "entryDate": DateFormat('dd-MMM-yyyy').format(DateTime.now()),
        "tokenNumber": tokenNumber,
      }).then(
        (value) => Get.snackbar(
          'Data inserted',
          'Thank you',
          snackPosition: SnackPosition.BOTTOM,
        ),
      );

      final bikeIcon = await imageFromAssetBundle(selectedVehicle.value == 4
          ? 'assets/images/car.png'
          : 'assets/images/bike.png');
      loading.value = false;
      update(['home']);

      await generatePdf(
        vehicleNumber: vehicleNoController.text.trim().toUpperCase(),
        vehicleType: selectedVehicle.value == 2 ? 'Bike' : 'Car',
        companyName: "Daccess",
        qrCodeNumber: qrNumber, // Your generated QR code string
        hoursRate: selectedVehicle.value == 2
            ? '20'
            : '40', // Example value, replace with actual
        everyHoursRate: selectedVehicle.value == 2
            ? '20'
            : '40', // Example value, replace with actual
        hours12Rate: selectedVehicle.value == 2
            ? '230'
            : '240', // Example value, replace with actual
        date: DateFormat('dd-MMM-yyyy').format(DateTime.now()),
        time: DateFormat('hh:mm:ss a').format(DateTime.now()),
        tokenNo: tokenNumber.toString(),
        bikeIcon: bikeIcon, // Pass your image here
        location: locationType ?? "Unknown", // Default if null
      ).then(
        (value) {
          update();
        },
      );
    } catch (error) {
      loading.value = false;
      update(['home']);
      Get.snackbar(
        'Error',
        'Try again',
        snackPosition: SnackPosition.BOTTOM,
      );
      log('Error inserting data: $error');
    }
  }

// Your existing function, now revised for clarity and structure
  Future<bool> generatePdf({
    required String vehicleNumber,
    required String vehicleType,
    required String companyName,
    required String qrCodeNumber,
    required String hoursRate,
    required String everyHoursRate,
    required String hours12Rate,
    required String date,
    required String time,
    required String tokenNo,
    required pw.ImageProvider bikeIcon, // Change to pw.ImageProvider
    required String location,
  }) async {
    final pdf = pw.Document();

    // Adding a page to the PDF document
    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text("---------------------------------------",
                  style: pw.TextStyle(
                    fontSize: 15, // Adjusted font size
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  )),
              pw.Center(
                child: pw.Text(companyName,
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    )),
              ),
              pw.Text("---------------------------------------",
                  style: pw.TextStyle(
                    fontSize: 15,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.black,
                  )),
              pw.Center(
                child: pw.Text("Parking Receipt",
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    )),
              ),
              pw.Center(
                child: pw.Text('Token No. $tokenNo',
                    style: const pw.TextStyle(
                        fontSize: 18, color: PdfColors.black)),
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.BarcodeWidget(
                    width: 100, // Adjust width as needed
                    height: 100, // Adjust height as needed
                    margin: const pw.EdgeInsets.symmetric(vertical: 20),
                    data: qrCodeNumber,
                    barcode: pw.Barcode.qrCode(),
                  ),
                  pw.SizedBox(
                    width: 5.w,
                  ),
                  pw.Image(bikeIcon,
                      width: 100, height: 100), // Adjust size as needed
                ],
              ),
              pw.Text(vehicleNumber,
                  style:
                      const pw.TextStyle(fontSize: 18, color: PdfColors.black)),
              pw.Text(
                'Entry: $date, $time',
                style: const pw.TextStyle(fontSize: 18, color: PdfColors.black),
              ),
              pw.Text(
                '2 Hr rate : $hoursRate',
                style: const pw.TextStyle(fontSize: 18, color: PdfColors.black),
              ),
              pw.Text(
                'After 2hr : $everyHoursRate',
                style: const pw.TextStyle(fontSize: 18, color: PdfColors.black),
              ),
              pw.Text(
                '12hr Rate : $hours12Rate',
                style: const pw.TextStyle(fontSize: 18, color: PdfColors.black),
              ),
              pw.Text('Location : $location',
                  style:
                      const pw.TextStyle(fontSize: 16, color: PdfColors.black)),
              pw.Text('Scan this QR Code at Exit Gate',
                  style:
                      const pw.TextStyle(fontSize: 16, color: PdfColors.black)),
              pw.Text('Parking at Owners Risk',
                  style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black)),
            ],
          );
        },
      ),
    );

    // Return the PDF layout as a boolean
    return Printing.layoutPdf(
      name: '$vehicleNumber-qrScan',
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
