
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';

import '../class/menuClass.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CarouselController buttonCarouselController = CarouselController();
  final List<int> _items = [1, 2, 3, 4, 5];
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Map<String, String> userDetails = {};

  String balance = "Loading...";
  String points = "Loading...";
  String rank = "Loading...";
  String welcomeText = "Loading...";
  String progressBarText = "Loading...";
  String username = "Loading...";
  String greetingTime = "Loading...";

  int progressDenominator = 0;

  double pointsToNextRank = 0;
  double currentPointprogress = 0;
  List<MenuClass> allMenuItems = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      Map<String, String> tempUserDetails = await getUserDetails();
      List<MenuClass> tempAllMenuItems = await getMenuData();



      if (mounted) {
        setState(() {
          userDetails = tempUserDetails;
          balance = userDetails['balance']!;
          points = userDetails['points']!;
          rank = userDetails['rank']!;

          // Welcome message
          username = userDetails['username']!;

          // Greeting message
          if (DateTime.now().hour < 12) {
            greetingTime = "Morning";
          } else if (DateTime.now().hour < 18) {
            greetingTime = "Afternoon";
          } else {
            greetingTime = "Evening";
          }

          // Greeting message
          welcomeText = "Good $greetingTime, $username!";

          if (rank == "Beginner") {
            progressDenominator = 50;
          } else if (rank == "Intermediate") {
            progressDenominator = 100;
          } else if (rank == "Advanced") {
            progressDenominator = 250;
          } else if (rank == "Expert") {
            progressDenominator = 500;
          }
          pointsToNextRank = double.parse(userDetails['pointstoNextRank']!);
          currentPointprogress = progressDenominator - pointsToNextRank;
          progressBarText = "$currentPointprogress/$progressDenominator";
          allMenuItems = tempAllMenuItems;
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<Map<String, String>> _getImageUrls() async {
    Map<String, String> imageUrls = {};


    for (var i = 0; i < allMenuItems.length; i++) {
      imageUrls[allMenuItems[i].name] = allMenuItems[i].imageURL;
    }

    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ReusableAppBar(title: 'Home',  backButton: false),
            FutureBuilder<Map<String,String>>(
              future: _getImageUrls(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return CircularProgressIndicator();
                } else {
                  Map<String, String> imageUrls = snapshot.data!;
                  return FlutterCarousel(
                    options: CarouselOptions(
                      height: 400.0,
                      aspectRatio: 2.0,
                      viewportFraction: 1.0,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      autoPlay: true,
                    ),
                    items: imageUrls.entries.map((entry) {
                      String name = entry.key;
                      String url = entry.value;
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: 500,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: CachedNetworkImage(
                                    imageUrl: url,
                                    imageBuilder: (context, imageProvider) => Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Text('Error: $error'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                }
              },
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                      child: Text(
                          welcomeText, style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.025)
                      )
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Align(
                    child: Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.0), // Adjust padding as needed
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey), // Add border
                          borderRadius: BorderRadius.circular(8.0), // Add border radius for rounded corners
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ReusableContainer(text: "Wallet", textvalue: "RM ${balance}"),
                            ReusableContainer(text: "Points", textvalue: "${points} pts"),
                            ReusableContainer(text: rank, textvalue: progressBarText),
                          ],
                        )
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
