import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../reusableWidgets/reusableFunctions.dart';
import '../reusableWidgets/reusableWidgets.dart';
import 'NavigationPage.dart';

class RankPage extends StatefulWidget {
  const RankPage({super.key});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  List pointHistory = [];
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Map<String, String> userDetails = {};
  String points = "Loading...";
  String pointstoNextRank = "0";
  String rank = "Loading...";
  String downloadURL = "Loading...";
  double progressDenominator = 1;
  double progressbarValue = 1;

  int currentButtonIndex = 0;

  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      pointHistory = await returnAllPointHistory();
      Map<String, String> tempuserDetails = await getUserDetails();

      setState(() {
        userDetails = tempuserDetails;
        points = userDetails['points']!;
        pointstoNextRank = userDetails['pointstoNextRank']!;
        rank = userDetails['rank']!;
      });

      if (rank == "Beginner") {
        progressDenominator = 50;
      } else if (rank == "Intermediate") {
        progressDenominator = 100;
      } else if (rank == "Advanced") {
        progressDenominator = 250;
      } else if (rank == "Expert") {
        progressDenominator = 500;
      }

      double tempprogressbarValue = (progressDenominator - (double.parse(pointstoNextRank))) / progressDenominator;

      String lowerrank = rank.toLowerCase();
      String tempdownloadURL = await _storage.ref('ranks/$lowerrank.png').getDownloadURL();

      setState(() {
        downloadURL = tempdownloadURL;
        progressbarValue = tempprogressbarValue;
        progressDenominator = progressDenominator;
      });
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
              ReusableAppBar(title: "Points", backButton: true),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              if (rank != "Expert")
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container (
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: CachedNetworkImageProvider(downloadURL),
                            ),
                            Text(rank, style: TextStyle(fontSize: 20)),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                            LinearProgressIndicator(
                              value: progressbarValue,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                            ),
                            Row(
                              children: [
                                Text("Rank Progression"),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.005),
                                Tooltip(
                                  message: 'Next Rank: ${rank == "Beginner" ? "Intermediate" : rank == "Intermediate" ? "Advanced" : rank == "Advanced" ? "Expert" : "Expert"}',
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 20,
                                  ),
                                ),
                                Spacer(),
                                Text("${(progressDenominator - (double.parse(pointstoNextRank)))}/${progressDenominator}", style: TextStyle(fontSize: 20))
                              ],
                            ),
                            Row(
                              children: [
                                Spacer(),

                              ],
                            )
                          ],
                        )
                    ),
                  ),
                ),

              if (rank == "Expert")
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container (
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: CachedNetworkImageProvider(downloadURL),
                            ),
                            Text(rank, style: TextStyle(fontSize: 20)),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                            LinearProgressIndicator(
                              value: 1,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Rank Progression"),
                                Text("Highest Possible Rank", style: TextStyle(fontSize: 20))
                              ],
                            )
                          ],
                        )
                    ),
                  ),
                ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  currentButtonIndex = 0;
                                });
                              },
                              child: Text(
                                'Beginner',
                                style: TextStyle(
                                  color: currentButtonIndex == 0 ? Colors.white : Colors.blue,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: currentButtonIndex == 0 ? Colors.blue : Colors.white,
                                side: BorderSide(
                                  color: Colors.grey,
                                ),
                                shape: RoundedRectangleBorder(),
                          
                              )
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  currentButtonIndex = 1;
                                });
                              },
                              child: Text(
                                'Intermediate',
                                style: TextStyle(
                                  color: currentButtonIndex == 1 ? Colors.white : Colors.blue,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: currentButtonIndex == 1 ? Colors.blue : Colors.white,
                                side: BorderSide(
                                  color: Colors.grey,
                                ),
                                shape: RoundedRectangleBorder(),
                          
                              )
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  currentButtonIndex = 2;
                                });
                              },
                              child: Text(
                                'Advanced',
                                style: TextStyle(
                                  color: currentButtonIndex == 2 ? Colors.white : Colors.blue,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: currentButtonIndex == 2 ? Colors.blue : Colors.white,
                                side: BorderSide(
                                  color: Colors.grey,
                                ),
                                shape: RoundedRectangleBorder(),
                              )
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  currentButtonIndex = 3;
                                });
                              },
                              child: Text(
                                'Expert',
                                style: TextStyle(
                                  color: currentButtonIndex == 3 ? Colors.white : Colors.blue,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: currentButtonIndex == 3 ? Colors.blue : Colors.white,
                                side: BorderSide(
                                  color: Colors.grey,
                                ),
                                shape: RoundedRectangleBorder(),
                              )
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          if (currentButtonIndex == 0)
                            Column(
                              children: [
                                if (rank == "Beginner" )
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("You are currently a Beginner"),
                                        Text("Become an Intermediate by ordering more!"),
                                      ],
                                    ),
                                  ),

                                Text("Perks"),
                                Divider(
                                  color: Colors.grey[500],
                                ),
                                Container(
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.grey[200],
                                          child: Icon(Icons.add, color: Colors.green),
                                        ),
                                        SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Points per RM"),
                                            Text("Earn 1x Point for every RM1 spent")
                                          ],
                                        )
                                      ],
                                    )
                                )
                              ],
                            ),

                          if (currentButtonIndex == 1)
                            Column(
                              children: [
                                if (rank == "Intermediate")
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("You are currently an Intermediate"),
                                        Text("Become an Advance by ordering more!"),
                                      ],
                                    ),
                                  ),

                                Text("Perks"),
                                Divider(
                                  color: Colors.grey[500],
                                ),
                                Container(
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.grey[200],
                                          child: Icon(Icons.add, color: Colors.green),
                                        ),
                                        SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Points per RM"),
                                            Text("Earn 1.5x Point for every RM1 spent")
                                          ],
                                        )
                                      ],
                                    )
                                )
                              ],
                            ),


                          if (currentButtonIndex == 2)
                            Column(
                              children: [
                                if (rank == "Advanced")
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("You are currently an Advanced"),
                                        Text("Become an Expert by ordering more!"),
                                      ],
                                    ),
                                  ),

                                Text("Perks"),
                                Divider(
                                  color: Colors.grey[500],
                                ),
                                Container(
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.grey[200],
                                          child: Icon(Icons.add, color: Colors.green),
                                        ),
                                        SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Points per RM"),
                                            Text("Earn 2x Point for every RM1 spent")
                                          ],
                                        )
                                      ],
                                    )
                                )
                              ],
                            ),



                          if (currentButtonIndex == 3)
                            Column(
                              children: [
                                if (rank == "Expert")
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("You are currently an Expert"),
                                        Text("Enjoy the best benefits when ordering!"),
                                      ],
                                    ),
                                  ),

                                Text("Perks"),
                                Divider(
                                  color: Colors.grey[500],
                                ),
                                Container(
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.grey[200],
                                          child: Icon(Icons.add, color: Colors.green),
                                        ),
                                        SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Points per RM"),
                                            Text("Earn 3x Point for every RM1 spent")
                                          ],
                                        )
                                      ],
                                    )
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}
