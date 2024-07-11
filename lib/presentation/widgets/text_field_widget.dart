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

  const TextFieldWidget({
    super.key,
    required this.hintText,
    required this.contentPadding,
    required this.borderRadius,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixIconColor,
    this.filled,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
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
