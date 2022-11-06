import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_fish/Common/parts/user_preference.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../View/NewMap/gmap.dart';
import '../View/Profile/user_profile.dart';
import 'home.dart';
import 'login.dart';

//各ページ(Widget)呼び出し

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // firebaseの初期化
  await Firebase.initializeApp();
  await UserPreferences.init();
  runApp(MyApp());
}

class UserState extends ChangeNotifier {
  late FirebaseAuth user;

  void setUser(FirebaseAuth currentUser) {
    user = currentUser;
    notifyListeners();
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  late int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final List<Widget> _screen = [
    HomePage(),
    Gmap(),
    //CreateCustomChatPage(),
    //ChatScreen(),
    //CameraScreen(),
    ProfilePage()
  ];

  // //@override
  // void dispose() async {
  //   //WidgetsBinding.instance.removeObserver(this);
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     prefs.remove('user');
  //   });
  // }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screen,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        unselectedLabelStyle: TextStyle(color: Colors.white, fontSize: 10),
        fixedColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.feed_outlined,
                color: _selectedIndex == 0 ? Colors.blue : Colors.grey),
            label: "タイムライン",
            //       style: TextStyle(
            //           color: _selectedIndex == 0 ? Colors.blue : Colors.grey)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined,
                color: _selectedIndex == 1 ? Colors.blue : Colors.grey),
            label: "マップ",

            ////今すぐ写真投稿機能の為に作ったが不要になる可能性があるため一様コードを取っておく。
            // style: TextStyle(
            //     color: _selectedIndex == 1 ? Colors.blue : Colors.grey)),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.photo_camera_outlined,
          //       color: _selectedIndex == 2 ? Colors.blue : Colors.grey),
          //   label: "今すぐ投稿",
          //   // style: TextStyle(
          //   //     color: _selectedIndex == 2 ? Colors.blue : Colors.grey)),
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined,
                color: _selectedIndex == 2 ? Colors.blue : Colors.grey),
            label: "プロフィール",
            // style: TextStyle(
            //     color: _selectedIndex == 3 ? Colors.blue : Colors.grey)),
          ),
        ],
      ),
    );
  }
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final UserState user = UserState();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserState>.value(
        value: user,
        child: ThemeProvider(
          initTheme: ThemeData.dark(),
          child: MaterialApp(
            //デバックラベル非表示
            debugShowCheckedModeBanner: false,
            title: 'GetSeries',
            theme: ThemeData.dark(),
            darkTheme: ThemeData.dark(),
            home: LoginCheck(),
            initialRoute: "/",
            routes: <String, WidgetBuilder>{
              // AddRecord.routeName: (BuildContext context) => AddRecord(),
              "/login": (BuildContext context) => const LoginPage(),
              "/home": (BuildContext context) => const MyStatefulWidget(),
            },
          ),
        ));
  }
}

class LoginCheck extends StatefulWidget {
  LoginCheck({Key? key}) : super(key: key);

  @override
  _LoginCheckState createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {
  //ログイン状態のチェック(非同期で行う)
  void checkUser() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, "/home");
        print('-----------ログインOK判定--HOME画面へ');
      } else {
        Navigator.pushReplacementNamed(context, "/login");
        print('-----------ログインNG判定の為ログイン画面へ');
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
          child: const Text("読み込み中..."),
        ),
      ),
    );
  }
}
