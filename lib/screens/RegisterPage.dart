
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:userfoodcatering/screens/LoginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  bool userEmpty = false;
  bool emailEmpty = false;
  bool passwordEmpty = false;
  bool confirmpasswordEmpty = false;
  bool checkPassword = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Register', style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
              const SizedBox(height: 25.0,),
              ReusableTextField(labelText: 'Username', controller: usernameController, isPassword: false),
              Align(
                alignment: Alignment.centerLeft,
                child: Visibility(
                  visible: userEmpty,
                  child: const Text('Please fill in all fields.',
                    style: TextStyle(color: Colors.red)),
                ),
              ),
              const SizedBox(height: 10.0,),
              ReusableTextField(labelText: 'Email', controller: emailController, isPassword: false),
              Align(
                alignment: Alignment.centerLeft,
                child: Visibility(
                  visible: emailEmpty,
                  child: const Text('Please fill in all fields.',
                    style: TextStyle(color: Colors.red)),
                ),
              ),
              const SizedBox(height: 10.0,),
              ReusableTextField(labelText: 'Password', controller: passwordController, isPassword: true),
              Align(
                alignment: Alignment.centerLeft,
                child: Visibility(
                  visible: passwordEmpty,
                  child: const Text('Please fill in all fields.',
                    style: TextStyle(color: Colors.red)),
                ),
              ),
              const SizedBox(height: 10.0,),
              ReusableTextField(labelText: 'Confirm Password', controller: confirmpasswordController, isPassword: true),
              Align(
                alignment: Alignment.centerLeft,
                child: Visibility(
                  visible: confirmpasswordEmpty,
                  child: const Text('Please fill in all fields.',
                    style: TextStyle(color: Colors.red)),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Visibility(
                  visible: checkPassword,
                  child: const Text('Password does not match.',
                    style: TextStyle(color: Colors.red)),
                ),
              ),
              const SizedBox(height: 10.0,),
              ElevatedButton(
                onPressed: () {
                  if (usernameController.text.isEmpty) {
                    setState(() {
                      userEmpty = true;
                    });
                  } else {
                    setState(() {
                      userEmpty = false;
                    });
                  }

                  if (emailController.text.isEmpty) {
                    setState(() {
                      emailEmpty = true;
                    });
                  } else {
                    setState(() {
                      emailEmpty = false;
                    });
                  }

                  if (passwordController.text.isEmpty) {
                    setState(() {
                      passwordEmpty = true;
                    });
                  } else {
                    setState(() {
                      passwordEmpty = false;
                    });
                  }

                  if (confirmpasswordController.text.isEmpty) {
                    setState(() {
                      confirmpasswordEmpty = true;
                    });
                  } else {
                    setState(() {
                      confirmpasswordEmpty = false;
                    });
                  }

                  if (passwordController.text != confirmpasswordController.text) {
                    setState(() {
                      confirmpasswordEmpty = false;
                      checkPassword = true;
                    });
                  } else {
                    setState(() {
                      checkPassword = false;
                    });
                  }


                  if (checkPassword == false && userEmpty == false && emailEmpty == false && passwordEmpty == false && confirmpasswordEmpty == false) {
                    FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text
                    ).then((value) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .set({
                        'userid': FirebaseAuth.instance.currentUser!.uid,
                        'username': usernameController.text,
                        'email': emailController.text,
                        'balance': 0,
                        'points': 0,
                        'pointstoNextRank': 50,
                        'rank': 'Beginner',
                        'profileImage': 'blank_profile',
                        'lastcheckedinTime': '',
                        'checkinCounter': 0,
                      }).then((value) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                      }).onError((error, stackTrace) {
                        print("Error: $error");
                      });
                    }).onError((error, stackTrace) {
                      print("Error: $error");
                    });
                  }
                },
                child: const Text('Register'),
              ),
              const SizedBox(height: 10,),
              GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: const Text('Have an account? Login here.')
              )
            ],
          ),
        ),
      ),
    );
  }
}
