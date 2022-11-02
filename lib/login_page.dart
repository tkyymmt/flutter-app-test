import 'package:flutter/material.dart';
import 'package:test/auth.dart';
import 'package:test/profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[_EmailForm(), _PasswordForm(), _LoginButton()],
        ),
      ),
    );
  }
}

class _EmailForm extends StatelessWidget {
  static final emailController = TextEditingController();
  static final emailFormKey = GlobalKey<FormFieldState>();

  String? _emailValidator(value) {
    if (value == null || value.isEmpty || !value.contains('@'))
      return 'メールアドレスを入力してください';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 80,
        width: 400,
        child: SizedBox(
          child: TextFormField(
            key: emailFormKey,
            controller: emailController,
            validator: (value) => _emailValidator(value),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 2.0,
                ),
              ),
              labelText: 'メールアドレス',
            ),
          ),
        ));
  }
}

class _PasswordForm extends StatefulWidget {
  @override
  State<_PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<_PasswordForm> {
  static final passwordController = TextEditingController();
  static final passwordFormKey = GlobalKey<FormFieldState>();
  bool _isObscure = true;

  String? _passwordValidator(value) {
    if (value == null || value.length < 8) return 'パスワードは8文字以上で入力してください';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 80,
        width: 400,
        child: TextFormField(
          key: passwordFormKey,
          controller: passwordController,
          validator: (value) => _passwordValidator(value),
          obscureText: _isObscure,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 2.0,
              ),
            ),
            labelText: 'パスワード',
          ),
        ));
  }
}

class _LoginButton extends StatelessWidget {
  _loginButtonPressed(context) async {
    if (_EmailForm.emailFormKey.currentState!.validate() &&
        _PasswordFormState.passwordFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('処理中...')));

      String errMsg = await authUser(
          email: _EmailForm.emailController.text,
          password: _PasswordFormState.passwordController.text);
      ScaffoldMessenger.of(context).clearSnackBars();
      if (errMsg.isEmpty) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfilePage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errMsg, style: const TextStyle(color: Colors.red))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
          onPressed: _loginButtonPressed(context),
          child: const Text(
            'ログイン',
            style: TextStyle(fontSize: 20),
          )),
    );
  }
}
