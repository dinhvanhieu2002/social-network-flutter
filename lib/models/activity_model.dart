import 'dart:convert';

class ActivityModel {
  final String fromUserId;
  final String toUserId;
  final String postId;
  final String postImageUrl;
  final String comment;
  final String? createdAt;
  final String? updatedAt;

  ActivityModel(
      {required this.fromUserId,
      required this.toUserId,
      required this.postId,
      required this.postImageUrl,
      required this.comment,
      required this.createdAt,
      required this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'postId': postId,
      'postImageUrl': postImageUrl,
      'comment': comment,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      fromUserId: map['fromUserId'] ?? '',
      toUserId: map['toUserId'] ?? "",
      postId: map['postId'] ?? "",
      postImageUrl: map['postImageUrl'] ?? '',
      comment: map['comment'] ?? "",
      createdAt: map['createdAt'] ?? "",
      updatedAt: map['createdAt'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityModel.fromJson(String source) =>
      ActivityModel.fromMap(json.decode(source));
}
