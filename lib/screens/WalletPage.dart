import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableColor.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';

import '../reusableWidgets/reusableFunctions.dart';
import 'TopupPage.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool isLoading = true;

  List<String> categoryTypes = [
    'All',
    'Expense',
    'Refund',
    'Topup',
  ];

  String _selectedCategory = 'All';

  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      setState(() {
        isLoading = true; // Start loading
      });

      allHistory = await returnAllFilteredOrderHistory(_selectedCategory);
      Map<String, String> tempuserDetails = await getUserDetails();

      setState(() {
        userDetails = tempuserDetails;
        balance = userDetails['balance']!;
        isLoading = false; // Data loaded, stop loading
      });
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false; // Stop loading in case of error
      });
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
              child: Container(
                decoration: BoxDecoration(
                  color: lightGrey,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.07,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.monetization_on,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width * 0.12,),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Balance", style: GoogleFonts.lato(
                            fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                            fontWeight: FontWeight.bold, // Adjust font weight
                            color: selectedButtonColor, // Adjust text color
                          ),),
                          Text("RM ${balance}", style: GoogleFonts.lato(
                            fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                            fontWeight: FontWeight.bold, // Adjust font weight
                            color: selectedButtonColor, // Adjust text color
                          ),)
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
                              size: MediaQuery.of(context).size.width * 0.1,
                            ),
                            Text("Top Up", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04))
                          ],
                        )
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05 ),
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
              ),
              child: Row(
                children: [
                  Text("Transaction History",
                    style: GoogleFonts.lato(
                    fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                    fontWeight: FontWeight.bold, // Adjust font weight
                    color: selectedButtonColor, // Adjust text color
                  ),),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.0075),
                  Tooltip(
                    message: 'Shows the recent 20 transactions',
                    child: Icon(
                      Icons.info_outline,
                      size: MediaQuery.of(context).size.width * 0.05,
                      color: selectedButtonColor,
                    ),
                  ),
                  Spacer(),
                  Baseline(
                    baseline: 0,
                    baselineType: TextBaseline.alphabetic,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: DropdownButtonFormField(
                        value: _selectedCategory,
                        items: categoryTypes.map((time) {
                          return DropdownMenuItem(
                            value: time,
                            child: Text(time),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value.toString();
                            fetchData();
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Select Category',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),

            if (isLoading)
              Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            if (!isLoading)
                for (var transaction in allHistory.take(20))
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          if (transaction.type == "Expense")
                            CircleAvatar(
                              radius: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.05,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.remove,
                                color: Colors.red,
                                size: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.07,),
                            ),

                          if (transaction.type == "Topup")
                            CircleAvatar(
                              radius: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.03,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.add,
                                color: Colors.green,
                                size: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.05,),
                            ),

                          if (transaction.type == "Refund")
                            CircleAvatar(
                              radius: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.03,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.money_off,
                                color: darkYellow,
                                size: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.05,),
                            ),

                          SizedBox(width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.02),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('RM ${transaction.total.toString()}',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: transaction.type == "Expense"
                                        ? Colors.red
                                        : transaction.type == "Refund"
                                        ? darkYellow
                                        : Colors.green
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
                            message: '${TimestampFormatter(transaction.createdAt
                                .toString())}',
                            child: Text('${DaysFromTimeStamp(
                                transaction.createdAt.toString())}'),
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
