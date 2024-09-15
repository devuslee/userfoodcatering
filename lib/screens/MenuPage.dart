import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:userfoodcatering/class/menuClass.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:userfoodcatering/screens/ViewOrderPage.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icon_badge/icon_badge.dart';

import '../reusableWidgets/reusableColor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'CartPage.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  Map<String, List<MenuClass>> menuData = {};
  List<GlobalKey> _itemKeys = [];
  ScrollController _scrollController = ScrollController();
  int cartCount = 0;
  double cartTotal = 0;
  String searchQuery = ""; // Search query variable

  int currentCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void fetchData() async {
    try {
      List<MenuClass> allMenuItems = await getMenuData();
      List categoryList = await getAllCategories();
      cartCount = await getCartQuantity();
      cartTotal = await getCartTotal();

      // Categorize the menu items
      for (var category in categoryList) {
        if (!menuData.containsKey(category)) {
          menuData[category] = [];
        }

        for (var menuItem in allMenuItems) {
          if (menuItem.category == category) {
            menuData[category]?.add(menuItem);
          }
        }
      }
      _itemKeys = List.generate(filteredMenuData.keys.length, (index) => GlobalKey());
      print(_itemKeys);
      if (mounted) {
        setState(() {
          // Update the UI after fetching data
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void scrollToMenu(int index) {
    if (index < 0 || index >= _itemKeys.length) return;

    final key = _itemKeys[index];
    if (key.currentContext != null) {
      final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero, ancestor: context.findRenderObject());

      _scrollController.animateTo(
        position.dy + _scrollController.offset - MediaQuery.of(context).size.height * 0.125,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
      ).then((_) {
        setState(() {
          currentCategoryIndex = index;  // Update category index after scrolling
        });
      });
    }
  }

  void _onScroll() {
    for (int i = 0; i < _itemKeys.length; i++) {
      if (_itemKeys[i].currentContext != null) {
        final RenderBox renderBox = _itemKeys[i].currentContext!.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero, ancestor: context.findRenderObject());
        if (position.dy > 0 && position.dy < MediaQuery.of(context).size.height * 0.5) {
          setState(() {
            currentCategoryIndex = i;
          });
          break;
        }
      }
    }
  }

  Map<String, List<MenuClass>> get filteredMenuData {
    if (searchQuery.isEmpty) {
      return menuData;
    }
    Map<String, List<MenuClass>> filteredData = {};
    menuData.forEach((category, items) {
      filteredData[category] = items.where((item) {
        return item.name.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    });
    return filteredData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.1), // Adjust height as needed
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.0075,),
            child: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              scrolledUnderElevation: 0,
              backgroundColor: backGroundColor,
              flexibleSpace: Center( // Center vertically within the AppBar
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.001,
                  ),// Add padding to the sides
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9, // Adjust width of the search bar
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[300]?.withOpacity(0.9),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(10), // Height of the bottom line
                child: Column(
                  children: [
                    Container(
                      color: Colors.grey, // Line color
                      height: 1.0, // Line thickness
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        color: notSelectedButtonColor,
                        border: Border(
                          right: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                          left: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: ListView(
                        children: filteredMenuData.keys.map((category) {
                          int categoryIndex = filteredMenuData.keys.toList().indexOf(category);
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                              color: notSelectedButtonColor,
                              // border: Border(
                              //   top: BorderSide(
                              //     color: Colors.grey,
                              //     width: (filteredMenuData.keys.first == category) ? 0.0 : 2.0,
                              //   ),
                              //   bottom: BorderSide(
                              //     color: Colors.grey,
                              //     width: (filteredMenuData.keys.last == category) ? 2.0 : 0.0,
                              //   ),
                              // ),
                            ),
                            child: InkWell(
                              onTap: () {
                                int index = 0;

                                for (var key in filteredMenuData.keys) {
                                  if (key == category) {
                                    break;
                                  }
                                  index++;
                                }

                                currentCategoryIndex = index;

                                _scrollController.removeListener(_onScroll);
                                setState(() {
                                  scrollToMenu(index);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  category,
                                  style: GoogleFonts.lato(
                                    fontSize: MediaQuery.of(context).size.width * 0.03,
                                    fontWeight: FontWeight.bold,
                                    color: (currentCategoryIndex == categoryIndex) ? selectedButtonColor : Colors.grey[500],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: filteredMenuData.keys.map((category) {
                            int categoryIndex = filteredMenuData.keys.toList().indexOf(category);
                            return Column(
                              key: _itemKeys[categoryIndex],
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (filteredMenuData[category]!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                  child: Center(
                                    child: Text(
                                      category,
                                      style: GoogleFonts.lato(
                                        fontSize: MediaQuery.of(context).size.width * 0.05,
                                        fontWeight: FontWeight.bold,
                                        // decoration:TextDecoration.underline,
                                        color: selectedButtonColor,
                                      ),
                                    ),
                                  ),
                                ),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 15,
                                    childAspectRatio: 1,
                                  ),
                                  itemCount: filteredMenuData[category]?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    var menuItem = filteredMenuData[category]?[index];

                                    return InkWell(
                                      onTap: () async {
                                        bool isRefresh = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ViewOrderPage(
                                              menuData: menuData[category]![index],
                                            ),
                                          ),
                                        );

                                        if (isRefresh) {
                                          setState(() async {
                                            cartTotal = await getCartTotal();
                                            cartCount = await getCartQuantity();
                                          });
                                        }
                                      },
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: CachedNetworkImage(
                                                imageUrl: menuItem?.imageURL ?? '',
                                                imageBuilder: (context, imageProvider) =>
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,  // Make the image circular
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,  // Ensures the image fills the circle properly
                                                        ),
                                                      ),
                                                    ),
                                                placeholder: (context, url) =>
                                                    Center(child: CircularProgressIndicator()),
                                                errorWidget: (context, url, error) =>
                                                    Text('Error: $error'),
                                              ),
                                            ),
                                            Text(
                                              menuItem?.name ?? '',
                                              style: GoogleFonts.lato(
                                                fontSize: MediaQuery.of(context).size.width * 0.05,
                                                fontWeight: FontWeight.bold,
                                                color: selectedButtonColor,
                                              ),
                                            ),
                                            Text(
                                              "RM${menuItem?.price.toString()}" ?? '',
                                              style: GoogleFonts.lato(
                                                fontSize: MediaQuery.of(context).size.width * 0.04,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // Divider(
                                //   color: Colors.grey[350],
                                //   thickness: 7.0,
                                // ),

                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: backGroundColor,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cartCount == 1 ? "${cartCount} item" : "${cartCount} items", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: Colors.grey)),
                  Text("RM${cartTotal}", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06, fontWeight: FontWeight.bold, color: selectedButtonColor)),
                ],
              ),
              Spacer(),
              IconBadge(
                icon: Icon(
                  Icons.shopping_cart,
                  color: powderBlue,
                  size: MediaQuery.of(context).size.width * 0.12,),
                itemCount: cartCount,
                badgeColor: Colors.red,
                right: 6,
                top: 0,
                hideZero: true,
                itemColor: Colors.white,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}
