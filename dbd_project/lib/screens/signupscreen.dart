import 'package:dbd_project/pages/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var nickname = TextEditingController();
  var userId = TextEditingController();
  var password = TextEditingController();
  var passwordConfirm = TextEditingController();
  var idCheck = false;

  static const storage = FlutterSecureStorage();

  _message(String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }

  _idCheck(String userId) async {
    if (userId == '') {
      _message('아이디를 입력해주세요.');
      return;
    }

    try {
      var dio = Dio();
      Response response = await dio.get('url 이름');

      if (response.statusCode == 200) {
        var result = response.data;
        // result 보고 체크하는 부분
        _message('사용 가능한 아이디 입니다.');
        idCheck = true;

      } else if (response.statusCode == 400){
        _message('이미 존재하는 아이디 입니다.');

      }
      else {
        _message('내부 서버 오류');
      }
    } catch (e) {
      _message('클라이언트 오류');
      return false;
    }
  }

  _submitJoin(String nickname, String userId, String password) async {
    try {
      var dio = Dio();
      var param = {
        'nickname': '$nickname',
        'userId': '$userId',
        'password': '$password'
      };

      Response response = await dio.post('url 이름');

      if (response.statusCode == 200) {
        String result = response.data;
        _message('회원가입 성공');

        // 이후 처리
        return true;
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
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('닉네임 : '),
          SizedBox(
            width: 230,
            height: 40,
            child: TextFormField(
              controller: nickname,
            ),
          ),
        ]),
        SizedBox(height: 30),
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
            Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  _idCheck(userId.text);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(40, 40),
                  foregroundColor: Colors.black,
                  backgroundColor: const Color(0xFFF5FBFF), // 텍스트 색상
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 모서리를 둥글게 할지 여부
                  ),
                ),
                child: const Text(
                  '중복확인',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }),
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
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('비밀번호 확인 : '),
          SizedBox(
            width: 230,
            height: 40,
            child: TextFormField(
              controller: passwordConfirm,
              obscureText: true,
            ),
          ),
        ]),
        SizedBox(height: 30),
        Builder(builder: (context) {
          return ElevatedButton(
            onPressed: () async {
              if (nickname.text.isEmpty) {
                _message('닉네임을 입력하세요');
              } else if (userId.text.isEmpty) {
                _message('아이디를 입력하세요');
              } else if (password.text.isEmpty) {
                _message('비밀번호를 입력하세요');
              } else if (passwordConfirm.text.isEmpty) {
                _message('비밀번호 확인란을 입력하세요');
              } else if (!idCheck) {
                _message('ID 확인을 해주세요');
              } else {
                bool isJoined = await _submitJoin(nickname.text, userId.text, password.text);
                if (isJoined) {
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
              '가입',
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
