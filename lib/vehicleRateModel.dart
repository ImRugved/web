// To parse this JSON data, do
//
//     final getVehicleRate = getVehicleRateFromJson(jsonString);

import 'dart:convert';

List<GetVehicleRate> getVehicleRateFromJson(String str) =>
    List<GetVehicleRate>.from(
        json.decode(str).map((x) => GetVehicleRate.fromJson(x)));

String getVehicleRateToJson(List<GetVehicleRate> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetVehicleRate {
  String? vehicleTypeId;
  String? hoursRate;
  String? everyHoursRate;
  String? hours12Rate;
  String? parkingCharges;

  GetVehicleRate({
    this.vehicleTypeId,
    this.hoursRate,
    this.everyHoursRate,
    this.hours12Rate,
    this.parkingCharges,
  });

  factory GetVehicleRate.fromJson(Map<String, dynamic> json) => GetVehicleRate(
        vehicleTypeId: json["vehicleTypeID"],
        hoursRate: json["hoursRate"],
        everyHoursRate: json["everyHoursRate"],
        hours12Rate: json["hours12Rate"],
        parkingCharges: json["parkingCharges"],
      );

  Map<String, dynamic> toJson() => {
        "vehicleTypeID": vehicleTypeId,
        "hoursRate": hoursRate,
        "everyHoursRate": everyHoursRate,
        "hours12Rate": hours12Rate,
        "parkingCharges": parkingCharges,
      };
}
