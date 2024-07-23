import 'package:flutter/material.dart';

class ReusableTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool isPassword;

  const ReusableTextField({
    Key? key,
    required this.labelText,
    required this.controller,
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
      obscureText: widget.isPassword && !showPassword,
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
        )
            : null,
      ),
    );
  }
}

class ReusableContainer extends StatefulWidget {
  final String text;
  final String textvalue;

  const ReusableContainer({
    Key? key,
    required this.text,
    required this.textvalue,
  }) : super(key: key);

  @override
  State<ReusableContainer> createState() => _ReusableContainerState();
}

class _ReusableContainerState extends State<ReusableContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75, // Adjust height as needed
      width: MediaQuery.of(context).size.width * 0.25, // Adjust width as needed
      margin: EdgeInsets.all(8.0), // Adjust margin as needed
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Adjust padding as needed
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey), // Add border
        borderRadius: BorderRadius.circular(8.0), // Add border radius for rounded corners
      ),
      child: Column(
        children: [
          Text(
            widget.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0, // Adjust font size
              fontWeight: FontWeight.bold, // Adjust font weight
            ),
          ),
          Text(
            widget.textvalue,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0, // Adjust font size
              fontWeight: FontWeight.bold, // Adjust font weight
            ),
          ),
        ],
      ),
    );
  }
}

class ReusableAppBar extends StatelessWidget {
  final String title;
  final bool backButton;

  const ReusableAppBar({
    Key? key,
    required this.title,
    required this.backButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Stack(
            children: [
              if (backButton)
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
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
                    onPressed: onTap,
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