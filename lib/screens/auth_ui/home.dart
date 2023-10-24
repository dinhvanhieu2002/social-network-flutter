import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network/screens/auth_ui/newfeed.dart';
import 'package:social_network/screens/auth_ui/search.dart';

class BottomTabScreen extends StatefulWidget {
  const BottomTabScreen({Key? key}) : super(key: key);

      @override
      State<BottomTabScreen> createState() => _BottomTabScreenState();
}

class _BottomTabScreenState extends State<BottomTabScreen> {
  late PageController pageController;


  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0); // Khởi tạo pageController và đặt trang ban đầu là 0
  }

  @override
  void dispose(){
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page){
  pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: PageView(
         physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
         children: const [
           FeedScreen(),
           SearchScreen(),
           Text('post'),
           Text('note'),
           Text('person'),
         ],
       ),
        bottomNavigationBar: CupertinoTabBar(
            activeColor: const Color(0xFFEC1E64),
            inactiveColor: Colors.black,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.house_alt_fill),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.search),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.plus),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.bell),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_alt_circle_fill),
              ),
            ],
          onTap: navigationTapped,
          ),
        );
  }
}
