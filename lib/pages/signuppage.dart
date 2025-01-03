import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantsnap/pages/homepage.dart';
import 'package:plantsnap/pages/loginpage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();


  

  void firebaseSignup(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((val) => {
            print(val.user!.uid),
                fireCloudSignup()
              });
    } catch (e) {
      print("Hello $e");
    }
  }

  void fireCloudSignup() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      print(user?.uid);
      if (user != null) {
        await FirebaseFirestore.instance.collection("user").doc(user.uid).set({
          "email": _emailController.text.toLowerCase().toString(),
          "password": _passwordController.text.toString(),
          "userId": user.uid
        }).then((val)=>{
          Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Homepage(login: 0,),
                    ))
        })
        
        .catchError((err) => {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Center(child: Text(err.code.toString())),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"))
                    ],
                  );
                },
              ),
            });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Sign up to get started',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 32.0),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // else if (!RegExp(
                    //         r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\$")
                    //     .hasMatch(value)) {
                    //   return 'Please enter a valid email';
                    // }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform signup
                        firebaseSignup(_emailController.text.toLowerCase().toString(),_passwordController.text.toString());
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text('Signing up...')),
                        // );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(thickness: 1.0),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('OR'),
                    ),
                    Expanded(
                      child: Divider(thickness: 1.0),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                // SizedBox(
                //   width: double.infinity,
                //   child: OutlinedButton.icon(
                //     onPressed: () {
                //       // Handle Google sign-up
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //             content: Text('Continue with Google...')),
                //       );
                //     },
                //     icon: const Icon(Icons.g_translate),
                //     label: const Text('Continue with Google'),
                //     style: OutlinedButton.styleFrom(
                //       padding: const EdgeInsets.symmetric(vertical: 16.0),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8.0),
                //       ),
                //     ),
                //   ),
                // ),
                
                // const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        // Navigate to login page
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage(),));
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
