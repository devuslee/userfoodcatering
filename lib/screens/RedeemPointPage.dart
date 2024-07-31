import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';


class RedeemPointPage extends StatefulWidget {
  const RedeemPointPage({super.key});

  @override
  State<RedeemPointPage> createState() => _RedeemPointPageState();
}

class _RedeemPointPageState extends State<RedeemPointPage> {
  int currentButtonIndex = 0;
  int checkinCounter = 0;
  int pointObtained = 0;
  bool isCheckin = false;
  String points = "";


  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      int tempcheckinCounter = await getcheckinCounter();
      bool tempIsCheckin = await getIsCheckin();
      String tempPoints = await getUserPoints();

      setState(() {
        checkinCounter = tempcheckinCounter;
        points = tempPoints;
        isCheckin = tempIsCheckin;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ReusableAppBar(title: "Redeem Page", backButton: false),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentButtonIndex = 0;
                      });
                    },
                    child: Text(
                      'Daily Check-in',
                      style: TextStyle(
                        color: currentButtonIndex == 0 ? Colors.white : Colors.blue,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentButtonIndex == 0 ? Colors.blue : Colors.white,
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
                        currentButtonIndex = 1;
                      });
                    },
                    child: Text(
                      'Redeem Rewards',
                      style: TextStyle(
                        color: currentButtonIndex == 1 ? Colors.white : Colors.blue,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentButtonIndex == 1 ? Colors.blue : Colors.white,
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
                        currentButtonIndex = 2;
                      });
                    },
                    child: Text(
                      'Vouchers',
                      style: TextStyle(
                        color: currentButtonIndex == 2 ? Colors.white : Colors.blue,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentButtonIndex == 2 ? Colors.blue : Colors.white,
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
          if (currentButtonIndex == 0)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(points, style: TextStyle(fontSize: 30, decoration: TextDecoration.underline)),
                      Text("Points"),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                      Align(
                          child: Text(
                              'Check-in to earn points'
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
                        onPressed: isCheckin == true ? handleCheckin : showComebackTomorrowDialog,
                        child: isCheckin == true ? Text(
                          'Check-in',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ) : Text(
                          'Come back tomorrow!',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: currentButtonIndex == 2 ? Colors.blue : Colors.white,
                            side: BorderSide(
                              color: Colors.grey,
                            ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      )
    );
  }
}
