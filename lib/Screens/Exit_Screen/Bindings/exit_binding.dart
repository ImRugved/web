import 'package:get/get.dart';
import 'package:web_app/Screens/Exit_Screen/Controller/exit_controller.dart';

class ExitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExitController>(
      () => ExitController(),
    );
  }
}
