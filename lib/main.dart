import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:speach_text_assist/Screens/HomeScreen.dart';
import 'package:speach_text_assist/Screens/WelcomeScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC94HXwqRQ2S2NqPW7X1_ywicexE628e4Q",
      appId: "1:20908731184:android:025fa3e0350939ad4376f5",
      messagingSenderId: "20908731184",
      projectId: "speech-text-assist",
    ),
  );

  runApp(const MyApp());
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: user != null ? const HomeScreen() : const WelcomeScreen(),
    );
  }
}
