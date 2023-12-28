import 'dart:convert';

class CommentModel {
  final String caption;
  final List<String>? reactions;
  final int? likeCount;
  final String id;
  final String postId;
  final String? userId;
  final String? createdAt;
  final String? updatedAt;

  CommentModel(
      {required this.caption,
      required this.reactions,
      required this.likeCount,
      required this.id,
      required this.postId,
      required this.userId,
      required this.createdAt,
      required this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      'caption': caption,
      'reactions': reactions,
      'likeCount': likeCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'postId': postId,
      'id': id,
      'userId': userId,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      caption: map['caption'] ?? '',
      reactions: List.from(map['reactions']),
      likeCount: map['likeCount'] ?? 0,
      userId: map['userId'] ?? '',
      postId: map['postId'] ?? '',
      createdAt: map['createdAt'] ?? "",
      updatedAt: map['createdAt'] ?? "",
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source));

  CommentModel copyWith(
      {String? caption,
      String? photo,
      List<String>? reactions,
      int? likeCount,
      String? id,
      String? postId,
      String? createdAt,
      String? updatedAt,
      String? userId}) {
    return CommentModel(
        caption: caption ?? this.caption,
        reactions: reactions ?? this.reactions,
        likeCount: likeCount ?? this.likeCount,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        id: id ?? this.id,
        userId: userId ?? this.userId,
        postId: postId ?? this.postId);
  }
}
