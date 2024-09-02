import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/utils/resources/strings_manager.dart';

import '../../utils/resources/sizes_manager.dart';

class SnackBarWidget extends StatelessWidget {
  const SnackBarWidget(
      {super.key,
      required this.text,
      required this.backgroundColor,
      required this.onPressed});

  final String text;
  final Color backgroundColor;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Container(
        height: SizesManager.h30,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(SizesManager.r2)),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style:
                    TextStyle(fontSize: SizesManager.s15, color: Colors.black),
              ),
            ),
            TextButton(
                style: ButtonStyle(
                    padding: WidgetStateProperty.all(
                        EdgeInsets.all(SizesManager.p5))),
                child: const Text(
                  StringsManger.cancel,
                ),
                onPressed: () {
                  onPressed;
                })
          ],
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.greenAccent,
      elevation: 0,
    );
  }
}