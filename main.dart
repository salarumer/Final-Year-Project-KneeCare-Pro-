import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gemini/flutter_gemini.dart'; // Import Gemini package
import 'package:signup/api/firebase_api.dart';
import 'cost.dart';
import 'home.dart'; // Your home screen
import 'pages/signinpage.dart'; // Your Sign In page




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  Gemini.init(apiKey: Gemini_Api_Key); // Initialize Gemini
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const AuthGate(), // Redirect based on auth state
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;

          if (user == null) {
            // If user is not signed in, navigate to Sign In
            return const Signin();
          } else {
            // If user is signed in, navigate to Home
            return const Home();
          }
        } else {
          // While waiting for the auth state
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
