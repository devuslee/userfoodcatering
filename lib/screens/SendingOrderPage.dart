import 'package:flutter/material.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../reusableWidgets/reusableColor.dart';


class SendingOrderPage extends StatefulWidget {
  final List cartList;
  final String specialRemark;
  final String desiredPickupTime;
  final double cartTotal;
  final String paymentMethod;

  const SendingOrderPage({
    Key? key,
    required this.cartList,
    required this.specialRemark,
    required this.desiredPickupTime,
    required this.cartTotal,
    required this.paymentMethod,
  }) : super(key: key);

  @override
  State<SendingOrderPage> createState() => _SendingOrderPageState();
}

class _SendingOrderPageState extends State<SendingOrderPage> {
  bool _processing = false;

  String discountID = "";

  @override
  void initState() {
    super.initState();
    processOrder();
  }

  void processOrder() async {


    discountID = await getUserDiscountID();

    if (mounted) {
      setState(() {
        _processing = true;
      });
    }

    // 5 seconds for the icon to turn green
    await Future.delayed(Duration(seconds: 5));

    if (mounted) {
      setState(() {
        _processing = false;
      });
    }

    // Buffer time for customers to still cancel order
    await Future.delayed(Duration(seconds: 2));
    Random random = Random();
    int randomNumber = random.nextInt(1000000000) + 1;

    if (mounted) {
      setState(() async {
        if (widget.paymentMethod == "E-Wallet") {
          deductWalletBalance(widget.cartTotal);
        }

        if (discountID != "") {
          deleteSpecificDiscount(discountID);
        }

        sendOrder(widget.cartList, widget.specialRemark, widget.desiredPickupTime, widget.cartTotal, randomNumber, widget.paymentMethod);
        createOrderHistory(widget.cartList, widget.specialRemark, widget.desiredPickupTime, widget.cartTotal, randomNumber, widget.paymentMethod, "Expense");
        deleteWholeCart();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text("Processing Order",
                style: GoogleFonts.lato(
                  fontSize: MediaQuery.of(context).size.width * 0.065, // Adjust font size
                  fontWeight: FontWeight.bold, // Adjust font weight
                  color: selectedButtonColor, // Adjust text color
                ),),
              Text("Sending your order...", style: TextStyle(fontSize: 20, color: Colors.grey)),
              Padding(
                padding: const EdgeInsets.only(
                  top: 32,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.fastfood, color: selectedButtonColor, size: 50),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                        SimpleAnimationProgressBar(
                            ratio: 1,
                            width: MediaQuery.of(context).size.width * 0.55,
                            height: MediaQuery.of(context).size.height * 0.01,
                            direction: Axis.horizontal,
                            backgroundColor: Colors.grey,
                            foregrondColor: Colors.blue,
                            duration: const Duration(seconds: 5),
                            curve: Curves.easeInOut,
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                        Icon(
                            Icons.check,
                            color: _processing ? Colors.grey : Colors.green,
                            size: 50),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                          "Cancel Order",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.red,
                          )
                        ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: lightGrey,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Pickup At:",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[500],
                              ),
                            ),
                            Text("5-G-1,Promenade, Jalan Mahsuri, 11900 Bayan Baru, Pulau Pinang",
                              style: GoogleFonts.lato(
                                fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                fontWeight: FontWeight.bold, // Adjust font weight
                                color: selectedButtonColor, // Adjust text color
                              ),
                            ),
                            Text("Total:",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[500],
                              ),
                            ),
                            Text("RM ${widget.cartTotal.toStringAsFixed(2)}",
                              style: GoogleFonts.lato(
                                fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                fontWeight: FontWeight.bold, // Adjust font weight
                                color: selectedButtonColor, // Adjust text color
                              ),
                            ),
                            Text("Pick Up Time:",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[500],
                              )
                            ),
                            Text(TimestampFormatter(widget.desiredPickupTime),
                              style: GoogleFonts.lato(
                                fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                fontWeight: FontWeight.bold, // Adjust font weight
                                color: selectedButtonColor, // Adjust text color
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            Text("Cart:",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey[500],
                                )
                            ),
                            ListView.builder(
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.cartList.length,
                              itemBuilder: (context, index) {
                                var item = widget.cartList[index];
                                return Padding(
                                  padding: const EdgeInsets.all(2.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      item.name,
                                                      style: GoogleFonts.lato(
                                                        fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                                        fontWeight: FontWeight.bold, // Adjust font weight
                                                        color: selectedButtonColor, // Adjust text color
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    widget.cartList[index].quantity.toString(),
                                                    style: GoogleFonts.lato(
                                                      fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                                      fontWeight: FontWeight.bold, // Adjust font weight
                                                      color: selectedButtonColor, // Adjust text color
                                                    ),
                                                  ),
                                                  SizedBox(height: (MediaQuery.of(context).size.height * 0.01)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                );
                              },
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            Text("Special Remarks:",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[500],
                              ),
                            ),
                            Text(widget.specialRemark == "" ? "None" : widget.specialRemark,
                              style: GoogleFonts.lato(
                                fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                fontWeight: FontWeight.bold, // Adjust font weight
                                color: selectedButtonColor, // Adjust text color
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 1,
                            ),
                            Text("Payment Method:",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[500],
                              ),
                            ),
                            Text(widget.paymentMethod,
                              style: GoogleFonts.lato(
                                fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                fontWeight: FontWeight.bold, // Adjust font weight
                                color: selectedButtonColor, // Adjust text color
                              ),
                            ),
                          ],
                        ),
                      )
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
