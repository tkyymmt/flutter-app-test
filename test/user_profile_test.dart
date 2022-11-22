import 'package:flutter_test/flutter_test.dart';
import 'package:test/user_profile.dart' show UserProfile;

void main() {
  test(
      '[UserProfile] constructor, getter and setter should be working correctly',
      () {
    UserProfile userProf = UserProfile('', '', '');

    expect(userProf.name, '');
    expect(userProf.email, '');
    expect(userProf.imgURL, '');

    String name = 'takkun';
    String email = 't@takkun.com';
    String imgURL = 'users/prof_img.png';

    userProf.name = name;
    userProf.email = email;
    userProf.imgURL = imgURL;

    expect(userProf.name, name);
    expect(userProf.email, email);
    expect(userProf.imgURL, imgURL);
  });
}
