import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:social_network/models/comment_model.dart';
import 'package:social_network/constants/constants.dart';

final commentRepositoryProvider = Provider((ref) => CommentRepository(
      client: Client(),
    ));

class CommentRepository {
  final Client _client;
  CommentRepository({required Client client}) : _client = client;

  void addComment(String token, String caption, String postId) async {
    final comment = CommentModel(
        caption: caption,
        reactions: null,
        likeCount: null,
        createdAt: null,
        updatedAt: null,
        userId: null,
        postId: postId,
        id: '');

    await _client
        .post(Uri.parse('$host/comments'), body: comment.toJson(), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': token,
    });
  }

  Future<List<CommentModel>> getCommentsOfPost(
      String token, String postId) async {
    var res = await _client.get(Uri.parse('$host/comments/$postId'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': token,
    });

    List<CommentModel> comments = [];
    switch (res.statusCode) {
      case 200:
        for (int i = 0; i < jsonDecode(res.body).length; i++) {
          comments
              .add(CommentModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
        }
        break;
    }

    return comments;
  }

  void likeComment(String token, String id) async {
    await _client.post(Uri.parse('$host/comments/$id/reaction'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': token,
    });
  }

  void removeComment(String token, String id) async {
    await _client.delete(Uri.parse('$host/comments/$id'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': token,
    });
  }
}
