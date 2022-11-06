//共通変数や共通の処理

import 'package:flutter/material.dart';

class LogedInUserInfo extends StatelessWidget {
  const LogedInUserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // --------------------------------------自身の情報
//ID
    int LoginUserID = 0;
//メアド
    String MyMailAddres = "";
// userName
    String MyUserName = "";

//会員ステータス 0 = 会員登録なし , 1= 無料会員 , 2= 有料会員 ,10= 広告主
    int MemberStatus = 0;

//登録Icon
    var MyIcon = "";

//自分の位置
    dynamic MyPosition = "";

//いいね数
    int like = 0;

    // --------------------------------------他の情報
//現在Loginしてる他のUser情報 name 場所 最後の履歴 など
    dynamic LogedInUsers = {};
//User会員数
    int ResisterAmount = 0;

    return Container(

        // child: Text("LogedInUserInfoクラス");
        );
  }
}
