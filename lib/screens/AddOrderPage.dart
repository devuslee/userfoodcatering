import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:userfoodcatering/class/menuClass.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:userfoodcatering/screens/ViewOrderPage.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  //contains all the menu data
  List<MenuClass> MenuList = [];

  void initState() {
    super.initState();
    fetchData();
  }


  void fetchData() async {
    try {
      MenuList = await getMenuData();
      setState(() {}); // Update the UI after fetching data
    } catch (error) {
      print('Error fetching data: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReusableAppBar(title: "Menu", backButton: false),
            const SizedBox(height: 5),
            Expanded(
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                childAspectRatio: 1,
                children: <Widget>[
                  for (var menu in MenuList)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          menu.name,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ViewOrderPage(menuData: menu),
                            ),
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl: menu.imageURL,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Text('Error: $error'),
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
