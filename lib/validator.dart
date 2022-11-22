import 'package:email_validator/email_validator.dart';

String? validateEmail(String? email) {
  if (email == null || email.isEmpty || !EmailValidator.validate(email)) {
    return 'メールアドレスが正しくありません';
  }
  return null;
}

String? validatePassword(String? password) {
  RegExp regex = RegExp(r'^[a-zA-Z0-9]{8,}$');
  if (password == null || !regex.hasMatch(password)) {
    return 'パスワードが正しくありません';
  }
  return null;
}
