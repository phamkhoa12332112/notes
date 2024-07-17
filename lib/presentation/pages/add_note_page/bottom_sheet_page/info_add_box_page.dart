import 'package:flutter/cupertino.dart';
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
            text: StringsManger.take_a_photo,
            icon: Icons.photo_camera_outlined),
        ListItem(text: StringsManger.add_pic, icon: Icons.image_outlined),
        ListItem(text: StringsManger.blueprint, icon: Icons.brush_outlined),
        ListItem(text: StringsManger.record, icon: Icons.mic),
        ListItem(text: StringsManger.check_box, icon: Icons.check_box_outlined),
      ],
    );
  }
}