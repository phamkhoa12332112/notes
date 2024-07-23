import 'package:flutter/material.dart';
import 'package:notesapp/presentation/pages/add_note_page/bottom_sheet_page/list_items.dart';
import 'package:notesapp/utils/resources/strings_manager.dart';

class InfoMoreVertPage extends StatelessWidget {
  const InfoMoreVertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListItem(
            textRight: StringsManger.delete,
            icon: Icons.delete_outline,
            onPressed: () {}),
        ListItem(
            textRight: StringsManger.copy,
            icon: Icons.content_copy,
            onPressed: () {}),
        ListItem(
            textRight: StringsManger.send,
            icon: Icons.share_outlined,
            onPressed: () {}),
        ListItem(
            textRight: StringsManger.collaborator,
            icon: Icons.person_add_outlined,
            onPressed: () {}),
        ListItem(
            textRight: StringsManger.label,
            icon: Icons.label_outline,
            onPressed: () {}),
        ListItem(
            textRight: StringsManger.help,
            icon: Icons.help_outline,
            onPressed: () {})
      ],
    );
  }
}
