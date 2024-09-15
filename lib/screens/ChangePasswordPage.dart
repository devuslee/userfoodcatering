import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../reusableWidgets/reusableColor.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ReusableAppBar(title: 'Change Password', backButton: true),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ReusableTextField(labelText: "Old Password", controller: oldpasswordController, isPassword: true),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ReusableTextField(labelText: "New Password", controller: newpasswordController, isPassword: true),
          ),
          ElevatedButton(
              onPressed: () {
                User? user = FirebaseAuth.instance.currentUser;
                AuthCredential credential = EmailAuthProvider.credential(email: user!.email!, password: oldpasswordController.text);
                user.reauthenticateWithCredential(credential).then((value) {
                  user.updatePassword(newpasswordController.text).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password changed successfully')));
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password change failed')));
                  });
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Incorrect Old Password')));
                });
              },
            child: Text("Change Password",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),
        ],
      )
    );
  }
}
