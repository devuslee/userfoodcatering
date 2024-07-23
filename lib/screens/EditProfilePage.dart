import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../reusableWidgets/reusableFunctions.dart';
import 'EditProfileImagePage.dart';

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

          usernameController.text = username;
          emailController.text = email;
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
          ReusableAppBar(title: "Edit Profile", backButton: true),
          const SizedBox(height: 10),
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: CachedNetworkImageProvider(profileURL),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileImagePage()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.black
                      ),
                    ),
                    child: Icon(
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
            child: ReusableTextField(labelText: "Username", controller: usernameController,),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ReusableTextField(labelText: "Email", controller: emailController, isReadOnly: true,),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ElevatedButton(
              onPressed: () {
                updateProfile(usernameController.text, profileImage);
              },
              child: const Text("Save Changes"),
          ),
        ],
      )
    );
  }
}
