import 'package:email_validator/email_validator.dart';

String? validateEmail(String? email) {
  if (email == null || email.isEmpty || !EmailValidator.validate(email))
    return 'メールアドレスを入力してください';
  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.length < 8) return 'パスワードは8文字以上で入力してください';
  return null;
}
