import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_app/Constant/constColors.dart';
import 'package:web_app/Constant/constTextTheme.dart';
import 'package:web_app/Constant/rounded_button.dart';
import 'package:web_app/Screens/Drawer_Screen/View/record_page.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    GetStorage box = GetStorage();
    return SizedBox(
      height: 690.h,
      width: 250.w,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(35),
          bottomRight: Radius.circular(35),
        ),
        child: Drawer(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: const BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [
                //     ConstColors.green,
                //     ConstColors.green.withOpacity(0.50),
                //     ConstColors.green
                //   ],
                // ),
                ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  //height: Get.height * .8,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Center(
                          child: CircleAvatar(
                        foregroundImage: const AssetImage(
                          'assets/images/parkingIcon.jpeg',
                        ),
                        radius: 45.sp,
                      )),
                      SizedBox(
                        height: 9.h,
                      ),
                      const Divider(
                        thickness: 1,
                        height: 0,
                      ),
                      Gap(10.h),
                    ],
                  ),
                ),
                RoundedButton(
                    press: () {
                      Get.to(() => const ReportPage());
                    },
                    text: "Report"),
                const Spacer(),
                Image.asset(
                  'assets/images/parkingIcon.jpeg',
                  height: 40.h,
                  width: 90.w,
                ),
                Text(
                  'Powered By ',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: ConstColors.red,
                    fontSize: 11.sp,
                  ),
                ),
                Text(
                  'DAccess Security Systems Pvt. Ltd.',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: ConstColors.black,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mainRow(String title) {
    return Column(
      children: [
        Gap(10.h),
        Row(
          children: [
            Icon(
              Icons.manage_history,
              size: 25.sp,
              color: ConstColors.black,
            ),
            Gap(8.w),
            Text(
              title,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w700,
                color: ConstColors.textColor,
                fontSize: 18.sp,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget titleRow(VoidCallback tap, String title, String icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: InkWell(
        onTap: tap,
        onDoubleTap: () {},
        child: Row(
          children: [
            Image.asset(icon, height: 30.sp, width: 25.w),
            Gap(10.w),
            Text(title, style: getTextTheme().displayMedium)
          ],
        ),
      ),
    );
  }
}
