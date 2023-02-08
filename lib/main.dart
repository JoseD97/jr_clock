import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:jr_clock/providers/auth_provider.dart';
import 'package:jr_clock/services/services.dart';
import 'package:jr_clock/services/preferences.dart';
import 'package:jr_clock/themes/main_theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/providers.dart';
import 'screens/screens.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Preferences.initPreferences();
  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HistoricProvider()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => FirebaseProvider()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'JR CLock',
        theme: mainTheme,
        scaffoldMessengerKey: NotificationsService.messengerKey,
        initialRoute: 'login',
        routes: {
          'login': (_) => const LoginScreen(),
          'register': (_) => const RegisterScreen(),
          'home': (_) => const HomeScreen(),
          'historic': (_) => const HistoricScreen(),
          'profile': (_) => const ProfileScreen(),
        },
      ),
    );
  }
}
