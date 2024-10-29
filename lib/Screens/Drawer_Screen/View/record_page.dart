import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:web_app/Screens/Drawer_Screen/Controller/report_controller.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final ReportController reportController = Get.put(ReportController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Entry Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Select Entry Date',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _selectDate(context, reportController),
              child: Obx(() {
                return Text(
                  reportController.selectedDate.value == null
                      ? 'Choose Date'
                      : DateFormat('dd-MMM-yyyy')
                          .format(reportController.selectedDate.value!),
                );
              }),
            ),
            const SizedBox(height: 20),
            Obx(() {
              if (reportController.entries.isEmpty) {
                return const Center(
                  child: Text(
                    'No records available',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              } else {
                return Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Token Number')),
                        DataColumn(label: Text('Vehicle Type')),
                        DataColumn(label: Text('Vehicle Number')),
                        DataColumn(label: Text('Location')),
                        DataColumn(label: Text('Entry Time')),
                      ],
                      rows: reportController.entries.map((entry) {
                        log('vehicle type is ${entry['vehicleType']}');
                        return DataRow(
                          cells: [
                            // entry['vehicleType'] == '2' ? "Bike" : "Car"
                            DataCell(
                                Text(entry['tokenNumber']?.toString() ?? '')),
                            DataCell(Text(
                                entry['vehicleType'] == 2 ? "Bike" : "Car")),
                            DataCell(
                                Text(entry['vehicleNo']?.toString() ?? '')),
                            DataCell(Text(entry['location']?.toString() ?? '')),
                            DataCell(
                                Text(entry['entryTime']?.toString() ?? '')),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  // Helper method for date picker dialog
  Future<void> _selectDate(
      BuildContext context, ReportController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      await controller.selectDate(picked);
    }
  }
}
