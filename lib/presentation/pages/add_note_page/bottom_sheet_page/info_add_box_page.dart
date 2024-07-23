import 'package:flutter/material.dart';
import 'package:notesapp/presentation/pages/add_note_page/bottom_sheet_page/list_items.dart';
import 'package:notesapp/utils/resources/strings_manager.dart';

class InfoAddBoxPage extends StatelessWidget {
  const InfoAddBoxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListItem(
            textRight: StringsManger.take_a_photo,
            icon: Icons.photo_camera_outlined,
            onPressed: () {}),
        ListItem(
            textRight: StringsManger.add_pic,
            icon: Icons.image_outlined,
            onPressed: () {}),
        ListItem(
            textRight: StringsManger.blueprint,
            icon: Icons.brush_outlined,
            onPressed: () {}),
        ListItem(
            textRight: StringsManger.record, icon: Icons.mic, onPressed: () {}),
        ListItem(
            textRight: StringsManger.check_box,
            icon: Icons.check_box_outlined,
            onPressed: () {}),
      ],
    );
  }
}
