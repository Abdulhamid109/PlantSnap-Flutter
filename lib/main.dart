import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plantsnap/firebase_options.dart';
// import 'package:plantsnap/pages/homepage.dart';
import 'package:plantsnap/pages/splashScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Splashscreen(),
    );
  }
}

