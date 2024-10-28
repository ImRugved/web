import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_app/Constant/constColors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      // if (kIsWeb) {
      //   GetStorage().read("authToken") != null
      //       ? Get.offAllNamed('/exit_web_screen')
      //       : Get.offAllNamed("/login_web_screen");
      // } else if (Platform.isAndroid || Platform.isIOS) {
      GetStorage().read("login") == true
          ? Get.offAllNamed('/home_screen')
          : Get.offAllNamed("/login_screen");

      // } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text(
            'Splash Screen',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: ConstColors.black,
              fontSize: kIsWeb ? 8.sp : 12.sp,
            ),
          ),
        ),
      ),
    );
  }
}
