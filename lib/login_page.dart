import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:test/auth.dart';
import 'package:test/validator.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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

final _emailFormKeyProvider = Provider((ref) => GlobalKey<FormFieldState>());
final _emailControllerProvider = Provider((ref) => TextEditingController());

class _EmailForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailFormKey = ref.watch(_emailFormKeyProvider);
    final emailController = ref.watch(_emailControllerProvider);
    return SizedBox(
        height: 80,
        width: 400,
        child: SizedBox(
          child: TextFormField(
            key: emailFormKey,
            controller: emailController,
            validator: (value) => validateEmail(value),
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

final _passwordFormKeyProvider = Provider((_) => GlobalKey<FormFieldState>());
final _passwordControllerProvider = Provider((_) => TextEditingController());

class _PasswordForm extends ConsumerWidget {
  final _isObscureProvider = StateProvider((_) => true);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordFormKey = ref.watch(_passwordFormKeyProvider);
    final passwordController = ref.watch(_passwordControllerProvider);
    final isObscure = ref.watch(_isObscureProvider.notifier);
    return SizedBox(
        height: 80,
        width: 400,
        child: TextFormField(
          key: passwordFormKey,
          controller: passwordController,
          validator: (value) => validatePassword(value),
          obscureText: isObscure.state,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                  isObscure.state ? Icons.visibility_off : Icons.visibility),
              onPressed: () => isObscure.state = !isObscure.state,
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

class _LoginButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
          onPressed: () => _loginButtonPressed(context, ref),
          child: const Text(
            'ログイン',
            style: TextStyle(fontSize: 20),
          )),
    );
  }

  void _loginButtonPressed(BuildContext context, WidgetRef ref) async {
    final emailFormKey = ref.watch(_emailFormKeyProvider);
    final emailController = ref.watch(_emailControllerProvider);
    final passwordFormKey = ref.watch(_passwordFormKeyProvider);
    final passwordController = ref.watch(_passwordControllerProvider);
    if (emailFormKey.currentState!.validate() &&
        passwordFormKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('処理中...')));

      String errMsg = await signInUser(
          email: emailController.text, password: passwordController.text);
      ScaffoldMessenger.of(context).clearSnackBars();
      if (errMsg.isEmpty) {
        emailController.clear();
        passwordController.clear();

        bool isMe = await isMeAdmin();
        if (isMe) {
          context.go('/admin');
        } else {
          context.go('/profile');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errMsg, style: const TextStyle(color: Colors.red))));
      }
    }
  }
}
