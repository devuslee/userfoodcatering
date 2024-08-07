import 'package:flutter/material.dart';

import '../screens/CartPage.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../screens/RedeemDiscountPage.dart';
import 'package:icon_badge/icon_badge.dart';

class ReusableTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool isPassword;
  final bool isReadOnly;

  const ReusableTextField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.isReadOnly = false,
    this.isPassword = false,
  }) : super(key: key);

  @override
  _ReusableTextFieldState createState() => _ReusableTextFieldState();
}

class _ReusableTextFieldState extends State<ReusableTextField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: TextStyle(
        color: widget.isReadOnly ? Colors.grey : Colors.black,
      ),
      obscureText: widget.isPassword && !showPassword,
      readOnly: widget.isReadOnly,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(),
        suffixIcon: widget.isPassword
            ? IconButton(
          onPressed: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
        ) : null,
        filled: widget.isReadOnly,
        fillColor: widget.isReadOnly ? Colors.grey[200] : null,
      ),
    );
  }
}

class ReusableContainer extends StatefulWidget {
  final String text;
  final String textvalue;
  final Function() onPressed;

  const ReusableContainer({
    Key? key,
    required this.text,
    required this.textvalue,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<ReusableContainer> createState() => _ReusableContainerState();
}

class _ReusableContainerState extends State<ReusableContainer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onPressed();
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25, // Adjust width as needed
        margin: EdgeInsets.all(8.0), // Adjust margin as needed
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Adjust padding as needed
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey), // Add border
          borderRadius: BorderRadius.circular(8.0), // Add border radius for rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.015, // Adjust font size
                  fontWeight: FontWeight.bold,
                  color: Colors.grey// Adjust font weight
                ),
              ),
              Text(
                widget.textvalue,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.02, // Adjust font size
                  fontWeight: FontWeight.bold, // Adjust font weight
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReusableAppBar extends StatelessWidget {
  final String title;
  final bool backButton;
  final bool cartButton;
  final int cartCount;

  const ReusableAppBar({
    Key? key,
    required this.title,
    required this.backButton,
    this.cartButton = false,
    this.cartCount = 0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                if (backButton)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                  ),
                Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 24.0, // Adjust font size
                      fontWeight: FontWeight.bold, // Adjust font weight
                    ),
                    textAlign: TextAlign.center, // Ensure text is centered
                  ),
                ),
                if (cartButton)
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconBadge(
                      icon: Icon(Icons.shopping_cart, color: Colors.grey, size: 30,),
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
                  ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                    width: 2.0,
                  ),
                ),
              )
            )
          ],
        ),
    );
  }
}

class ReuseableSettingContainer extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onTap;

  const ReuseableSettingContainer({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon),
                SizedBox(width: 10.0),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0, // Adjust font size
                    fontWeight: FontWeight.bold, // Adjust font weight
                  ),
                ),
                Spacer(),
                IconButton(
                    onPressed: () async {onTap();},
                    icon: Icon(Icons.arrow_forward_ios)
                ),
              ],
            ),
            Divider(
              color: Colors.grey.withOpacity(0.5),
              thickness: 2.0,
            ),
          ],
        ),
    );
  }
}


class ReusableCheckinIcon extends StatelessWidget {
  final String title;
  final String pointsEarned;
  final int checkinCounter;
  final int currentCheckinCounter;


  const ReusableCheckinIcon({
    Key? key,
    required this.title,
    required this.checkinCounter,
    required this.currentCheckinCounter,
    required this.pointsEarned,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey),
            ),
            child: CircleAvatar(
              child: Icon(Icons.check,
                color: checkinCounter > currentCheckinCounter ? Colors.green : Colors.grey,),
            ),
          ),
          Text(title),
          Text("${pointsEarned}pts"),
        ]
    );
  }
}

class ReusableDiscount extends StatefulWidget {
  final String downloadURL;
  final String pointCost;
  final String discountRM;
  final Function() fetchData;


  const ReusableDiscount({
    Key? key,
    required this.downloadURL,
    required this.pointCost,
    required this.discountRM,
    required this.fetchData,
  }) : super(key: key);

  @override
  State<ReusableDiscount> createState() => _ReusableDiscountState();
}

class _ReusableDiscountState extends State<ReusableDiscount> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        bool shouldRefresh = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RedeemDiscountPage(
                points: widget.pointCost,
                discount: widget.discountRM,
                downloadURL: widget.downloadURL)));

        if (shouldRefresh) {
            widget.fetchData();
          }
        },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(child: widget.downloadURL == "" ? Text("No Image") : CachedNetworkImage(imageUrl: widget.downloadURL)),
              Divider(
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text("Redeem with", style: TextStyle(color: Colors.grey)),
                      Text("${widget.pointCost} pts")
                    ],
                  ),
                  Column(
                    children: [
                      Text("Reward",style: TextStyle(color: Colors.grey)),
                      Text("RM${widget.discountRM} off")
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


