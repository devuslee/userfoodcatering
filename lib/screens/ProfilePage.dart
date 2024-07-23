import 'dart:io';

import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:userfoodcatering/screens/TopupPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String balance = 'Loading...';
  String points = 'Loading...';
  String rank = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      //firebase updates slow, have to delay the setstate
      await Future.delayed(Duration(milliseconds: 100));


      String userBalance = await getUserBalance();
      String userPoints = await getUserPoints();
      String userRank = await getUserRank();

      if (mounted) {
        setState(() {
          balance = userBalance;
          points = userPoints;
          rank = userRank;
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
                      backgroundImage: AssetImage('blank_profile.jpeg'),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Text('John Doe', style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                    Text(
                                      "Balance",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(balance),
                                    ElevatedButton(
                                        onPressed: () async {
                                          bool shouldRefresh = await Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => TopupPage()
                                              )
                                          );
                                          if (shouldRefresh) {
                                            setState(() {
                                              fetchData();
                                            });
                                          }
                                        },
                                        child: Text(" + Top Up")
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
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
                                  ],
                                ),
                                //vertical divider
                                Container(
                                  width: 1.0,
                                  height: 50.0,
                                  color: Colors.grey,
                                ),
                                Column(
                                  children: [
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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    Divider(
                      color: Colors.grey.withOpacity(0.5),
                      thickness: 2.0,
                    ),
                    ReuseableSettingContainer(title: "Logout", icon: Icons.logout, onTap: () {print('Logout');}),
                    ReuseableSettingContainer(title: "Edit Profile", icon: Icons.edit, onTap: () {print('Edit Profile');}),
                    ReuseableSettingContainer(title: "Change Password", icon: Icons.lock, onTap: () {}),
                    ReuseableSettingContainer(title: "Delete Account", icon: Icons.delete, onTap: () {}),
                  ]
              ),
            )
          ],
        ),
      ),
    );
  }
}