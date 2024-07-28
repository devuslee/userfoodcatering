import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';

import '../reusableWidgets/reusableFunctions.dart';
import 'TopupPage.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {

  List allHistory = [];
  List activeHistory = [];
  List pastHistory = [];

  Map<String, String> userDetails = {};
  String balance = "Loading...";

  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      allHistory = await returnAllOrderHistory();
      Map<String, String> tempuserDetails = await getUserDetails();

      setState(() {
        userDetails = tempuserDetails;
        balance = userDetails['balance']!;
      }); // Update the UI after fetching data
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
            ReusableAppBar(title: "Wallet", backButton: true),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container (
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.03,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.monetization_on,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width * 0.05,),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Balance", style: TextStyle(fontSize: 20)),
                          Text("RM ${balance}", style: TextStyle(fontSize: 20))
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () async {
                          bool shouldRefresh = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TopupPage()
                              )
                          );
                          if (shouldRefresh) {
                            setState(() {
                              fetchData();
                            });
                          }
                        },
                        icon: Column(
                          children: [
                            Icon(
                              Icons.wallet,
                              color: Colors.green,
                              size: MediaQuery.of(context).size.width * 0.05,
                            ),
                            Text("Top Up", style: TextStyle(fontSize: 12))
                          ],
                        )
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text("Transaction History", style: TextStyle(fontSize: 20)),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.0075),
                  Tooltip(
                    message: 'Shows the recent 20 transactions',
                    child: Icon(
                      Icons.info_outline,
                      size: 20,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            for (var transaction in allHistory.take(20))
              Container(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        if (transaction.type == "Expense") CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.03,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.remove,
                            color: Colors.red,
                            size: MediaQuery.of(context).size.width * 0.05,),
                        ),
        
                        if (transaction.type == "Topup") CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.03,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.add,
                            color: Colors.green,
                            size: MediaQuery.of(context).size.width * 0.05,),
                        ),
        
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('RM ${transaction.total.toString()}',
                              style: TextStyle(
                                fontSize: 20,
                                color: transaction.type == "Expense" ? Colors.red : Colors.green
                              ),),
                            Text('Order ID (${transaction.id.toString()})',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey
                              ),),
                          ],
                        ),
                        Spacer(),
                        Tooltip(
                          message: '${TimestampFormatter(transaction.createdAt.toString())}',
                          child: Text('${DaysFromTimeStamp(transaction.createdAt.toString())}'),
                        ),
                      ],
                    ),
                  ),
              )
          ],
        ),
      )
    );
  }
}
