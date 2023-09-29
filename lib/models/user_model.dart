import 'dart:convert';

class UserModel {
  final String email;
  final String? username;
  final String fullName;
  final String? password;
  final String avatar;
  final String uid;
  final String token;

  UserModel({
    required this.email,
    required this.username,
    required this.fullName,
    required this.avatar,
    required this.password,
    required this.uid,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'fullName': fullName,
      'avatar': avatar,
      'password': password,
      'uid': uid,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      username: map['username'],
      fullName: map['fullName'] ?? '',
      avatar: map['avatar'] ?? '',
      password: map['password'],
      uid: map['_id'] ?? '',
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
    String? password,
    String? uid,
    String? token,
  }) {
    return UserModel(
      email: email ?? this.email,
      username: username,
      fullName: fullName ?? this.fullName,
      avatar: avatar ?? this.avatar,
      password: password,
      uid: uid ?? this.uid,
      token: token ?? this.token,
    );
  }
}
