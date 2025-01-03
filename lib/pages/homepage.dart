import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:plantsnap/pages/identifyPage.dart';
import 'package:plantsnap/pages/loginpage.dart';

class Homepage extends StatefulWidget {
  final int login;
  const Homepage({super.key, required this.login});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late InfiniteScrollController controller;
  int selectedIndex = 0;
  File? _selectedImage;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    controller = InfiniteScrollController();
    print("Current UID: ${_auth.currentUser!.uid}");
    print("Logged in with :${widget.login}");
    fetchCurrentUser();
  }

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        return File(image.path); // Returns the selected image as a File
      }
    } catch (e) {
      print("Error picking image from gallery: $e");
    }
    return null; // Returns null if no image is selected
  }

  //image from camera
  Future<File?> captureImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        return File(image.path); // Returns the captured image as a File
      }
    } catch (e) {
      print("Error capturing image from camera: $e");
    }
    return null; // Returns null if no image is captured
  }

  Future<void> signOut() async {
    if (widget.login == 0) {
      print("object b");
      await _auth.signOut().then(
            (val) => FirebaseAuth.instance.signOut().then(
                  (val) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  ),
                ),
          );
    } else if (widget.login == 1) {
      print("object n");
      await _googleSignIn.signOut().then(
            (val) => FirebaseAuth.instance.signOut().then(
                  (val) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  ),
                ),
          );
    }
  }

  String username = "";
  static int track = 0;
  //fetch current user
  void fetchCurrentUser() async {
    try {
      if (widget.login == 0) {
        track = widget.login;
        final current = await FirebaseFirestore.instance
            .collection("user")
            .doc(_auth.currentUser!.uid)
            .get();
        setState(() {
          username = current["email"];
        });
      } else if (widget.login == 1) {
        track = widget.login;
        final current = await FirebaseFirestore.instance
            .collection("G-User")
            .doc(_auth.currentUser!.uid)
            .get();
        setState(() {
          username = current["email"];
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 1;
    double width = MediaQuery.of(context).size.width * 1;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "PlantSnap",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 11, 77, 175),
                shadows: [
                  Shadow(
                      color: Colors.white, offset: Offset(2, 2), blurRadius: 15)
                ]),
          ),
          elevation: 5,
          backgroundColor: Colors.green,
          actions: const [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "About Us",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: Color.fromARGB(255, 0, 3, 7),
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: height * 1,
            width: width * 1,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://imgs.search.brave.com/_c3DECpGo1V0q3ZQdHsHhoTYfOQhgunuOTyJn-fhiIE/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93YWxs/cGFwZXJhY2Nlc3Mu/Y29tL2Z1bGwvNDU4/Njg4OS5qcGc"),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Welcome to the World of Plants with AI",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 8, 8, 8),
                        shadows: [
                          BoxShadow(
                              offset: Offset(2, 2),
                              blurRadius: 20,
                              spreadRadius: 10)
                        ]),
                  ),
                  // buttons
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        shadowColor: Colors.black,
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () async {
                        final image = await pickImageFromGallery();
                        if (image != null) {
                          setState(() {
                            _selectedImage = image;
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Identifypage(selectedImage: _selectedImage,),));

                        }
                      },
                      child: const Text(
                        "Upload",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          shadowColor: Colors.black,
                          backgroundColor: Colors.green),
                      onPressed: () async{
                        final image = await captureImageFromCamera();
                        if (image != null) {
                          setState(() {
                            _selectedImage = image;
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Identifypage(selectedImage: _selectedImage,),));
                        }
                      },
                      child: const Text(
                        "Capture",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  //plant images carousel

                  const ListTile(
                    title: Text(
                      "The clearest way into the Universe is through a forest wilderness.",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("— John Muir",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const ListTile(
                    title: Text(
                      "A society grows great when old men plant trees whose shade they know they shall never sit in.",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("— Greek Proverb",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const ListTile(
                    title: Text(
                      "A society grows great when old men plant trees whose shade they know they shall never sit in.",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("— Greek Proverb",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300)),
                  ),
                ],
              ),
            ),
          ),
        ),
        drawer: Drawer(
          backgroundColor: Colors.greenAccent,
          child: Column(
            children: [
              Container(
                height: height * 0.3,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/logo.png"),
                        fit: BoxFit.cover)),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Icon(
                  Icons.home,
                  size: 30,
                ),
                title: const Text(
                  "Home",
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 10,
                        )
                      ]),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Homepage(
                        login: widget.login,
                      ),
                    )),
              ),
              const ListTile(
                leading: Icon(
                  Icons.info,
                  size: 30,
                ),
                title: Text(
                  "About Us",
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 10,
                        )
                      ]),
                ),
              ),
              const ListTile(
                leading: Icon(
                  Icons.history,
                  size: 30,
                ),
                title: Text(
                  "History",
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 10,
                        )
                      ]),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  size: 30,
                ),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(1, 1),
                          blurRadius: 10,
                        )
                      ]),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Center(
                          child: Text("Are you Sure you want to Logout?"),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              TextButton(
                                  onPressed: () => signOut(),
                                  child: const Text("Yes")),
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("No"))
                            ],
                          )
                        ],
                      );
                    },
                  );
                },
              ),
              SizedBox(
                height: height * 0.176,
              ),
              Container(
                height: 100,
                child: Center(
                  child: Text(
                    username != "" ? username : "tony Stark",
                    style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1, 1),
                            blurRadius: 10,
                          )
                        ]),
                  ),
                ),
                color: Colors.green.shade700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
