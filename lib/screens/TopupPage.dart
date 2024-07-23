import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:userfoodcatering/screens/ProfilePage.dart';

class TopupPage extends StatefulWidget {
  const TopupPage({super.key});

  @override
  State<TopupPage> createState() => _TopupPageState();
}

class _TopupPageState extends State<TopupPage> {
  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ReusableAppBar(title: "Top Up", backButton: true),
          Text('Enter the amount you want to top up'),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ReusableTextField(
              labelText: 'Amount',
              controller: amountController,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              TopupUserWallet(double.parse(amountController.text));
              Navigator.pop(context, true);
            },
            child: Text('Top Up'),
          ),

        ],
      ),
    );
  }
}
