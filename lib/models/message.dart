class Message {
  final String content;
  final int userFromId;
  final DateTime createAt;
  final bool isMine;
  final String userFromImage;
  final String type;
  final int channelId;
  Message({
    required this.content,
    required this.userFromId,
    required this.createAt,
    required this.isMine,
    required this.userFromImage,
    required this.type,
    required this.channelId,
  });

  Message.createText({
    required this.content,
    required this.userFromId,
    required this.channelId,
  })  : isMine = true,
        createAt = DateTime.now(),
        userFromImage = '',
        type = 'text';

  Message.createImage({
    required this.content,
    required this.userFromId,
    required this.channelId,
  })  : isMine = true,
        createAt = DateTime.now(),
        userFromImage = '',
        type = 'image';

  Message.createChart({
    required this.content,
    required this.userFromId,
    required this.channelId,
  })  : isMine = true,
        createAt = DateTime.now(),
        userFromImage = '',
        type = 'chart';

  Message.fromJson(Map<String, dynamic> json, int senderId, String senderImage)
      : content = json['content'],
        userFromId = json['user_id'],
        createAt = DateTime.parse(json['created_at']),
        isMine = json['user_id'] == senderId,
        userFromImage = senderImage,
        type = json['type'],
        channelId = json['channel_id'];

  Map toMap() {
    return {
      'content': content,
      'user_id': userFromId,
      'type': type,
      'channel_id': channelId
    };
  }
}
