import 'package:get/get.dart';
import 'package:web_app/Screens/Entry_Screen/Controller/entry_controller.dart';

class EntryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EntryController>(
      () => EntryController(),
    );
  }
}
