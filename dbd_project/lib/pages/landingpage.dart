import 'package:dbd_project/pages/accountpage.dart';
import 'package:dbd_project/pages/mainpage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';

class LandingPage extends StatefulWidget {
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  void initState() {
    Timer(Duration(seconds: 1), () {
      Get.offAll(AccountPage());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [CircularProgressIndicator()],
    ));
  }
}
