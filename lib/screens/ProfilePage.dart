import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:userfoodcatering/screens/ChangePasswordPage.dart';
import 'package:userfoodcatering/screens/PointPage.dart';
import 'package:userfoodcatering/screens/RankPage.dart';
import 'package:userfoodcatering/screens/TopupPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:userfoodcatering/screens/WalletPage.dart';
import '../reusableWidgets/reusableColor.dart';
import 'EditProfilePage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'LoginPage.dart';
import 'package:timezone/timezone.dart' as tz;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Map<String, String> userDetails = {};
  String balance = "Loading...";
  String points = "Loading...";
  String rank = "Loading...";
  String username = "Loading...";
  String profileURL = "Loading...";


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      //firebase updates slow, have to delay the setstate
      await Future.delayed(Duration(milliseconds: 500));


      Map<String, String> tempuserDetails = await getUserDetails();

      if (mounted) {
        setState(() {
          userDetails = tempuserDetails;
          balance = userDetails['balance']!;
          points = (double.parse(userDetails['points']!).toStringAsFixed(2)).toString();
          rank = userDetails['rank']!;
          username = userDetails['username']!;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            ReusableAppBar(title: "Profile",  backButton: false),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: CachedNetworkImageProvider(profileURL),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Text(username, style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: lightGrey,
                        border: Border.all(color: Colors.black,),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.blue,
                                      child: Icon(Icons.monetization_on, color: Colors.white),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                    Text(
                                      "Balance",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                        'RM ${balance}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          bool shouldRefresh = await Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => WalletPage()
                                              )
                                          );
                                          if (shouldRefresh) {
                                            setState(() {
                                              fetchData();
                                            });
                                          }
                                        },
                                      child: Text("View Points",
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
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              height: 1,
                              color: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                    Text(
                                      "Points",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                        points,
                                        style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      )
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          bool shouldRefresh = await Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => PointPage()
                                              )
                                          );
                                          if (shouldRefresh) {
                                            setState(() {
                                              fetchData();
                                            });
                                          }
                                        },
                                        child: Text("View Points",
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
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                  ],
                                ),
                                //vertical divider
                                Container(
                                  width: 1.0,
                                  height: MediaQuery.of(context).size.height * 0.14,
                                  color: Colors.grey,
                                ),
                                Column(
                                  children: [
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                    Text(
                                      "Rank",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                        rank,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          bool shouldRefresh = await Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => RankPage()
                                              )
                                          );
                                          if (shouldRefresh) {
                                            setState(() {
                                              fetchData();
                                            });
                                          }
                                        },
                                      child: Text("View Points",
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
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                  ],
                                ),
                              ],
                            )
                          ]
                        ),
                      )
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Text(
                        "Settings",
                      style: GoogleFonts.lato(
                        fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                        fontWeight: FontWeight.bold, // Adjust font weight
                        color: selectedButtonColor, // Adjust text color
                      ),
                      ),
                    Divider(
                      color: Colors.grey.withOpacity(0.5),
                      thickness: 2.0,
                    ),
                    ReuseableSettingContainer(
                        title: "Edit Profile",
                        icon: Icons.edit,
                        onTap: () async {
                          bool shouldRefresh = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditProfilePage()
                              )
                          );

                          if (shouldRefresh) {
                            setState(() {
                              fetchData();
                            });
                          }
                        },
                    ),
                    ReuseableSettingContainer(
                        title: "Change Password",
                        icon: Icons.lock,
                        onTap: () async {
                          bool shouldRefresh = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ChangePasswordPage()
                              )
                          );

                          if (shouldRefresh) {
                            setState(() {
                              fetchData();
                            });
                          }
                        },
                    ),
                    ReuseableSettingContainer(
                        title: "Logout",
                        icon: Icons.logout,
                        onTap: () {
                          logout(context);
                        }
                        ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                  ]
              ),
            )
          ],
        ),
      ),
    );
  }
}