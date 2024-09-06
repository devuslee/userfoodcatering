import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../reusableWidgets/reusableFunctions.dart';
import 'ReviewPage.dart';

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


  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      for (var item in widget.orderDetails['orderHistory']) {
        total = total + item['total'];
      }
      pointGained = await getPointsGained(widget.orderDetails['orderID'].toString());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ReusableAppBar(title: "Details", backButton: true),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),

            if (widget.orderDetails['status'] == "Pending")
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your order has been received!"),
                      if (widget.orderDetails['desiredPickupTime'].split(' ')[0] == DateTime.now().toString().split(' ')[0])
                        Text("Your order is getting prepared!"),
                    ],
                  ),
                ),
              ),

            if (widget.orderDetails['status'] == "Ready")
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your order is ready!"),
                      Text("Come pick it up!"),
                    ],
                  ),
                ),
              ),

            if (widget.orderDetails['status'] == "Completed")
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Thank you for your support!"),
                      Text("Please leave a review!"),
                    ],
                  ),
                ),
              ),

            if (widget.orderDetails['status'] == "Completed and Reviewed")
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Thank you for your support!"),
                      Text("Enjoy your meal!"),
                    ],
                  ),
                ),
              ),
            Divider(
              color: Colors.grey[200],
              thickness: 7,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Container(
              width: MediaQuery.of(context).size.width * 0.98,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order Details", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.02, fontWeight: FontWeight.bold)),
                    Text("Pickup Location: ", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.015, color: Colors.grey)),
                    Text('Location: 5-G-1, Promenade, Jalan Mahsuri, 11900 Bayan Baru, Pulau Pinang', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.015, color: Colors.black),),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    Text("Order ID: ", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.015, color: Colors.grey)),
                    Text('${widget.orderDetails['orderID']}', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.015, color: Colors.black),),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    Text("Cart: ", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.015, color: Colors.grey)),
                    for (var item in widget.orderDetails['orderHistory'])
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            height: MediaQuery.of(context).size.height * 0.25,
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
                                      Text("${item['name']}", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.02, fontWeight: FontWeight.bold)),
                                      Text("RM ${item['price']}", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.02, fontWeight: FontWeight.bold)),
                                      SizedBox(height: MediaQuery.of(context).size.height * 0.11),
                                      Text("Quantity: ${item['quantity']}", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.015, color: Colors.grey)),
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
                    Text("Payment Method: ", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.015, color: Colors.grey)),
                    Text('${widget.orderDetails['paymentMethod']}', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.015, color: Colors.black),),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    Text("Payment Summary"),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Amount", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.015, color: Colors.grey)),
                        Text("RM ${total}", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.015, color: Colors.grey)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Discount", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.015, color: Colors.grey)),
                        Text("- RM $discount", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.015, color: Colors.grey)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Points Gained", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.015, color: Colors.grey)),
                        Text("${pointGained} pts", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.015, color: Colors.grey)),
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
                        Text("Grand Total", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.025, color: Colors.black)),
                        Text("RM ${widget.orderDetails['total']}", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.025, color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey[200],
              thickness: 7,
            ),
          ],
        ),
      ),
      bottomNavigationBar:  BottomAppBar(
        height: MediaQuery.of(context).size.height * 0.12,
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.9,
                child: ElevatedButton(
                  onPressed: () async {
                    if (widget.orderDetails['status'] == "Pending") {

                    }

                    if (widget.orderDetails['status'] == "Ready") {
                      updateHistoryStatus(widget.orderDetails['orderID'], "Completed");
                      refreshData();
                    }

                    if (widget.orderDetails['status'] == "Completed") {
                      bool isRefresh = await Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => ReviewPage(
                            orderHistory: widget.orderDetails['orderHistory'],
                            id: widget.orderDetails["orderID"],
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

                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(widget.orderDetails['status'] == "Pending" ? "Cancel Order"
                      : widget.orderDetails['status'] == "Ready" ? "Order Picked Up"
                      : widget.orderDetails['status'] == "Completed" ? "Review Order"
                      : widget.orderDetails['status'] == "Completed and Reviewed" ? "Reorder"
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
