import 'package:flutter/material.dart';
import 'package:instagram/core/theme/app_theme.dart';
import 'package:instagram/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram/features/feed/presentations/screens/HomeScreen.dart';
import 'core/utils/token_storage.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _tokenStorage = TokenStorage();
  bool _isLoggedIn = false;
  bool _checked = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final token = await _tokenStorage.readAccessToken();
    setState(() {
      _isLoggedIn = token != null;
      _checked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_checked) {
      return Center(child: CircularProgressIndicator(color: Colors.blueAccent));
    }
    return MaterialApp(
      title: 'Instagram Clone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: _isLoggedIn ? Homescreen() : LoginScreen(),
    );
  }
}
