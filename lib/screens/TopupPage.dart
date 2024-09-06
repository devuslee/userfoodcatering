import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:userfoodcatering/screens/ProfilePage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'TopupQrCode.dart';

class TopupPage extends StatefulWidget {
  const TopupPage({super.key});

  @override
  State<TopupPage> createState() => _TopupPageState();
}

class _TopupPageState extends State<TopupPage> {
  TextEditingController amountController = TextEditingController();
  bool amountEmpty = false;
  bool containsAlphabets = false;
  bool decimalPoint = false;

  final RegExp _amountRegExp = RegExp(r'^[0-9.]+$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ReusableAppBar(title: "Top Up", backButton: true),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
            child: Column(
              children: [
                Text('Enter the amount you want to top up'),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                ReusableTextField(
                  labelText: 'Amount',
                  controller: amountController,
                ),

                if (amountEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Visibility(
                      visible: amountEmpty,
                      child: const Text('Please enter an amount.',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ),


                if (containsAlphabets)
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Visibility(
                        visible: containsAlphabets,
                        child: const Text('Please enter a valid amount.',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ),

                if (decimalPoint)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Visibility(
                      visible: decimalPoint,
                      child: const Text('Please enter within 2 decimal points.',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                ElevatedButton(
                  onPressed: () {
                    if (amountController.text.isEmpty) {
                      setState(() {
                        amountEmpty = true;
                        containsAlphabets = false;
                        decimalPoint = false;
                      });
                      return;
                    }

                    if (!_amountRegExp.hasMatch(amountController.text)) {
                      setState(() {
                        containsAlphabets = true;
                        amountEmpty = false;
                        decimalPoint = false;
                      });
                      return;
                    }

                    if (amountController.text.contains('.')) {
                      if (amountController.text.split('.')[1].length > 2) {
                        setState(() {
                          decimalPoint = true;
                          amountEmpty = false;
                          containsAlphabets = false;
                        });
                        return;
                      }
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TopupQrCode(amount: amountController.text),
                      ),
                    );
                  },
                  child: Text('Top Up'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
