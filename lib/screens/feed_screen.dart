import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:social_network/models/post_model.dart';
import 'package:social_network/models/user_model.dart';
import 'package:social_network/widgets/post/post_view.dart';
import 'package:social_network/repository/post_repository.dart';
import 'package:social_network/repository/auth_repository.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network/widgets/refresh_widget.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  List<PostModel> _posts = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPosts();
  }

  Future loadPosts() async {
    List<PostModel> posts = await ref.read(postRepositoryProvider).getPosts(ref.read(userProvider)!.token);
    setState(() {
      _posts = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.read(userProvider)!.id;
    return Scaffold(
        body: SafeArea(
            child: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      title: const Text(
                        "InsNoob",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Billabong',
                            fontSize: 35),
                      ),
                      floating: true,
                      backgroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      actions: [
                        IconButton(
                          onPressed: () =>
                              Routemaster.of(context).replace('/conversations'),
                          icon: SvgPicture.asset(
                            'assets/images/messenger.svg',
                            width: 24,
                            height: 24,
                          ),
                          color: Colors.black,
                        )
                      ],
                    ),
                  ];
                },
                body: RefreshWidget(
                  onRefresh: loadPosts,
                  child: ListView.builder(
                            itemCount: _posts.length,
                            itemBuilder: (context, index) {
                              PostModel post = _posts[index];
                              return FutureBuilder(
                                future: ref
                                    .watch(authRepositoryProvider)
                                    .getUserWithId(
                                      token: ref.watch(userProvider)!.token,
                                      userId: post.userId!,
                                    ),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const SizedBox.shrink();
                                  }
                                  UserModel author = snapshot.data!;
                
                                  return PostView(
                                    currentUserId: currentUserId,
                                    post: post,
                                    author: author,
                                    showCommentCount: true,
                                  );
                                },
                              );
                            }),
                )
                    )));
  }
}
