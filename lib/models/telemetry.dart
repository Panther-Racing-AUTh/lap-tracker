class Data {
  String canbusId;
  double value;
  String timestamp;
  late String name;

  Data({required this.canbusId, required this.timestamp, required this.value});

  Data.fromJson(Map<String, dynamic> json)
      : this.canbusId = json['canbusId'],
        this.timestamp = json['timestamp2'],
        this.value = json['value'];

  Map toMap() {
    return {
      'canbusId': canbusId,
      'value': value,
      'timestamp2': timestamp,
    };
  }

  void setName() {
    name = m[canbusId]!;
  }
}

Map<String, String> m = {
  '15E': 'Brake Pressure',
  '65': 'Oil Pressure',
  '66': 'Air Intake Pressure',
  '12A': 'Air Intake Temperature',
  '15D': 'Throttle Position',
  '12B': 'Fuel Temperature',
  '69': 'RPM'
};
