import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/blocs/bloc.export.dart';
import 'package:notesapp/models/task.dart';

import '../../../config/routes/routes.dart';
import '../../../utils/resources/gaps_manager.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../widgets/bottom_sheet_page/info_add_box_page.dart';
import '../../widgets/bottom_sheet_page/info_more_vert_page.dart';
import '../../widgets/bottom_sheet_page/info_notification_add_page.dart';
import '../choose_label_page/choose_label_screen.dart';

class EditNoteScreen extends StatefulWidget {
  final Task task;

  const EditNoteScreen({super.key, required this.task});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late bool? pinNote = widget.task.isPin;
  late String title = widget.task.title;
  late String content = widget.task.content;
  late List<String> labelTask;
  late Map<String, bool> checkList = {};

  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: title);
    contentController = TextEditingController(text: content);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void onTap() {
    setState(() {
      pinNote = !pinNote!;
    });
  }

  Future<void> onLabel() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => ChooseLabelScreen(checkList: checkList)),
    );

    if (result != null && result is Map<String, bool>) {
      setState(() {
        checkList = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.task.labelsList.forEach((label) {
      checkList[label] = true;
    });
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
                        if (widget.task.isStore!) {
                          var task = Task(
                              title: titleController.text,
                              content: contentController.text,
                              isChoose: false,
                              isPin: !pinNote!,
                              isStore: widget.task.isStore,
                              labelsList: const []);
                          context.read<TasksBloc>().add(PinTask(task: task));
                          Navigator.pushNamedAndRemoveUntil(context,
                              RoutesName.saveScreen, (route) => route.isFirst);
                        } else {
                          onTap();
                        }
                      },
                      child: pinNote!
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
                          labelTask = checkList.entries
                              .where((entry) => entry.value)
                              .map((entry) => entry.key.toString())
                              .toList();
                          var task = Task(
                              title: titleController.text,
                              content: contentController.text,
                              isChoose: false,
                              isPin: pinNote,
                              isStore: widget.task.isStore,
                              labelsList: labelTask);
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
                  if (checkList.isNotEmpty)
                    Wrap(
                        spacing: SizesManager.w5,
                        children: List.generate(
                            checkList.length,
                            (index) => Chip(
                                  padding: EdgeInsets.all(SizesManager.p8),
                                  label: Text(
                                    checkList.keys.elementAt(index),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: SizesManager.s15),
                                  ),
                                ))),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade300,
        onPressed: () {
          labelTask = checkList.entries
              .where((entry) => entry.value)
              .map((entry) => entry.key.toString())
              .toList();
          var editedTask = Task(
              title: titleController.text,
              content: contentController.text,
              isPin: pinNote,
              isChoose: false,
              isStore: widget.task.isStore,
              labelsList: labelTask);
          context
              .read<TasksBloc>()
              .add(EditTask(oldTask: widget.task, newTask: editedTask));
          if (!pinNote!) {
            context.read<TasksBloc>().add(RemovePinTask(task: widget.task));
          } else {
            context.read<TasksBloc>().add(RestorePinTask(task: widget.task));
          }
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
                    builder: (ctx) => InfoMoreVertPage(onLabel: onLabel));
              },
              icon: const Icon(Icons.more_vert),
            )
          ],
        ),
      ),
    );
  }
}