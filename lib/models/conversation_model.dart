import 'dart:convert';

class ConversationModel {
  final String id;
  final String? lastMessageAt;
  final List<String>? messages;
  final List<String> users;
  final String? createdAt;
  final String? updatedAt;
  ConversationModel({
    required this.id,
    required this.lastMessageAt,
    required this.messages,
    required this.users,
    required this.createdAt,
    required this.updatedAt,
  });


  ConversationModel copyWith({
    String? id,
    String? lastMessageAt,
    List<String>? messages,
    List<String>? users,
    String? createdAt,
    String? updatedAt,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      messages: messages ?? this.messages,
      users: users ?? this.users,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'lastMessageAt': lastMessageAt,
      'messages': messages,
      'users': users,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      id: map['id'] ?? '',
      lastMessageAt: map['lastMessageAt'] ?? '',
      messages: List<String>.from(map['messages']),
      users: List<String>.from(map['users']),
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationModel.fromJson(String source) => ConversationModel.fromMap(json.decode(source));
}
