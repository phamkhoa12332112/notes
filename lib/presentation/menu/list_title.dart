import 'package:flutter/material.dart';

class ContentSidebar extends StatelessWidget {
  final String text;
  final Widget icon;
  final String routes;


  const ContentSidebar({super.key, required this.text, required this.icon, required this.routes});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, routes);
      },
      leading: icon,
      title: Text(text),
    );
  }
}