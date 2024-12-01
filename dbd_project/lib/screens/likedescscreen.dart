import 'dart:convert';

import 'package:dbd_project/cards/postcard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LikeDescScreen extends StatefulWidget {
  @override
  _LikeDescScreenState createState() => _LikeDescScreenState();
}

class _LikeDescScreenState extends State<LikeDescScreen> {
  int _page = 0;
  final int _limit = 30;
  late int _amount;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List _list = [];
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _initLoad();
    _controller = ScrollController()..addListener(_nextLoad);
  }

  void _initLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      // 쿼리 보내는 부분
      final res =
          await http.get(Uri.parse("http://localhost:8080/post/like-count"));
      setState(() {
        _list = jsonDecode(utf8.decode(res.bodyBytes));
      });

      _amount = _list[0]['id'];
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _nextLoad() async {
    if (_hasNextPage &&
        !_isFirstLoadRunning &&
        !_isLoadMoreRunning &&
        _controller.position.extentAfter < 100) {
      setState(() {
        _isLoadMoreRunning = true;
      });

      _page += 1;

      try {
        final res = await http.get(
            Uri.parse("http://localhost:8080/post/like-count?pageNo=$_page"));

        final List fetchedPosts = json.decode(res.body);

        if (fetchedPosts.isNotEmpty) {
          print('데이터 불러옴. pageNo: $_page');
          setState(() {
            _list.addAll(fetchedPosts);
          });
        } else {
          print('더이상 불러올 데이터 없음..');
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (e) {
        print(e.toString());
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_nextLoad);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isFirstLoadRunning
          ? const Center(child: CircularProgressIndicator())
          : Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Expanded(
                child: ListView.builder(
                  controller: _controller,
                  itemCount: _list.length,
                  itemBuilder: (context, index) => PostCard(
                    postId: _list[index]['id'],
                    title: _list[index]['title'],
                    nickname: _list[index]['nickname'],
                    createdAt: _list[index]['createdAt'],
                    content: _list[index]['content'],
                    likeCount: _list[index]['likeCount'],
                    isLiked: _list[index]['isLiked'],
                  ),
                ),
              ),
              if (_isLoadMoreRunning == true)
                Container(
                  padding: const EdgeInsets.all(30),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              if (_hasNextPage == false)
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.blue,
                  child: const Center(
                    child: Text(
                      'No more data to be fetched.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ]),
    );
  }
}
