import 'package:dbd_project/pages/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' as getx;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var userId = TextEditingController();
  var password = TextEditingController();

  static const storage = FlutterSecureStorage();

  _message(String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // 로그인 시도
  _submitLogin(userId, password) async {
    try {
      var dio = Dio();
      var param = {'userId': '$userId', 'password': '$password'};
      return true;

      Response response = await dio.post('url 이름');

      if (response.statusCode == 200) {
        String result = response.data;
        _message('로그인 성공');

        // 이후 처리
        return true;
      } else if (response.statusCode == 400) {
        _message('ID가 존재하지 않거나 비밀번호가 잘못되었습니다.');
        return false;
      } else {
        _message('내부 서버 오류');
        return false;
      }
    } catch (e) {
      _message('클라이언트 오류');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('아이디 : '),
            SizedBox(
              width: 230,
              height: 40,
              child: TextFormField(
                controller: userId,
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('비밀번호 : '),
          SizedBox(
            width: 230,
            height: 40,
            child: TextFormField(
              controller: password,
              obscureText: true,
            ),
          ),
        ]),
        SizedBox(height: 30),
        Builder(builder: (context) {
          return ElevatedButton(
            onPressed: () async {
              if (userId.text.isEmpty) {
                _message('아이디를 입력하세요');
              } else if (password.text.isEmpty) {
                _message('비밀번호를 입력하세요');
              } else {
                bool isLoggedIn = await _submitLogin(userId, password);
                if (isLoggedIn) {
                  await storage.write(key: 'login', value: userId.text);
                  getx.Get.off(MainPage());
                }
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(150, 50),
              foregroundColor: Colors.black,
              backgroundColor: const Color(0xFFF5FBFF), // 텍스트 색상
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // 모서리를 둥글게 할지 여부
              ),
            ),
            child: const Text(
              '로그인',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }),
      ],
    ));
  }
}
