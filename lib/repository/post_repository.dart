import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:social_network/models/error_model.dart';
import 'package:social_network/models/post_model.dart';
import 'package:social_network/constants/constants.dart';

final postRepositoryProvider = Provider((ref) => PostRepository(
      client: Client(),
    ));

class PostRepository {
  final Client _client;
  PostRepository({required Client client}) : _client = client;

  Future<ErrorModel> createPost(
      {required String token,
      required String caption,
      required String photo}) async {
    ErrorModel error =
        ErrorModel(error: 'Some unexpected error occurred', data: null);

    try {
      final post = PostModel(
          caption: caption,
          photo: photo,
          reactions: null,
          likeCount: null,
          createdAt: null,
          updatedAt: null,
          userId: "",
          id: "");

      var res = await _client
          .post(Uri.parse('$host/posts'), body: post.toJson(), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      });

      switch (res.statusCode) {
        case 200:
          error = ErrorModel(error: null, data: PostModel.fromJson(res.body));
          break;
        default:
          error = ErrorModel(
            error: res.body,
            data: null,
          );
          break;
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<List<PostModel>> getPosts(String token) async {
    var res = await _client.get(Uri.parse('$host/posts'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': token,
    });
    List<PostModel> posts = [];
    switch (res.statusCode) {
      case 200:
        for (int i = 0; i < jsonDecode(res.body).length; i++) {
          posts.add(PostModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
        }
        break;
    }
    return posts;
  }

  Future<List<PostModel>> getPostsOfUser(String token, String userId) async {
    var res =
        await _client.get(Uri.parse('$host/posts/user/$userId'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': token,
    });

    List<PostModel> posts = [];
    switch (res.statusCode) {
      case 200:
        for (int i = 0; i < jsonDecode(res.body).length; i++) {
          posts.add(PostModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
        }
    }

    return posts;
  }

  Future<PostModel> getPostById(String token, String postId) async {
    var res = await _client.get(Uri.parse('$host/posts/$postId'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': token,
    });

    PostModel? post;
    switch (res.statusCode) {
      case 200:
        post = PostModel.fromJson(jsonEncode(jsonDecode(res.body)));
        break;
    }

    return post!;
  }

  Future<bool> didLikedPost(
      {required String token,
      required String currentUserId,
      required PostModel post}) async {
    try {
      final res =
          await _client.get(Uri.parse('$host/posts/${post.id}'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      });

      final postItem = PostModel.fromJson(res.body);
      if (postItem.reactions!.contains(currentUserId)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void likePost(String token, String id) async {
    await _client.post(Uri.parse('$host/posts/$id/like'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': token,
    });
  }

  void unlikePost(String token, String id) async {
    await _client.post(Uri.parse('$host/posts/$id/unlike'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': token,
    });
  }

  void removePost(String token, String id) async {
    await _client.delete(Uri.parse('$host/posts/$id'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': token,
    });
  }

  void updatePost(
      {required String token,
      required String id,
      required String caption}) async {
    await _client.put(Uri.parse('$host/posts/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({'caption': caption}));
  }
}
