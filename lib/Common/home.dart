import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_fish/Model/DbQuery/auth.dart';
import 'package:get_fish/Model/DbQuery/data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic myUid = AuthQuery.initData();
    var _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.80),
          child: AppBar(
            actions: <Widget>[],
            leading: IconButton(
              padding: const EdgeInsets.only(top: 20),
              onPressed: () => _scaffoldKey.currentState!.openDrawer(),
              icon: const Icon(
                Icons.menu_book_outlined,
              ),
            ),
            toolbarHeight: 140,
            elevation: 0.0,
            title: Container(
              height: 50,
              padding: const EdgeInsets.only(top: 20),
              child: const Text("タイムライン"),
            ),
            centerTitle: true,
          ),
        ),
        // 　Drawersパネル
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.only(top: 20),
            children: <Widget>[
              // todo 必要確認しのぶ　DrawerHeaderインスタンス 移行対象 → viewParts
              DrawerHeader(
                child: Text(
                  myUid!,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              //ログアウト機能一旦ドロアーに設置
              ListTile(
                title: const Text('ログアウト'),
                onTap: () async {
                  await AuthQuery.logOutExe(context);
                },
              ),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: DataAccess.getPosts(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                print('Test');
                return CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      splashColor: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: <Widget>[
                            Image.network(
                              snapshot.data!.docs[index]['image_path'],
                              height: 130,
                              errorBuilder: (context, error, stackTrace) {
                                return Text('');
                              },
                            ),
                            Expanded(
                              child: Container(
                                // padding: const EdgeInsets.all(10),
                                child: ListTile(
                                  title: Text(
                                    snapshot.data!.docs[index]['user_typed'],
                                  ),
                                  subtitle: Text(
                                      snapshot.data!.docs[index]['user_id']),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return Text('Loading');
            }));
  }
}
