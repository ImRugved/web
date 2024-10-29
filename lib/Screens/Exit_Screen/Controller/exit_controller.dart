import 'dart:developer';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';

class ExitController extends GetxController {
  final CollectionReference db =
      FirebaseFirestore.instance.collection('vehicleEntry');
  TextEditingController outputController = TextEditingController();
  final GetStorage storage = GetStorage();
  var totalParkingDuration = ''.obs;
  TextEditingController totalParkingCharges = TextEditingController();
  String? paymentType;
  RxBool isLoading = false.obs;
  List<String> paymentsTypeList = ["Cash", "UPI", "Cards"];

  Future scan() async {
    await Permission.camera.request();
    outputController.clear();
    String userID = storage.read('userMasterID');
    var barcode = await BarcodeScanner.scan();
    log('Qr code $barcode');
    log('userID $userID');
    outputController.text = barcode.rawContent;
    fetchVehicleData(vehicleNo: outputController.text);
  }

  Future<void> fetchVehicleData(
      {required String vehicleNo, bool? checkOut}) async {
    log('vehicle number in fetch data is $vehicleNo');
    try {
      if (vehicleNo.isEmpty) {
        Get.snackbar('Error', 'Please enter a valid vehicle number.',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      QuerySnapshot snapshot =
          await db.where('vehicleNo', isEqualTo: vehicleNo.toUpperCase()).get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = snapshot.docs.first;
        String entryTimeStr = doc['entryTime'];
        String entryDateStr = doc['entryDate'];
        int vehicleType = doc['vehicleType'];
        String vehicleNumber = doc['vehicleNo'];
        final bikeIcon = await imageFromAssetBundle(vehicleType == 4
            ? 'assets/images/car.png'
            : 'assets/images/bike.png');

        DateTime entryDateTime = DateFormat('dd-MMM-yyyy hh:mm:ss a')
            .parse('$entryDateStr $entryTimeStr');
        DateTime currentDateTime = DateTime.now();

        Duration duration = currentDateTime.difference(entryDateTime);
        int totalMinutes = duration.inMinutes;
        String amount = calculateCharges(vehicleType, totalMinutes);

        totalParkingDuration.value = duration.toString().split('.').first;
        totalParkingCharges.text = amount;
        update(['ExitScreen']);

        if (checkOut == true) {
          if (paymentType != null) {
            await generatePdf(
                amount,
                vehicleNumber,
                "Daccess", // Replace with actual company name
                paymentType!,
                vehicleType == 2 ? "Bike" : "Car",
                entryDateStr,
                entryTimeStr,
                bikeIcon,
                DateFormat('dd-MMM-yyyy').format(currentDateTime),
                totalParkingDuration.value);
            Get.snackbar('Success', 'PDF receipt generated successfully',
                snackPosition: SnackPosition.BOTTOM);
          } else {
            Get.snackbar(
                'Error', 'Please select a payment type before checking out.',
                snackPosition: SnackPosition.BOTTOM);
          }
        }
      } else {
        Get.snackbar('Error', 'No vehicle found with that number',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error',
          'An error occurred while fetching vehicle data. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
      debugPrint('Error fetching vehicle data: $e'); // Log the exact error
    }
  }

  String calculateCharges(int vehicleType, int totalMinutes) {
    double charge = 0.0;

    if (vehicleType == 2) {
      if (totalMinutes <= 120) {
        charge = 20;
      } else if (totalMinutes <= 720) {
        charge = 20 + ((totalMinutes - 120) / 60).ceil() * 20;
      } else {
        charge = 230;
      }
    } else if (vehicleType == 4) {
      if (totalMinutes <= 120) {
        charge = 40;
      } else if (totalMinutes <= 720) {
        charge = 40 + ((totalMinutes - 120) / 60).ceil() * 40;
      } else {
        charge = 240;
      }
    }

    return charge.toStringAsFixed(2);
  }

  Future<Future<bool>> generatePdf(
      String amount,
      String vehicleNumber,
      String companyName,
      String paymentType,
      String vehicleType,
      String date,
      String time,
      var bikeIcon,
      String dateOut,
      String totalTime) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("---------------------------------------",
                    style: pw.TextStyle(
                      fontSize: 45,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    )),
                pw.Center(
                  child: pw.Text(companyName,
                      style: pw.TextStyle(
                        fontSize: 35,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black,
                      )),
                ),
                pw.Text("---------------------------------------",
                    style: pw.TextStyle(
                      fontSize: 45,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    )),
                pw.Center(
                  child: pw.Text("Payment Receipt",
                      style: pw.TextStyle(
                          fontSize: 40,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black)),
                ),
                pw.Container(height: 10),
                pw.Text('Vehicle No. $vehicleNumber',
                    style: const pw.TextStyle(
                        fontSize: 35, color: PdfColors.black)),
                pw.Text('Amount Paid: $amount',
                    style: const pw.TextStyle(
                        fontSize: 35, color: PdfColors.black)),
                pw.Text("Payment Type: $paymentType",
                    style: const pw.TextStyle(
                        fontSize: 35, color: PdfColors.black)),
                pw.Text("Entry: $date, $time",
                    style: const pw.TextStyle(
                        fontSize: 35, color: PdfColors.black)),
                pw.Text(
                    "Exit: $dateOut, ${DateFormat('hh:mm:ss a').format(DateTime.now())}",
                    style: const pw.TextStyle(
                        fontSize: 35, color: PdfColors.black)),
                pw.Text("Total Time: $totalTime",
                    style: const pw.TextStyle(
                        fontSize: 35, color: PdfColors.black)),
                pw.Divider(),
                pw.Center(
                  child: pw.Image(
                    bikeIcon,
                    width: 300,
                    height: 150,
                  ),
                ),
                pw.Center(
                  child: pw.Text("Drive Safely.",
                      style: pw.TextStyle(
                          fontSize: 35,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black)),
                ),
                pw.Center(
                  child: pw.Text("Thank you for Visiting",
                      style: pw.TextStyle(
                          fontSize: 35,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black)),
                ),
                pw.Center(
                  child: pw.Text("Come Again!",
                      style: pw.TextStyle(
                          fontSize: 35,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black)),
                ),
              ],
            ),
          );
        },
      ),
    );
    return Printing.layoutPdf(
      name: '$vehicleNumber-qrScan',
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
