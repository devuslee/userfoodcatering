import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:intl/intl.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';

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
          CircularProgressIndicator(),
        ],
      ))
      : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReusableAppBar(title: "History",  backButton: false),
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
                        color: currentButtonIndex == 0 ? Colors.white : Colors.blue,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentButtonIndex == 0 ? Colors.blue : Colors.white,
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
                        color: currentButtonIndex == 1 ? Colors.white : Colors.blue,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentButtonIndex == 1 ? Colors.blue : Colors.white,
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
                        color: currentButtonIndex == 2 ? Colors.white : Colors.blue,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentButtonIndex == 2 ? Colors.blue : Colors.white,
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
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
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
                                    width: MediaQuery.of(context).size.width * 0.81,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
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
                                              Text('ID: ${history.id}'),
                                              Text('Total:      '),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Created at: ${TimestampFormatter(history.createdAt)}'),
                                              Text('RM${NumberFormat('##0.00').format(history.total)}'),
                                            ],
                                          ),
                                          Text('Picked up at: ${PickupTimestampFormatter(
                                              history.createdAt,
                                              history.desiredPickupTime)
                                            }'
                                          ),
                                          Text(history.specialRemarks == "" ? 'Special Remarks: None' : 'Special Remarks: ${history.specialRemarks}'),
                                          Text('Payment Method: ${history.paymentMethod}'),
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
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
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
                                  width: MediaQuery.of(context).size.width * 0.81,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
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
                                            Text('ID: ${history.id}'),
                                            Text('Total:      '),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Created at: ${TimestampFormatter(history.createdAt)}'),
                                            Text('RM${NumberFormat('##0.00').format(history.total)}'),
                                          ],
                                        ),
                                        Text('Picked up at: ${PickupTimestampFormatter(
                                            history.createdAt,
                                            history.desiredPickupTime)
                                        }'
                                        ),
                                        Text(history.specialRemarks == "" ? 'Special Remarks: None' : 'Special Remarks: ${history.specialRemarks}'),
                                        Text('Payment Method: ${history.paymentMethod}'),
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
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
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
                                  width: MediaQuery.of(context).size.width * 0.81,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
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
                                            Text('ID: ${history.id}'),
                                            Text('Total:      '),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Created at: ${TimestampFormatter(history.createdAt)}'),
                                            Text('RM${NumberFormat('##0.00').format(history.total)}'),
                                          ],
                                        ),
                                        Text('Picked up at: ${PickupTimestampFormatter(
                                            history.createdAt,
                                            history.desiredPickupTime)
                                        }'
                                        ),
                                        Text(history.specialRemarks == "" ? 'Special Remarks: None' : 'Special Remarks: ${history.specialRemarks}'),
                                        Text('Payment Method: ${history.paymentMethod}'),
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
