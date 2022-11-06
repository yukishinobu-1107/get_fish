import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_fish/Common/parts/input_check.dart';
import 'package:get_fish/Model/DbQuery/auth.dart';

import 'main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // User入力値
  String name = "";
  String email = "";
  String password = "";

  // メッセージ表示用 登録を促す広告使用
  String infoText = "";

  // todo 基本前画面スクロール対応に修正 ※共通化処理
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //名前
              TextFormField(
                decoration: const InputDecoration(
                    labelText: '名前', hintText: "他ユーザから見える名前です"),
                onChanged: (String value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              // メールアドレス入力
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'メールアドレス', hintText: "有効なアドレス"),
                onChanged: (String value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              // パスワード入力
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'パスワード', hintText: "8文字以上"),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              Container(
                padding: const EdgeInsets.all(15),

                // 名前、mail、pass  全て入力height: ,(条件一致)でボタン活性化

                child: Padding(
                  padding: const EdgeInsets.only(top: 9.0),
                  child: ElevatedButton(
                    // onPressed: _inputWatch() == true
                    onPressed:
                        InputCheck.glbInputWatch(name, email, password) == true
                            ? null
                            : () async {
                                // 登録したユーザー情報
                                final User user =
                                    AuthQuery.resisterExe(email, password);
                                try {
                                  user;
                                  // 元User登録処理移行
                                  setState(() {
                                    infoText = "登録OK：${user.email}";
                                    print("registered");
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return MyApp();
                                    }));
                                  });
                                  // 登録に失敗した場合
                                } catch (e) {
                                  setState(() {
                                    infoText = "登録NG：${e.toString()}";
                                    print(infoText);
                                  });
                                }
                              },
                    child: const Text('登録'),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'ログインする',
                        style: const TextStyle(color: Colors.black),
                        recognizer: TapGestureRecognizer(),
                      ),
                    )
                  ],
                  // children: <Widget>[
                  //
                  // ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
