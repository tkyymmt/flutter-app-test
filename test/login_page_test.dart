import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test/firebase_options.dart';
import 'package:test/login_page.dart';

void main() {
  /*
  testWidgets('[LoginPage] widget testing ...', (tester) async {
    await tester
        .pumpWidget(const ProviderScope(child: MaterialApp(home: LoginPage())));

    final emailFormFinder = find.widgetWithText(TextFormField, 'メールアドレス');
    final passwordFormFinder = find.widgetWithText(TextFormField, 'パスワード');
    final loginButtonFinder = find.widgetWithText(ElevatedButton, 'ログイン');

    expect(emailFormFinder, findsOneWidget);
    expect(passwordFormFinder, findsOneWidget);
    expect(loginButtonFinder, findsOneWidget);

    const String email = 't@takkun.com';
    const String password = 'tttttttt';

    await tester.enterText(emailFormFinder, email);
    await tester.enterText(passwordFormFinder, password);
    //await tester.tap(loginButtonFinder);
    await tester.pump();

    expect(find.text(email), findsOneWidget);
    expect(find.text(password), findsOneWidget);
    //expect(find., findsOneWidget);
  });
  */
}
