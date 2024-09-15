import 'package:flutter/material.dart';

import '../reusableWidgets/reusableColor.dart';
import '../reusableWidgets/reusableFunctions.dart';
import '../reusableWidgets/reusableWidgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:google_fonts/google_fonts.dart';

class ClaimDiscountPage extends StatefulWidget {
  final String deliverymethod;
  final String discount;
  final Timestamp expiredAt;
  final String imageURL;
  final String discountID;


  const ClaimDiscountPage({
    Key? key,
    required this.deliverymethod,
    required this.discount,
    required this.expiredAt,
    required this.imageURL,
    required this.discountID,
  }) : super(key: key);

  @override
  State<ClaimDiscountPage> createState() => _ClaimDiscountPageState();
}

class _ClaimDiscountPageState extends State<ClaimDiscountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80.0), // To avoid overlap with the button
            child: Column(
              children: [
                ReusableAppBar(title: "Use Discount", backButton: true),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageURL,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Divider(thickness: 2),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Discount', style: GoogleFonts.lato(
                          fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                          fontWeight: FontWeight.bold, // Adjust font weight
                          color: selectedButtonColor, // Adjust text color
                        ),),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                        Text("RM ${widget.discount}", style: TextStyle(color: Colors.grey[550],
                            fontSize: MediaQuery.of(context).size.width * 0.04)),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        Text("Valid until", style: GoogleFonts.lato(
                          fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                          fontWeight: FontWeight.bold, // Adjust font weight
                          color: selectedButtonColor, // Adjust text color
                        ),),
                        Text(TimestampToStringFormatter(widget.expiredAt), style: TextStyle(color: Colors.grey[550],
                            fontSize: MediaQuery.of(context).size.width * 0.04)),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        Text("Delivery Method", style: GoogleFonts.lato(
                          fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                          fontWeight: FontWeight.bold, // Adjust font weight
                          color: selectedButtonColor, // Adjust text color
                        ),),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                        Text(widget.deliverymethod, style: TextStyle(color: Colors.grey[550],
                            fontSize: MediaQuery.of(context).size.width * 0.04)),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        Text("Terms & Conditions", style: GoogleFonts.lato(
                          fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                          fontWeight: FontWeight.bold, // Adjust font weight
                          color: selectedButtonColor, // Adjust text color
                        ),),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                        Text("1. This discount is only valid for one-time use.",
                            style: TextStyle(color: Colors.grey[550],
                                fontSize: MediaQuery.of(context).size.width * 0.04)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60.0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    updateUserDiscount(widget.discountID);
                    Navigator.pop(context,true);
                    floatingSnackBar(
                      message: "Discount Selected!",
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
                  child: Text("Redeem Now",
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
