import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';

import '../reusableWidgets/reusableColor.dart';
import '../reusableWidgets/reusableFunctions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'MoreOrderDetailsPage.dart';
import 'ReviewPage.dart';


class CheckReviews extends StatefulWidget {
  const CheckReviews({super.key});

  @override
  State<CheckReviews> createState() => _CheckReviewsState();
}

class _CheckReviewsState extends State<CheckReviews> {
  List<Map<String, dynamic>> allReviews = [];
  String profileURL = "";
  String username = "";


  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      allReviews = await returnAllReviews();
      profileURL = await returnProfileImage();
      username = await returnUsername();

      if (mounted) {
        setState(() {

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
            ReusableAppBar(title: "Reviews", backButton: true),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,),
                    child: Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: allReviews.length ?? 0,
                          itemBuilder: (context, index) {
                            String comment = '';
                            var item = allReviews[index];

                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      List historyList = await returnSpecificListOrderHistory(item['id'].toString());


                                      Map<String, dynamic> TemporderDetails = await convertOrderHistoryToMap(
                                          historyList[0].createdAt,
                                          historyList[0].desiredPickupTime,
                                          historyList[0].id,
                                          historyList[0].orderHistory,
                                          historyList[0].paymentMethod,
                                          historyList[0].specialRemarks,
                                          historyList[0].status,
                                          historyList[0].total,
                                          historyList[0].type
                                      );


                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MoreOrderDetailsPage(
                                            orderDetails: TemporderDetails['${DateTime.now().toString().split(' ')[0]}'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black),
                                          color: lightGrey,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CachedNetworkImage(
                                                                imageUrl: profileURL,
                                                                imageBuilder: (context, imageProvider) => Container(
                                                                  width: 50.0,
                                                                  height: 50.0,
                                                                  decoration: BoxDecoration(
                                                                    shape: BoxShape.circle,
                                                                    image: DecorationImage(
                                                                      image: imageProvider,
                                                                      fit: BoxFit.cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                                placeholder: (context, url) => CircularProgressIndicator(),
                                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                                              ),
                                                              SizedBox(width: MediaQuery.of(context).size.width * 0.015),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Container(
                                                                    width: MediaQuery.of(context).size.width * 0.5,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                            username,
                                                                            style: GoogleFonts.lato(
                                                                              fontSize: MediaQuery.of(context).size.height * 0.025,
                                                                              fontWeight: FontWeight.bold,
                                                                            )
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      IgnorePointer(
                                                                          ignoring: true,
                                                                          child: RatingBar.builder(
                                                                            initialRating: item['rating'] ?? 0.0,
                                                                            direction: Axis.horizontal,
                                                                            allowHalfRating: true,
                                                                            itemCount: 5,
                                                                            itemSize: MediaQuery.of(context).size.height * 0.025,
                                                                            itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                                                            itemBuilder: (context, _) => Icon(
                                                                              Icons.star,
                                                                              color: Colors.amber,
                                                                            ),
                                                                            onRatingUpdate: (rating) {
                                                                              print(rating);
                                                                            },
                                                                          )
                                                                      ),
                                                                      SizedBox(width: MediaQuery.of(context).size.width * 0.005),
                                                                      Text(DaysFromTimeStamp(
                                                                          item['createdAt']),
                                                                          style: TextStyle(
                                                                              fontSize: MediaQuery.of(context).size.height * 0.02)
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                                          Container(
                                                            width: MediaQuery.of(context).size.width * 0.85,
                                                            child: Text(
                                                              item['comment'],
                                                              style: TextStyle(
                                                                fontSize: MediaQuery.of(context).size.height * 0.02,
                                                              ),
                                                              maxLines: null, // Allows the text to use as many lines as needed
                                                              overflow: TextOverflow.visible, // Ensures overflowed text is visible
                                                              softWrap: true, // Ensures text wraps to the next line
                                                            ),
                                                          ),
                                                        ]
                                                    )
                                                  ],
                                                ),
                                              ]
                                          ),
                                        )
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                ],
                              );
                          },
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
