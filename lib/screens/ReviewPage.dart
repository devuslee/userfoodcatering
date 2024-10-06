
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableColor.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';



class ReviewPage extends StatefulWidget {
  final List<dynamic> orderHistory;
  final int id;
  final String desiredPickupTime;

  const ReviewPage({
    Key? key,
    required this.orderHistory,
    required this.id,
    required this.desiredPickupTime,
  }) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {

  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      print(widget.desiredPickupTime);

      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> _showLoadingDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ReusableAppBar(title: "Review", backButton: true),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none, // Allow positioning the circle outside the container
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                              Text(
                                "Comment",
                                style: GoogleFonts.lato(
                                  fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                  fontWeight: FontWeight.bold, // Adjust font weight
                                  color: Colors.black, // Adjust text color
                                ),
                              ),
                              Text(
                                "Leave a comment and let us know how we did!",
                                style: GoogleFonts.lato(
                                  fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                  color: Colors.black, // Adjust text color
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: -25,
                        left: (MediaQuery.of(context).size.width * 0.45) / 2 - 20,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: selectedButtonColor, // Circle color
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "1", // The number you want to display
                              style: GoogleFonts.lato(
                                fontSize: MediaQuery.of(context).size.width * 0.04, // Adjust font size for the number
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
                  Stack(
                    clipBehavior: Clip.none, // Allow positioning the circle outside the container
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                              Text(
                                "Earn Points",
                                style: GoogleFonts.lato(
                                  fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                  fontWeight: FontWeight.bold, // Adjust font weight
                                  color: Colors.black, // Adjust text color
                                ),
                              ),
                              Text(
                                "Earn 10 points for each review submitted!",
                                style: GoogleFonts.lato(
                                  fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                  color: Colors.black, // Adjust text color
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: -25,
                        left: (MediaQuery.of(context).size.width * 0.45) / 2 - 20,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: selectedButtonColor, // Circle color
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "2", // The number you want to display
                              style: GoogleFonts.lato(
                                fontSize: MediaQuery.of(context).size.width * 0.04, // Adjust font size for the number
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.orderHistory.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.32,
                        decoration: BoxDecoration(
                          color: lightGrey,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                  ),
                                  child: Image.network(
                                    widget.orderHistory[index]['imageURL'],
                                    width: MediaQuery.of(context).size.width * 0.30,
                                    height: MediaQuery.of(context).size.height * 0.15,
                                    fit: BoxFit.cover,
                                  ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(" ${widget.orderHistory[index]['name']}",
                                        style: GoogleFonts.lato(
                                          fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                          fontWeight: FontWeight.bold, // Adjust font weight
                                          color: selectedButtonColor, // Adjust text color
                                        ),
                                      ),
                                      RatingBar.builder(
                                        initialRating: (0 as num).toDouble(),
                                        direction: Axis.horizontal,
                                        allowHalfRating: false,
                                        itemCount: 5,
                                        itemSize: 30.0,
                                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          setState(() {
                                            widget.orderHistory[index]['rating'] = rating;
                                          });
                                        },
                                      ),
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.07,),
                                    ],
                                  ),
                                ),
                              ),
                            ]
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              maxLines: 2,
                              maxLength: 100,
                              decoration: InputDecoration(
                                hintText: 'Leave comments here...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                              ),

                              onChanged: (value) {
                                setState(() {
                                  widget.orderHistory[index]['comment'] = value;
                                });
                              },
                            ),
                          ),
                        ],
                      )
                    ),
                  );
                },
              ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
            ElevatedButton(
              onPressed: () async {

                _showLoadingDialog();

                await createReview(widget.orderHistory, widget.id, widget.desiredPickupTime);
                await updateAdminHistoryStatus(widget.desiredPickupTime, widget.id, "Completed and Reviewed");

                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Review Submitted"),
                      content: Text("Thank you for your review! You have been awarded 10 points."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Random random = Random();
                            int uniqueID = random.nextInt(100000000);

                            // Award points
                            createReviewPointHistory(10, uniqueID);

                            // Close the success dialog
                            Navigator.pop(context);
                          },
                          child: Text("Close"),
                        ),
                      ],
                    );
                  },
                ).then((_) {
                  // After dialog is closed, pop the parent page with true to indicate success
                  Navigator.pop(context, true);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedButtonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Submit Review",
                style: GoogleFonts.lato(
                  fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size// Adjust font weight
                  color: Colors.white, // Adjust text color
                ),),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
          ],
        ),
      )
    );
  }
}
