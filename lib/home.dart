import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:web_app/constTextTheme.dart';
import 'package:web_app/controller.dart';
import 'package:web_app/customDrop.dart';

class VehicleRateScreen extends StatelessWidget {
  const VehicleRateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VehicleRateController controller = Get.put(VehicleRateController());
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vehicle Rates'),
        ),
        body: Column(
          children: [
            GetBuilder(
              id: 'rate',
              init: VehicleRateController(),
              builder: (controller) {
                return controller.isLoading.value == true
                    ? const Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DataTable(
                            columnSpacing: 15.0,
                            border: TableBorder.all(color: Colors.black),
                            columns: const [
                              DataColumn(label: Text('Vehicle Type')),
                              DataColumn(label: Text('First 2 Hrs charge')),
                              DataColumn(
                                  label: Text('After 2 Hrs, hourly charges')),
                              DataColumn(label: Text('Rate for 12 hrs')),
                            ],
                            rows: controller.vehicleRates.map((rate) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(rate.vehicleTypeId ?? '')),
                                  DataCell(Text(rate.hoursRate ?? '')),
                                  DataCell(Text(rate.everyHoursRate ?? '')),
                                  DataCell(Text(rate.hours12Rate ?? '')),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      );
              },
            ),
            GetBuilder(
                init: VehicleRateController(),
                id: 'loc',
                builder: (controller) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                    child: CustomDropDown(
                      value: controller.locationType,
                      items: controller.locationTypeList
                          .map((value) => DropdownMenuItem(
                                value: value.name,
                                child: Text(value.name!),
                              ))
                          .toList(),
                      label: "Select Location",
                      hintText: 'Please select location name',
                      style: getTextTheme().headlineMedium,
                      onChanged: (value) {
                        controller.locationType = value!;
                        controller.update(["loc"]);
                      },
                    ),
                  );
                }),
            typeVehicle(),
          ],
        ));
  }

  Widget typeVehicle() {
    return GetBuilder(
      init: VehicleRateController(),
      id: "typeOfVehicle",
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onDoubleTap: () {},
              onTap: () {
                controller.selectVehicle('bike');
              },
              child: Row(
                children: [
                  const Text(
                    "Bike",
                  ),
                  IconButton(
                      onPressed: () {
                        controller.selectVehicle('bike');
                      },
                      icon: Icon(
                        controller.selectedVehicle.value == 2
                            ? Icons.circle
                            : Icons.circle_outlined,
                        color: controller.selectedVehicle.value == 2
                            ? Colors.green
                            : Colors.black,
                        size: 25.sp,
                      ))
                ],
              ),
            ),
            GestureDetector(
              onDoubleTap: () {},
              onTap: () {
                controller.selectVehicle('car');
              },
              child: Row(
                children: [
                  // Image.asset(
                  //   'assets/images/car.png',
                  //   width: 50.w,
                  //   height: 100.h,
                  // ),
                  const Text(
                    "Car",
                  ),
                  IconButton(
                    onPressed: () {
                      controller.selectVehicle('car');
                    },
                    icon: Icon(
                      controller.selectedVehicle.value == 4
                          ? Icons.circle
                          : Icons.circle_outlined,
                      color: controller.selectedVehicle.value == 4
                          ? Colors.green
                          : Colors.black,
                      size: 25.sp,
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
