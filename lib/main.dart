import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:test/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test/profile_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// if [USE_FIREBASE_EMU] is not defined, compiler omit this code.
  if (const bool.fromEnvironment('USE_FIREBASE_EMU')) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(initialLocation: '/login', routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage())
  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}
