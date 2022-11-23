import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test/user_profile.dart' show UserProfile;

void main() {
  test(
      '[UserProfile] constructor, getter and setter should be working correctly',
      () {
    Image img = Image.network(
        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg');
    UserProfile userProf = UserProfile('', '', img);

    expect(userProf.name, '');
    expect(userProf.email, '');
    expect(userProf.img, img);

    String name = 'takkun';
    String email = 't@takkun.com';
    img = Image.network(
        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg');

    userProf.name = name;

    expect(userProf.name, name);
  });
}
