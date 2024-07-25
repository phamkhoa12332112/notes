import 'package:flutter/material.dart';

import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';

class DeleteScreen extends StatelessWidget {
  const DeleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Stack(
            children: [
              Title(
                  color: Colors.black, child: const Text(StringsManger.delete)),
              const Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.more_vert))
            ],
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.delete_outline,
                    color: Colors.orangeAccent, size: SizesManager.w150),
                Text(
                  StringsManger.delete_text,
                  style: TextStyle(fontSize: SizesManager.s15),
                ),
              ],
            ),
          ),
        ));
  }
}