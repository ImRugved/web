import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                preferredSize: Size(Get.width, 65.h),
                child: AppBar(
                  actions: [
                    Text(
                      "Parking Management",
                      style: getTextTheme().headlineLarge,
                    ),
                    Gap(20.w)
                  ],
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
                              //padding: EdgeInsets.symmetric(vertical: 50.h,horizontal: 100.w),
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
                      TextField(
                        controller: controller.outputController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z0-9]'),
                          )
                        ],
                        decoration: InputDecoration(
                          //label: const Text("Qr number: "),
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
                        ),
                        onChanged: (value) {
                          controller.outputController.text =
                              value.trim().toUpperCase();
                        },
                        //readOnly: true,
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
                                                ? () {
                                                    controller.fetchVehicleData(
                                                        checkOut: false);
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
