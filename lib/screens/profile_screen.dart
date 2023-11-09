import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network/models/error_model.dart';
import 'package:social_network/models/post_model.dart';
import 'package:social_network/models/user_model.dart';
import 'package:social_network/repository/auth_repository.dart';
import 'package:social_network/repository/post_repository.dart';
import 'package:social_network/screens/edit_profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:social_network/screens/post_detail_screen.dart';
import 'package:social_network/widgets/post/post_view.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String currentUserId;
  final String userId;

  const ProfileScreen(
      {super.key, required this.currentUserId, required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  ErrorModel? errorModel;

  bool _isFollowing = false;
  int _followerCount = 0;
  int _followingCount = 0;
  List<PostModel> _posts = [];
  int _displayPosts = 0; // 0 - grid, 1 - column
  UserModel? _profileUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupProfile();
    setupPosts();
  }

  void setupProfile() async {
    String token = ref.read(userProvider)!.token;
    UserModel user = await ref
        .read(authRepositoryProvider)
        .getUserWithId(token: token, userId: widget.userId);

    bool isFollowingUser = user.following.contains(widget.currentUserId);

    setState(() {
      _profileUser = user;
      _isFollowing = isFollowingUser;
      _followingCount = user.following.length;
      _followerCount = user.followers.length;
    });
  }

  void setupPosts() async {
    List<PostModel> posts = await ref
        .read(postRepositoryProvider)
        .getPostsOfUser(ref.read(userProvider)!.token, widget.userId);
    setState(() {
      _posts = posts;
    });
  }

  followOrUnfollow() {
    if (_isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  _followUser() async {
    String token = ref.read(userProvider)!.token;
    ref.read(authRepositoryProvider).follow(token, widget.userId);
    setState(() {
      _isFollowing = true;
      _followerCount++;
    });
  }

  _unfollowUser() {
    String token = ref.read(userProvider)!.token;
    ref.read(authRepositoryProvider).unfollow(token, widget.userId);
    setState(() {
      _isFollowing = false;
      _followerCount--;
    });
  }

  Widget displayButton(UserModel user, WidgetRef ref) {
    return user.id == ref.watch(userProvider)!.id
        ? SizedBox(
            width: 200.0,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfileScreen(
                    user: user,
                    updateUser: (UserModel updateUser) {
                      // Trigger state rebuild after editing profile
                      UserModel updatedUser = UserModel(
                          id: updateUser.id,
                          username: updateUser.username,
                          email: user.email,
                          avatar: updateUser.avatar,
                          bio: updateUser.bio,
                          fullName: updateUser.fullName,
                          password: updateUser.password,
                          followers: updateUser.followers,
                          following: updateUser.following,
                          token: updateUser.token);
                      setState(() => _profileUser = updatedUser);
                    },
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  textStyle: const TextStyle(color: Colors.white)),
              child: const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          )
        : SizedBox(
            width: 200.0,
            child: ElevatedButton(
              // _followOrUnfollow
              onPressed: () => {},
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isFollowing ? Colors.grey[200] : Colors.blue,
                  textStyle: TextStyle(
                    color: _isFollowing ? Colors.black : Colors.white,
                  )),
              child: Text(
                _isFollowing ? 'Unfollow' : 'Follow',
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
          );
  }

  buildProfileInfo(UserModel user) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundImage: CachedNetworkImageProvider(
                  user.avatar,
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              _posts.length.toString(),
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              'posts',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              _followerCount.toString(),
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              'followers',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              _followingCount.toString(),
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              'following',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                    displayButton(user, ref),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _profileUser != null ? _profileUser!.fullName : "Loading...",
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _profileUser != null ? _profileUser!.bio : "Loading...",
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ],
    );
  }

  buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.grid_on),
          iconSize: 30.0,
          color: _displayPosts == 0
              ? Theme.of(context).primaryColor
              : Colors.grey[300],
          onPressed: () => setState(() {
            _displayPosts = 0;
          }),
        ),
        IconButton(
          icon: const Icon(Icons.list),
          iconSize: 30.0,
          color: _displayPosts == 1
              ? Theme.of(context).primaryColor
              : Colors.grey[300],
          onPressed: () => setState(() {
            _displayPosts = 1;
          }),
        ),
      ],
    );
  }

  buildTilePost(PostModel post) {
    return GridTile(
      child: GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => PostDetailScreen(post: post))),
        child: Image(
          image: CachedNetworkImageProvider(post.photo),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  buildDisplayPosts() {
    if (_displayPosts == 0) {
      // Grid
      List<GridTile> tiles = [];
      for (var post in _posts) {
        tiles.add(buildTilePost(post));
      }
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: tiles,
      );
    } else {
      // Column
      List<PostView> postViews = [];
      for (var post in _posts) {
        postViews.add(
          PostView(
            currentUserId: widget.currentUserId,
            post: post,
            author: _profileUser!,
          ),
        );
      }
      return Column(children: postViews);
    }
  }

  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        shadowColor: Colors.transparent,
        title: Text(
          _profileUser?.username ?? "Loading...",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
            onPressed: () => signOut(ref),
          ),
        ],
      ),
      body: FutureBuilder(
        future: ref.watch(authRepositoryProvider).getUserWithId(
            token: ref.watch(userProvider)!.token, userId: widget.userId),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          UserModel user = snapshot.data!;
          return ListView(
            children: <Widget>[
              buildProfileInfo(user),
              buildToggleButtons(),
              const Divider(),
              buildDisplayPosts(),
            ],
          );
        },
      ),
    );
  }
}
