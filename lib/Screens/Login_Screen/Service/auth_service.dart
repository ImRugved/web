import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:web_app/Screens/Login_Screen/Controller/login_controller.dart';

class FirebaseAuthServices extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final controller = Get.put(LoginController());
}
