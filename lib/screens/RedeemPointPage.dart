import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';


class RedeemPointPage extends StatefulWidget {
  const RedeemPointPage({super.key});

  @override
  State<RedeemPointPage> createState() => _RedeemPointPageState();
}

class _RedeemPointPageState extends State<RedeemPointPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ReusableAppBar(title: "Redeem Page", backButton: false),

        ],
      )
    );
  }
}
