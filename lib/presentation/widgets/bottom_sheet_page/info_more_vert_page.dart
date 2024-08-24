import 'package:flutter/material.dart';
import 'package:notesapp/config/routes/routes.dart';
import 'package:notesapp/utils/resources/strings_manager.dart';

import 'list_items.dart';

class InfoMoreVertPage extends StatelessWidget {
  const InfoMoreVertPage(
      {super.key,
      required this.onLabel,
      required this.onDelete,
      required this.onDuplicate});

  final VoidCallback onLabel;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListItem(
            textRight: StringsManger.delete_bin,
            icon: Icons.delete_outline,
            onPressed: () => onDelete()),
        ListItem(
            textRight: StringsManger.copy,
            icon: Icons.content_copy,
            onPressed: () => onDuplicate()),
        ListItem(
            textRight: StringsManger.label,
            icon: Icons.label_outline,
            onPressed: onLabel),
        ListItem(
            textRight: StringsManger.help,
            icon: Icons.help_outline,
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.helpScreen);
            })
      ],
    );
  }
}