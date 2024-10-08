import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:userfoodcatering/screens/ClaimDiscountPage.dart';
import 'package:userfoodcatering/screens/RankPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../reusableWidgets/reusableColor.dart';


class RedeemPointPage extends StatefulWidget {
  int currentIndex;

  RedeemPointPage({
    Key? key,
    this.currentIndex = 0
  }) : super(key: key);



  @override
  State<RedeemPointPage> createState() => _RedeemPointPageState();
}

class _RedeemPointPageState extends State<RedeemPointPage> {
  int checkinCounter = 0;
  double pointObtained = 0;
  bool isCheckin = false;
  String points = "";
  String rank = "";
  String discountID = "";
  String discountRM3 = "";
  String discountRM5 = "";
  String discountRM7 = "";
  String discountRM10 = "";
  List<Map<String, dynamic>> discountList = [];


  FirebaseStorage _storage = FirebaseStorage.instance;


  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      int tempcheckinCounter = await getcheckinCounter();

      bool tempIsCheckin = await getIsCheckin();

      String tempPoints = await getUserPoints();

      String tempRank = await getUserRank();
      String tempdiscountID = await getUserDiscountID();


      String tempdiscountRM3 = await _storage.ref('discounts/rm3off.jpeg').getDownloadURL();
      String tempdiscountRM5 = await _storage.ref('discounts/rm5off.jpeg').getDownloadURL();
      String tempdiscountRM7 = await _storage.ref('discounts/rm7off.jpeg').getDownloadURL();
      String tempdiscountRM10 = await _storage.ref('discounts/rm10off.jpeg').getDownloadURL();


      List<Map<String, dynamic>> tempdiscountList = await getAllDiscounts();

      if (mounted)
        setState(() {
          checkinCounter = tempcheckinCounter;
          points = (double.parse(tempPoints!).toStringAsFixed(2)).toString();
          discountID = tempdiscountID;
          isCheckin = tempIsCheckin;
          rank = tempRank;
          discountRM3 = tempdiscountRM3;
          discountRM5 = tempdiscountRM5;
          discountRM7 = tempdiscountRM7;
          discountRM10 = tempdiscountRM10;
          discountList = tempdiscountList;
        });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> handleCheckin() async {
    try {
      pointObtained = await incrementcheckinCounter();
      fetchData();
      showPointsDialog();
    } catch (error) {
      print('Error during check-in: $error');
    }
  }

