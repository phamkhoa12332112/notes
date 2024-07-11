import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/resources/gaps_manager.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';


class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Title(
              color: Colors.black, child: const Text(StringsManger.setting)),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(SizesManager.s18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  StringsManger.show_mode,
                  style: TextStyle(
                      fontSize: SizesManager.s20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    const Text(StringsManger.show_mode_1,
                        style: TextStyle(fontSize: SizesManager.s15)),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Switch(value: true, onChanged: (value) {}))
                  ],
                ),
                const Text(
                  StringsManger.default_remind,
                  style: TextStyle(
                      fontSize: SizesManager.s20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
                GapsManager.h10,
                const Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Text(StringsManger.morning,
                        style: TextStyle(fontSize: SizesManager.s15)),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Text('08:00'))
                  ],
                ),
                GapsManager.h10,
                const Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Text(StringsManger.afternoon,
                          style: TextStyle(fontSize: SizesManager.s15)),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text('13:00'))
                    ]
                ),
                GapsManager.h10,
                const Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Text(StringsManger.night,
                        style: TextStyle(fontSize: SizesManager.s15)),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Text('18:00'))
                  ],
                ),
                GapsManager.h10,
                const Text(
                  StringsManger.share,
                  style: TextStyle(
                      fontSize: SizesManager.s20,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    const Text(StringsManger.on_share,
                        style: TextStyle(fontSize: SizesManager.s15)),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Switch(value: true, onChanged: (value) {}))
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}