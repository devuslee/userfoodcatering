import 'package:flutter/material.dart';
import 'package:userfoodcatering/reusableWidgets/reusableFunctions.dart';
import 'package:userfoodcatering/reusableWidgets/reusableWidgets.dart';
import 'package:userfoodcatering/screens/MenuPage.dart';
import 'package:userfoodcatering/screens/NavigationPage.dart';
import 'package:userfoodcatering/screens/ViewOrderPage.dart';
import 'package:userfoodcatering/class/menuClass.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../reusableWidgets/reusableColor.dart';
import 'SendingOrderPage.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController specialRequestController = TextEditingController();

  List<String> pickupTimes = [
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
  ];

  DateTime selectedDate = DateTime.now();
  String _selectedPaymentMethod = 'Cash';

  String _selectedTime = '10:00 AM';
  List _cartItems = [];
  double cartQuantity = 0;

  double cartTotal = 0;
  double discountedcartTotal = 0;

  bool discounted = false;
  String discountID = '';
  String discountAmount = "0";

  Map<String, String> userDetails = {};
  String balance = "Loading...";

  List paymentMethods = [
    'Cash',
    'E-Wallet',
  ];

  late SharedPreferences prefs;

  String tempDateTime = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      Map<String, String> tempuserDetails = await getUserDetails();
      String tempDiscountID = await getUserDiscountID();
      prefs = await SharedPreferences.getInstance();

      if (prefs.getString('date') != null) {
        tempDateTime = prefs.getString('date').toString();
        selectedDate = DateTime.parse(tempDateTime);
        _dateController.text = DayMonthYearFormatter(tempDateTime.toString().split(' ')[0]);
      }

      if (prefs.getString('pickupTime') != null) {
        _selectedTime = prefs.getString('pickupTime').toString();
      }

      if (prefs.getString('specialRequest') != null) {
        specialRequestController.text = prefs.getString('specialRequest').toString();
      }

      if (prefs.getString('paymentMethod') != null) {
        _selectedPaymentMethod = prefs.getString('paymentMethod').toString();
      }


      _cartItems = await getUserCart();
      cartQuantity = 0;
      cartTotal = 0;
      for (var item in _cartItems) {
        cartQuantity = cartQuantity + item.quantity;
        cartTotal = cartTotal + item.total;
      }

      if (tempDiscountID != "") {
        discountAmount = await getSpecificDiscount(tempDiscountID);
      }

      if (mounted) {
        setState(() {
          userDetails = tempuserDetails;
          discountID = tempDiscountID;
          discountAmount = discountAmount;
          balance = userDetails['balance']!;
          paymentMethods = [
            'Cash',
            'E-Wallet (RM $balance)',
          ];

          if (double.parse(discountAmount) != 0) {
            if (cartTotal > double.parse(discountAmount)) {
              discountedcartTotal = cartTotal - double.parse(discountAmount);
              discounted = true;
            } else if (cartTotal <= double.parse(discountAmount)) {
              discountedcartTotal = 0;
              discounted = true;
            } else {
              discountAmount = "0";
              discounted = false;
            }
          }
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //usually use the reusable widget but i need to alter the appbar
              SafeArea(
              child: Column(
              mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () {
                              //instead of pop use push to navigate to the navigation page
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NavigationPage(currentIndex: 2,)));
                            },
                            icon: Icon(Icons.arrow_back_ios),
                          ),
                        ),
                      Center(
                        child: Text(
                          "Cart",
                          style: GoogleFonts.lato(
                            fontSize: MediaQuery.of(context).size.width * 0.065, // Adjust font size
                            fontWeight: FontWeight.bold, // Adjust font weight
                            color: selectedButtonColor, // Adjust text color
                          ),
                          textAlign: TextAlign.center, // Ensure text is centered
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.08,
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
                            style: GoogleFonts.lato(
                              fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                              fontWeight: FontWeight.bold, // Adjust font weight
                              color: selectedButtonColor, // Adjust text color
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                          Tooltip(
                            message: 'Currently there are no delivery options available',
                            child: Icon(
                              Icons.info_outline,
                              size: MediaQuery.of(context).size.width * 0.05,
                            ),
                          )
                        ],
                      ),
                    )
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.04,
                  right: MediaQuery.of(context).size.width * 0.04,
                  bottom: 0.0,
                ),
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
                                style: GoogleFonts.lato(
                                  fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                  fontWeight: FontWeight.bold, // Adjust font weight
                                  color: selectedButtonColor, // Adjust text color
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
                                  color: powderBlue,
                                ),
                                Text(
                                  'No items in cart',
                                  style: GoogleFonts.lato(
                                    fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                    fontWeight: FontWeight.bold, // Adjust font weight
                                    color: selectedButtonColor, // Adjust text color
                                  ),
                                ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => NavigationPage(currentIndex: 2,),
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
                                      backgroundColor: selectedButtonColor,
                                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                      textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ),
                              ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                                  height: MediaQuery.of(context).size.height * 0.15,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    // border: Border.all(
                                    //   color: Colors.grey,
                                    //   width: 1,
                                    // ),
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
                                                    style: GoogleFonts.lato(
                                                      fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                                      fontWeight: FontWeight.bold, // Adjust font weight
                                                      color: selectedButtonColor, // Adjust text color
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
                                                  child: Text('EDIT',
                                                    style: GoogleFonts.lato(
                                                      fontSize: MediaQuery.of(context).size.width * 0.035, // Adjust font size
                                                      fontWeight: FontWeight.bold, // Adjust font weight
                                                      color: selectedButtonColor, // Adjust text color
                                                    ),),
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
                                            Row(
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width * 0.075,
                                                  height: MediaQuery.of(context).size.width * 0.075,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                      width: 1,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: IconButton(
                                                      onPressed: () {
                                                        if (item.quantity == 1) {
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

                                                          return;
                                                        }

                                                        int quantity = item.quantity - 1;
                                                        double total = item.price * quantity;
                                                        updateSpecificCart(item.name, quantity, total);
                                                        setState(() {
                                                          fetchData();
                                                        });
                                                      },
                                                      icon: Icon(Icons.remove),
                                                       iconSize:  MediaQuery.of(context).size.width * 0.03,
                                                  ),
                                                ),
                                                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                                                Text(
                                                  '${item.quantity}',
                                                  style: GoogleFonts.lato(
                                                    fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                                    fontWeight: FontWeight.bold, // Adjust font weight
                                                    color: selectedButtonColor, // Adjust text color
                                                  ),
                                                ),
                                                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                                                Container(
                                                  width: MediaQuery.of(context).size.width * 0.075,
                                                  height: MediaQuery.of(context).size.width * 0.075,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                      width: 1,
                                                    ),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      int quantity = item.quantity + 1;
                                                      double total = item.price * quantity;
                                                      updateSpecificCart(item.name, quantity, total);
                                                      setState(() {
                                                        fetchData();
                                                      });
                                                    },
                                                    icon: Icon(Icons.add),
                                                    iconSize:  MediaQuery.of(context).size.width * 0.03,
                                                  ),
                                                ),
                                                Spacer(),
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
                                                  iconSize:  MediaQuery.of(context).size.width * 0.075,
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
                        color: backGroundColor,
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
                            style: GoogleFonts.lato(
                              fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                              fontWeight: FontWeight.bold, // Adjust font weight
                              color: selectedButtonColor, // Adjust text color
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
                                prefs.setString("pickupTime", _selectedTime);
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
                        color: backGroundColor,
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
                            "Pickup Date",
                            style: GoogleFonts.lato(
                              fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                              fontWeight: FontWeight.bold, // Adjust font weight
                              color: selectedButtonColor, // Adjust text color
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                        backgroundColor: Colors.grey[300],
                                        child: _dateController.text == '' ?
                                        Tooltip(
                                          message: 'Select a date',
                                          child: Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        ) :
                                        Tooltip(
                                          message: 'Date Selected',
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.green,
                                          ),
                                        )
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                                    Text(
                                      _dateController.text == '' ? 'Select a date' : _dateController.text,
                                      style: GoogleFonts.lato(
                                        fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                        fontWeight: FontWeight.bold, // Adjust font weight
                                        color: selectedButtonColor, // Adjust text color
                                      ),
                                    ),
                                    Spacer(),
                                    IconButton(
                                      onPressed: () async {
                                        DateTime? date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now().add(Duration(days: 1)),
                                          firstDate: DateTime.now().add(Duration(days: 1)),
                                          lastDate: DateTime(2025),
                                        );

                                        if (date != null) {
                                          setState(() {
                                            DateTime AMPMtoDatetime = parseTime(_selectedTime);
                                            selectedDate = DateTime(
                                              date.year,
                                              date.month,
                                              date.day,
                                              AMPMtoDatetime.hour,
                                              AMPMtoDatetime.minute,
                                            );
                                            print(selectedDate);
                                            _dateController.text = DayMonthYearFormatter(date.toString().split(' ')[0]);
                                            prefs.setString('date', selectedDate.toString());
                                          });
                                        }
                                      },
                                      icon: Icon(Icons.calendar_today),
                                    ),
                                  ],
                                ),
                              )
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: backGroundColor,
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
                            style: GoogleFonts.lato(
                              fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                              fontWeight: FontWeight.bold, // Adjust font weight
                              color: selectedButtonColor, // Adjust text color
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Have any special request?',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            controller: specialRequestController,
                            onChanged: (value) async {
                              prefs.setString('specialRequest', value);
                            },
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: backGroundColor,
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
                            style: GoogleFonts.lato(
                              fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                              fontWeight: FontWeight.bold, // Adjust font weight
                              color: selectedButtonColor, // Adjust text color
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                          DropdownButtonFormField(
                            value: _selectedPaymentMethod,
                            items: paymentMethods.map((payment) {
                              return DropdownMenuItem(
                                value: payment.toString().split(' ')[0],
                                child: Text(payment),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedPaymentMethod = value.toString();
                                prefs.setString("paymentMethod", _selectedPaymentMethod);
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: backGroundColor,
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
                            "Select Discount",
                            style: GoogleFonts.lato(
                              fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                              fontWeight: FontWeight.bold, // Adjust font weight
                              color: selectedButtonColor, // Adjust text color
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                          if (discountID == '')
                            Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.discount,
                                    size: 100,
                                    color: powderBlue,
                                  ),
                                  Text(
                                    'No Discounts Selected',
                                    style: GoogleFonts.lato(
                                      fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                      fontWeight: FontWeight.bold, // Adjust font weight
                                      color: selectedButtonColor, // Adjust text color
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.75,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => NavigationPage(currentIndex: 1, redeemPagecurrentIndex: 2,),
                                        ));
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'Select a discount',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedButtonColor,
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
                            ),

                          if (discountID != '')
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      child: cartTotal == 0 ?
                                      Tooltip(
                                        message: 'Discount cannot be applied as there are items in cart',
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                      ) :
                                      Tooltip(
                                        message: 'Discount applied',
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        ),
                                      )
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.005),
                                    Text(
                                      'RM ${discountAmount} Discount Applied',
                                      style: GoogleFonts.lato(
                                        fontSize: MediaQuery.of(context).size.width * 0.05, // Adjust font size
                                        fontWeight: FontWeight.bold, // Adjust font weight
                                        color: selectedButtonColor, // Adjust text color
                                      ),
                                    ),
                                    Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => NavigationPage(currentIndex: 1, redeemPagecurrentIndex: 2,),
                                          ));
                                        },
                                        icon: Icon(Icons.arrow_forward_ios)
                                    ),
                                  ],
                                ),
                              )
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
                            color: backGroundColor,
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
                                    cartQuantity == 1 ? "${cartQuantity.toInt()} item" : "${cartQuantity.toInt()} items",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),

                                  if (discounted == true)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "RM ${cartTotal.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: discounted ? Colors.grey[500] : Colors.green,
                                            decoration: discounted ? TextDecoration.lineThrough : TextDecoration.none,
                                            decorationColor: Colors.grey,
                                            decorationThickness: 2,
                                          ),
                                        ),
                                        Text(
                                          "RM ${discountedcartTotal.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (discounted == false)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "RM ${cartTotal.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    )
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_cartItems.isEmpty) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Empty Cart'),
                                          content: Text('No items in cart'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Dismiss the dialog
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    return;
                                  }

                                  if (cartTotal > double.parse(balance) && _selectedPaymentMethod == 'E-Wallet') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Error'),
                                          content: Text('Insufficient balance in E-Wallet'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Dismiss the dialog
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    return;
                                  }

                                  if (_dateController.text == "") {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Error'),
                                          content: Text('Please select a date'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Dismiss the dialog
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    return;
                                  }

                                  if (selectedDate.toString().split(' ')[0] == DateTime.now().add(Duration(days: 1)).toString().split(' ')[0]) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Note!'),
                                          content: Text('Orders placed 1 day ahead cannnot be cancelled! '),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Dismiss the dialog
                                              },
                                              child: Text('Close'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                if (discounted == false) {
                                                  await Navigator.push(
                                                    context, MaterialPageRoute(
                                                    builder: (context) =>
                                                        SendingOrderPage(
                                                          cartList: _cartItems,
                                                          specialRemark: specialRequestController.text,
                                                          desiredPickupTime: selectedDate.toString(),
                                                          cartTotal: cartTotal,
                                                          paymentMethod: _selectedPaymentMethod,
                                                        ),
                                                  ),
                                                  ).then((value) => fetchData());
                                                }
                                                if (discounted == true) {
                                                  await Navigator.push(
                                                    context, MaterialPageRoute(
                                                    builder: (context) =>
                                                        SendingOrderPage(
                                                          cartList: _cartItems,
                                                          specialRemark: specialRequestController.text,
                                                          desiredPickupTime: selectedDate.toString(),
                                                          cartTotal: discountedcartTotal,
                                                          paymentMethod: _selectedPaymentMethod,
                                                        ),
                                                  ),
                                                  ).then((value) => fetchData());
                                                } // Dismiss the dialog
                                              },
                                              child: Text('Continue'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    return;
                                  }

                                  if (discounted == false) {
                                    await Navigator.push(
                                      context, MaterialPageRoute(
                                      builder: (context) =>
                                          SendingOrderPage(
                                            cartList: _cartItems,
                                            specialRemark: specialRequestController.text,
                                            desiredPickupTime: selectedDate.toString(),
                                            cartTotal: cartTotal,
                                            paymentMethod: _selectedPaymentMethod,
                                          ),
                                    ),
                                    ).then((value) => fetchData());
                                  }
                                  if (discounted == true) {
                                    await Navigator.push(
                                      context, MaterialPageRoute(
                                      builder: (context) =>
                                          SendingOrderPage(
                                            cartList: _cartItems,
                                            specialRemark: specialRequestController.text,
                                            desiredPickupTime: selectedDate.toString(),
                                            cartTotal: discountedcartTotal,
                                            paymentMethod: _selectedPaymentMethod,
                                          ),
                                    ),
                                    ).then((value) => fetchData());
                                  }

                                  setState(() {
                                    fetchData();
                                  });
                                },
                                child: Text(
                                    "Order Now",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,)
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: selectedButtonColor,
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

DateTime parseTime(String time) {
  final parts = time.split(' ');
  final timePart = parts[0];
  final period = parts[1];

  final timeParts = timePart.split(':');
  int hour = int.parse(timeParts[0]);
  final int minute = int.parse(timeParts[1]);

  if (period == 'PM' && hour != 12) {
    hour += 12;
  } else if (period == 'AM' && hour == 12) {
    hour = 0;
  }

  return DateTime(0, 1, 1, hour, minute);
}
