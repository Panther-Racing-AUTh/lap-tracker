class Message {
  final String id;
  final String content;
  final bool markAsRead;
  final String userFrom;
  final DateTime createAt;
  final bool isMine;
  final String userFromName;
  final String userFromImage;
  final String type;

  Message({
    required this.id,
    required this.content,
    required this.markAsRead,
    required this.userFrom,
    required this.createAt,
    required this.isMine,
    required this.userFromImage,
    required this.userFromName,
    required this.type,
  });

  Message.createText({
    required this.content,
    required this.userFrom,
    required this.userFromName,
  })  : id = '',
        markAsRead = false,
        isMine = true,
        createAt = DateTime.now(),
        userFromImage = '',
        type = 'text';

  Message.createImage({
    required this.content,
    required this.userFrom,
    required this.userFromName,
  })  : id = '',
        markAsRead = false,
        isMine = true,
        createAt = DateTime.now(),
        userFromImage = '',
        type = 'image';

  Message.createChart({
    required this.content,
    required this.userFrom,
    required this.userFromName,
  })  : id = '',
        markAsRead = false,
        isMine = true,
        createAt = DateTime.now(),
        userFromImage = '',
        type = 'chart';

  Message.fromJson(Map<String, dynamic> json, String userId, String senderImage)
      : id = json['id'],
        content = json['content'],
        markAsRead = json['mark_as_read'],
        userFrom = json['user_from'],
        createAt = DateTime.parse(json['created_at']),
        isMine = json['user_from'] == userId,
        userFromName = json['user_from_name'],
        userFromImage = senderImage,
        type = json['type'];

  Map toMap() {
    return {
      'content': content,
      'user_from': userFrom,
      'mark_as_read': markAsRead,
      'user_from_name': userFromName,
      'type': type
    };
  }
}
