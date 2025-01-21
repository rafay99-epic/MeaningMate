import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;
  final bool isNumber;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.isPassword,
    this.isNumber = false,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _isObscured : false,
        keyboardType:
            widget.isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          prefixIcon: Icon(
            widget.icon,
            color: Theme.of(context).colorScheme.primary,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.0,
            ),
          ),
        ),
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}
