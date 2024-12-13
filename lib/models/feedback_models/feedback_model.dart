class FeedbackModel{
  String user;
  double starRate;
  String message;

  FeedbackModel({required this.user,this.starRate=0.0,required this.message});

  Map<String, dynamic> toMap() {
    return {
      'user': user ,
      'star_rate': starRate, // Format date/time as string
      'message': message,
    };
  }
  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      user: map['user'],
      starRate: map['star_rate'],
      message: map['message'] as String,
    );
  }

}
