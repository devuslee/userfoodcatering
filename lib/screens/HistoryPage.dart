import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:intl/intl.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';

import '../reusableWidgets/reusableColor.dart';
import 'MoreOrderDetailsPage.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int currentButtonIndex = 0;

  List allHistory = [];
  List activeHistory = [];
  List pastHistory = [];

  bool isLoading = true;

  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      allHistory = await returnAllOrderHistory();
      activeHistory = await returnActiveOrderHistory();
      pastHistory = await returnPastOrderHistory();
      setState(() {}); // Update the UI after fetching data
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
      ? Center(child: Column(
        children: [
          ReusableAppBar(title: "History",  backButton: false),
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          CircularProgressIndicator(),
        ],
      ))
      : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReusableAppBar(title: "History",  backButton: false),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentButtonIndex = 0;
                      });
                    },
                    child: Text(
                      'All',
                      style: TextStyle(
                        color: currentButtonIndex == 0 ? notSelectedButtonColor : selectedButtonColor,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentButtonIndex == 0 ? selectedButtonColor : notSelectedButtonColor,
                      side: BorderSide(
                        color: Colors.grey,
                      ),

                    )
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentButtonIndex = 1;
                      });
                    },
                    child: Text(
                      'Active',
                      style: TextStyle(
                        color: currentButtonIndex == 1 ? notSelectedButtonColor : selectedButtonColor,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentButtonIndex == 1 ?  selectedButtonColor : notSelectedButtonColor,
                      side: BorderSide(
                        color: Colors.grey,
                      ),
                    )
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentButtonIndex = 2;
                      });
                    },
                    child: Text(
                      'Past',
                      style: TextStyle(
                        color: currentButtonIndex == 2 ? notSelectedButtonColor : selectedButtonColor,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentButtonIndex == 2 ?  selectedButtonColor : notSelectedButtonColor,
                      side: BorderSide(
                        color: Colors.grey,
                      ),

                    )
                ),
              ],
            ),
            if (currentButtonIndex == 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  for (var history in allHistory)
                    if (history.type == 'Expense')
                    Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            Map<String, dynamic> TemporderDetails = await convertOrderHistoryToMap(
                                history.createdAt,
                                history.desiredPickupTime,
                                history.id,
                                history.orderHistory,
                                history.paymentMethod,
                                history.specialRemarks,
                                history.status,
                                history.total,
                                history.type
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
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: lightPeach,
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
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      decoration: BoxDecoration(
                                          color: darkPeach,
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
                                              history.status == 'Pending' ? 'Order is on the way' : 'Order has been delivered',
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
                                                    Text('ID: ${history.id}'),
                                                    Text('Created: ${TimestampFormatter(history.createdAt)}'),
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
                                            Text('Picked up at: ${TimestampFormatter(
                                                history.desiredPickupTime)
                                              }'
                                            ),
                                            Text(history.specialRemarks == "" ? 'Special Remarks: None' : 'Special Remarks: ${history.specialRemarks}'),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Payment Method: ${history.paymentMethod}'),
                                                Spacer(),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text('Status: '),
                                                    Baseline(
                                                      baseline: 0,
                                                      baselineType: TextBaseline.alphabetic,
                                                      child: Container(
                                                        height: MediaQuery.of(context).size.height * 0.045,
                                                          decoration: BoxDecoration(
                                                              color:
                                                              history.status == 'Pending' ? darkYellow :
                                                              history.status == "Cancelled" ? Colors.red :
                                                              Colors.green,
                                                              borderRadius: BorderRadius.circular(5)
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(
                                                              (history.status == "Completed and Reviewed") ? "Reviewed" : history.status,
                                                              style: TextStyle(
                                                                  color: Colors.white),
                                                            ),
                                                          )
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.grey[300],
                                            ),
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
                                          ],
                                        )
                                    ),
                                  ),
                                ],
                              ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                      ],
                    ),
                ],
              ),
            if (currentButtonIndex == 1)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  for (var history in activeHistory)
                    if (history.type == 'Expense')
                      Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              Map<String, dynamic> TemporderDetails = await convertOrderHistoryToMap(
                                  history.createdAt,
                                  history.desiredPickupTime,
                                  history.id,
                                  history.orderHistory,
                                  history.paymentMethod,
                                  history.specialRemarks,
                                  history.status,
                                  history.total,
                                  history.type
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
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                color: lightPeach,
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
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      decoration: BoxDecoration(
                                          color: darkPeach,
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
                                              history.status == 'Pending' ? 'Order is on the way' : 'Order has been delivered',
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
                                                    Text('ID: ${history.id}'),
                                                    Text('Created: ${TimestampFormatter(history.createdAt)}'),
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
                                            Text('Picked up at: ${TimestampFormatter(
                                                history.desiredPickupTime)
                                            }'
                                            ),
                                            Text(history.specialRemarks == "" ? 'Special Remarks: None' : 'Special Remarks: ${history.specialRemarks}'),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Payment Method: ${history.paymentMethod}'),
                                                Spacer(),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text('Status: '),
                                                    Baseline(
                                                      baseline: 0,
                                                      baselineType: TextBaseline.alphabetic,
                                                      child: Container(
                                                          height: MediaQuery.of(context).size.height * 0.045,
                                                          decoration: BoxDecoration(
                                                              color:
                                                              history.status == 'Pending' ? darkYellow :
                                                              history.status == "Cancelled" ? Colors.red :
                                                              Colors.green,
                                                              borderRadius: BorderRadius.circular(5)
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(
                                                              (history.status == "Completed and Reviewed") ? "Reviewed" : history.status,
                                                              style: TextStyle(
                                                                  color: Colors.white),
                                                            ),
                                                          )
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.grey[300],
                                            ),
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
                                          ],
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        ],
                      ),
                ],
              ),
            if (currentButtonIndex == 2)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  for (var history in pastHistory)
                    if (history.type == 'Expense')
                      Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              Map<String, dynamic> TemporderDetails = await convertOrderHistoryToMap(
                                  history.createdAt,
                                  history.desiredPickupTime,
                                  history.id,
                                  history.orderHistory,
                                  history.paymentMethod,
                                  history.specialRemarks,
                                  history.status,
                                  history.total,
                                  history.type
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
                              width: MediaQuery.of(context).size.width * 0.9,
                              decoration: BoxDecoration(
                                color: lightPeach,
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
                                      width: MediaQuery.of(context).size.width * 0.9,
                                      decoration: BoxDecoration(
                                          color: darkPeach,
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
                                              history.status == 'Pending' ? 'Order is on the way' : 'Order has been delivered',
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
                                                    Text('ID: ${history.id}'),
                                                    Text('Created: ${TimestampFormatter(history.createdAt)}'),
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
                                            Text('Picked up at: ${TimestampFormatter(
                                                history.desiredPickupTime)
                                            }'
                                            ),
                                            Text(history.specialRemarks == "" ? 'Special Remarks: None' : 'Special Remarks: ${history.specialRemarks}'),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Payment Method: ${history.paymentMethod}'),
                                                Spacer(),
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text('Status: '),
                                                    Baseline(
                                                      baseline: 0,
                                                      baselineType: TextBaseline.alphabetic,
                                                      child: Container(
                                                          height: MediaQuery.of(context).size.height * 0.045,
                                                          decoration: BoxDecoration(
                                                              color:
                                                              history.status == 'Pending' ? darkYellow :
                                                              history.status == "Cancelled" ? Colors.red :
                                                              Colors.green,
                                                              borderRadius: BorderRadius.circular(5)
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text(
                                                              (history.status == "Completed and Reviewed") ? "Reviewed" : history.status,
                                                              style: TextStyle(
                                                                  color: Colors.white),
                                                            ),
                                                          )
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.grey[300],
                                            ),
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
                                          ],
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        ],
                      ),
                ],
              ),
          ],
        ),
      )
    );
  }
}
