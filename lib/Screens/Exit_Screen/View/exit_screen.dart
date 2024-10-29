import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:web_app/Constant/constColors.dart';
import 'package:web_app/Constant/constTextTheme.dart';
import 'package:web_app/Constant/customDrop.dart';
import 'package:web_app/Constant/loading.dart';
import 'package:web_app/Constant/rounded_button.dart';
import 'package:web_app/Screens/Exit_Screen/Controller/exit_controller.dart';

class ExitScreen extends GetView<ExitController> {
  const ExitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? qrCodeResult;
    return GetBuilder(
        init: ExitController(),
        id: "ExitScreen",
        builder: (_) {
          return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size(Get.width, 40.h),
                child: AppBar(
                  title: Text(
                    "Vehicle Exit",
                    style: getTextTheme().headlineLarge,
                  ),
                  centerTitle: true,
                  backgroundColor: ConstColors.white,
                  surfaceTintColor: ConstColors.backgroundColor,
                ),
              ),
              backgroundColor: ConstColors.backgroundColor,
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            controller.scan();
                          },
                          onDoubleTap: () {},
                          child: Container(
                              height: 100.h,
                              width: 250.w,
                              margin: EdgeInsets.symmetric(
                                  vertical: 15.h, horizontal: 0.w),
                              decoration: BoxDecoration(
                                  color: ConstColors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: ConstColors.green)),
                              child: Center(
                                  child: Text(
                                "TAP HERE TO SCAN QR...",
                                style: getTextTheme().labelLarge,
                              ))),
                        ),
                      ),
                      Gap(10.h),
                      TextField(
                        controller: controller.outputController,
                        decoration: InputDecoration(
                          fillColor: ConstColors.white,
                          filled: true,
                          labelStyle: getTextTheme().labelMedium,
                          hintText: "Please enter vehicle number",
                          hintStyle: getTextTheme().labelSmall,
                          suffixIcon: InkWell(
                            onTap: () {
                              controller.fetchVehicleData(
                                  vehicleNo: controller.outputController.text,
                                  checkOut: false);
                            },
                            child: Icon(
                              Icons.search,
                              size: 25.sp,
                              color: ConstColors.black,
                            ),
                          ),
                          border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: ConstColors.green)),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ConstColors.green,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          controller.outputController.text =
                              value.trim().toUpperCase();
                        },
                      ),
                      controller.totalParkingCharges.text != ""
                          ? Column(
                              children: [
                                Gap(20.h),
                                TextField(
                                  controller: controller.totalParkingCharges,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    label: Text("Amount to pay :",
                                        style: getTextTheme().labelMedium),
                                    border: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ConstColors.green,
                                      ),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: ConstColors.green,
                                      ),
                                    ),
                                    fillColor: ConstColors.white,
                                    filled: true,
                                  ),
                                ),
                                Gap(20.h),
                                CustomDropDown(
                                  value: controller.paymentType,
                                  items: controller.paymentsTypeList
                                      .map((value) => DropdownMenuItem(
                                            value: value,
                                            child: Text(value),
                                          ))
                                      .toList(),
                                  label: 'Please select payment type:',
                                  onChanged: (value) {
                                    controller.paymentType = value!;
                                    controller.update(["ExitScreen"]);
                                  },
                                ),
                                Gap(20.h),
                                RoundedButton(
                                        press:
                                            (controller.paymentType != null &&
                                                    controller.outputController
                                                            .text !=
                                                        "")
                                                ? () async {
                                                    controller.isLoading.value =
                                                        true;
                                                    await controller
                                                        .fetchVehicleData(
                                                            vehicleNo: controller
                                                                .outputController
                                                                .text,
                                                            checkOut: true);
                                                    controller.isLoading.value =
                                                        false;
                                                  }
                                                : null,
                                        text: "Check Out")
                                    .toProgress(controller.isLoading),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ));
        });
  }
}
