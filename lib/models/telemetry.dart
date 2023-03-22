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
  'SUSP_FL': 'SUSP_FL',
  'SUSP_FR': 'SUSP_FR',
  'Strai_Gauge_FR': 'Strai_Gauge_FR',
  'Strain_Gauge_FL': 'Strain_Gauge_FLn',
  'Vdc': 'Vdc',
  'APPS1_Raw': 'APPS1_Raw'
};
