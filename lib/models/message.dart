class Message {
  final int id;
  final String content;
  final int userFromId;
  final DateTime createAt;
  final bool isMine;
  final String userFromImage;
  final String type;

  Message({
    required this.id,
    required this.content,
    required this.userFromId,
    required this.createAt,
    required this.isMine,
    required this.userFromImage,
    required this.type,
  });

  Message.createText({
    required this.content,
    required this.userFromId,
  })  : id = 0,
        isMine = true,
        createAt = DateTime.now(),
        userFromImage = '',
        type = 'text';

  Message.createImage({
    required this.content,
    required this.userFromId,
  })  : id = 0,
        isMine = true,
        createAt = DateTime.now(),
        userFromImage = '',
        type = 'image';

  Message.createChart({
    required this.content,
    required this.userFromId,
  })  : id = 0,
        isMine = true,
        createAt = DateTime.now(),
        userFromImage = '',
        type = 'chart';

  Message.fromJson(Map<String, dynamic> json, int senderId, String senderImage)
      : id = senderId,
        content = json['content'],
        userFromId = json['user_from'],
        createAt = DateTime.parse(json['created_at']),
        isMine = json['user_from'] == senderId,
        userFromImage = senderImage,
        type = json['type'];

  Map toMap() {
    return {'content': content, 'user_from': userFromId, 'type': type};
  }
}
