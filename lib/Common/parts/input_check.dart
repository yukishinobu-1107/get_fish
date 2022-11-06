// 各種入力っチェック関数

class InputCheck {
// User登録時入力チェック ※ todo 追加実装 存在しないドメイン、なども必要、
  static glbInputWatch(String name, String email, String password) {
    //いずれかが未入力(入力条件未満)の場合非活性
    if (name == "" ||
        email.length < 6 ||
        !email.contains("@") ||
        password == "" ||
        password.length < 8) {
      print("----------------global-User登録時入力チェック");
      return true;
    } else {
      return false;
    }
  }

  // ログイン時入力チェック
  static glbLogInWatch(String email, String password) {
    //いずれかが未入力(入力条件未満)の場合非活性
    if (email.length < 6 ||
        !email.contains("@") ||
        password == "" ||
        password.length < 8) {
      return true;
    } else {
      return false;
    }
  }
}
