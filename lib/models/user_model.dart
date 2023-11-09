import 'dart:convert';

class UserModel {
  final String email;
  final String? username;
  final String fullName;
  final String? password;
  final String avatar;
  final String bio;
  final List<dynamic> following;
  final List<dynamic> followers;
  final String id;
  final String token;

  UserModel({
    required this.email,
    required this.username,
    required this.fullName,
    required this.avatar,
    required this.bio,
    required this.password,
    required this.following,
    required this.followers,
    required this.id,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'fullName': fullName,
      'avatar': avatar,
      'bio': bio,
      'password': password,
      'following': following,
      'followers': followers,
      'id': id,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      username: map['username'],
      fullName: map['fullName'] ?? '',
      avatar: map['avatar'] ?? '',
      bio: map['bio'] ?? '',
      password: map['password'],
      following: map['following'] ?? [],
      followers: map['followers'] ?? [],
      id: map['id'] ?? '',
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? email,
    String? username,
    String? fullName,
    String? avatar,
    String? bio,
    String? password,
    List<String>? following,
    List<String>? followers,
    String? id,
    String? token,
  }) {
    return UserModel(
      email: email ?? this.email,
      username: username,
      fullName: fullName ?? this.fullName,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      password: password,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      id: id ?? this.id,
      token: token ?? this.token,
    );
  }
}
