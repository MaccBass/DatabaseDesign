import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class WriteScreen extends StatefulWidget {
  @override
  _WriteScreenState createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  var _title = TextEditingController();
  var _content = TextEditingController();
  late String? userId;

  static const storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    initId();
  }

  Future<void> initId() async {
    userId = await storage.read(key: 'login');
    setState(() {});
  }

  _message(String message) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }

  _submitContent(String userId, String title, String content) async {
    try {
      var dio = Dio();
      var param = {
        'userId': '$userId',
        'title': '$title',
        'content': '$content'
      };
      Response response = await dio.post('url 이름');

      if (response.statusCode == 200) {
        String result = response.data;
        _message('작성 성공');

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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width - 50,
              child: TextFormField(
                controller: _title,
                decoration: InputDecoration(
                  hintText: '제목',
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 500,
              width: MediaQuery.of(context).size.width - 50,
              child: TextFormField(
                controller: _content,
                maxLines: 20,
                decoration: InputDecoration(
                  hintText: '내용',
                ),
              ),
            ),
            Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  if (_title.text.isEmpty) {
                    _message('제목을 입력하세요');
                  } else if (_content.text.isEmpty) {
                    _message('내용을 입력하세요');
                  } else {
                    bool isSuccess = await _submitContent(userId!, _title.text, _content.text);
                    if (isSuccess) {
                      _message('글이 작성되었습니다.');
                      _title.text='';
                      _content.text='';
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
                  '작성',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
