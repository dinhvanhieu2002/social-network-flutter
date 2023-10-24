import 'package:flutter/material.dart';

import '../../widgets/user.dart';


class SearchScreen extends StatefulWidget{
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>{

  final List<User> _users =[
    User('Dan Le', '@dan_le1308', 'https://st.gamevui.com/images/image/2020/09/17/AmongUs-Avatar-maker-hd01.jpg', false),
    User('Minh Quan', '@minh_quan', 'https://st.gamevui.com/images/image/2020/09/17/AmongUs-Avatar-maker-hd01.jpg', false),
    User('DanLeDepTrai', '@hello', 'https://st.gamevui.com/images/image/2020/09/17/AmongUs-Avatar-maker-hd01.jpg', false),
    User('Hihi', '@hihihaha', 'https://st.gamevui.com/images/image/2020/09/17/AmongUs-Avatar-maker-hd01.jpg', false),
    User('Hehe', '@hehehe', 'https://st.gamevui.com/images/image/2020/09/17/AmongUs-Avatar-maker-hd01.jpg', false),
  ];

  List<User> _foundedUsers = [];

  @override
  void initState(){
    super.initState();
    setState(() {
      _foundedUsers = _users;
    });
  }

  onSearch(String search){
    setState(() {
      _foundedUsers = _users.where((user) => user.name.toLowerCase().contains(search)).toList();
    });
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Container(
          height: 38,
          child: TextField(
            onChanged: (value) => onSearch(value),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: EdgeInsets.all(0),
              prefixIcon: Icon(Icons.search, color: Colors.grey[500],),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              hintText: "Search Users"
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(right: 20, left: 20),
        color: Colors.white,
        child: _foundedUsers.length > 0 ? ListView.builder(
          itemCount: _foundedUsers.length,
            itemBuilder: (context, index){
             return userComponent(user: _foundedUsers[index]);
            }) : Center(
          child: Text(
            'No User Found', style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  userComponent({required User user}){
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(user.image),
                ),
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),),
                  SizedBox(height: 5,),
                  Text(user.username, style: TextStyle(color: Colors.grey[500]),),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                user.isFollowedByMe = !user.isFollowedByMe;
              });
            },
            child: AnimatedContainer(
              height: 35,
              width: 110,
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: user.isFollowedByMe ? Color(0xFFEC1E64) : Color(0xffffff),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: user.isFollowedByMe ? Colors.transparent : Colors.grey.shade700,)
              ),
              child: Center(
                child: Text(
                  user.isFollowedByMe ? 'Unfollow' : 'Follow',
                  style: TextStyle(
                      color: user.isFollowedByMe ? Colors.black : Colors.black,
                      fontWeight: FontWeight.bold),),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
