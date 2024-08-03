import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/blocs/bloc/tasks_bloc.dart';
import 'package:notesapp/models/task.dart';

import '../../../config/routes/routes.dart';
import '../../../utils/resources/gaps_manager.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../widgets/bottom_sheet_page/info_add_box_page.dart';
import '../../widgets/bottom_sheet_page/info_more_vert_page.dart';
import '../../widgets/bottom_sheet_page/info_notification_add_page.dart';

class EditNoteScreen extends StatefulWidget {
  final Task task;

  const EditNoteScreen({super.key, required this.task});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late bool pinNote = false;

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController =
        TextEditingController(text: widget.task.title);
    final TextEditingController contentController =
        TextEditingController(text: widget.task.content);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Row(
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
                                              child:
                                                  const Text(StringsManger.no),
                                              onPressed: () =>
                                                  Navigator.pop(context)),
                                          CupertinoDialogAction(
                                              child:
                                                  const Text(StringsManger.yes),
                                              onPressed: () => widget
                                                      .task.isStore!
                                                  ? Navigator
                                                      .pushNamedAndRemoveUntil(
                                                      context,
                                                      RoutesName.saveScreen,
                                                      (route) => route.isFirst,
                                                    )
                                                  : Navigator.pushNamed(context,
                                                      RoutesName.homeScreen))
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
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        var task = Task(
                            title: titleController.text,
                            content: contentController.text,
                            isChoose: false,
                            isPin: !pinNote,
                            isStore: widget.task.isStore);
                        context.read<TasksBloc>().add(PinTask(task: task));
                        widget.task.isStore!
                            ? Navigator.pushNamedAndRemoveUntil(context,
                                RoutesName.saveScreen, (route) => route.isFirst)
                            : Navigator.pop(context);
                      },
                      child: pinNote
                          ? const Icon(Icons.push_pin)
                          : const Icon(Icons.push_pin_outlined),
                    ),
                    GapsManager.w20,
                    InkWell(
                        child: const Icon(Icons.notification_add_outlined),
                        onTap: () {
                          showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              context: context,
                              builder: (context) =>
                                  const InfoNotificationAddPage());
                        }),
                    GapsManager.w20,
                    InkWell(
                        onTap: () {
                          var task = Task(
                              title: titleController.text,
                              content: contentController.text,
                              isChoose: false,
                              isStore: widget.task.isStore);
                          if (!widget.task.isStore!) {
                            context
                                .read<TasksBloc>()
                                .add(StoreTask(task: task));
                          }
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.save_alt)),
                  ],
                )
              ],
            ),
            GapsManager.h10,
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(left: SizesManager.p10),
                children: [
                  TextField(
                    style: TextStyle(fontSize: SizesManager.s30),
                    controller: titleController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: StringsManger.title,
                        hintStyle: TextStyle(
                            color: Colors.grey, fontSize: SizesManager.s30)),
                  ),
                  TextField(
                    style: TextStyle(fontSize: SizesManager.s20),
                    controller: contentController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: StringsManger.noted,
                        hintStyle: TextStyle(
                            color: Colors.grey, fontSize: SizesManager.s20)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var editedTask = Task(
              title: titleController.text,
              content: contentController.text,
              isChoose: false,
              isStore: widget.task.isStore);
          context
              .read<TasksBloc>()
              .add(EditTask(oldTask: widget.task, newTask: editedTask));
          widget.task.isStore!
              ? Navigator.pushNamedAndRemoveUntil(
                  context, RoutesName.saveScreen, (route) => route.isFirst)
              : Navigator.pushNamed(context, RoutesName.homeScreen);
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
                    onPressed: () {
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                          context: context,
                          builder: (ctx) => const InfoAddBoxPage());
                    },
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
                  Text(
                    StringsManger.update_home,
                    style: TextStyle(fontSize: SizesManager.s15),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                    context: context,
                    builder: (ctx) => const InfoMoreVertPage());
              },
              icon: const Icon(Icons.more_vert),
            )
          ],
        ),
      ),
    );
  }
}