class SetupChange {
  final String dateTime;
  final String previousSettings;
  final String afterSettings;
  final String userId;
  final String changes;

  SetupChange({
    required this.dateTime,
    required this.previousSettings,
    required this.afterSettings,
    required this.userId,
    required this.changes,
  });

  SetupChange.fromJson(Map<String, dynamic> json)
      : dateTime = json['created_at'],
        previousSettings = json['previous_settings'],
        afterSettings = json['changed_settings'],
        userId = json['userId'],
        changes = json['changes'];
}
