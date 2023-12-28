import 'dart:convert';

class MessageModel {
  final String id;
  final String conversationId;
  final String sender;
  final String? image;
  final String? body;
  final String? createdAt;
  final String? updatedAt;
  MessageModel({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.image,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
  });


  MessageModel copyWith({
    String? id,
    String? conversationId,
    String? sender,
    String? image,
    String? body,
    String? createdAt,
    String? updatedAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      sender: sender ?? this.sender,
      image: image ?? this.image,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'conversationId': conversationId,
      'sender': sender,
      'image': image,
      'body': body,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      conversationId: map['conversationId'] ?? '',
      sender: map['sender'] ?? '',
      image: map['image'] ?? '',
      body: map['body'] ?? '',
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) => MessageModel.fromMap(json.decode(source));
}
