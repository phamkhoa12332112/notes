import 'package:flutter/material.dart';
import 'package:notesapp/utils/resources/strings_manager.dart';

import '../list_item.dart';

class InfoAddBoxPage extends StatelessWidget {
  const InfoAddBoxPage(
      {super.key,
      required this.onGallery,
      required this.onCamera,
      required this.onCheckBox,
      required this.onRecord,
      required this.onPaint});

  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onCheckBox;
  final VoidCallback onRecord;
  final VoidCallback onPaint;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListItem(
          textRight: StringsManger.take_a_photo,
          icon: Icons.photo_camera_outlined,
          onPressed: onCamera,
        ),
        ListItem(
          textRight: StringsManger.add_pic,
          icon: Icons.image_outlined,
          onPressed: onGallery,
        ),
        ListItem(
          textRight: StringsManger.blueprint,
          icon: Icons.brush_outlined,
          onPressed: onPaint,
        ),
        ListItem(
          textRight: StringsManger.record,
          icon: Icons.mic,
          onPressed: onRecord,
        ),
        ListItem(
          textRight: StringsManger.check_box,
          icon: Icons.check_box_outlined,
          onPressed: onCheckBox,
        ),
      ],
    );
  }
}