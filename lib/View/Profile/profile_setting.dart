import 'package:cloud_firestore/cloud_firestore.dart';import 'package:firebase_auth/firebase_auth.dart';import 'package:flutter/cupertino.dart';import 'package:flutter/material.dart';import 'package:get_fish/Common/user_model.dart';import 'package:get_fish/Model/DbQuery/data.dart';class ProfileSetting extends StatefulWidget {  const ProfileSetting({Key? key}) : super(key: key);  @override  _ProfileSettingState createState() => _ProfileSettingState();}dynamic myIcon = "assets/imgs/Einstein.jpeg";String userTyped = "";class _ProfileSettingState extends State<ProfileSetting> {  @override  Widget build(BuildContext context) {    var ownIconPath = myIcon;    return Scaffold(      appBar: AppBar(        title: const Text('プロフィール編集'),        centerTitle: true,        actions: <Widget>[          IconButton(            icon: const Icon(              Icons.save,            ),            onPressed: () {              final FirebaseAuth auth = FirebaseAuth.instance;              final User? user = auth.currentUser;              final uid = user!.uid;              var us = UserModel(userId: uid, name: "");              FirebaseFirestore.instance                  .collection('つぶやき')                  .doc()                  .set({'名前': userTyped});            },          )        ],      ),      body: SingleChildScrollView(        child: Container(          // color: Colors.deepPurpleAccent,          width: double.infinity,          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),          child: Column(            children: [              Container(                color: Colors.black,                child: Row(                  mainAxisAlignment: MainAxisAlignment.center,                  children: const [                    // todo  レビューに応じて星の数判定 動的処理に切り替え予定 現状モック   ☆☆☆☆                    Icon(Icons.star_outlined, color: Colors.amberAccent),                    Icon(Icons.star_outlined, color: Colors.amberAccent),                    Icon(Icons.star_outlined, color: Colors.amberAccent),                    Icon(Icons.star_outlined, color: Colors.amberAccent),                    Icon(Icons.star_outlined, color: Colors.amberAccent),                  ],                ),              ),              // アイコンの色を設定できる              GestureDetector(                child: Container(                  color: Colors.black,                  child: Align(                    // bodyを跨いで表示できない 12/21                    alignment: const Alignment(0, 0),                    child: Container(                      decoration: BoxDecoration(                        borderRadius: BorderRadius.circular(100),                        border: Border.all(color: Colors.white, width: 2),                      ),                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),                      child: ClipOval(                        // 登録アイコン , 無ければDefault 画像 or 広告                        child: Image.asset(                          ownIconPath,                          width: 150,                          height: 150,                          fit: BoxFit.fill,                        ),                      ),                    ),                  ),                ),              ),              Padding(padding: EdgeInsets.all(10.0)),              SizedBox(                child: TextFormField(                  decoration: InputDecoration(                    //Focusしていないとき                    enabledBorder: new OutlineInputBorder(                      borderRadius: new BorderRadius.circular(25.0),                      borderSide: BorderSide(                        color: Colors.black,                      ),                    ),                    //Focusしているとき                    focusedBorder: OutlineInputBorder(                      borderRadius: new BorderRadius.circular(25.0),                      borderSide: BorderSide(                        color: Colors.blue,                        width: 1.0,                      ),                    ),                    hintText: '名前',                    contentPadding: EdgeInsets.all(16.0),                  ),                  onChanged: (String name) {                    setState(() {                      userTyped = name;                      print(userTyped);                    });                  },                ),              ),              // 投稿履歴 (表示のみ)              Container(                width: 200,                padding: const EdgeInsets.all(2),                margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),                decoration: BoxDecoration(                  color: Colors.black,                  // 角丸                  borderRadius: BorderRadius.circular(20),                ),                // 投稿履歴Btn  有料会員のみ過去の投稿に対してアクセス可能にするのか?                child: const Text(                  '投稿履歴',                  textAlign: TextAlign.center,                  style: TextStyle(                    fontSize: 22,                    color: Colors.white,                  ),                ),              ),              const Padding(                padding: EdgeInsets.all(10),              ),              SizedBox(                height: 300,                child: Column(                  children: <Widget>[                    Expanded(                      child: StreamBuilder<QuerySnapshot>(                        stream: DataAccess.getMutter(),                        builder:                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {                          if (snapshot.connectionState ==                              ConnectionState.waiting) {                            return CircularProgressIndicator();                          } else if (snapshot.connectionState ==                              ConnectionState.done) {                            return const Text('done');                          } else if (snapshot.hasError) {                            return const Text('Error!');                          }                          if (snapshot.hasData) {                            final List<DocumentSnapshot> documents =                                snapshot.data!.docs;                            return ListView(                              children:                                  documents.map((DocumentSnapshot document) {                                //documentからデータを取得する処理を書く                                return Card(                                  shape: RoundedRectangleBorder(                                    borderRadius: BorderRadius.circular(40),                                  ),                                  child: ListTile(                                    leading: const Icon(Icons.person_outlined),                                    onTap: () {                                      showDialog(                                        context: context,                                        builder: (context) {                                          // モーダルに変更後return コンタクト、ブロック機能                                          return const AlertDialog(                                            // 投稿詳細 : replyもこの中潜らせるかも                                            content:                                                Text("Hello leading ICON!"),                                          );                                        },                                      );                                    },                                    title: Text(document['投稿'].toString()),                                    subtitle:                                        Text(document['createdAt'].toString()),                                  ),                                );                              }).toList(),                            );                          }                          return const Center(                            child: Text('読込中……'),                          );                        },                      ),                    )                  ],                ),              )            ],          ),        ),      ),    );  }}