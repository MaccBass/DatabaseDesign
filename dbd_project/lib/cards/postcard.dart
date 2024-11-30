import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  String title;
  String nickname;
  String createdAt;
  String content;
  int likeCount;
  PostCard(
      {required this.title,
      required this.nickname,
      required this.createdAt,
      required this.content,
      required this.likeCount});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 205,
      color: Colors.white,
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.title),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(widget.nickname),
                      SizedBox(width: 10),
                      Text(widget.createdAt),
                    ],
                  ),
                ],
              )),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [Text(widget.content)],
              )),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.favorite),
                  onPressed: () {
                    
                  }
                ),
                SizedBox(
                  width: 5,
                ),
                Text(widget.likeCount.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
