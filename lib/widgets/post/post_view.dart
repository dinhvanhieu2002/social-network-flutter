import 'dart:async';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network/models/error_model.dart';
import 'package:social_network/models/post_model.dart';
import 'package:social_network/models/user_model.dart';
import 'package:social_network/repository/auth_repository.dart';
import 'package:social_network/repository/post_repository.dart';
import 'package:social_network/screens/profile_screen.dart';

class PostView extends ConsumerStatefulWidget {
  final String currentUserId;
  final PostModel post;
  final UserModel author;

  const PostView(
      {super.key,
      required this.currentUserId,
      required this.post,
      required this.author});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends ConsumerState<PostView> {
  int _likeCount = 0;
  bool _isLiked = false;
  bool _heartAnim = false;
  ErrorModel? errorModel;
  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.likeCount!;
    _initPostLiked();
  }

  @override
  void didUpdateWidget(PostView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.likeCount != widget.post.likeCount) {
      _likeCount = widget.post.likeCount!;
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

  _likePost() {
    if (_isLiked) {
      // Unlike Post
      ref
          .read(postRepositoryProvider)
          .unlikePost(ref.watch(userProvider)!.token, widget.post.id);
      setState(() {
        _isLiked = false;
        _likeCount = _likeCount - 1;
      });
    } else {
      // Like Post
      ref
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
                    radius: 25.0,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        CachedNetworkImageProvider(widget.author.avatar),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    widget.author.username!,
                    style: const TextStyle(
                      fontSize: 18.0,
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
                      iconSize: 30.0,
                      onPressed: _likePost,
                    ),
                    IconButton(
                        icon: const Icon(Icons.comment),
                        iconSize: 30.0,
                        onPressed: () {}),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    '${_likeCount.toString()} likes',
                    style: const TextStyle(
                      fontSize: 16.0,
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
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.post.caption,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                // CommentView(
                //     currentUserId: widget.currentUserId,
                //     post: widget.post,
                //     author: widget.author),
                // const SizedBox(height: 8.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
