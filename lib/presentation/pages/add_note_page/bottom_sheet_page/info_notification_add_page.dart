import 'package:flutter/material.dart';
import 'package:notesapp/presentation/pages/add_note_page/bottom_sheet_page/list_items.dart';
import 'package:notesapp/utils/resources/strings_manager.dart';

import '../../../../config/routes/routes.dart';

class InfoNotificationAddPage extends StatefulWidget {
  const InfoNotificationAddPage({super.key});

  @override
  State<InfoNotificationAddPage> createState() => _InfoNotificationAddPageState();
}

class _InfoNotificationAddPageState extends State<InfoNotificationAddPage> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListItem(
            textRight: StringsManger.today,
            icon: Icons.schedule,
            textLeft: StringsManger.time_today,
            onPressed: () {
              Navigator.popAndPushNamed(
                  context, RoutesName.addNoteScreen,
                  result: [StringsManger.time_today]);
            }),
        ListItem(
            textRight: StringsManger.tomorrow,
            icon: Icons.schedule,
            textLeft: StringsManger.time_tomorrow,
            onPressed: () => Navigator.popAndPushNamed(
                context, RoutesName.addNoteScreen,
                result: [StringsManger.time_tomorrow])),
        ListItem(
            textRight: StringsManger.friday_morning,
            icon: Icons.schedule,
            textLeft: StringsManger.time_friday_morning,
            onPressed: () => Navigator.popAndPushNamed(
                context, RoutesName.addNoteScreen,
                result: [StringsManger.time_friday_morning])),
        ListItem(
            textRight: StringsManger.private_home,
            icon: Icons.home,
            textLeft: StringsManger.address_private_home,
            onPressed: () => Navigator.popAndPushNamed(
                context, RoutesName.addNoteScreen,
                result: [StringsManger.address_private_home])),
        ListItem(
            textRight: StringsManger.workplace,
            icon: Icons.work,
            onPressed: () => Navigator.popAndPushNamed(
                context, RoutesName.addNoteScreen)),
        ListItem(
            textRight: StringsManger.date_and_time,
            icon: Icons.schedule,
            onPressed: () => Navigator.popAndPushNamed(
                context, RoutesName.addNoteScreen)),
        ListItem(
            textRight: StringsManger.location,
            icon: Icons.location_on,
            onPressed: () => Navigator.popAndPushNamed(
                context, RoutesName.addNoteScreen))
      ],
    );
  }
}
