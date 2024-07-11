import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/routes/routes.dart';
import '../../../utils/resources/gaps_manager.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';


class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => CupertinoAlertDialog(
                                title: const Text(StringsManger.back),
                                content: const Text(
                                    StringsManger.content_dialog),
                                actions: [
                                  CupertinoDialogAction(
                                      child: const Text(StringsManger.no),
                                      onPressed: () =>
                                          Navigator.pop(context)),
                                  CupertinoDialogAction(
                                      child: const Text(StringsManger.yes),
                                      onPressed: () => Navigator.pushNamed(
                                          context, RoutesName.homeScreen))
                                ],
                              ),
                              barrierDismissible: false);
                        },
                        padding: const EdgeInsets.all(SizesManager.p10),
                        icon: const Icon(
                          size: SizesManager.s30,
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.push_pin_outlined),
                      Icon(Icons.notification_add_outlined),
                      Icon(Icons.save_alt),
                    ],
                  ),
                )
              ],
            ),
            GapsManager.h10,
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(left: SizesManager.p10),
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: StringsManger.title,
                        hintStyle: TextStyle(
                            color: Colors.grey, fontSize: SizesManager.s30)),
                  ),
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: StringsManger.noted,
                        hintStyle: TextStyle(color: Colors.grey)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, RoutesName.homeScreen,
              result: [_titleController.text, _contentController.text]);
        },
        elevation: SizesManager.e10,
        child: const Icon(Icons.save),
      ),
      bottomNavigationBar: BottomAppBar(
        height: SizesManager.h60,
        color: Colors.white60,
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_box_outlined),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.palette_outlined),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.text_format_outlined),
                  ),
                  const Text(StringsManger.update_home),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            )
          ],
        ),
      ),
    );
  }
}