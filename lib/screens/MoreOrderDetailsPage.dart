import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../reusableWidgets/reusableColor.dart';
import '../reusableWidgets/reusableFunctions.dart';
import 'CartPage.dart';
import 'ReviewPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';


class MoreOrderDetailsPage extends StatefulWidget {
  Map<String, dynamic> orderDetails;

  MoreOrderDetailsPage({
    Key? key,
    required this.orderDetails
  }) : super(key: key);

  @override
  State<MoreOrderDetailsPage> createState() => _MoreOrderDetailsPageState();
}

class _MoreOrderDetailsPageState extends State<MoreOrderDetailsPage> {

  double discount = 0.0;
  double total = 0.0;
  double pointGained = 0.0;
  double pointsGainedThroughRank = 0.0;

  String uniqueIdentifier = DateTime.now().millisecondsSinceEpoch.toString();


  void initState() {
    super.initState();
    fetchData();

    FirebaseFirestore.instance
        .collection('qrCodes')
        .doc(uniqueIdentifier)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data()?['scanned'] == true) {
        _onQrCodeScanned();
      }
    });
  }

  void fetchData() async {
    try {

      total = 0;

      for (var item in widget.orderDetails['orderHistory']) {
        total = total + item['total'];
      }
      pointGained = await getPointsGained(widget.orderDetails['orderID'].toString());

      pointsGainedThroughRank = await calculatePointsGained(total);
      discount = total - widget.orderDetails['total'];

      if (mounted) {
        setState(() {

        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> refreshData() async {
    try {
      total = 0;

      widget.orderDetails = await getOrderDetails(widget.orderDetails['orderID'].toString());

      for (var item in widget.orderDetails['orderHistory']) {
        total = total + item['total'];
      }
      pointGained = await getPointsGained(widget.orderDetails['orderID'].toString());
      discount = total - widget.orderDetails['total'];

      if (mounted) {
        setState(() {
          widget.orderDetails = widget.orderDetails;
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void createQrCode() async {
    await FirebaseFirestore.instance.collection('qrCodes').doc(uniqueIdentifier).set({
      'scanned': false,
      'amount': widget.orderDetails['total'],
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  void _onQrCodeScanned() {
    Navigator.pop(context);

    updateHistoryStatus(widget.orderDetails['orderID'], "Completed");
    createPointHistory(widget.orderDetails['total'], widget.orderDetails['orderID']);
    refreshData();

    _showCompletedDialog();
  }

  void _showCompletedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Order Completed!"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("You've been awarded $pointsGainedThroughRank points!"),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Text("Please leave a review to gain more points!"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                bool isRefresh = await Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => ReviewPage(
                      orderHistory: widget.orderDetails['orderHistory'],
                      id: widget.orderDetails["orderID"],
                      desiredPickupTime: widget.orderDetails['desiredPickupTime']
                    )
                ),
                );

                if (isRefresh) {
                  setState(() async {
                    Navigator.pop(context);
                    await refreshData();
                  });
                }
              },
              child: Text("Leave Review"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ReusableAppBar(title: "Details", backButton: true),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),

            if (widget.orderDetails['status'] == "Cancelled")
            Column(
              children: [
                Center(
                  child: Image.asset(
                      'assets/orderCancelled.png',
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.contain
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text("This order has been cancelled!",
                            style: GoogleFonts.lato(
                              fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                              fontWeight: FontWeight.bold, // Adjust font weight
                              color: Colors.red, // Adjust text color
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (widget.orderDetails['status'] == "Pending")
              Column(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/orderPending.png',
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.3,
                      fit: BoxFit.contain
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text("Your order has been received!",
                            style: GoogleFonts.lato(
                              fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                              fontWeight: FontWeight.bold, // Adjust font weight
                              color: selectedButtonColor, // Adjust text color
                              ),
                            ),
                          ),
                          if (widget.orderDetails['desiredPickupTime'].split(' ')[0] == DateTime.now().toString().split(' ')[0])
                            Center(
                                child: Text("Your order is getting prepared!",
                                  style: GoogleFonts.lato(
                                    fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                    fontWeight: FontWeight.bold, // Adjust font weight
                                    color: selectedButtonColor, // Adjust text color
                                  ),
                                )
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            if (widget.orderDetails['status'] == "Ready")
              Column(
                children: [
                  Center(
                    child: Image.asset(
                        'assets/orderReady.png',
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.contain
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text("Your order is ready!",
                              style: GoogleFonts.lato(
                                fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                fontWeight: FontWeight.bold, // Adjust font weight
                                color: selectedButtonColor, // Adjust text color
                              ),
                            ),
                          ),
                          Center(
                              child: Text("Come pick it up!",
                                style: GoogleFonts.lato(
                                  fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                  fontWeight: FontWeight.bold, // Adjust font weight
                                  color: selectedButtonColor, // Adjust text color
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            if (widget.orderDetails['status'] == "Completed")
              Column(
                children: [
                  Center(
                    child: Image.asset(
                        'assets/orderCompleted.png',
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.contain
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text("Thank you for your support!",
                              style: GoogleFonts.lato(
                                fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                fontWeight: FontWeight.bold, // Adjust font weight
                                color: selectedButtonColor, // Adjust text color
                              ),
                            ),
                          ),
                          Center(
                            child: Text("Please leave a review!",
                              style: GoogleFonts.lato(
                                fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                fontWeight: FontWeight.bold, // Adjust font weight
                                color: selectedButtonColor, // Adjust text color
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            if (widget.orderDetails['status'] == "Completed and Reviewed")
              Column(
                children: [
                  Center(
                    child: Image.asset(
                        'assets/orderReviewed.png',
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.contain
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text("Thank you for your support!",
                              style: GoogleFonts.lato(
                                fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                fontWeight: FontWeight.bold, // Adjust font weight
                                color: selectedButtonColor, // Adjust text color
                              ),
                            ),
                          ),
                            Center(
                                child: Text("Enjoy your meal!",
                                  style: GoogleFonts.lato(
                                    fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                    fontWeight: FontWeight.bold, // Adjust font weight
                                    color: selectedButtonColor, // Adjust text color
                                  ),
                                )
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Divider(
              color: Colors.grey[350],
              thickness: 7,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Container(
              width: MediaQuery.of(context).size.width * 0.98,
              decoration: BoxDecoration(
                color: backGroundColor,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Order Details",
                          style: GoogleFonts.lato(
                            fontSize: MediaQuery.of(context).size.width * 0.06, // Adjust font size
                            fontWeight: FontWeight.bold, // Adjust font weight
                            color: selectedButtonColor, // Adjust text color
                          ),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                color:
                                widget.orderDetails['status'] == 'Pending' ? darkYellow :
                                widget.orderDetails['status'] == "Cancelled" ? Colors.red :
                                Colors.green,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.orderDetails['status'],
                                style: TextStyle(
                                    color: Colors.white),
                              ),
                            )
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    Text("Pickup Time: ",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.grey[500]
                        )
                    ),
                    Text('${DayMonthYearFormatter(widget.orderDetails['desiredPickupTime'])}, ${HourFormatter(widget.orderDetails['desiredPickupTime'])}',
                        style: GoogleFonts.lato(
                          fontSize: MediaQuery.of(context).size.width * 0.04, // Adjust font size
                          fontWeight: FontWeight.bold, // Adjust font weight
                          color: selectedButtonColor, // Adjust text color
                        ),
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    Text("Pickup Location: ",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.grey[500]
                        )
                    ),
                    Text('Location: 5-G-1, Promenade, Jalan Mahsuri, 11900 Bayan Baru, Pulau Pinang',
                      style: GoogleFonts.lato(
                        fontSize: MediaQuery.of(context).size.width * 0.04, // Adjust font size
                        fontWeight: FontWeight.bold, // Adjust font weight
                        color: selectedButtonColor, // Adjust text color
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    Text("Order ID: ",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.grey[500]
                        ),
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: widget.orderDetails['orderID'].toString()));

                        // Optionally show a message/snackbar to indicate the copy action
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Order ID copied to clipboard'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text('${widget.orderDetails['orderID']}',
                              style: GoogleFonts.lato(
                                fontSize: MediaQuery.of(context).size.width * 0.04, // Adjust font size
                                fontWeight: FontWeight.bold, // Adjust font weight
                                color: selectedButtonColor, // Adjust text color
                              ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.005),
                          Icon(
                            Icons.copy,
                            color: selectedButtonColor,
                            size: MediaQuery.of(context).size.width * 0.04,
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    Text("Cart: ",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          color: Colors.grey[500]
                      ),),
                    for (var item in widget.orderDetails['orderHistory'])
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  child: Image.network(
                                    item["imageURL"],
                                    width: MediaQuery.of(context).size.width * 0.25,
                                    height: MediaQuery.of(context).size.height * 0.25,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${item['name']}",
                                        style: GoogleFonts.lato(
                                          fontSize: MediaQuery.of(context).size.width * 0.04, // Adjust font size
                                          fontWeight: FontWeight.bold, // Adjust font weight
                                          color: selectedButtonColor, // Adjust text color
                                        ),),
                                      Text("RM ${item['price']}", style: GoogleFonts.lato(
                                        fontSize: MediaQuery.of(context).size.width * 0.04, // Adjust font size
                                        fontWeight: FontWeight.bold, // Adjust font weight
                                        color: Colors.green, // Adjust text color
                                      ),),
                                      Text("Quantity: ${item['quantity']}",
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width * 0.035,
                                            color: Colors.grey[500]
                                        ),),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        ],
                      ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    Text("Payment Method: ",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.grey[500]
                        ),
                    ),
                    Text('${widget.orderDetails['paymentMethod']}',
                        style: GoogleFonts.lato(
                      fontSize: MediaQuery.of(context).size.width * 0.04, // Adjust font size
                      fontWeight: FontWeight.bold, // Adjust font weight
                      color: selectedButtonColor, // Adjust text color
                    ),),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    Text("Special Remarks: ",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.grey[500]
                        ),
                    ),
                    Text(widget.orderDetails['specialRemarks'] == "" ?
                    "No Remarks" :
                    '${widget.orderDetails['specialRemarks']}',
                        style: GoogleFonts.lato(
                          fontSize: MediaQuery.of(context).size.width * 0.04, // Adjust font size
                          fontWeight: FontWeight.bold, // Adjust font weight
                          color: selectedButtonColor, // Adjust text color
                        ),
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    Text("Payment Summary",
                      style: GoogleFonts.lato(
                        fontSize: MediaQuery.of(context).size.width * 0.04, // Adjust font size
                        fontWeight: FontWeight.bold, // Adjust font weight
                        color: selectedButtonColor, // Adjust text color
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Amount", style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.grey[500]
                        )),
                        Text("RM ${total}", style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.grey[500]
                        )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Discount", style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.grey[500]
                        )),
                        Text("- RM $discount", style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.grey[500]
                        )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Points Gained", style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.grey[500]
                        )),
                        Text("${pointGained} pts", style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            color: Colors.grey[500]
                        )),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.20, // Adjust the width as needed
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Grand Total",
                          style: GoogleFonts.lato(
                            fontSize: MediaQuery.of(context).size.width * 0.04, // Adjust font size
                            fontWeight: FontWeight.bold, // Adjust font weight
                            color: selectedButtonColor, // Adjust text color
                          ),
                        ),
                        Text("RM ${widget.orderDetails['total']}",
                          style: GoogleFonts.lato(
                            fontSize: MediaQuery.of(context).size.width * 0.04, // Adjust font size
                            fontWeight: FontWeight.bold, // Adjust font weight
                            color: Colors.black, // Adjust text color
                          ),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey[350],
              thickness: 7,
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.orderDetails['status'] == "Pending" &&
          DateTime.parse(widget.orderDetails['desiredPickupTime']).compareTo(DateTime.now().add(Duration(days: 1))) < 0
          ? null
          : BottomAppBar(
        height: MediaQuery.of(context).size.height * 0.12,
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.9,
                child: ElevatedButton(
                  onPressed: () async {
                    if (widget.orderDetails['status'] == "Pending") {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Cancel Order"),
                              content: Text("Are you sure you want to cancel this order? This process is irreversible."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("No"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    updateHistoryStatus(widget.orderDetails['orderID'], "Cancelled");
                                    if (widget.orderDetails['paymentMethod'] == "E-Wallet") {
                                      RefundUserWallet(widget.orderDetails['total']);
                                    }
                                    refreshData();
                                  },
                                  child: Text("Yes"),
                                ),
                              ],
                            );
                          }
                      );
                    }

                    if (widget.orderDetails['status'] == "Ready") {
                      createQrCode();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Scan this QR Code"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.2,
                                  width: MediaQuery.of(context).size.height * 0.2,
                                  child: QrImageView(
                                    data: "${uniqueIdentifier} ${widget.orderDetails['orderID']}",
                                    size: 200,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Please scan this code to confirm your order.",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: Text("Close"),
                              ),
                            ],
                          );
                        },
                      );
                    }

                    if (widget.orderDetails['status'] == "Completed") {
                      bool isRefresh = await Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => ReviewPage(
                            orderHistory: widget.orderDetails['orderHistory'],
                            id: widget.orderDetails["orderID"],
                            desiredPickupTime: widget.orderDetails['desiredPickupTime']
                          )
                        ),
                      );

                      if (isRefresh) {
                        setState(() {
                          refreshData();
                        });
                      }
                    }

                    if (widget.orderDetails['status'] == "Completed and Reviewed") {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Reorder"),
                              content: Text("Reordering will clear your current cart. Are you sure you want to reorder?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("No"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await clearCart();
                                    for (var item in widget.orderDetails['orderHistory']) {
                                      addToCart(item['name'], item['price'], item['quantity'], item['total'], item['imageURL']);
                                    }
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
                                  },
                                  child: Text("Yes"),
                                ),
                              ],
                            );
                          }
                      );
                    }

                    if (widget.orderDetails['status'] == "Cancelled") {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Reorder"),
                              content: Text("Reordering will clear your current cart. Are you sure you want to reorder?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("No"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await clearCart();
                                    for (var item in widget.orderDetails['orderHistory']) {
                                      addToCart(item['name'], item['price'], item['quantity'], item['total'], item['imageURL']);
                                    }
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
                                  },
                                  child: Text("Yes"),
                                ),
                              ],
                            );
                          }
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(widget.orderDetails['status'] == "Pending" ? "Cancel Order"
                      : widget.orderDetails['status'] == "Ready" ? "Order Picked Up"
                      : widget.orderDetails['status'] == "Completed" ? "Review Order"
                      : widget.orderDetails['status'] == "Completed and Reviewed" ? "Reorder"
                      : widget.orderDetails['status'] == "Cancelled" ? "Reorder"
                      : "Error",
                  style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
