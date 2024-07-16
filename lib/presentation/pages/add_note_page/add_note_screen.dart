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
                        padding: EdgeInsets.all(SizesManager.p10),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.push_pin_outlined)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notification_add_outlined)),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.save_alt)),
                    ],
                  ),
                )
              ],
            ),
            GapsManager.h10,
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(left: SizesManager.p10),
                children: [
                  TextField(
                    style: TextStyle(fontSize: SizesManager.s15),
                    controller: _titleController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: StringsManger.title,
                        hintStyle: TextStyle(
                            color: Colors.grey, fontSize: SizesManager.s15)),
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
                  PopupMenuButton(
                    icon: const Icon(Icons.add_box_outlined),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        child: Text('title1'),
                        value: 'title1',
                      ),
                      const PopupMenuItem(
                        child: Text('title2'),
                        value: 'title2',
                      )
                    ],
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
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  child: Text('title1'),
                  value: 'title1',
                ),
                const PopupMenuItem(
                  child: Text('title2'),
                  value: 'title2',
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
