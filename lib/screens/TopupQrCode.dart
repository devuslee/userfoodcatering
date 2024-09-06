import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TopupQrCode extends StatefulWidget {
  final String amount;

  const TopupQrCode({
    Key? key,
    required this.amount
  }) : super(key: key);

  @override
  State<TopupQrCode> createState() => _TopupQrCodeState();
}

class _TopupQrCodeState extends State<TopupQrCode> {
  String uniqueIdentifier = DateTime.now().millisecondsSinceEpoch.toString();

  void initState() {
    super.initState();
    createQrCode();

    FirebaseFirestore.instance
        .collection('qrCodes')
        .doc(uniqueIdentifier)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data()?['scanned'] == true) {
        // QR code has been scanned
        _onQrCodeScanned();
      }
    });
  }

  void createQrCode() async {
    await FirebaseFirestore.instance.collection('qrCodes').doc(uniqueIdentifier).set({
      'scanned': false,
      'amount': widget.amount,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  void _onQrCodeScanned() {
    Navigator.pop(context);
    Navigator.pop(context, true);
    SnackBar snackBar = SnackBar(content: Text("Topup completed"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ReusableAppBar(title: "QR Code", backButton: true),
          QrImageView(
            data: "0123456789 ${FirebaseAuth.instance.currentUser!.uid} ${widget.amount} ${uniqueIdentifier}",
            size: 200,
          ),
        ],
      )
    );
  }
}
