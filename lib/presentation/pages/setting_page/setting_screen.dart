import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notesapp/blocs/bloc_notification/timing_bloc.dart';
import 'package:notesapp/blocs/bloc_theme/theme_bloc.dart';
import 'package:notesapp/models/timing.dart';

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
  String formattedMorningTime = "";
  String formattedAfternoonTime = "";
  String formattedEveningTime = "";

  void _showTimePicker(DateTime time, Function(DateTime) onTimePicked) {
    TimeOfDay initialTime = TimeOfDay(hour: time.hour, minute: time.minute);
    showTimePicker(context: context, initialTime: initialTime)
        .then((pickedTime) {
      if (pickedTime != null) {
        DateTime updateTime = DateTime(time.year, time.month, time.day,
            pickedTime.hour, pickedTime.minute);
        onTimePicked(updateTime);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimingBloc, TimingState>(
        builder: (context, state) {
      DateTime morning = state.morning;
      DateTime afternoon = state.afternoon;
      DateTime evening = state.evening;
      formattedMorningTime = DateFormat("HH:mm").format(morning);
      formattedAfternoonTime = DateFormat("HH:mm").format(afternoon);
      formattedEveningTime = DateFormat("HH:mm").format(evening);
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
                  GapsManager.h20,
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      const Text(
                        StringsManger.show_mode_1,
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: IconSwitch(
                            value: context.read<ThemeBloc>().state ==
                                ThemeMode.dark,
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
                  GapsManager.h20,
                  Text(
                    StringsManger.default_remind,
                    style: TextStyle(
                        fontSize: SizesManager.s25,
                        fontWeight: FontWeight.w400),
                  ),
                  GapsManager.h20,
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      const Text(
                        StringsManger.morning,
                      ),
                      GestureDetector(
                        onTap: () {
                          _showTimePicker(morning, (updatedTime) {
                            setState(() {
                              formattedMorningTime =
                                  DateFormat("HH:mm").format(updatedTime);
                            });
                            var time = Timing(morning: updatedTime);
                            context
                                .read<TimingBloc>()
                                .add(SetMorningTime(notification: time));
                          });
                        },
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(formattedMorningTime)),
                      )
                    ],
                  ),
                  GapsManager.h20,
                  Stack(alignment: Alignment.centerLeft, children: [
                    const Text(
                      StringsManger.afternoon,
                    ),
                    GestureDetector(
                      onTap: () {
                        _showTimePicker(morning, (updatedTime) {
                          setState(() {
                            formattedMorningTime =
                                DateFormat("HH:mm").format(updatedTime);
                          });
                          var time = Timing(afternoon: updatedTime);
                          context
                              .read<TimingBloc>()
                              .add(SetAfternoonTime(notification: time));
                        });
                      },
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(formattedAfternoonTime)),
                    )
                  ]),
                  GapsManager.h20,
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      const Text(
                        StringsManger.night,
                      ),
                      GestureDetector(
                        onTap: () {
                          _showTimePicker(morning, (updatedTime) {
                            setState(() {
                              formattedMorningTime =
                                  DateFormat("HH:mm").format(updatedTime);
                            });
                            var time = Timing(evening: updatedTime);
                            context
                                .read<TimingBloc>()
                                .add(SetEveningTime(notification: time));
                          });
                        },
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(formattedEveningTime)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ));
    });
  }
}
