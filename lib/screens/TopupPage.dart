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
  bool amountEmpty = false;
  bool containsAlphabets = false;
  final RegExp _amountRegExp = RegExp(r'^[0-9.]+$');

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

          if (amountEmpty)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Visibility(
                visible: amountEmpty,
                child: const Text('Please enter an amount.',
                    style: TextStyle(color: Colors.red)),
              ),
            ),
          ),

          if (containsAlphabets)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Visibility(
                visible: containsAlphabets,
                child: const Text('Please enter a valid amount.',
                    style: TextStyle(color: Colors.red)),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (amountController.text.isEmpty) {
                setState(() {
                  amountEmpty = true;
                  containsAlphabets = false;
                });
                return;
              }

              if (!_amountRegExp.hasMatch(amountController.text)) {
                setState(() {
                  containsAlphabets = true;
                  amountEmpty = false;
                });
                return;
              }

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
