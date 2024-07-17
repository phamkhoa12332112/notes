import 'package:flutter/material.dart';
import 'package:notesapp/utils/resources/sizes_manager.dart';

class ListItem extends StatelessWidget {
  String text;
  IconData icon;

  ListItem({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizesManager.h30,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            alignment: Alignment.centerLeft,
            elevation: 0,
            shape: const RoundedRectangleBorder()),
        onPressed: () {},
        label: Text(text, style: const TextStyle(color: Colors.black)),
        icon: Icon(icon, color: Colors.black),
      ),
    );
  }
}