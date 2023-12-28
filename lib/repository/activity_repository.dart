import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:social_network/constants/constants.dart';
import 'package:social_network/models/activity_model.dart';
import 'package:social_network/models/post_model.dart';

final activityRepositoryProvider = Provider((ref) => ActivityRepository(
      client: Client(),
    ));

class ActivityRepository {
  final Client _client;
  ActivityRepository({required Client client}) : _client = client;

  Future<void> addActivity(String token, String currentUserId, PostModel post,
      String comment) async {
    try {
      print(' add activity');
      final activity = ActivityModel(
          fromUserId: currentUserId,
          toUserId: post.userId!,
          postId: post.id,
          postImageUrl: post.photo,
          comment: comment,
          createdAt: null,
          updatedAt: null);

      if (currentUserId != post.userId) {
        var res = await _client.post(Uri.parse('$host/activities'),
            body: activity.toJson(),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token,
            });

        print(jsonDecode(res.body)['error']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<ActivityModel>> getActivities(String token) async {
    var res = await _client.get(Uri.parse('$host/activities'), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'x-auth-token': token,
    });
    List<ActivityModel> activities = [];
    if (res.statusCode == 200) {
      for (int i = 0; i < jsonDecode(res.body).length; i++) {
        activities
            .add(ActivityModel.fromJson(jsonEncode(jsonDecode(res.body)[i])));
      }
    }
    return activities;
  }
}
