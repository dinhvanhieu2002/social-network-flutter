import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network/models/comment_model.dart';
import 'package:social_network/models/error_model.dart';
import 'package:social_network/models/post_model.dart';
import 'package:social_network/models/user_model.dart';
import 'package:social_network/repository/activity_repository.dart';
import 'package:social_network/repository/auth_repository.dart';
import 'package:social_network/repository/comment_repository.dart';
import 'package:social_network/widgets/loader.dart';

class CommentView extends ConsumerStatefulWidget {
  final String currentUserId;
  final PostModel post;
  final UserModel author;

  const CommentView(
      {super.key,
      required this.currentUserId,
      required this.post,
      required this.author});

  @override
  _CommentViewState createState() => _CommentViewState();
}

class _CommentViewState extends ConsumerState<CommentView> {
  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;
  int _commentCount = 0;
  ErrorModel? errorModel;
  @override
  void initState() {
    super.initState();
    _initCommentCount();
  }

  _initCommentCount() async {
    List<CommentModel> comments = await ref
        .read(commentRepositoryProvider)
        .getCommentsOfPost(ref.read(userProvider)!.token, widget.post.id);

    if (mounted) {
      setState(() {
        _commentCount = comments.length;
      });
    }
  }

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
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.grey,
            backgroundImage: CachedNetworkImageProvider(author.avatar),
          ),
          title: Text(author.username!),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(comment.caption),
              const SizedBox(height: 6.0),
              Text(
                DateFormat.yMd()
                    .add_jm()
                    .format(DateTime.parse(comment.createdAt!)),
              ),
            ],
          ),
        );
      },
    );
  }

  buildCommentTF() {
    return IconTheme(
      data: IconThemeData(
        color: _isCommenting
            ? Theme.of(context).focusColor
            : Theme.of(context).disabledColor,
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

  void showCommentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Center(
                child: Text(
                  "Comments",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: FutureBuilder(
                  future: ref
                      .watch(commentRepositoryProvider)
                      .getCommentsOfPost(
                          ref.watch(userProvider)!.token, widget.post.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    }
                    final List<CommentModel> comments = snapshot.data!;
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          CommentModel comment = comments[index];
                          return _buildComment(comment);
                        });
                  }),
            ),
            const Divider(height: 1.0),
            buildCommentTF(),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _commentCount > 0
        ? Container(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            margin: const EdgeInsets.only(
              left: 20.0,
            ),
            child: GestureDetector(
              onTap: () => showCommentModal(context),
              child: Text("View $_commentCount comments"),
            ),
          )
        : const SizedBox(height: 8.0);
  }
}
