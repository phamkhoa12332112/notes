import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notesapp/blocs/bloc/tasks_bloc.dart';
import 'package:notesapp/models/task.dart';
import 'package:notesapp/presentation/widgets/dialog_box_notification.dart';

import '../../../config/routes/routes.dart';
import '../../../utils/resources/gaps_manager.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../widgets/bottom_sheet_page/info_add_box_page.dart';
import '../../widgets/bottom_sheet_page/info_more_vert_page.dart';
import '../../widgets/bottom_sheet_page/info_notification_add_page.dart';
import '../choose_label_page/choose_label_screen.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  late bool pinNote = false;
  late String title;
  late String content;
  late List<String> labelTask;
  late bool timeOrLocation;
  late Map<String, bool> checkList = {};
  late Map<IconData, Map<String, DateTime>> notificationList = {};
  late DateTime now = DateTime.now();
  String date = '';
  String formattedDate = '';
  String location = '';

  void onTapTime() {
    setState(() {
      timeOrLocation = false;
    });
  }

  void onTapLocation() {
    setState(() {
      timeOrLocation = true;
    });
  }

  void onTap() {
    setState(() {
      pinNote = !pinNote;
    });
  }

  void onDelete() {
    setState(() {
      notificationList.clear();
    });
  }

  void onSave(DateTime updateTime, String locations, bool timeOrLocation) {
    setState(() {
      !timeOrLocation
          ? {
              now = updateTime,
              date =
                  '${StringsManger.day} ${now.day} ${StringsManger.month} ${now.month}',
              formattedDate = DateFormat('HH:mm').format(now),
            }
          : location = locations;
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

  Future<void> onNotification() async {
    final result =
        await showModalBottomSheet<Map<IconData, Map<String, DateTime>>>(
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            context: context,
            builder: (context) => const InfoNotificationAddPage());

    if (result != null) {
      setState(() {
        notificationList = result;
        now = result.values.first.values.first;
        date =
            '${StringsManger.day} ${now.day} ${StringsManger.month} ${now.month}';
        formattedDate = DateFormat('HH:mm').format(now);
        if (notificationList.keys.first != Icons.schedule) {
          timeOrLocation = true;
          location = notificationList.values.first.keys.first;
        } else {
          timeOrLocation = false;
        }
      });
    }
  }

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
                                              onPressed: () =>
                                                  Navigator.pushNamed(context,
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
                      onTap: onTap,
                      child: pinNote
                          ? const Icon(Icons.push_pin)
                          : const Icon(Icons.push_pin_outlined),
                    ),
                    GapsManager.w20,
                    InkWell(
                        child: const Icon(Icons.notification_add_outlined),
                        onTap: () {
                          onNotification();
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
                              labelsList: labelTask,
                              notifications: notificationList);
                          context.read<TasksBloc>().add(StoreTask(task: task));
                          context
                              .read<TasksBloc>()
                              .add(AddLabelTask(task: task));
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
                    minLines: 1,
                    maxLines: 5,
                    style: TextStyle(fontSize: SizesManager.s30),
                    controller: titleController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: StringsManger.title,
                        hintStyle: TextStyle(
                            color: Colors.grey, fontSize: SizesManager.s30)),
                  ),
                  TextField(
                    minLines: 1,
                    maxLines: 10,
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
                      children: checkList.entries
                          .where((entry) => entry.value)
                          .map((entry) => Chip(
                                padding: EdgeInsets.all(SizesManager.p8),
                                label: Text(
                                  entry.key,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: SizesManager.s15),
                                ),
                              ))
                          .toList(),
                    ),
                  if (notificationList.isNotEmpty)
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => DialogBoxNotification(
                                  now: now,
                                  timeOrLocation: timeOrLocation,
                                  resultLocation: location,
                                  onDelete: onDelete,
                                  onSave: onSave,
                                  onTapTime: onTapTime,
                                  onTapLocation: onTapLocation,
                                ));
                      },
                      child: Wrap(spacing: SizesManager.w5, children: [
                        Chip(
                            padding: EdgeInsets.all(SizesManager.p8),
                            avatar: timeOrLocation
                                ? (location != StringsManger.private_home)
                                    ? const Icon(Icons.work)
                                    : const Icon(Icons.home)
                                : const Icon(Icons.schedule),
                            label: timeOrLocation
                                ? Text(
                                    location,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: SizesManager.s15),
                                  )
                                : Text(
                                    '$date, $formattedDate',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: SizesManager.s15),
                                  ))
                      ]),
                    )
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
          var task = Task(
              title: titleController.text,
              content: contentController.text,
              isChoose: false,
              isPin: pinNote,
              labelsList: labelTask,
              notifications: notificationList);
          pinNote
              ? context
                  .read<TasksBloc>()
                  .add(PinTask(oldTask: task, newTask: task))
              : context.read<TasksBloc>().add(AddTask(task: task));
          context.read<TasksBloc>().add(AddLabelTask(task: task));
          Navigator.popAndPushNamed(context, RoutesName.homeScreen);
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