import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:test/validator.dart';

/// script string should not be accepted e.g. '<script></script>'
/// The password passed to [validatePassword] should constain at least 8 charactors
void main() {
  /// [validateEmail] returns null if valid email address was thrown,
  /// otherwise returns string says 'メールアドレスを入力してください'
  ///
  /// irrelevant symbol should not be accepted
  group('[validateEmail] should be working correctly.', () {
    test('Valid email should be returning null', () {
      String email = 't@takkun.com';
      String? errMsg = validateEmail(email);
      expect(errMsg, null);

      email = 'y@yas.com';
      errMsg = validateEmail(email);
      expect(errMsg, null);

      email = 'm@maro.com';
      errMsg = validateEmail(email);
      expect(errMsg, null);
    });
    test('Passing null', () {
      const String? email = null;
      String? errMsg = validateEmail(email);
      expect(errMsg, 'メールアドレスが正しくありません');
    });
    test('Passing empty string', () {
      const String email = '';
      String? errMsg = validateEmail(email);
      expect(errMsg, 'メールアドレスが正しくありません');
    });
    final random = Random.secure();
    test('Passing symbol charactors', () {
      const symbolChars = "`~!#\$%^&*()=+\\]}[{'\";:/?>,<";
      const length = 32;
      final symbolStr = List.generate(
              length, (_) => symbolChars[random.nextInt(symbolChars.length)])
          .join();
      String? errMsg = validateEmail(symbolStr);
      expect(errMsg, 'メールアドレスが正しくありません');
    });
    test('Passing malicious script', () {
      String scriptStr = '<script> </script>';
      String? errMsg = validateEmail(scriptStr);
      expect(errMsg, 'メールアドレスが正しくありません');
    });
    test('Passing long string', () {
      const longStr =
          'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
      String? errMsg = validateEmail(longStr);
      expect(errMsg, 'メールアドレスが正しくありません');
    });
  });

  /// [validatePassword] returns null if valid password was thrown,
  /// otherwise returns string says 'パスワードが正しくありません'
  group('[validatePassword] should be working correctly.', () {
    test('valid password should be returning null', () {
      String password = 'tttttttt';
      String? errMsg = validatePassword(password);
      expect(errMsg, null);

      password = 'TTTTTTTT';
      errMsg = validatePassword(password);
      expect(errMsg, null);

      password = 'aA000091';
      errMsg = validatePassword(password);
      expect(errMsg, null);

      password =
          'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
      errMsg = validatePassword(password);
      expect(errMsg, null);
    });
    test('Passing null', () {
      const String? password = null;
      String? errMsg = validatePassword(password);
      expect(errMsg, 'パスワードが正しくありません');
    });
    test('Passing empty string', () {
      const String password = '';
      String? errMsg = validatePassword(password);
      expect(errMsg, 'パスワードが正しくありません');
    });
    final random = Random.secure();
    test('Passing symbol charactors', () {
      const symbolChars = "`~!#\$%^&*()=+\\]}[{'\";:/?>,<";
      const length = 32;
      final symbolStr = List.generate(
              length, (_) => symbolChars[random.nextInt(symbolChars.length)])
          .join();
      String? errMsg = validatePassword(symbolStr);
      expect(errMsg, 'パスワードが正しくありません');
    });
    test('Passing malicious script', () {
      String scriptStr = '<script> </script>';
      String? errMsg = validatePassword(scriptStr);
      expect(errMsg, 'パスワードが正しくありません');
    });
  });
}
