import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_fish/Common/login.dart';
import 'package:get_fish/Common/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../user.dart';
// DataBaseにアクセスする際にここからアクセス

class AuthQuery {
  // User user;
// App起動時、OwnData取得のため
  static UserModel? myAccount;
  static initData() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final myUid = user!.email;
    return myUid;
  }

  // 確認 uid とは
  final uid = FirebaseAuth.instance.currentUser!.uid;
  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  // 1 会員登録処理 メールアドレス パスワード
  // todo UserName 登録してない為　追加実装
  static resisterExe(String mail, String pass) async {
    // メール/パスワードでユーザー登録
    Firebase.initializeApp();
    String resisterMail = mail;
    String resisterPass = pass;
    String resisterMessage = 'ログインする';

    final FirebaseAuth auth = FirebaseAuth.instance;

    final UserCredential result = await auth.createUserWithEmailAndPassword(
      email: resisterMail,
      password: resisterPass,
    );
    print("------登録処理-----画面遷移未実装----2022/02/09確認すみ");
    return result;
  }

//ログアウト処理
  static logOutExe(dynamic context) async {
    print("--------ログアウト処理実行---");
    FirebaseAuth.instance.signOut();
    await Navigator.push(
      context,
      MaterialPageRoute(
        //    ログインページへ遷移
        builder: (context) => LoginPage(),
        fullscreenDialog: true,
      ),
    );
  }

// todo 退会処理
  quiteMemberExe() {}

// todo 会員status [無料会員0、有料1、広告主9]
  memberShipStatus() {}

// todo 有料課金処理 flag管理
  resisterPrimeMember() {}

  //判定処理 メールアドレス パスワード
  static loginGate(String mail, String pass) async {
    // Firebase.initializeApp();

    String Message = '-------ログイン';

    final UserCredential result =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: mail,
      password: pass,
    );
    print(Message);
    return result;
  }
}

//  ログイン判定処理クラス   todo 改修余地あり
class LoginCheck extends StatefulWidget {
  const LoginCheck({Key? key}) : super(key: key);

  @override
  _LoginCheckState createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {
  //ログイン状態チェック(非同期)
  void checkUser() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      // 比較対象調査
      if (user != null) {
        print('-------ModelAccess-----LogIn判定');
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        print('-------ModelAccess-----LogOut判定');
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  //ログイン状態のチェック時はこの画面が表示される
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}
