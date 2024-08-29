import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/blocs/bloc_theme/theme_bloc.dart';

import '../../../utils/resources/gaps_manager.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../widgets/switch_theme_mode.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Title(
              color: Colors.black, child: const Text(StringsManger.setting)),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(SizesManager.p18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  StringsManger.show_mode,
                  style: TextStyle(
                      fontSize: SizesManager.s25,
                      fontWeight: FontWeight.w400),
                ),
                GapsManager.h10,
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Text(StringsManger.show_mode_1,
                        style: TextStyle(fontSize: SizesManager.s15)),
                    Align(
                        alignment: Alignment.centerRight,
                        child: IconSwitch(
                          value:
                              context.read<ThemeBloc>().state == ThemeMode.dark,
                          onChanged: (value) {
                            setState(() {
                              context
                                  .read<ThemeBloc>()
                                  .add(ThemeChanged(value));
                            });
                          },
                        ))
                  ],
                ),
                GapsManager.h10,
                Text(
                  StringsManger.default_remind,
                  style: TextStyle(
                      fontSize: SizesManager.s25,
                      fontWeight: FontWeight.w400),
                ),
                GapsManager.h10,
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Text(StringsManger.morning,
                        style: TextStyle(fontSize: SizesManager.s15)),
                    const Align(
                        alignment: Alignment.centerRight, child: Text('08:00'))
                  ],
                ),
                GapsManager.h10,
                Stack(alignment: Alignment.centerLeft, children: [
                  Text(StringsManger.afternoon,
                      style: TextStyle(fontSize: SizesManager.s15)),
                  const Align(
                      alignment: Alignment.centerRight, child: Text('13:00'))
                ]),
                GapsManager.h10,
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Text(StringsManger.night,
                        style: TextStyle(fontSize: SizesManager.s15)),
                    const Align(
                        alignment: Alignment.centerRight, child: Text('18:00'))
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}