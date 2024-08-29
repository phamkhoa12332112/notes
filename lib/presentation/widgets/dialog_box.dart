import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/utils/resources/gaps_manager.dart';
import 'package:notesapp/utils/resources/sizes_manager.dart';
import 'package:notesapp/utils/resources/strings_manager.dart';

import '../../blocs/bloc_task/tasks_bloc.dart';
import '../pages/label_notes_page/label_notes_screen.dart';

class DialogBox extends StatelessWidget {
  DialogBox({super.key, required this.label})
      : controller = TextEditingController(text: label);

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade100,
      content: SizedBox(
        height: SizesManager.h120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              color: Colors.white,
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            GapsManager.h10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Background color
                    ),
                    onPressed: () {
                      context.read<TasksBloc>().add(EditLabel(
                          oldLabel: label, newLabel: controller.text));
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => LabelNote(
                                    label: controller.text,
                                  )),
                          (route) => route.isCurrent);
                    },
                    child: const Text(StringsManger.save_button)),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Background color
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(StringsManger.cancel_button)),
              ],
            )
          ],
        ),
      ),
    );
  }
}