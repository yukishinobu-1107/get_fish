import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_fish/Common/parts/input_check.dart';
import 'package:get_fish/Common/register.dart';
import "package:get_fish/Model/DbQuery/auth.dart";
import 'package:get_fish/Model/DbQuery/data.dart';

import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // メッセージ表示用
  String infoText = '';

  // ユーザー入力値
  // String name = '';
  String email = '';
  String password = '';

  String logInMessage = 'ログインする';

//  ログイン画面使用画像   ※広告、告知に関する資材
  dynamic advPics;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Evevt開催中の場合は表示変更    ex : リモートつり大会開催中 , 写真投稿受付開始　等
        title: Text(logInMessage),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //名前
              // TextFormField(
              //   decoration: const InputDecoration(labelText: '名前'),
              //   onChanged: (String value) {
              //     setState(() {
              //       name = value;
              //     });
              //   },
              // ),
              // メールアドレス入力
              TextFormField(
                decoration: const InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              // パスワード入力
              TextFormField(
                decoration: const InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),

              // ログインボタンエリア
              Container(
                padding: const EdgeInsets.all(15),
                child: ElevatedButton(
                  onPressed: InputCheck.glbLogInWatch(email, password) == true
                      ? null
                      : () async {
                          try {
                            await AuthQuery.loginGate(email, password);

                            //todo 調査 何を実装してるか
                            await FirebaseAuth.instance.currentUser!.uid;
                            await Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) {
                              return const MyStatefulWidget();
                            }));
                          } catch (e) {
                            // 登録に失敗した場合
                            setState(() {
                              infoText =
                                  "-----------------登録NG：${e.toString()}";
                            });
                          }
                        },
                  child: const Text("ログイン"),
                ),
              ),
              // 新規登録リンクエリア
              Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // 遷移先画面実態 RegisterPage()

                            builder: (context) => const RegisterPage(),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                      child: const Text('新規登録はこちら'),
                    ),
                  ],
                  // children: <Widget>[
                  //
                  // ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
