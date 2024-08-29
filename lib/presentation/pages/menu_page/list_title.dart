import 'package:flutter/material.dart';

class ContentSidebar extends StatelessWidget {
  final String text;
  final Widget icon;
  final String routes;
  final Function? onTap;

  const ContentSidebar({
    super.key,
    required this.text,
    required this.icon,
    required this.routes,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
        Navigator.pushNamed(context, routes);
      },
      leading: icon,
      title: Text(text),
    );
  }
}