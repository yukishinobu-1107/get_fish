// import 'package:flappy_search_bar/flappy_search_bar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// // todo 検索バー　(Map画面で使用予定) 実装 2021/12/12 OgawaK
// @override
// Widget build(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.all(10.0),
//     child: SearchBar<Application>(
//       onSearch: search,
//       onItemFound: (Application app, int index) {
//         return ListTile(
//             // アプリ情報から必要な情報を取得して画面に表示する処理を行っています。
//             );
//       },
//     ),
//   );
// }
//
// class Application {}
//
// /// 検索対象のアプリ情報を検索しています。
// Future<List<Application>> search(String search) async {
//   final apps = await widget.getAppsFunction;
//   var searchApps = apps.where((app) => app.appName.contains(search)).toList();
//   return searchApps;
// }
