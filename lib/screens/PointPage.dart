import 'package:flutter/material.dart';

import '../reusableWidgets/reusableColor.dart';
import '../reusableWidgets/reusableFunctions.dart';
import '../reusableWidgets/reusableWidgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'NavigationPage.dart';

class PointPage extends StatefulWidget {
  const PointPage({super.key});

  @override
  State<PointPage> createState() => _PointPageState();
}

class _PointPageState extends State<PointPage> {
  List pointHistory = [];

  Map<String, String> userDetails = {};
  String points = "Loading...";


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
        points = (double.parse(userDetails['points']!).toStringAsFixed(2)).toString();
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container (
                  decoration: BoxDecoration(
                    color: lightGrey,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.07,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.point_of_sale,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.width * 0.12,),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Points", style: GoogleFonts.lato(
                              fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                              fontWeight: FontWeight.bold, // Adjust font weight
                              color: selectedButtonColor, // Adjust text color
                            ),),
                            Text(points, style: GoogleFonts.lato(
                              fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                              fontWeight: FontWeight.bold, // Adjust font weight
                              color: selectedButtonColor, // Adjust text color
                            ),)
                          ],
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => NavigationPage(currentIndex: 1,),
                              ));
                            },
                            icon: Column(
                              children: [
                                Icon(
                                  Icons.redeem,
                                  color: Colors.redAccent,
                                  size: MediaQuery.of(context).size.width * 0.1,
                                ),
                                Text("Redeem", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04)),
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  children: [
                    Text("Point History", style: GoogleFonts.lato(
                      fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                      fontWeight: FontWeight.bold, // Adjust font weight
                      color: selectedButtonColor, // Adjust text color
                    ),),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.0075),
                    Tooltip(
                      message: 'Shows the recent 20 transactions',
                      child: Icon(
                        Icons.info_outline,
                        size: MediaQuery.of(context).size.width * 0.05,
                        color: selectedButtonColor,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              for (var transaction in pointHistory.take(20))
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        if (transaction.type == "Expense") CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.05,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.remove,
                            color: Colors.red,
                            size: MediaQuery.of(context).size.width * 0.07,),
                        ),

                        if (transaction.type == "Income") CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.05,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.add,
                            color: Colors.green,
                            size: MediaQuery.of(context).size.width * 0.07,),
                        ),

                        SizedBox(width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('${transaction.points.toString()} Points',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: transaction.type == "Expense" ? Colors.red : Colors.green
                              ),),
                            Text('Order ID (${transaction.id.toString()})',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey
                              ),),
                          ],
                        ),
                        Spacer(),
                        Tooltip(
                          message: '${TimestampFormatter(transaction.createdAt.toString())}',
                          child: Text('${DaysFromTimeStamp(transaction.createdAt.toString())}'),
                        ),
                      ],
                    ),
                  ),
                )
            ],
          ),
        )
    );
  }
}
