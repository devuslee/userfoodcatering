import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:userfoodcatering/screens/ProfilePage.dart';
import 'package:userfoodcatering/screens/HomePage.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:userfoodcatering/screens/MenuPage.dart';
import 'package:userfoodcatering/screens/CartPage.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:userfoodcatering/screens/HistoryPage.dart';

class NavigationPage extends StatefulWidget {
  final int currentIndex;

  const NavigationPage({Key? key, required this.currentIndex}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentPageIndex = 0;
  int cartCount = 0;


  void initState() {
    super.initState();
    currentPageIndex = widget.currentIndex == null ? 0 : widget.currentIndex;
    fetchData();
  }

  void fetchData() async {
    try {
      cartCount = await getCartQuantity();
      // Fetch points and rank similarly
      setState(() {}); // Update the UI after fetching data
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  final List<Widget> _pages = [
    HomePage(),
    CartPage(),
    HistoryPage(),
    ProfilePage(),
    AddOrderPage(),
  ];

  final IconList = [
    Icons.home,
    Icons.shopping_cart,
    Icons.history,
    Icons.person,
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentPageIndex],
      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              currentPageIndex = 4;
            });
          },
          shape: const CircleBorder(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: currentPageIndex == 4 ? Colors.blue : Colors.grey),
              const SizedBox(height: 1),
              Text(
                  "Order",
                  maxLines: 1,
                  style: TextStyle(color: currentPageIndex == 4 ? Colors.blue : Colors.grey),
                ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        height: 80,
        itemCount: IconList.length,
        tabBuilder: (index, isActive) {
          final color = isActive ? Colors.blue : Colors.grey;
          return Container(
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconBadge(
                      icon: Icon(IconList[index], color: color, size: 30,),
                      itemCount: index == 1 ? cartCount : 0,
                      badgeColor: Colors.red,
                      right: 6,
                      top: 0,
                      hideZero: true,
                      itemColor: Colors.white,
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        index == 0 ? 'Home' : index == 1 ? 'Cart' : index == 2 ? 'History' : index == 3 ? 'Profile' : '',
                        maxLines: 1,
                        style: TextStyle(color: color),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        activeIndex: currentPageIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() => currentPageIndex = index),
      ),
    );
  }
}

