import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:userfoodcatering/class/menuClass.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:floating_snackbar/floating_snackbar.dart';

class ViewOrderPage extends StatefulWidget {
  final MenuClass menuData;

  const ViewOrderPage({
    Key? key,
    required this.menuData,
  }) : super(key: key);

  @override
  State<ViewOrderPage> createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends State<ViewOrderPage> {
  int counter = 1;

  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      counter = await getFoodQuantity(widget.menuData.name);

      setState(() {});
    } catch (error) {
      print('Error fetching data: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    double total = widget.menuData.price * counter;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.menuData.imageURL),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 300),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.menuData.name,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IgnorePointer(
                                    ignoring: true,
                                      child: RatingBar.builder(
                                        initialRating: widget.menuData.rating,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 25.0,
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
                                  SizedBox(height: 8),
                                  Text(
                                    "${widget.menuData.rating} Star Rating",
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ]
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Price: \RM${widget.menuData.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "/per Portion",
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ]
                              ),
                            ],
                          ),
                        SizedBox(height: 16),
                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.menuData.description,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 150),

                      ]
                    ),
                  ),
                ),
              ],
            ),
          ),
          // App Bar with back button and favorite button
          Positioned(
            top: 40.0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Colors.white.withOpacity(0.7),
                    child: IconButton(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.18,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey,
                    width: 1,
                    ),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Total: \RM${total.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (counter > 1) {
                              counter--;
                            }
                          });
                        },
                        child: Text("-"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        counter.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            counter++;
                          });
                        },
                        child: Text("+"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  ElevatedButton(
                    onPressed: () {
                      addToCart(widget.menuData.name, widget.menuData.price, counter, total, widget.menuData.imageURL);
                      Navigator.pop(context);

                      floatingSnackBar(
                        message: "Item added to cart",
                        context: context,
                        textColor: Colors.white,
                        backgroundColor: Colors.grey,
                        duration: Duration(seconds: 2),
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      );
                    },
                    child: Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}
