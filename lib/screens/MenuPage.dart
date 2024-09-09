import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:userfoodcatering/class/menuClass.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:userfoodcatering/screens/ViewOrderPage.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icon_badge/icon_badge.dart';

import '../reusableWidgets/reusableColor.dart';
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

      _itemKeys = List.generate(categoryList.length, (index) => GlobalKey());
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

    if (index < 0 || index >= _itemKeys.length) return; // Guard against out-of-bounds


    if (_itemKeys[index].currentContext != null) {
      final RenderBox renderBox = _itemKeys[index].currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero, ancestor: context.findRenderObject());

      _scrollController.animateTo(
        position.dy + _scrollController.offset - MediaQuery.of(context).size.height * 0.125,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
      ).then((_) => _scrollController.addListener(_onScroll));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
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
                      children: menuData.keys.map((category) {
                        int categoryIndex = menuData.keys.toList().indexOf(category);
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey,
                                width: (menuData.keys.first == category) ? 0.0: 2.0,
                              ),
                              bottom: BorderSide(
                                color: Colors.grey,
                                width: (menuData.keys.last == category) ? 2.0 : 0.0,
                              ),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              int index = 0;
                              for (String key in menuData.keys) {
                                if (key == category) break;
                                index += menuData[key]!.length;
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
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: (currentCategoryIndex == categoryIndex) ? Colors.red : Colors.black,
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
                        children: menuData.keys.map((category) {
                          int categoryIndex = menuData.keys.toList().indexOf(category);
                          return Column(
                            key: _itemKeys[categoryIndex],
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (menuData[category]!.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text(
                                    'No items available',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1,
                                ),
                                itemCount: menuData[category]?.length ?? 0,
                                itemBuilder: (context, index) {
                                  var menuItem = menuData[category]?[index];
        
        
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          menuItem?.name ?? '',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
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
                                            child: CachedNetworkImage(
                                              imageUrl: menuItem?.imageURL ?? '',
                                              imageBuilder: (context, imageProvider) =>
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                              placeholder: (context, url) =>
                                                  Center(child: CircularProgressIndicator()),
                                              errorWidget: (context, url, error) =>
                                                  Text('Error: $error'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
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
          Positioned(
            bottom: MediaQuery.of(context).size.width * 0.01, // Adjust the position from the bottom
            right: MediaQuery.of(context).size.width * 0.05, // Adjust the position from the right
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  color: aquamarine,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Total Price: RM${cartTotal}", style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.02, fontWeight: FontWeight.bold)),
                      Spacer(),
                      IconBadge(
                        icon: Icon(Icons.shopping_cart, color: powderBlue, size: MediaQuery.of(context).size.width * 0.05,),
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
              ),
            )
          ),
        ]
      ),
    );
  }
}
