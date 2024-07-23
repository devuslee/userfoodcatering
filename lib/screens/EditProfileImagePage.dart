import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';



final currentUser = FirebaseAuth.instance.currentUser!.uid;
String url = "";

class EditProfileImagePage extends StatefulWidget {
  const EditProfileImagePage({super.key});

  @override
  State<EditProfileImagePage> createState() => _EditProfileImagePageState();
}

class _EditProfileImagePageState extends State<EditProfileImagePage> {
  PlatformFile? _selectedFile;
  UploadTask? uploadTask;

  Map<String, String> userDetails = {};
  String balance = "Loading...";
  String points = "Loading...";
  String rank = "Loading...";
  String username = "Loading...";
  String email = "Loading...";
  String profileImage = "Loading...";
  String profileURL = "Loading...";

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      _selectedFile = result.files.first;
      profileURL = result.files.first.path!;
    });
  }

  Future uploadFile() async {
    if (_selectedFile == null) return;

    final path = 'users/${currentUser}.jpeg';
    final file = File(_selectedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    url = await snapshot.ref.getDownloadURL();
    print('Download-Link: $url');

    setState(() {
      profileURL = url;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      //firebase updates slow, have to delay the setstate
      await Future.delayed(Duration(milliseconds: 100));

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
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ReusableAppBar(title: "Choose Image", backButton: true),
          Container(
            width: 200,
            height: 200,
            child: _selectedFile != null
                ? Image.file(
              File(_selectedFile!.path!),
              fit: BoxFit.cover,
              ) : CachedNetworkImage(
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
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  Text('Error: $error'),
            ),
          ),
          ElevatedButton(
            onPressed: selectFile,
            child: Text('Select File'),
          ),
          ElevatedButton(
            onPressed: uploadFile,
            child: Text('Upload File'),
          ),
        ],
      ),
    );
  }
}
