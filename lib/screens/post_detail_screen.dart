import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network/models/comment_model.dart';
import 'package:social_network/models/post_model.dart';
import 'package:social_network/models/user_model.dart';
import 'package:intl/intl.dart';
import 'package:social_network/repository/activity_repository.dart';
import 'package:social_network/repository/auth_repository.dart';
import 'package:social_network/repository/comment_repository.dart';
import 'package:social_network/widgets/post/post_view.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final PostModel post;

  const PostDetailScreen({super.key, required this.post});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;

  _buildComment(CommentModel comment) {
    return FutureBuilder(
      future: ref.watch(authRepositoryProvider).getUserWithId(
          token: ref.watch(userProvider)!.token, userId: comment.userId!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        UserModel author = snapshot.data!;
        return ListTile(
          tileColor: Colors.white,
          leading: CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.grey,
            backgroundImage: CachedNetworkImageProvider(author.avatar),
          ),
          title: Text(author.username!, style: const TextStyle(fontSize: 14)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(comment.caption, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 6.0),
              Text(
                DateFormat.yMd()
                    .add_jm()
                    .format(DateTime.parse(comment.createdAt!, )),
                    style: const TextStyle(fontSize: 10)
              ),
            ],
          ),
        );
      },
    );
  }

  _buildCommentTF() {
    return IconTheme(
      data: IconThemeData(
        color: _isCommenting ? Colors.blue : Theme.of(context).disabledColor,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(width: 10.0),
            Expanded(
              child: TextField(
                controller: _commentController,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
                onChanged: (comment) {
                  setState(() {
                    _isCommenting = comment.isNotEmpty;
                  });
                },
                decoration: const InputDecoration.collapsed(
                    hintText: 'Write a comment...'),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (_isCommenting) {
                    ref.watch(commentRepositoryProvider).addComment(
                        ref.watch(userProvider)!.token,
                        _commentController.text,
                        widget.post.id);

                    ref.watch(activityRepositoryProvider).addActivity(
                        ref.watch(userProvider)!.token,
                        ref.watch(userProvider)!.id,
                        widget.post,
                        _commentController.text);
                    _commentController.clear();
                    setState(() {
                      _isCommenting = false;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.read(userProvider)!.id;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
        centerTitle: true,
        title: const Text(
          'Post',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                  future: ref.watch(authRepositoryProvider).getUserWithId(
                      token: ref.watch(userProvider)!.token,
                      userId: widget.post.userId!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }
                    UserModel author = snapshot.data!;
                    return PostView(
                        currentUserId: currentUserId,
                        post: widget.post,
                        author: author,
                        showCommentCount: false,);
                  }),
              const Divider(
                height: 1.0,
              ),
              FutureBuilder(
                future: ref.watch(commentRepositoryProvider).getCommentsOfPost(
                    ref.watch(userProvider)!.token, widget.post.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      CommentModel comment = snapshot.data![index];
                      return _buildComment(comment);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: _buildCommentTF(),
      ),
    );
  }
}
