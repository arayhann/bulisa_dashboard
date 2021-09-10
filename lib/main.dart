import 'package:bulisa_dashboard/pages/main_page.dart';
import 'package:bulisa_dashboard/pages/login_page.dart';
import 'package:bulisa_dashboard/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('bulisa');
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BuLiSa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: AuthPage(),
    );
  }
}

class AuthPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.read(authProvider.notifier);
    return authState.tryAutoLogin() ? MainPage() : LoginPage();
  }
}
