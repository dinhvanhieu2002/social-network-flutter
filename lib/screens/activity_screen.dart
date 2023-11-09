import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network/models/activity_model.dart';
import 'package:social_network/models/post_model.dart';
import 'package:social_network/models/user_model.dart';
import 'package:intl/intl.dart';
import 'package:social_network/repository/activity_repository.dart';
import 'package:social_network/repository/auth_repository.dart';
import 'package:social_network/repository/post_repository.dart';
import 'package:social_network/screens/post_detail_screen.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  final String currentUserId;

  const ActivityScreen({super.key, required this.currentUserId});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  List<ActivityModel> _activities = [];

  @override
  void initState() {
    super.initState();
    _setupActivities();
  }

  _setupActivities() async {
    List<ActivityModel> activities = await ref
        .read(activityRepositoryProvider)
        .getActivities(ref.read(userProvider)!.token);
    if (mounted) {
      setState(() {
        _activities = activities;
      });
    }
  }

  _buildActivity(ActivityModel activity) {
    return FutureBuilder(
      future: ref.watch(authRepositoryProvider).getUserWithId(
          token: ref.watch(userProvider)!.token, userId: activity.fromUserId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        UserModel user = snapshot.data!;
        return ListTile(
          leading: CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.grey,
            backgroundImage: CachedNetworkImageProvider(user.avatar),
          ),
          title: Text('${user.username} commented: "${activity.comment}"'),
          subtitle: Text(
            DateFormat.yMd()
                .add_jm()
                .format(DateTime.parse(activity.createdAt!)),
          ),
          trailing: CachedNetworkImage(
            imageUrl: activity.postImageUrl,
            height: 40.0,
            width: 40.0,
            fit: BoxFit.cover,
          ),
          onTap: () async {
            PostModel post = await ref
                .watch(postRepositoryProvider)
                .getPostById(ref.watch(userProvider)!.token, activity.postId);
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PostDetailScreen(post: post),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: const Text(
          'Activities',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _setupActivities(),
        child: ListView.builder(
          itemCount: _activities.length,
          itemBuilder: (BuildContext context, int index) {
            ActivityModel activity = _activities[index];
            return _buildActivity(activity);
          },
        ),
      ),
    );
  }
}
