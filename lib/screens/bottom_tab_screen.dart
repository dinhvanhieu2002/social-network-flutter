import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:social_network/models/error_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network/screens/activity_screen.dart';
import 'package:social_network/screens/feed_screen.dart';
import 'package:social_network/screens/search_screen.dart';
import 'package:social_network/screens/profile_screen.dart';
import 'package:social_network/repository/auth_repository.dart';

class BottomTabScreen extends ConsumerStatefulWidget {
  const BottomTabScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomTabScreenState();
}

class _BottomTabScreenState extends ConsumerState<BottomTabScreen> {
  int _currentIndex = 0;
  ErrorModel? errorModel;

  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onItemTapped(int index) {
    if (index != 2) {
      setState(() {
        _currentIndex = index;
      });
    } else {
      Routemaster.of(context).push('/create-post');
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = ref.read(userProvider)!.avatar;
    final currentUserId = ref.read(userProvider)!.id;
    // print(avatarUrl);
    // print(currentUserId);
    final List<Widget> pages = [
      const FeedScreen(),
      const SearchScreen(),
      const SizedBox(width: 20.0),
      ActivityScreen(currentUserId: currentUserId),
      ProfileScreen(currentUserId: currentUserId, userId: currentUserId),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: onItemTapped,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.black,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              activeIcon: Icon(
                Icons.search,
                fill: 0.9,
                grade: 0.5,
              ),
              label: 'Search',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 24,
                height: 24,
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(avatarUrl),
                ),
              ),
              activeIcon: Stack(alignment: Alignment.center, children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13.0),
                      color: Colors.black),
                ),
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      avatarUrl,
                    ),
                  ),
                ),
              ]),
              label: 'Profile',
            ),
          ]),
    );
  }
}
