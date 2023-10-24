import 'package:flutter/material.dart';
import 'package:social_network/widgets/postcard.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Image.asset('assets/images/instagram.png',
        color: Colors.black,
        height: 32,
        ),
          actions: [IconButton(
              onPressed: (){
              },
              icon: const Icon(Icons.messenger_outline_rounded), color: Colors.black,)
          ],
      ),
      //hiển thị những bài đăng
      body: ListView(
        children: const [
          PostCard(),
          PostCard(),
          PostCard(),
          PostCard(),
          PostCard(),
        ],
      ),
    );
  }
}

