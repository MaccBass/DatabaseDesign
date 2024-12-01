import 'package:dbd_project/screens/homescreen.dart';
import 'package:dbd_project/screens/likedescscreen.dart';
import 'package:dbd_project/screens/mylikescreen.dart';
import 'package:dbd_project/screens/writescreen.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(label: '게시글', icon: Icon(Icons.note_outlined)),
    BottomNavigationBarItem(label: '인기순', icon: Icon(Icons.star)),
    BottomNavigationBarItem(label: '글쓰기', icon: Icon(Icons.add)),
    BottomNavigationBarItem(label: '좋아요', icon: Icon(Icons.favorite)),
  ];
  List pages = [HomeScreen(), LikeDescScreen(), WriteScreen(), MyLikeScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메인페이지'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 10,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: bottomItems,
      ),
      body: pages[_selectedIndex],
    );
  }
}
