import 'package:flutter/material.dart';
import 'package:notesapp/utils/resources/sizes_manager.dart';

class ListItem extends StatelessWidget {
  String textRight;
  String? textLeft;
  IconData icon;
  Function()? onPressed;

  ListItem(
      {super.key,
      required this.textRight,
      required this.icon,
      this.textLeft,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizesManager.h30,
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              alignment: Alignment.centerLeft,
              elevation: 0,
              shape: const RoundedRectangleBorder()),
          onPressed: onPressed,
          label:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(textRight, style: const TextStyle(color: Colors.black)),
            Text(textLeft ?? "", style: const TextStyle(color: Colors.black54))
          ]),
          icon: Icon(icon, color: Colors.black)),
    );
  }
}
