import 'package:flutter_test/flutter_test.dart';
import 'package:test/user_profile.dart';

void main() {
  test(
      '[UserProfile] constructor, getter and setter should be working correctly',
      () {
    UserProfile userProf = UserProfile('', '');

    expect(userProf.name, '');
    expect(userProf.email, '');

    String name = 'takkun';
    String email = 't@takkun.com';

    userProf.name = name;
    userProf.email = email;

    expect(userProf.name, name);
    expect(userProf.email, email);
  });
}
