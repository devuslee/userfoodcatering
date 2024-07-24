import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:userfoodcatering/screens/MenuPage.dart';
import 'package:userfoodcatering/screens/NavigationPage.dart';
import 'package:userfoodcatering/screens/ViewOrderPage.dart';
import 'package:userfoodcatering/class/menuClass.dart';

import 'SendingOrderPage.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<String> pickupTimes = [
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
  ];

  List paymentMethods = [
    'Cash',
    'E-Wallet',
  ];

  String _selectedPaymentMethod = 'Cash';

  String _selectedTime = '10:00 AM';
  List _cartItems = [];
  double cartQuantity = 0;
  double cartTotal = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      _cartItems = await getUserCart();
      cartQuantity = 0;
      cartTotal = 0;
      for (var item in _cartItems) {
        cartQuantity = cartQuantity + item.quantity;
        cartTotal = cartTotal + item.total;
      }
      setState(() {

      });
    } catch (error) {
      print('Error fetching data: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    TextEditingController specialRequestController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ReusableAppBar(title: "Cart",  backButton: false),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    height: 50,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey,
                                width: 1
                            ),
                            top: BorderSide(
                                color: Colors.grey,
                                width: 1
                            )
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Self Pickup',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                          Tooltip(
                            message: 'Currently there are no delivery options available',
                            child: Icon(
                              Icons.info_outline,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 1
                                ),
                            )
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Order Summary',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _cartItems.length == 0 ? 1 : _cartItems.length,
                      itemBuilder: (context, index) {
                        if (_cartItems.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_cart,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'No items in cart',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => NavigationPage(currentIndex: 4,),
                                    ));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.restaurant_menu, color: Colors.white),
                                      Text(
                                          'Browse the menu',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                    ],
                                  ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                      textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ),
                              ),
                            ],
                            ),
                          );
                        }

                        var item = _cartItems[index];
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                              Card(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                          child: Image.network(
                                            item.imageURL,
                                            width: MediaQuery.of(context).size.width * 0.25,
                                            height: MediaQuery.of(context).size.height * 0.25,
                                            fit: BoxFit.cover,
                                          ),
                                        ),

                                      SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    item.name,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    var _menuData = await getSpecificMenuData(item.name);
                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => ViewOrderPage(menuData: _menuData[0]),
                                                      ),
                                                    ).then((value) => fetchData());
                                                  },
                                                  child: Text('EDIT'),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              'RM ${item.total}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green,
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context).size.height * 0.11,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Portions: ${item.quantity}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text('Confirm Deletion'),
                                                          content: Text('Are you sure you want to delete this item?'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop(); // Dismiss the dialog
                                                              },
                                                              child: Text('Cancel'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                deleteSpecificCart(item.name);
                                                                setState(() {
                                                                  fetchData();
                                                                });
                                                                Navigator.of(context).pop(); // Dismiss the dialog after deleting
                                                              },
                                                              child: Text('Delete'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  icon: Icon(Icons.delete),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                            ],
                          ),
                        );
                      },
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          Text(
                            "Pickup Time",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          DropdownButtonFormField(
                            value: _selectedTime,
                            items: pickupTimes.map((time) {
                              return DropdownMenuItem(
                                value: time,
                                child: Text(time),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedTime = value.toString();
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Select Pickup Time',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          Text(
                            "Special Request",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Have any special request? Let us know!'
                                  ' (e.g. no onions, extra spicy, etc.)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            controller: specialRequestController,
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          Text(
                            "Select Payment Method",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          DropdownButtonFormField(
                            value: _selectedPaymentMethod,
                            items: paymentMethods.map((payment) {
                              return DropdownMenuItem(
                                value: payment,
                                child: Text(payment),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedPaymentMethod = value.toString();
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Select Payment Method',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                                  Text(
                                    "Total Portions: ${cartQuantity.toString()}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "RM ${cartTotal.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.60,
                                    height: MediaQuery.of(context).size.height * 0.10,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.location_on,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            '5-G-1,Promenade, Jalan Mahsuri, 11900 Bayan Baru, Pulau Pinang',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => SendingOrderPage(
                                      cartList: _cartItems,
                                      specialRemark: specialRequestController.text,
                                      desiredPickupTime: _selectedTime,
                                      cartTotal: cartTotal,
                                      paymentMethod: _selectedPaymentMethod,
                                      ),
                                    ),
                                  ).then((value) => fetchData());

                                  setState(() {
                                    fetchData();
                                  });
                                },
                                child: Text(
                                    "Order Now",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  textStyle: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
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
      ),
    );
  }
}
