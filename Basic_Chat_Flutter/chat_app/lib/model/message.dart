class Message {
  String message;
  String sentByMe;

  Message({required this.message, required this.sentByMe});

factory Message.fromJson(Map<String, dynamic> json) {
  return Message(
    message: json["message"] ?? "", // Provide a default value if message is null
    sentByMe: json["sentByMe"] ?? "", // Provide a default value if sentByMe is null
  );
}
}