import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/presentation/pages/add_note_page/bottom_sheet_page/list_items.dart';
import 'package:notesapp/utils/resources/strings_manager.dart';

class InfoNotificationAddPage extends StatelessWidget {
  const InfoNotificationAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListItem(text: StringsManger.today, icon: Icons.schedule),
        ListItem(text: StringsManger.tomorrow, icon: Icons.schedule),
        ListItem(text: StringsManger.friday_morning, icon: Icons.schedule),
        ListItem(
            text: StringsManger.private_home, icon: Icons.home),
        ListItem(text: StringsManger.workplace, icon: Icons.work),
        ListItem(text: StringsManger.date_and_time, icon: Icons.schedule),
        ListItem(text: StringsManger.location, icon: Icons.location_on)
      ],
    );
  }
}