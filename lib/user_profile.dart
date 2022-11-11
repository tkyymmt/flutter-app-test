// バリデーションをどこで行うか。コンストラクタかセッターなのかゲッターなのか

class UserProfile {
  String _name;
  String _email;

  UserProfile(this._name, this._email);

  String get name => _name;
  set name(String name) {
    if (name.isEmpty) throw Exception('name is empty');
    _name = name;
  }

  String get email => _email;
  set email(String email) {
    if (email.isEmpty) throw Exception('email is empty');
    _email = email;
  }
}
