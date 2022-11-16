import 'package:flutter_test/flutter_test.dart';
import 'package:test/validator.dart';

void main() {
  group('[validateEmail] should be working correctly.', () {
    test('Valid email should be returning null', () {
      const String email = 't@takkun.com';

      String? errMsg = validateEmail(email);

      expect(errMsg, null);
    });
    test('Invalid email should be returning error message.', () {
      const String email = '';

      String? errMsg = validateEmail(email);

      expect(errMsg, 'メールアドレスを入力してください');
    });
  });

  group('[validatePassword] should be working correctly.', () {
    test('valid password should be returning null', () {
      const String password = 'tttttttt';

      String? errMsg = validatePassword(password);

      expect(errMsg, null);
    });
    test('Invalid password should be returning error message.', () {
      const String password = '';

      String? errMsg = validatePassword(password);

      expect(errMsg, 'パスワードは8文字以上で入力してください');
    });
  });
}
