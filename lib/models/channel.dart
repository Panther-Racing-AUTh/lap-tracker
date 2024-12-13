class Channel {
  int id;
  String name;

  Channel({required this.id, required this.name});
  Channel.fromJson(Map json)
      : id = json['id'],
        name = json['name'];
}
