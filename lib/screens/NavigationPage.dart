import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:userfoodcatering/screens/PointPage.dart';
import 'package:userfoodcatering/screens/ProfilePage.dart';
import 'package:userfoodcatering/screens/HomePage.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:userfoodcatering/screens/MenuPage.dart';
import 'package:userfoodcatering/screens/CartPage.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:userfoodcatering/screens/HistoryPage.dart';
import 'package:userfoodcatering/screens/RedeemPointPage.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import '../reusableWidgets/reusableColor.dart';

class NavigationPage extends StatefulWidget {
  final int currentIndex;
  final int redeemPagecurrentIndex;

  const NavigationPage({
    Key? key,
    required this.currentIndex,
    this.redeemPagecurrentIndex = 0,
  }) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentPageIndex = 0;
  int redeemPageIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.currentIndex;
    redeemPageIndex = widget.redeemPagecurrentIndex;
    _pages = _initializePages(); // Initialize _pages after setting redeemPageIndex
    fetchData();
  }

  void fetchData() async {
    try {
      setState(() {
        redeemPageIndex = widget.redeemPagecurrentIndex;
        _pages = _initializePages(); // Update _pages after fetching data
      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  List<Widget> _initializePages() {
    return [
      HomePage(),
      RedeemPointPage(currentIndex: redeemPageIndex),
      AddOrderPage(),
      HistoryPage(),
      ProfilePage(),
    ];
  }

  final IconList = [
    Icons.home,
    Icons.redeem,
    Icons.add,
    Icons.history,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentPageIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 1,  // Thin line
            decoration: BoxDecoration(
              color: Colors.grey[300],  // Light grey color for the line
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,  // Light shadow
                  blurRadius: 6,  // How much the shadow spreads
                  offset: Offset(0, -3),  // Position of shadow (above the line)
                ),
              ],
            ),
          ),
          BottomAppBar(
            padding: EdgeInsets.symmetric(horizontal: 0),
            height: MediaQuery.of(context).size.height * 0.1,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.8 / IconList.length,
                  child: InkWell(
                    onTap: () => setState(() => currentPageIndex = 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: currentPageIndex == 0 ? selectedButtonColor : notSelectedButtonColor,
                          size: MediaQuery.of(context).size.height * 0.04,
                        ),
                        Text(
                          "Home",
                          maxLines: 1,
                          style: TextStyle(color: currentPageIndex == 0 ? selectedButtonColor : notSelectedButtonColor,
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8 / IconList.length,
                  child: InkWell(
                    onTap: () => setState(() => currentPageIndex = 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.redeem,
                          color: currentPageIndex == 1 ? selectedButtonColor : notSelectedButtonColor,
                          size: MediaQuery.of(context).size.height * 0.04,
                        ),
                        Text(
                          "Redeem",
                          maxLines: 1,
                          style: TextStyle(color: currentPageIndex == 1 ? selectedButtonColor : notSelectedButtonColor,
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8 / IconList.length,
                  child: InkWell(
                    onTap: () => setState(() => currentPageIndex = 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: currentPageIndex == 2 ? selectedButtonColor : notSelectedButtonColor,
                          size: MediaQuery.of(context).size.height * 0.04,
                        ),
                        Text(
                          "Order",
                          maxLines: 1,
                          style: TextStyle(color: currentPageIndex == 2 ? selectedButtonColor : notSelectedButtonColor,
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8 / IconList.length,
                  child: InkWell(
                    onTap: () => setState(() => currentPageIndex = 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          color: currentPageIndex == 3 ? selectedButtonColor : notSelectedButtonColor,
                          size: MediaQuery.of(context).size.height * 0.04,
                        ),
                        Text(
                          "History",
                          maxLines: 1,
                          style: TextStyle(color: currentPageIndex == 3 ? selectedButtonColor : notSelectedButtonColor,
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8 / IconList.length,
                  child: InkWell(
                    onTap: () => setState(() => currentPageIndex = 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: currentPageIndex == 4 ? selectedButtonColor : notSelectedButtonColor,
                          size: MediaQuery.of(context).size.height * 0.04,
                        ),
                        Text(
                          "Profile",
                          maxLines: 1,
                          style: TextStyle(color: currentPageIndex == 4 ? selectedButtonColor : notSelectedButtonColor,
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
  // bottomNavigationBar: AnimatedBottomNavigationBar.builder(
      //   backgroundColor: navigationBarColor,
      //   height: MediaQuery.of(context).size.height * 0.1,
      //   itemCount: IconList.length,
      //   tabBuilder: (index, isActive) {
      //     final color = isActive ? selectedButtonColor : Colors.grey;
      //     return Container(
      //       child: Stack(
      //         alignment: Alignment.center,
      //         children: [
      //           Column(
      //             mainAxisSize: MainAxisSize.min,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               IconBadge(
      //                 icon: Icon(IconList[index], color: color, size: 30,),
      //                 itemCount: 0,
      //                 badgeColor: Colors.red,
      //                 right: 6,
      //                 top: 0,
      //                 hideZero: true,
      //                 itemColor: Colors.white,
      //               ),
      //               Text(
      //                 index == 0 ? 'Home' : index == 1 ? 'Redeem' : index == 2 ? 'Order' : index == 3 ? 'History' : index == 4 ? 'Profile' : '',
      //                 maxLines: 1,
      //                 style: TextStyle(color: color),
      //               ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      //   activeIndex: currentPageIndex,
      //   onTap: (index) => setState(() => currentPageIndex = index),
      // ),