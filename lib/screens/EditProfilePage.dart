import 'dart:io';
import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../reusableWidgets/reusableFunctions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final currentUser = FirebaseAuth.instance.currentUser!.uid;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Map<String, String> userDetails = {};
  String balance = "Loading...";
  String points = "Loading...";
  String rank = "Loading...";
  String username = "Loading...";
  String email = "Loading...";
  String profileImage = "Loading...";
  String profileURL = "Loading...";

  PlatformFile? _selectedFile;
  UploadTask? uploadTask;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void fetchData() async {
    try {
      // Firebase updates slow, have to delay the setState
      await Future.delayed(const Duration(milliseconds: 100));

      Map<String, String> tempuserDetails = await getUserDetails();

      if (mounted) {
        setState(() {
          userDetails = tempuserDetails;
          balance = userDetails['balance']!;
          points = userDetails['points']!;
          rank = userDetails['rank']!;
          username = userDetails['username']!;
          email = userDetails['email']!;
          profileImage = userDetails['profileImage']!;
          profileURL = userDetails['profileURL']!;

          usernameController.text = username;
          emailController.text = email;
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
      // You can also show an error message to the user
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      _selectedFile = result.files.first;
      profileURL = result.files.first.path!;
    });
  }

  Future<void> uploadFile() async {
    if (_selectedFile == null) return;

    final path = 'users/$currentUser.jpeg';
    final file = File(_selectedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final url = await snapshot.ref.getDownloadURL();
    print('Download-Link: $url');

    setState(() {
      profileURL = url;
    });

    updateProfile(usernameController.text, currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ReusableAppBar(title: "Edit Profile", backButton: true),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                width: 200,
                height: 200,
                child: _selectedFile != null
                    ? Image.file(
                  File(_selectedFile!.path!),
                  fit: BoxFit.cover,
                )
                    : CachedNetworkImage(
                  imageUrl: profileURL,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      Text('Error: $error'),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: selectFile,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ReusableTextField(
              labelText: "Username",
              controller: usernameController,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ReusableTextField(
              labelText: "Email",
              controller: emailController,
              isReadOnly: true,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ElevatedButton(
            onPressed: () {
              uploadFile();
              Navigator.pop(context,true);
              },
            child: const Text("Save Changes"),
          ),
        ],
      ),
    );
  }
}
