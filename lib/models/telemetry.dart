class Data {
  String canbusTimelineId;

  String canbusId;
  double value;
  String timestamp;
  String canbusIdName;
  String unit;

  Data({
    required this.canbusId,
    required this.timestamp,
    required this.value,
    required this.canbusIdName,
    required this.canbusTimelineId,
    required this.unit,
  });
}

Map<String, String> m = {
  'SUSP_FL': 'Tire Temperature',
  'SUSP_FR': 'Oil Pressure',
  'Strai_Gauge_FR': 'Air Intake Pressure',
  'Strain_Gauge_FL': 'Air Intake Temperature',
  'Vdc': 'RPM',
  'APPS1_Raw': 'Suspension'
};