  void showPointsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Check-in Successful"),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.05,
            child: Column(
              children: [
                Text("You have earned $pointObtained points"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showComebackTomorrowDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("You have already claimed your check-in points today"),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.05,
            child: Column(
              children: [
                Text("Come back tomorrow!"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showResetDiscountIDDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Refresh Discount Selection"),
        content: Text("This will unselect any current discount selection."),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  resetDiscountID();
                  setState(() {
                    fetchData();
                  });
                  floatingSnackBar(
                    message: "Discount Refreshed!",
                    context: context,
                    textColor: Colors.white,
                    backgroundColor: Colors.grey,
                    duration: Duration(seconds: 2),
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Text("Confirm"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
            ],
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ReusableAppBar(title: "Redeem Page", backButton: false),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.currentIndex = 0;
                        });
                      },
                      child: Text(
                        'Daily Check-in',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          color: widget.currentIndex == 0 ? notSelectedButtonColor : selectedButtonColor,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.currentIndex == 0 ? selectedButtonColor : notSelectedButtonColor,
                        side: BorderSide(
                          color: Colors.grey,
                        ),
                        shape: RoundedRectangleBorder(),

                      )
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.currentIndex = 1;
                        });
                      },
                      child: Text(
                        'Rewards',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          color: widget.currentIndex == 1 ? notSelectedButtonColor : selectedButtonColor,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.currentIndex == 1 ? selectedButtonColor : notSelectedButtonColor,
                        side: BorderSide(
                          color: Colors.grey,
                        ),
                        shape: RoundedRectangleBorder(),
        
                      )
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.currentIndex = 2;
                        });
                      },
                      child: Text(
                        'Vouchers',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          color: widget.currentIndex == 2 ? notSelectedButtonColor : selectedButtonColor ,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.currentIndex == 2 ? selectedButtonColor : notSelectedButtonColor,
                        side: BorderSide(
                          color: Colors.grey,
                        ),
                        shape: RoundedRectangleBorder(),
                      )
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01,),
              ],
            ),
            if (widget.currentIndex == 0)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        color: lightGrey,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(points,
                              style: GoogleFonts.lato(
                                fontSize: MediaQuery.of(context).size.width * 0.065, // Adjust font size
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline, // Adjust font weight
                                color: selectedButtonColor, // Adjust text color
                              ),),
                            Text("Points",
                              style: GoogleFonts.lato(
                                fontSize: MediaQuery.of(context).size.width * 0.04, // Adjust font size
                                fontWeight: FontWeight.bold, // Adjust font weight
                                color: selectedButtonColor, // Adjust text color
                              ),),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                            Align(
                                child: Text(
                                    'Check-in to earn points',
                                  style: GoogleFonts.lato(
                                    fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                    fontWeight: FontWeight.bold, // Adjust font weight
                                    color: selectedButtonColor, // Adjust text color
                                  ),
                                )
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ReusableCheckinIcon(title: "Day 1", checkinCounter: checkinCounter, currentCheckinCounter: 0, pointsEarned: "1"),
                                ReusableCheckinIcon(title: "Day 2", checkinCounter: checkinCounter, currentCheckinCounter: 1, pointsEarned: "1"),
                                ReusableCheckinIcon(title: "Day 3", checkinCounter: checkinCounter, currentCheckinCounter: 2, pointsEarned: "2"),
                                ReusableCheckinIcon(title: "Day 4", checkinCounter: checkinCounter, currentCheckinCounter: 3, pointsEarned: "4"),
                                ReusableCheckinIcon(title: "Day 5", checkinCounter: checkinCounter, currentCheckinCounter: 4, pointsEarned: "6"),
                                ReusableCheckinIcon(title: "Day 6", checkinCounter: checkinCounter, currentCheckinCounter: 5, pointsEarned: "10"),
                                ReusableCheckinIcon(title: "Day 7", checkinCounter: checkinCounter, currentCheckinCounter: 6, pointsEarned: "15"),
                              ],
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                            ElevatedButton(
                              onPressed: isCheckin ? handleCheckin : showComebackTomorrowDialog,
                              child: Text(
                                isCheckin ? 'Check-in' : 'Points Collected! Come back tomorrow!',
                                style: TextStyle(
                                  color: selectedButtonColor,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isCheckin ? backGroundColor : backGroundColor,
                                side: BorderSide(
                                  color: Colors.grey,
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding for better tap area
                                shape: RoundedRectangleBorder( // Optional rounded corners for modern look
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),

                            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        
            if (widget.currentIndex == 1)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        color: lightGrey,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(rank,
                                  style: GoogleFonts.lato(
                                    fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                    fontWeight: FontWeight.bold, // Adjust font weight
                                    color: selectedButtonColor, // Adjust text color
                                  ),
                                  ),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.01,),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RankPage()));
                                  },
                                    icon: Icon(Icons.arrow_forward_ios,
                                    size: MediaQuery.of(context).size.width * 0.05,
                                    color: selectedButtonColor)
                                ),
                              ],
                            ),
                            Text("${points} points",
                              style: GoogleFonts.lato(
                                fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                fontWeight: FontWeight.bold, // Adjust font weight
                                color: selectedButtonColor, // Adjust text color
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    Text("Redeem Rewards",
                      style: GoogleFonts.lato(
                        fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                        fontWeight: FontWeight.bold, // Adjust font weight
                        color: selectedButtonColor, // Adjust text color
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    ReusableDiscount(downloadURL: discountRM3, pointCost: "300", discountRM: "3", fetchData: fetchData,),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    ReusableDiscount(downloadURL: discountRM5, pointCost: "500", discountRM: "5", fetchData: fetchData),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    ReusableDiscount(downloadURL: discountRM7, pointCost: "700", discountRM: "7", fetchData: fetchData),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    ReusableDiscount(downloadURL: discountRM10, pointCost: "900", discountRM: "10", fetchData: fetchData),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                  ],
                ),
              ),

            if (widget.currentIndex == 2)
              if (discountList.isEmpty)
                Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      decoration: BoxDecoration(
                        color:  lightGrey,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(Icons.hourglass_empty, size: 50,),
                            Text("No vouchers available"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            if (widget.currentIndex == 2)
              if (discountList.isNotEmpty)
                Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: discountList.length,
                      itemBuilder: (context, i) {
                        return Column(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                              InkWell(
                                onTap: () async {
                                  bool isRefresh = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ClaimDiscountPage(
                                              deliverymethod: discountList[i]['deliverymethod'],
                                              discount: discountList[i]['discount'],
                                              expiredAt: discountList[i]['expiredAt'],
                                              imageURL: discountList[i]['imageURL'],
                                              discountID: discountList[i]['id']
                                          )));

                                  if (isRefresh == true) {
                                    setState(() {
                                      fetchData();
                                    });
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.95,
                                  decoration: BoxDecoration(
                                    color: lightGrey,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      Column(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: discountList[i]['imageURL'],
                                          placeholder: (context, url) => CircularProgressIndicator(),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                          height: 1,
                                          thickness: 1,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                Text("Discount "),
                                                Text("RM ${discountList[i]['discount']}", style: TextStyle(color: Colors.grey)),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text("Valid until"),
                                                Text(TimeStampToDayMonthYearFormatter(discountList[i]['expiredAt']), style: TextStyle(color: Colors.grey)),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text("Delivery method"),
                                                Text(discountList[i]['deliverymethod'], style: TextStyle(color: Colors.grey)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                      if (discountList[i]['id'] == discountID)
                                      Positioned(
                                        right: 10,
                                        top: 10,
                                        child: CircleAvatar(
                                        child: Icon(Icons.check, color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                        );
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    ElevatedButton(
                        onPressed: () {
                          showResetDiscountIDDialog();
                        },
                        child: Text("Clear Selection",
                        style: TextStyle(
                          color: selectedButtonColor,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: backGroundColor,
                          side: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                  ],
                ),
          ],
        ),
      )
    );
  }
}
