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
  '65': 'Oil Pressure',
  '66': 'Air Intake Pressure',
  '12A': 'Air Intake Temperature',
  '15E': 'Throttle Position',
  '12B': 'Fuel Temperature',
  '15D': 'RPM'
};
