import 'package:flutter/material.dart';
import 'package:test/auth.dart';
import 'package:test/profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  bool _isObscure = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[_emailForm(), _passwordForm(), _loginButton()],
        ),
      ),
    );
  }

  String? _emailValidator(value) {
    if (value == null || value.isEmpty || !value.contains('@'))
      return 'メールアドレスを入力してください';
    return null;
  }

  final _emailFormKey = GlobalKey<FormFieldState>();
  Widget _emailForm() {
    return SizedBox(
        height: 80,
        width: 400,
        child: TextFormField(
          key: _emailFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _emailValidator,
          controller: _emailController,
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
        ));
  }

  String? _passwordValidator(value) {
    if (value == null || value.length < 8) return 'パスワードは8文字以上で入力してください';
    return null;
  }

  final _passwordFormKey = GlobalKey<FormFieldState>();
  Widget _passwordForm() {
    return SizedBox(
        height: 80,
        width: 400,
        child: TextFormField(
          key: _passwordFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: _passwordValidator,
          obscureText: _isObscure,
          controller: _passwordController,
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

  Widget _loginButton() {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
          onPressed: () async {
            if (_emailFormKey.currentState!.validate() &&
                _passwordFormKey.currentState!.validate()) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('処理中...')));

              String errMsg = await authUser(
                  email: _emailController.text,
                  password: _passwordController.text);
              ScaffoldMessenger.of(context).clearSnackBars();
              if (errMsg.isEmpty) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(errMsg,
                        style: const TextStyle(color: Colors.red))));
              }
            }
          },
          child: const Text(
            'ログイン',
            style: TextStyle(fontSize: 20),
          )),
    );
  }
}
