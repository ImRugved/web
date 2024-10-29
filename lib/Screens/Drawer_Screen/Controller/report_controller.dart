import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportController extends GetxController {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Observables for selected date and entries list
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  RxList<Map<String, dynamic>> entries = <Map<String, dynamic>>[].obs;

  // Function to select a date and fetch data
  Future<void> selectDate(DateTime date) async {
    selectedDate.value = date;
    await fetchEntries();
  }

  // Function to fetch entries for the selected date
  Future<void> fetchEntries() async {
    if (selectedDate.value != null) {
      final formattedDate =
          DateFormat('dd-MMM-yyyy').format(selectedDate.value!);
      final snapshot = await db
          .collection('vehicleEntry')
          .where('entryDate', isEqualTo: formattedDate)
          .get();

      entries.value = snapshot.docs.map((doc) => doc.data()).toList();
    }
  }
}
