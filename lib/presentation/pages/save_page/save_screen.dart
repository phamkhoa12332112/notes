import 'package:flutter/material.dart';

import '../../../utils/resources/gaps_manager.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';


class SaveScreen extends StatelessWidget {
  const SaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Title(color: Colors.black, child: const Text(StringsManger.save)),
              const Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.search),
                    GapsManager.w20,
                    Icon(Icons.view_stream_outlined)
                  ],
                ),
              )
            ],
          ),
        ),
        body: const SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.save_alt_outlined,
                    color: Colors.orangeAccent, size: SizesManager.s100),
                Text(StringsManger.save_text),
              ],
            ),
          ),
        )
    );
  }
}