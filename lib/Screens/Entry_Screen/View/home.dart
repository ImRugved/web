import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_app/Constant/constColors.dart';
import 'package:web_app/Constant/constTextTheme.dart';
import 'package:web_app/Constant/customDrop.dart';
import 'package:web_app/Constant/loading.dart';
import 'package:web_app/Constant/rounded_button.dart';
import 'package:web_app/Screens/Entry_Screen/Controller/entry_controller.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final VehicleRateController controller = Get.put(VehicleRateController());
    return GetBuilder(
        init: EntryController(),
        id: 'home',
        builder: (controller) {
          log('location ius ${controller.locationType}');
          return Scaffold(
              appBar: AppBar(
                title: const Text('Vehicle Entry'),
                actions: [
                  IconButton(
                    onPressed: () async {
                      await GetStorage().erase();
                      Get.offAllNamed('/login_screen');
                      controller.signOut();
                    },
                    icon: Icon(
                      Icons.logout_outlined,
                      color: ConstColors.black,
                      size: 25.sp,
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    GetBuilder(
                      id: 'rate',
                      init: EntryController(),
                      builder: (controller) {
                        return controller.isLoading.value == true
                            ? const Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DataTable(
                                    columnSpacing: 15.0,
                                    border:
                                        TableBorder.all(color: Colors.black),
                                    columns: const [
                                      DataColumn(label: Text('Vehicle Type')),
                                      DataColumn(
                                          label: Text('First 2 Hrs charge')),
                                      DataColumn(
                                          label: Text(
                                              'After 2 Hrs, hourly charges')),
                                      DataColumn(
                                          label: Text('Rate for 12 hrs')),
                                    ],
                                    rows: controller.vehicleRates.map((rate) {
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                              Text(rate.vehicleTypeId ?? '')),
                                          DataCell(Text(rate.hoursRate ?? '')),
                                          DataCell(
                                              Text(rate.everyHoursRate ?? '')),
                                          DataCell(
                                              Text(rate.hours12Rate ?? '')),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                      },
                    ),
                    GetBuilder(
                        init: EntryController(),
                        id: 'vno',
                        builder: (ctrl) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 15.h),
                            child: TextFormField(
                              controller: ctrl.vehicleNoController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9]'),
                                )
                              ],
                              cursorColor: ConstColors.black,
                              decoration: InputDecoration(
                                labelStyle: getTextTheme().headlineSmall,
                                fillColor: ConstColors.white,
                                filled: true,
                                labelText: 'Enter Vehicle Number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.sp),
                                  ),
                                  borderSide: const BorderSide(
                                    color: ConstColors.black,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.sp),
                                  ),
                                  borderSide: const BorderSide(
                                    color: ConstColors.black,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.sp),
                                  ),
                                  borderSide: const BorderSide(
                                    color: ConstColors.black,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.sp),
                                  ),
                                  borderSide: const BorderSide(
                                    color: ConstColors.red,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.sp),
                                  ),
                                  borderSide: const BorderSide(
                                    color: ConstColors.green,
                                  ),
                                ),
                              ),
                              onChanged: (value) {
                                ctrl.vehicleNoController.text =
                                    value.trim().toUpperCase();
                                ctrl.update(["home"]);
                              },
                              keyboardType: TextInputType.text,
                            ),
                          );
                        }),
                    GetBuilder(
                        init: EntryController(),
                        id: 'loc',
                        builder: (controller) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 5.h),
                            child: CustomDropDown(
                              value: controller.locationType,
                              items: ['ABC', 'XYZ', 'PQR', 'NMO']
                                  .map((value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      ))
                                  .toList(),
                              label: "Select Location",
                              hintText: 'Please select location name',
                              style: getTextTheme().headlineMedium,
                              onChanged: (value) {
                                controller.locationType = value!;
                                controller.update(["loc"]);
                              },
                            ),
                          );
                        }),
                    typeVehicle(),
                    SizedBox(
                      height: 50.h,
                    ),
                    RoundedButton(
                      press: () async {
                        if (controller.vehicleNoController.text
                                .trim()
                                .isNotEmpty &&
                            controller.selectedVehicle.value != 0) {
                          controller.insert().then(
                            (value) {
                              controller.selectedVehicle.value = 0;
                              controller.vehicleNoController.clear();
                              controller.locationType = null;
                              controller.update();
                            },
                          );
                        } else {
                          Get.snackbar(
                            'Error',
                            controller.selectedVehicle.value == 0
                                ? "Please Select a vehicle type"
                                : "Please enter a vehicle number",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      text: 'Print',
                      color: Colors.teal,
                      bordercolor: Colors.teal,
                      width: 250.w,
                    ).toProgress(controller.loading)
                  ],
                ),
              ));
        });
  }

  Widget typeVehicle() {
    return GetBuilder(
      init: EntryController(),
      id: "typeOfVehicle",
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onDoubleTap: () {},
              onTap: () {
                controller.selectVehicle('bike');
              },
              child: Row(
                children: [
                  const Text(
                    "Bike",
                  ),
                  IconButton(
                      onPressed: () {
                        controller.selectVehicle('bike');
                      },
                      icon: Icon(
                        controller.selectedVehicle.value == 2
                            ? Icons.circle
                            : Icons.circle_outlined,
                        color: controller.selectedVehicle.value == 2
                            ? Colors.green
                            : Colors.black,
                        size: 25.sp,
                      ))
                ],
              ),
            ),
            GestureDetector(
              onDoubleTap: () {},
              onTap: () {
                controller.selectVehicle('car');
              },
              child: Row(
                children: [
                  // Image.asset(
                  //   'assets/images/car.png',
                  //   width: 50.w,
                  //   height: 100.h,
                  // ),
                  const Text(
                    "Car",
                  ),
                  IconButton(
                    onPressed: () {
                      controller.selectVehicle('car');
                    },
                    icon: Icon(
                      controller.selectedVehicle.value == 4
                          ? Icons.circle
                          : Icons.circle_outlined,
                      color: controller.selectedVehicle.value == 4
                          ? Colors.green
                          : Colors.black,
                      size: 25.sp,
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
