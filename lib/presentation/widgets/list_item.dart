import 'package:flutter/material.dart';
import 'package:notesapp/utils/resources/gaps_manager.dart';
import 'package:notesapp/utils/resources/sizes_manager.dart';

class ListItem extends StatelessWidget {
  const ListItem(
      {Key? key,
      required this.textRight,
      required this.icon,
      required this.onPressed,
      this.textLeft})
      : super(key: key);

  final String textRight;
  final IconData icon;
  final VoidCallback onPressed;
  final String? textLeft;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: SizesManager.p8),
        child: Row(
          children: [
            GapsManager.w10,
            Icon(
              icon,
            ),
            GapsManager.w10,
            Expanded(
              child: Row(
                children: [
                  Text(
                    textRight,
                    style: TextStyle(fontSize: SizesManager.s18),
                  ),
                  Expanded(
                    child: Text(
                      textLeft ?? "",
                      style: TextStyle(
                          fontSize: SizesManager.s18,
                          fontWeight: FontWeight.w200),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            GapsManager.w10
          ],
        ),
      ),
    );
  }
}