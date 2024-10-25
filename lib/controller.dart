import 'dart:developer';

import 'package:get/get.dart';
import 'package:web_app/locationModel.dart';
import 'package:web_app/vehicleRateModel.dart';

import 'firestore_service.dart';

class VehicleRateController extends GetxController {
  RxList<GetVehicleRate> vehicleRates = <GetVehicleRate>[].obs;
  RxList<GetOfficeModel> locationTypeList = <GetOfficeModel>[].obs;
  RxBool isLoading = false.obs;
  String? locationType;
  RxInt selectedVehicle = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocations();
    fetchVehicleRates();
  }

  void selectVehicle(String vehicleType) {
    selectedVehicle.value = vehicleType == 'bike' ? 2 : 4;
    log('selected vehicle value is ${selectedVehicle.value}');
    update(["typeOfVehicle"]);
  }

  void fetchVehicleRates() async {
    isLoading.value = true;
    FirestoreService firestoreService = FirestoreService();
    vehicleRates.value = await firestoreService.getVehicleRates();
    isLoading.value = false;
    update(['rate']);
  }

  void fetchLocations() async {
    FirestoreService firestoreService = FirestoreService();
    locationTypeList.value = await firestoreService.getLocations();
    update(['loc']);
  }
}
