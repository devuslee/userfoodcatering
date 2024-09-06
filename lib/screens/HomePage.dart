
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:userfoodcatering/screens/CalendarPage.dart';
import 'package:userfoodcatering/screens/RankPage.dart';
import 'package:userfoodcatering/screens/WalletPage.dart';
import 'package:intl/intl.dart';
import '../class/menuClass.dart';
import '../reusableWidgets/reusableColor.dart';
import 'PointPage.dart';
import 'ReviewPage.dart';

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

  String selectedDateTime = DateTime.now().toString().split(" ")[0];

  DateTime selectedDate = DateTime.now();

  List todayHistory = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      Map<String, String> tempUserDetails = await getUserDetails();
      List<MenuClass> tempAllMenuItems = await getMenuData();
      todayHistory = await returnOrderHistory(selectedDateTime);


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
          currentPointprogress = double.parse(currentPointprogress.toStringAsFixed(2));
          progressBarText = "$currentPointprogress/$progressDenominator";
          allMenuItems = tempAllMenuItems;
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void _incrementDate() {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: 1));
      selectedDateTime = selectedDate.toString().split(" ")[0];
      setState(() {
        fetchData();
      });
    });
  }

  void _decrementDate() {
    setState(() {
      selectedDate = selectedDate.subtract(Duration(days: 1));
      selectedDateTime = selectedDate.toString().split(" ")[0];
      setState(() {
        fetchData();
      });
    });
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
                  Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.0), // Adjust padding as needed
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey), // Add border
                          borderRadius: BorderRadius.circular(8.0), // Add border radius for rounded corners
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ReusableContainer(text: "Wallet", textvalue: "RM ${balance}", onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => WalletPage()),);
                            }),
                            ReusableContainer(text: "Points", textvalue: "${points} pts", onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PointPage()),);
                            },),

                            if (rank == "Expert")
                            ReusableContainer(text: rank, textvalue: "Highest Rank", onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RankPage()),);
                            },),

                            if (rank != "Expert")
                            ReusableContainer(text: rank, textvalue: progressBarText, onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RankPage()),);
                            },),
                          ],
                        )
                    ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  // Text(
                  //   "Heres the orders you have for today",
                  //   style: TextStyle(
                  //     fontSize: 20.0,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _decrementDate,
                        icon: Icon(
                          Icons.arrow_left,
                          size: 50,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(selectedDateTime),
                            firstDate: DateTime(2021),
                            lastDate: DateTime(2025),
                          );

                          if (date != null) {
                            selectedDateTime = date.toString().split(" ")[0];
                            setState(() {
                              fetchData();
                            });
                          }
                        },
                        child: Text(
                          DayMonthYearFormatter(selectedDateTime),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _incrementDate,
                        icon: Icon(
                          Icons.arrow_right,
                          size: 50,
                        ),
                      ),
                    ],
                  ),

                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarPage()),);
                      },
                      child: Text("View Calendar"),
                  ),



                  if (todayHistory.isEmpty)
                    Column(
                      children: [
                        Icon(Icons.error_outline, size: 50.0, color: Colors.red),
                        Text(
                          "No orders for today",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.grey,
                          ),
                        ),
                      ]
                    ),


                  if (todayHistory.isNotEmpty)
                    for (var history in todayHistory)
                      if (history.type == 'Expense')
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width * 0.81,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          )

                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Pickup Order",
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Location: 5-G-1,Promenade, Jalan Mahsuri, 11900 Bayan Baru, Pulau Pinang'),
                                                    Text('Pickup Time: ${HourFormatter(
                                                        history.desiredPickupTime)
                                                    }'
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Total"),
                                                    Text('RM${NumberFormat('##0.00').format(history.total)}'),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Text('Pickup Date: ${DayMonthYearFormatter(history.desiredPickupTime)} (Today)'),
                                            Text(history.specialRemarks == "" ? 'Special Remarks: None' : 'Special Remarks: ${history.specialRemarks}'),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Payment Method: ${history.paymentMethod}'),
                                                Spacer(),
                                                Row(
                                                  children: [
                                                    Text('Status: '),
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            color: history.status == 'Pending' ? darkYellow : Colors.green,
                                                            borderRadius: BorderRadius.circular(5)
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Text(
                                                            history.status,
                                                            style: TextStyle(
                                                                color: Colors.white),
                                                          ),
                                                        )
                                                    ),
                                                  ],
                                                ),
                                                ],
                                            ),
                                            Divider(color: Colors.grey[300],),
                                            for (var order in history.orderHistory)
                                              Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(order['name']),
                                                      Text(order['quantity'].toString()),
                                                    ],
                                                  ),
                                                ],
                                              ),

                                            if (history.status == "Ready")
                                              Column(
                                                children: [
                                                  Divider(color: Colors.grey[300],),
                                                  Text("Yours order is ready! Please come and pick it up!"),
                                                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                  ElevatedButton(
                                                    child: Text("I have picked up my order"),
                                                    onPressed: ()  {
                                                      setState(() {
                                                        updateHistoryStatus(history.id, "Completed");
                                                        fetchData();
                                                      });

                                                      //bound to change when qr code is done

                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      side: BorderSide(color: Colors.grey),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            if (history.status == "Completed")
                                              Column(
                                                children: [
                                                  Divider(color: Colors.grey[300],),
                                                  Text("Thanks for ordering with us! Please leave a review!"),
                                                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                  ElevatedButton(
                                                    child: Text("Leave a Review"),
                                                    onPressed: () async {
                                                      bool isRefresh = await Navigator.push(
                                                        context, MaterialPageRoute(
                                                          builder: (context) => ReviewPage(
                                                            orderHistory: history.orderHistory,
                                                            id: history.id,
                                                          )
                                                        ),
                                                      );

                                                      if (isRefresh) {
                                                        setState(() {
                                                          fetchData();
                                                        });
                                                      }
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      side: BorderSide(color: Colors.grey),
                                                      ),
                                                  ),
                                                ],
                                              ),

                                            if (history.status == "Completed and Reviewed")
                                              Column(
                                                children: [
                                                  Divider(color: Colors.grey[300],),
                                                  Text("Thanks for ordering with us!"),
                                                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                ],
                                              ),
                                          ],
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                          ],
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
