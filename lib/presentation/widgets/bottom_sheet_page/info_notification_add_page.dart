import 'package:flutter/material.dart';
import 'package:notesapp/utils/resources/strings_manager.dart';

import '../list_item.dart';

class InfoNotificationAddPage extends StatefulWidget {
  const InfoNotificationAddPage({super.key});

  @override
  State<InfoNotificationAddPage> createState() =>
      _InfoNotificationAddPageState();
}

class _InfoNotificationAddPageState extends State<InfoNotificationAddPage> {
  late DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListItem(
            textRight: StringsManger.today_notification,
            icon: Icons.schedule,
            textLeft: StringsManger.time_today,
            onPressed: () {
              DateTime resultTime =
                  DateTime(now.year, now.month, now.day, 18, 0);
              Navigator.pop(context, {
                Icons.schedule: {StringsManger.today: resultTime}
              });
            }),
        ListItem(
            textRight: StringsManger.tomorrow_notification,
            icon: Icons.schedule,
            textLeft: StringsManger.time_tomorrow,
            onPressed: () {
              now = now.add(const Duration(days: 1));
              DateTime resultTime =
                  DateTime(now.year, now.month, now.day, 8, 0);
              String resultText =
                  '${StringsManger.day} ${resultTime.day} ${StringsManger.month} ${resultTime.month}';
              Navigator.pop(context, {
                Icons.schedule: {resultText: resultTime}
              });
            }),
        ListItem(
            textRight: StringsManger.friday_morning,
            icon: Icons.schedule,
            textLeft: StringsManger.time_friday_morning,
            onPressed: () {
              int currentWeekday = now.weekday;
              int daysUntilFriday = (DateTime.friday - currentWeekday + 7) % 7;
              if (daysUntilFriday == 0) {
                daysUntilFriday = 7;
              }
              DateTime nextFriday = now.add(Duration(days: daysUntilFriday));
              DateTime resultTime = DateTime(
                  nextFriday.year, nextFriday.month, nextFriday.day, 8, 0);
              String resultText =
                  '${StringsManger.day} ${resultTime.day} ${StringsManger.month} ${resultTime.month}';
              Navigator.pop(context, {
                Icons.schedule: {resultText: resultTime}
              });
            }),
        ListItem(
            textRight: StringsManger.private_home,
            icon: Icons.home,
            onPressed: () => Navigator.pop(context, {
                  Icons.home: {StringsManger.private_home: now}
                })),
        ListItem(
            textRight: StringsManger.workplace,
            icon: Icons.work,
            onPressed: () => Navigator.pop(context, {
                  Icons.work: {StringsManger.workplace: now}
                })),
        ListItem(
            textRight: StringsManger.date_and_time,
            icon: Icons.schedule,
            onPressed: () => Navigator.pop(context, {
                  Icons.schedule: {StringsManger.date_and_time: now}
                })),
      ],
    );
  }
}