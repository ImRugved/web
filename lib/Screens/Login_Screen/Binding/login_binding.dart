import 'package:get/get.dart';
import 'package:web_app/Screens/Login_Screen/Controller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}
