import 'package:flutter/material.dart';
import 'package:test/profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  bool _isObscure = true;
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

  Widget _emailForm() {
    return SizedBox(
        height: 80,
        width: 400,
        child: TextFormField(
          //key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty || !value.contains('@'))
              return 'メールアドレスを入力してください';
            _emailFilled = true;
            if (_passwordFilled && _emailFilled) setState(() {});
            return null;
          },
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

  Widget _passwordForm() {
    return SizedBox(
        height: 80,
        width: 400,
        child: TextFormField(
          /*
          onChanged: (value) {
            
          },
          */
          //key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty)
              return 'パスワードを入力してください';
            else if (value.length < 8) return 'パスワードは8文字以上で入力してください';
            _passwordFilled = true;
            if (_passwordFilled && _emailFilled) setState(() {});
            return null;
          },
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

  bool _emailFilled = false;
  bool _passwordFilled = false;
  Widget _loginButton() {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
          onPressed: !_emailFilled || !_passwordFilled
              ? null
              : () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProfilePage(email: _emailController.text)));
                  /*
                    if (_formKey.currentState!.validate())
                      _gotoProfilePage();
                    else
                      _formKey.currentState!.save();
                      */
                },
          child: const Text(
            'ログイン',
            style: TextStyle(fontSize: 20),
          )),
    );
  }
}
