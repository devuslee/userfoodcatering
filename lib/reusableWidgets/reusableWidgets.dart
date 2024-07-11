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
      width: MediaQuery.of(context).size.width * 0.3, // Adjust width as needed
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
