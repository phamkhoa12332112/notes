import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final double contentPadding;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? prefixIconColor;
  final bool? filled;
  final Color? fillColor;
  final double borderRadius;
  final TextEditingController controller;
  final Function(String)? onChanged;

  const TextFieldWidget({
    super.key,
    required this.hintText,
    required this.contentPadding,
    required this.borderRadius,
    required this.controller,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixIconColor,
    this.filled,
    this.fillColor,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
          hintText: hintText,
          filled: filled,
          fillColor: fillColor,
          contentPadding: EdgeInsets.all(contentPadding),
          border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(borderRadius))),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          prefixIconColor: prefixIconColor),
    );
  }
}