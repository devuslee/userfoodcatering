import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../reusableWidgets/reusableColor.dart';
import 'CartPage.dart';

class RedeemDiscountPage extends StatefulWidget {
  final String points;
  final String discount;
  final String downloadURL;

  const RedeemDiscountPage({
    Key? key,
    required this.points,
    required this.discount,
    required this.downloadURL,
  }) : super(key: key);

  @override
  State<RedeemDiscountPage> createState() => _RedeemDiscountPageState();
}

class _RedeemDiscountPageState extends State<RedeemDiscountPage> {
  DateTime validUntil = DateTime.now().add(Duration(days: 30));
  String userPoints = "0";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      userPoints = await getUserPoints();

      setState(() {
        userPoints = userPoints;
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80.0), // To avoid overlap with the button
            child: Column(
              children: [
                ReusableAppBar(title: "Redeem Discount", backButton: true),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                    imageUrl: widget.downloadURL,
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
                        Text('Points', style: GoogleFonts.lato(
                          fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                          fontWeight: FontWeight.bold, // Adjust font weight
                          color: selectedButtonColor, // Adjust text color
                        ),),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                        Text("${widget.points} pts",
                            style: TextStyle(color: Colors.grey[550],
                            fontSize: MediaQuery.of(context).size.width * 0.04)
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                        Text(DayMonthYearFormatter(validUntil.toString()), style: TextStyle(color: Colors.grey[550],
                            fontSize: MediaQuery.of(context).size.width * 0.04)),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        Text("Delivery Method", style: GoogleFonts.lato(
                          fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                          fontWeight: FontWeight.bold, // Adjust font weight
                          color: selectedButtonColor, // Adjust text color
                        ),),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                        Text("Self-Pickup", style: TextStyle(color: Colors.grey[550],
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

                    if (double.parse(userPoints) < double.parse(widget.points))
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Insufficient Points"),
                            content: Text("You do not have enough points to redeem this discount."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("OK"),
                              ),
                            ],
                          ),
                      );
                    else

                    if (double.parse(userPoints) >= double.parse(widget.points))
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Are you sure?"),
                          content: Text("${widget.points} points will be deducted from your account."),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    createDiscount(widget.points, widget.discount, validUntil, "Self-Pickup", widget.downloadURL);
                                    Navigator.pop(context,true);
                                    Navigator.pop(context,true);
                                  },
                                  child: Text("Confirm"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                ),
                              ],
                            ),
                          ],
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
