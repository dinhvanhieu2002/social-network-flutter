import 'dart:async';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network/models/comment_model.dart';
import 'package:social_network/models/error_model.dart';
import 'package:social_network/models/post_model.dart';
import 'package:social_network/models/user_model.dart';
import 'package:social_network/repository/activity_repository.dart';
import 'package:social_network/repository/auth_repository.dart';
import 'package:social_network/repository/comment_repository.dart';
import 'package:social_network/repository/post_repository.dart';
import 'package:social_network/screens/profile_screen.dart';

class PostView extends ConsumerStatefulWidget {
  final String currentUserId;
  final PostModel post;
  final UserModel author;
  final bool showCommentCount;

  const PostView(
      {super.key,
      required this.currentUserId,
      required this.post,
      required this.author,
      required this.showCommentCount});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends ConsumerState<PostView> {
  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;
  int _commentCount = 0;
  List<CommentModel>? _comments;
  int _likeCount = 0;
  bool _isLiked = false;
  bool _heartAnim = false;
  ErrorModel? errorModel;
  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.likeCount!;
    _initPostLiked();
    _initComments();
  }

  @override
  void didUpdateWidget(PostView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.likeCount != widget.post.likeCount) {
      _likeCount = widget.post.likeCount!;
    }
  }

  _initComments() async {
    List<CommentModel> comments = await ref
        .read(commentRepositoryProvider)
        .getCommentsOfPost(ref.read(userProvider)!.token, widget.post.id);

    if (mounted) {
      setState(() {
        _commentCount = comments.length;
        _comments = comments;
      });
    }
  }

  _initPostLiked() async {
    bool isLiked = await ref.read(postRepositoryProvider).didLikedPost(
        token: ref.read(userProvider)!.token,
        currentUserId: widget.currentUserId,
        post: widget.post);

    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  _likePost() async {
    if (_isLiked) {
      // Unlike Post
      await ref
          .read(postRepositoryProvider)
          .unlikePost(ref.watch(userProvider)!.token, widget.post.id);
      setState(() {
        _isLiked = false;
        _likeCount = _likeCount - 1;
      });
    } else {
      // Like Post
      await ref
          .read(postRepositoryProvider)
          .likePost(ref.watch(userProvider)!.token, widget.post.id);

      setState(() {
        _heartAnim = true;
        _isLiked = true;
        _likeCount = _likeCount + 1;
      });
      Timer(const Duration(milliseconds: 350), () {
        setState(() {
          _heartAnim = false;
        });
      });
    }
  }

  void deleteFunction(CommentModel comment) async {
    print('do remove');
    await ref.watch(commentRepositoryProvider).removeComment(widget.currentUserId, comment.id);
    setState(() {
      _comments!.removeWhere((element) => element.id == comment.id);
      _commentCount--;
    });
  }

  void moreFunction(CommentModel comment) {}

  _buildComment(CommentModel comment) {
    return FutureBuilder(
      future: ref.watch(authRepositoryProvider).getUserWithId(
          token: ref.watch(userProvider)!.token, userId: comment.userId!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        UserModel author = snapshot.data!;
        return author.id == widget.currentUserId
            ? Slidable(
                endActionPane:
                    ActionPane(motion: const StretchMotion(), children: [
                  SlidableAction(
                    onPressed: (context) => moreFunction(comment),
                    icon: Icons.more_horiz_outlined,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  SlidableAction(
                    onPressed: (context) => deleteFunction(comment),
                    icon: Icons.delete,
                    backgroundColor: Colors.red.shade300,
                  )
                ]),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(author.avatar),
                  ),
                  title: Row(
                    children: [
                      Text(author.username!, style: const TextStyle(fontSize: 14)),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        timeago.format(DateTime.parse(comment.createdAt!)),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(comment.caption, style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 6.0),
                    ],
                  ),
                ),
              )
            : ListTile(
                leading: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(author.avatar),
                ),
                title: Row(
                  children: [
                    Text(author.username!),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      timeago.format(DateTime.parse(comment.createdAt!)),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(comment.caption),
                    const SizedBox(height: 6.0),
                  ],
                ),
              );
      },
    );
  }

  void updateComments(CommentModel comment) {
    setState(() {
      _comments = [comment, ..._comments!];
      _commentCount++;
      _isCommenting = false;
    });
  }

  buildCommentTF() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) => 
       IconTheme(
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
                  onPressed: () async {
                    if (_isCommenting) {
                      CommentModel? newComment = await ref.watch(commentRepositoryProvider).addComment(
                          ref.watch(userProvider)!.token,
                          _commentController.text,
                          widget.post.id);
    
                      await ref.watch(activityRepositoryProvider).addActivity(
                          ref.watch(userProvider)!.token,
                          ref.watch(userProvider)!.id,
                          widget.post,
                          _commentController.text);
                      _commentController.clear();
                      print("new comment ${newComment.id}");
                      
                      updateComments(newComment);
                    }
                  },
                ),
              ),
            ],
          ),
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
            _commentCount != 0 || _comments != null
                ? Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _commentCount,
                        itemBuilder: (context, index) {
                          CommentModel comment = _comments![index];
                          return _buildComment(comment);
                        }),
                  )
                : const Expanded(
                    child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No comments yet',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text('Start the new comment')
                        ]),
                  )),
            const Divider(height: 1.0),
            buildCommentTF(),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(
                  currentUserId: widget.currentUserId,
                  userId: widget.post.userId!,
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10.0,
              ),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    
                    radius: 20.0,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        CachedNetworkImageProvider(widget.author.avatar),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    widget.author.username!,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onDoubleTap: _likePost,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.post.photo),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                _heartAnim
                    ? Animator(
                        duration: const Duration(milliseconds: 300),
                        tween: Tween(begin: 0.5, end: 1.4),
                        curve: Curves.elasticOut,
                        builder: (context, anim, child) => Transform.scale(
                          scale: anim.value,
                          child: Icon(
                            Icons.favorite,
                            size: 100.0,
                            color: Colors.red[400],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: _isLiked
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(Icons.favorite_border),
                      iconSize: 24.0,
                      onPressed: _likePost,
                    ),
                    IconButton(
                        icon: const Icon(Icons.mode_comment_outlined),
                        iconSize: 24.0,
                        onPressed: () => showCommentModal(context)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    '${_likeCount.toString()} likes',
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(
                        left: 12.0,
                        right: 6.0,
                      ),
                      child: Text(
                        widget.author.username.toString(),
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.post.caption,
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                widget.showCommentCount && _commentCount != 0
                    ? Container(
                        margin: const EdgeInsets.only(
                          left: 12.0,
                        ),
                        child: GestureDetector(
                          onTap: () => showCommentModal(context),
                          child: Text(
                            "View $_commentCount comments",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      )
                    : const SizedBox(
                        height: 0.0,
                      ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: Text(
                    timeago.format(DateTime.parse(widget.post.createdAt!)),
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
