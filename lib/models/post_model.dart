import 'dart:convert';

class PostModel {
  final String caption;
  final String photo;
  final List<String>? reactions;
  final int? likeCount;
  final String id;
  final String? userId;
  final String? createdAt;
  final String? updatedAt;

  PostModel(
      {required this.caption,
      required this.photo,
      required this.reactions,
      required this.likeCount,
      required this.id,
      required this.userId,
      required this.createdAt,
      required this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      'caption': caption,
      'photo': photo,
      'reactions': reactions,
      'likeCount': likeCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'id': id,
      'userId': userId,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      caption: map['caption'] ?? '',
      photo: map['photo'],
      reactions: List.from(map['reactions']),
      likeCount: map['likeCount'] ?? 0,
      userId: map['userId'] ?? '',
      createdAt: map['createdAt'] ?? "",
      updatedAt: map['createdAt'] ?? "",
      id: map['id'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source));
}
