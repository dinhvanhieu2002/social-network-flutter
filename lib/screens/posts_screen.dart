import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:social_network/models/post_model.dart';
import 'package:social_network/models/user_model.dart';
import 'package:social_network/repository/auth_repository.dart';
import 'package:social_network/repository/post_repository.dart';
import 'package:social_network/widgets/post/post_view.dart';

class PostsScreen extends ConsumerStatefulWidget {
  final String currentUserId;
  final String userId;
  final UserModel profileUser;

  const PostsScreen(
      {super.key,
      required this.currentUserId,
      required this.userId,
      required this.profileUser});

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends ConsumerState<PostsScreen> {
  List<PostModel> _posts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupPosts();
  }

  void setupPosts() async {
    List<PostModel> posts = await ref
        .read(postRepositoryProvider)
        .getPostsOfUser(ref.read(userProvider)!.token, widget.userId);
    setState(() {
      _posts = posts;
    });
  }

  buildDisplayPosts() {
    List<PostView> postViews = [];
    for (var post in _posts) {
      postViews.add(
        PostView(
          currentUserId: widget.currentUserId,
          post: post,
          author: widget.profileUser,
          showCommentCount: true,
        ),
      );
    }
    return Column(children: postViews);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (BuildContext context, int index) {
          PostModel post = _posts[index];
          return FutureBuilder(
            future: ref.watch(authRepositoryProvider).getUserWithId(
                  token: ref.watch(userProvider)!.token,
                  userId: post.userId!,
                ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              UserModel author = snapshot.data!;

              return PostView(
                currentUserId: widget.currentUserId,
                post: post,
                author: author,
                showCommentCount: true,
              );
            },
          );
        },
      ),
    );
  }
}
