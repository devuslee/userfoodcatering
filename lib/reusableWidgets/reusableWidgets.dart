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