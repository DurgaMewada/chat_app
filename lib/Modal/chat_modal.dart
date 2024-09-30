import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModal {
  String? sender;
  String? receiver;
  String? message;
  String? image;

  Timestamp time;
  bool isEdited;


  ChatModal({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.image,
    required this.time,
    this.isEdited = false,
  });


  factory ChatModal.fromMap(Map<String, dynamic> map) {
    return ChatModal(
      sender: map['sender'] as String?,
      receiver: map['receiver'] as String?,
      message: map['message'] as String? ,
      image: map['image'] ,
      time: map['time'] as Timestamp,
      isEdited: map['isEdited'] ?? false,
    );
  }


  Map<String, dynamic> toMap(ChatModal chat) {
    return {
      'sender': chat.sender,
      'receiver': chat.receiver,
      'message': chat.message,
      'image': chat.image,
      'time': chat.time,
      'isEdited': chat.isEdited,
    };
  }
}