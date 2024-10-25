import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_app/locationModel.dart';
import 'package:web_app/vehicleRateModel.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch vehicle rates from Firestore
  Future<List<GetVehicleRate>> getVehicleRates() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('vehicleRate').get();
    return querySnapshot.docs.map((doc) {
      return GetVehicleRate.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<List<GetOfficeModel>> getLocations() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('locations').get();
    return querySnapshot.docs.map((doc) {
      return GetOfficeModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
