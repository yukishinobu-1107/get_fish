import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_fish/Common/user_model.dart';
import 'package:get_fish/Model/DbQuery/auth.dart';
import 'package:get_fish/Model/DbQuery/data.dart';

// todo 2022/02/05 確認(しのぶ) 画面部類か Ogawa Viewの中へ移動予定
class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

int count = 0;

class _AddPostState extends State<AddPost> {
  UserModel? us = AuthQuery.myAccount;
  String userTyped = "";
  String roomName = 'each_talk';
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  File? image;

  ImageProvider getImage() {
    if (image == null) {
      return NetworkImage(us!.imagePath);
    } else {
      return FileImage(image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ポストを追加'),
        centerTitle: true,
        actions: <Widget>[
          //image set
          IconButton(
            onPressed: () async {
              if (count != 0) {
                await showDialog<int>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('メッセージ'),
                        content: Text('無料会員は一枚のみアップロード可能です'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('OK'),
                            onPressed: () => Navigator.of(context).pop(0),
                          ),
                        ],
                      );
                    });
              }

              if (count == 0) {
                var result = await DataAccess.getImageFromGallery();
                if (result != null) {
                  setState(() {
                    image = File(result.path);
                    print('//////Image Set Up ////////');
                    print(image);
                  });
                  print('////////// Count is ');
                  print(count);
                  count++;
                }
              }
            },
            icon: const Icon(
              Icons.image_outlined,
            ),
          ),
          TextButton(
            onPressed: () async {
              final FirebaseAuth auth = FirebaseAuth.instance;
              final User? user = auth.currentUser;
              final uid = user!.uid;

              String imagePath = '';

              if (image == null) {
                UserModel result = UserModel(
                  userId: uid,
                  name: '',
                  typed: userTyped,
                  imagePath: '',
                  createdTime: Timestamp.now(),
                  updatedTime: Timestamp.now(),
                );
                DataAccess.addUserPost2(result);
                DataAccess.addPosts2(result);
                Navigator.of(context).pop();
              }
              var results = await DataAccess.uploadImage(uid, image!);
              imagePath = results;
              UserModel result = UserModel(
                userId: uid,
                name: '',
                typed: userTyped,
                imagePath: imagePath,
                createdTime: Timestamp.now(),
                updatedTime: Timestamp.now(),
              );
              DataAccess.addUserPost(result);
              DataAccess.addPosts(result);
              Navigator.of(context).pop();
            },
            child: const Text('つぶやく'),
          )
        ],
      ),
      body: Center(
        child: Container(
          child: ListView(
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'つぶやく',
                ),
                autofocus: true,
                onChanged: (String val) {
                  setState(() {
                    userTyped = val;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
