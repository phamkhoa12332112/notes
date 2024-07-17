import 'package:flutter/cupertino.dart';
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
        ListItem(text: StringsManger.delete, icon: Icons.delete_outline),
        ListItem(text: StringsManger.copy, icon: Icons.content_copy),
        ListItem(text: StringsManger.send, icon: Icons.share_outlined),
        ListItem(
            text: StringsManger.collaborator, icon: Icons.person_add_outlined),
        ListItem(text: StringsManger.label, icon: Icons.label_outline),
        ListItem(text: StringsManger.help, icon: Icons.help_outline)
      ],
    );
  }
}