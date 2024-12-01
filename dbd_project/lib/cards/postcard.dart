import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PostCard extends StatefulWidget {
  int postId;
  String title;
  String nickname;
  String createdAt;
  String content;
  int likeCount;
  bool isLiked;
  PostCard(
      {required this.postId,
      required this.title,
      required this.nickname,
      required this.createdAt,
      required this.content,
      required this.likeCount,
      required this.isLiked});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  static const storage = FlutterSecureStorage();

  _message(String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }

  _submitLike(String userId, int postId) async {
    if (widget.isLiked) {
      _message('이미 좋아요한 게시물입니다.');
      return false;
    }
    try {
      final response = await http.post(
        Uri.parse("http://localhost:8080/post/$postId"),
        headers: {
          "accept": "*/*",
          "Content-Type": "application/json",
          "userId": userId
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

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
                    icon: widget.isLiked
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border_outlined),
                    onPressed: () async {
                      String? userId = await storage.read(key: 'login');
                      bool isSubmitted =
                          await _submitLike(userId!, widget.postId);
                      if (isSubmitted) {
                        widget.likeCount++;
                        widget.isLiked = true;
                      }
                      ;
                      setState(() {});
                    }),
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
