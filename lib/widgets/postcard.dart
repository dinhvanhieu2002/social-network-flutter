import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  const PostCard({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        vertical: 10
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16
            ).copyWith(right: 0),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage('https://genk.mediacdn.vn/2018/8/19/1112-1534657441975116194487.jpg'),
                ),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('username', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('location', style: TextStyle(fontWeight: FontWeight.normal))
                      ],
                    ),
                  ),
                ),
// thiếu làm button delete post
              ],
            ),
          ),

          //IMAGE section
          const SizedBox(height: 5,),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
              'https://truyenhinhvov.qltns.mediacdn.vn/239964650902032384/2020/11/9/2-1604914482109798891886.jpg',
            fit: BoxFit.cover,
            ),
          ),

          // Like comment section
          Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.favorite, color: Color(0xFFEC1E64),),
              ),
              Text('2.6K', style: TextStyle(fontWeight: FontWeight.w500)),

              IconButton(onPressed: () {}, icon: const Icon(Icons.comment_outlined),
              ),
              Text('425', style: TextStyle(fontWeight: FontWeight.w500)),

              Expanded(child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(Icons.bookmark_border),
                  onPressed: () {},
                ),
              ),
              )
            ],
          ),
          //Caption and time
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 3
                ).copyWith(right: 0),
                child: const Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Caption Here!', style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              height: 1.2,
                            )),
                            Text('20 MINUTES AGO', style: TextStyle(
                              fontSize: 10,
                              height: 1.2,
                              fontWeight: FontWeight.w300
                              )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
