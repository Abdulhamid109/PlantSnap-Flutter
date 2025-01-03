import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plantsnap/pages/homepage.dart';
import 'package:plantsnap/pages/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => SplashscreenState();
}

class SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  static const String LOGINKEY = "Login";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 5), () async {
      var sharedPref = await SharedPreferences.getInstance();
      var isloggedin = sharedPref.getBool(LOGINKEY);
      if (isloggedin != null) {
        if (isloggedin) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const Homepage(login: 0,),
          ));
        }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
        }
      }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage(),));

      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  void where() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.green],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'PlantSnap 🪴',
              style: TextStyle(color: Colors.white, fontSize: 35),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: CircularProgressIndicator(
                color: Colors.green.shade900,
              ),
            )
          ],
        ),
      ),
    );
  }
}
