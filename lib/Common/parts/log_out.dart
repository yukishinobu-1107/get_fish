import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_fish/Model/DbQuery/auth.dart';
import 'package:get_fish/Model/DbQuery/data.dart';

class LogoutPage extends StatelessWidget {
  final User user;

  const LogoutPage(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ログアウトします'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Hello ${user.displayName}",
                style: const TextStyle(fontSize: 50)),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                //ログアウト処理
                await AuthQuery.logOutExe(context);
                final uid = <String>[];
                uid.add(user.uid);
                print('............uid logout page');
                print(uid);
              },
              child: const Text('Logout', style: TextStyle(fontSize: 50)),
            )
          ],
        ),
      ),
    );
  }
}
