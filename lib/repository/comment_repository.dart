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

  Future<CommentModel> addComment(String token, String caption, String postId) async {
    
    try {
      final comment = CommentModel(
          caption: caption,
          reactions: null,
          likeCount: null,
          createdAt: null,
          updatedAt: null,
          userId: null,
          postId: postId,
          id: '');

      var res = await _client
          .post(Uri.parse('$host/comments'), body: comment.toJson(), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      });

      if(res.statusCode == 201) {
          // final data = jsonDecode(res.body)[''] as Map<String, dynamic>;
          // final results = List<Map<String, dynamic>>.from(data['results'] as List);
          // return results.map(Photo.fromMap).toList();
        
          CommentModel commentModel = comment.copyWith(
            caption: jsonDecode(res.body)['caption'],
            reactions: List.from(jsonDecode(res.body)['reactions']),
            likeCount: jsonDecode(res.body)['likeCount'] as int,
            createdAt: jsonDecode(res.body)['createdAt'],
            updatedAt: jsonDecode(res.body)['updatedAt'],
            userId: jsonDecode(res.body)['userId'],
            postId: jsonDecode(res.body)['postId'],
            id: jsonDecode(res.body)['id']
          );
          return commentModel;

      }
      throw Exception("something went wrong");
    } catch (e) {
            throw Exception(e);

    }
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

  // Stream<List<CommentModel>> getCommentsOfPost(
  //     String token, String postId) async* {
  //   while(true) {
  //     var res = await _client.get(Uri.parse('$host/comments/$postId'), headers: {
  //     'Content-Type': 'application/json; charset=UTF-8',
  //     'x-auth-token': token,
  //   });

  //   List<CommentModel> comments = [];
  //   if(res.statusCode == 200) {
  //     for (int i = 0; i < jsonDecode(res.body).length; i++) {
  //         comments
  //             .add(CommentModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
  //       }
  //       // yield comments;
  //   } else {
  //     //  yield [];
  //   }
  //   yield comments;
  //    await Future.delayed(const Duration(minutes: 5));
  //   }
  // }

  Future<void> likeComment(String token, String id) async {
    try {
      await _client.post(Uri.parse('$host/comments/$id/reaction'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      });
      
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> removeComment(String token, String id) async {
    try {
      var res = await _client.delete(Uri.parse('$host/comments/$id'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      });

      switch(res.statusCode) {
        case 200: 
           print('remove comment success');
      }
      
    } catch (e) {
      throw Exception(e);
    }
  }
}
