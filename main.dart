import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );
  runApp(const KareHelpDeskApp());
}

class KareHelpDeskApp extends StatelessWidget {
  const KareHelpDeskApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Supabase.instance.client.auth;
    return MaterialApp(
      title: 'KARE Help Desk',
      debugShowCheckedModeBanner: false,
      theme: kareTheme(),
      home: StreamBuilder<AuthState>(
        stream: auth.onAuthStateChange,
        builder: (context, _) =>
            auth.currentSession == null ? const LoginScreen() : const HomeScreen(),
      ),
    );
  }
}
