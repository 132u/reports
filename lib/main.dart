import 'package:chat_app/screens/auth.dart';
import 'package:chat_app/screens/drivers.dart'; 
import 'package:chat_app/screens/reports.dart';
import 'package:chat_app/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Отчеты',
      theme: ThemeData(
    // Define the default brightness and colors.
   // brightness: Brightness.dark,
    primaryColor: Color.fromARGB(255, 18, 123, 58),

    // Define the default font family.
    fontFamily: 'Georgia',

    // Define the default `TextTheme`. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 20, fontStyle: FontStyle.normal),
      bodyMedium: TextStyle(fontSize: 14, fontFamily: 'Hind'),
    ),
  ),
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snapshot){
        if(snapshot.connectionState ==  ConnectionState.waiting){
          return const SplashScreen();
        }
        if(snapshot.hasData){
          return ReportsScreen();
        }
        return const AuthScreen();
      },)
    );
  }
}