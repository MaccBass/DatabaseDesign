import 'package:dbd_project/cards/postcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyLikeScreen extends StatefulWidget {
  @override
  _MyLikeScreenState createState() => _MyLikeScreenState();
}

class _MyLikeScreenState extends State<MyLikeScreen> {
  int _page = 1;
  final int _limit = 30;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  List _list = [];
  late ScrollController _controller;

  late String? userId;
  static const storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    initId();
    _initLoad();
    _controller = ScrollController()..addListener(_nextLoad);
  }

  Future<void> initId() async {
    userId = await storage.read(key: 'login');
    setState(() {});
  }

  void _initLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      // 쿼리 보내는 부분
      final res = await http.get(Uri.parse("_url?_page=$_page&_limit=$_limit"));
      setState(() {
        _list = json.decode(res.body);
      });
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
        final res =
            await http.get(Uri.parse("_url?_page=$_page&_limit=$_limit"));

        final List fetchedPosts = json.decode(res.body);

        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _list.addAll(fetchedPosts);
          });
        } else {
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
          : Expanded(
              child: ListView.builder(
                itemCount: _list.length,
                itemBuilder: (context, index) => PostCard(
                  title: 'title',
                  nickname: 'nickname',
                  createdAt: 'yyyy-mm-dd',
                  content: 'content',
                  likeCount: 0,
                ),
              ),
            ),
    );
  }
}
