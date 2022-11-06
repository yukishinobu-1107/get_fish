import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_fish/Common/user_model.dart';
import 'package:get_fish/Model/user.dart';
import 'package:image_picker/image_picker.dart';

// Firestore Database Query発行ファイル
class DataAccess {
  // DB
  FirebaseFirestore fb = FirebaseFirestore.instance;

  static accessFirebase() {
    final FirebaseFirestore fb = FirebaseFirestore.instance;
    return fb;
  }

  static getUid() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final myUid = user!.uid;
    return myUid;
  }

  static getName() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final myUid = user!.uid;

    Stream UserName = DataAccess.accessFirebase()
        .collection('post')
        .doc(myUid)
        .snapshots()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc['名前'];
        print('............');
        print(doc['名前']);
      });
    });
    return UserName;
  }

  //プロフィールページのつぶやき取得処理
  static getMutter() {
    Stream documentStream = accessFirebase()
        .collection('users')
        .doc(DataAccess.getUid().toString())
        .collection('user_post')
        .snapshots();
    return documentStream;
  }

  static getPosts() {
    Stream documentStream =
        accessFirebase().collection('time_line').snapshots();
    return documentStream;
  }

  static getFieldPost() {
    Stream documentStream = accessFirebase()
        .collection('imageURLs')
        .where(FieldPath.documentId, isEqualTo: getUid())
        .snapshots();
    return documentStream;
  }

//チャットルーム新規作成
  static addChatRoom(String roomName) {
    final date = DateTime.now().toLocal().toIso8601String();
    final db = accessFirebase().collection('chat_room').doc(roomName).set({
      '名前': roomName,
      '作成日': date,
    });
    return db;
  }

  static chatRoomList() {
    Stream documentStream =
        accessFirebase().collection('chat_room').orderBy('作成日').snapshots();
    return documentStream;
  }

  var us = UserModel(userId: getUid(), name: "");
  var _now = DateTime.now();

  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users =
      _firestoreInstance.collection('users');
  static final CollectionReference posts =
      _firestoreInstance.collection('posts');

  static Future<dynamic> addUserPost(UserModel newAccount) async {
    try {
      await users.doc(newAccount.userId).collection('user_post').doc().set({
        'name': newAccount.name,
        'user_id': newAccount.userId,
        'user_typed': newAccount.typed,
        'image_path': newAccount.imagePath,
        'created_time': Timestamp.now(),
        'updated_time': Timestamp.now(),
      });
      print('success');
      return true;
    } on FirebaseException catch (e) {
      print('error');

      return false;
    }
  }

  static Future<dynamic> addPosts(UserModel newAccount) async {
    try {
      await posts.doc().set({
        'name': newAccount.name,
        'user_id': newAccount.userId,
        'user_typed': newAccount.typed,
        'image_path': newAccount.imagePath,
        'created_time': Timestamp.now(),
        'updated_time': Timestamp.now(),
      });
      print('success');
      return true;
    } on FirebaseException catch (e) {
      print('error');

      return false;
    }
  }

  static Future<dynamic> addUserPost2(UserModel newAccount) async {
    try {
      await users.doc(newAccount.userId).collection('user_post').doc().set({
        'name': newAccount.name,
        'user_id': newAccount.userId,
        'user_typed': newAccount.typed,
        'image_path': '',
        'created_time': Timestamp.now(),
        'updated_time': Timestamp.now(),
      });
      print('success');
      return true;
    } on FirebaseException catch (e) {
      print('error');

      return false;
    }
  }

  static Future<dynamic> addPosts2(UserModel newAccount) async {
    try {
      await posts.doc().set({
        'name': newAccount.name,
        'user_id': newAccount.userId,
        'user_typed': newAccount.typed,
        'image_path': '',
        'created_time': Timestamp.now(),
        'updated_time': Timestamp.now(),
      });
      print('success');
      return true;
    } on FirebaseException catch (e) {
      print('error');

      return false;
    }
  }

  static final CollectionReference spotTalk =
      _firestoreInstance.collection('spot_talk');
  static Future<dynamic> AddSpotTalk(UserModel newAccount, String value) async {
    try {
      await spotTalk.doc(value).collection('spot_Talk_Details').doc().set({
        'uid': newAccount.userId,
        'name': newAccount.name,
        'user_typed': newAccount.typed,
        'image_path': newAccount.imagePath,
        'created_time': Timestamp.now(),
        'updated_time': Timestamp.now(),
      });
      print('success');
      return true;
    } on FirebaseException catch (e) {
      print('error');

      return false;
    }
  }

  static final CollectionReference timeLine =
      _firestoreInstance.collection('time_line');
  static Future<dynamic> AddTimeLine(UserModel newAccount, String value) async {
    try {
      await timeLine.add({
        'name': newAccount.name,
        'user_id': newAccount.userId,
        'user_typed': newAccount.typed,
        'image_path': newAccount.imagePath,
        'created_time': Timestamp.now(),
        'updated_time': Timestamp.now(),
      });
      print('success');
      return true;
    } on FirebaseException catch (e) {
      print('error');

      return false;
    }
  }

  static getSpotPosts(String value) {
    Stream documentStream = accessFirebase()
        .collection('spot_talk')
        .doc(value)
        .collection('spot_Talk_Details')
        .snapshots();
    return documentStream;
  }

  List<UserModel> products = [];

  Future getProducts(String userId) async {
    dynamic collection =
        await FirebaseFirestore.instance.collection('post').get();
    products = collection.docs
        .map((doc) => UserModel(userId: getUid(), name: ''))
        .toList();
    this.products = products;
  }

  static Future<String> uploadImage(String uid, File image) async {
    final FirebaseStorage storageInstance = FirebaseStorage.instance;
    final Reference ref = storageInstance.ref();
    await ref.child(uid).putFile(image);
    String downloadUrl = await storageInstance.ref(uid).getDownloadURL();
    print('image_path: $downloadUrl');
    return downloadUrl;
  }

  static Future<dynamic> getImageFromGallery() async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
    // if (pickedFile != null) {
    //   setState(() {
    //     image = File(pickedFile.path);
    //   });
    // }
  }

  // static Future<dynamic> updateUser(UserModel updateAccount) async {
  //   try {
  //     users.doc(updateAccount.userId).update({
  //       'name': updateAccount.name,
  //       'image_path': updateAccount.imagePath,
  //       //'user_id': updateAccount.userId,
  //       'self_introduction': updateAccount.introduction,
  //       'updated_time': Timestamp.now(),
  //     });
  //     print('更新完了');
  //     return true;
  //   } on FirebaseException catch (e) {
  //     print('更新Error');
  //     return false;
  //   }
  // }

  // static final CollectionReference userDetail =
  //     _firestoreInstance.collection('userDetail');
  static Future<dynamic> userDetails(Users newAccount) async {
    try {
      await FirebaseFirestore.instance
          .collection('userDetails')
          .doc(getUid().toString())
          .set({
        'name': newAccount.name,
        'nickName': newAccount.nickName,
        'area': newAccount.about,
        'introduction': newAccount.about,
        'image_path': newAccount.imagePath,
        'created_time': Timestamp.now(),
        'updated_time': Timestamp.now(),
      });
      SetOptions(merge: true);
      print('success');
      return true;
    } on FirebaseException catch (e) {
      print('error');
      return false;
    }
  }

// todo 住所(ポイント)検索処理
  serchFshingExe() {}

// todo 情報投稿処理
  dropInfoExe() {}

// todo メッセージ送信
  sendMsgExe() {}

// todo メッセージ受信(更新処理)
  Exe() {}
}
