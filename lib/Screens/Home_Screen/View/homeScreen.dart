import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_app/Constant/constColors.dart';
import 'package:web_app/Constant/constTextTheme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(Get.width, 65.h),
        child: AppBar(
          // title: Image.asset(
          //   "assets/images/parkingLogo.png",
          //   height: 65.h,
          //   width: 100.w,
          // ),
          actions: [
            Text(
              "Parking Management",
              style: getTextTheme().headlineLarge,
            ),
            IconButton(
                onPressed: () async {
                  await GetStorage().erase();
                  Get.offAllNamed("/login_screen");
                },
                icon: Icon(
                  Icons.exit_to_app_outlined,
                  size: 25.sp,
                )),
          ],
          backgroundColor: ConstColors.white,
          surfaceTintColor: ConstColors.white,
        ),
      ),
      backgroundColor: ConstColors.white,
      body: Column(
        children: [
          entry(),
          exit(),
        ],
      ),
      // bottomSheet: Container(
      //   width: Get.width,
      //   color: ConstColors.white,
      //   child: Padding(
      //     padding: EdgeInsets.symmetric(vertical: 20.h),
      //     child: RichText(
      //       textAlign: TextAlign.center,
      //       text: TextSpan(
      //         children: <TextSpan>[
      //           TextSpan(
      //             text: 'Powered By ',
      //             style: GoogleFonts.poppins(
      //               fontWeight: FontWeight.w600,
      //               color: ConstColors.black,
      //               fontSize: 12.sp,
      //             ),
      //           ),
      //           TextSpan(
      //             text: 'DAccess Security Systems Pvt. Ltd.',
      //             style: GoogleFonts.poppins(
      //               fontWeight: FontWeight.w600,
      //               color: ConstColors.green,
      //               fontSize: 12.sp,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Widget entry() {
    return GestureDetector(
      onTap: () {
        Get.toNamed("/entry_screen");
      },
      onDoubleTap: () {},
      child: Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(vertical: 70.h, horizontal: 0.w),
          margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
          decoration: BoxDecoration(
              color: ConstColors.lightGreen,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            "Entry Gate",
            style: getTextTheme().headlineLarge,
          ))),
    );
  }

  Widget exit() {
    return GestureDetector(
      onTap: () {
        Get.toNamed("/exit_screen");
      },
      onDoubleTap: () {},
      child: Container(
          width: Get.width,
          padding: EdgeInsets.symmetric(vertical: 70.h, horizontal: 0.w),
          margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
          decoration: BoxDecoration(
              color: ConstColors.lightGreen,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            "Exit Gate",
            style: getTextTheme().headlineLarge,
          ))),
    );
  }
}
