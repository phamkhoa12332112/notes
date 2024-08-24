import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:notesapp/blocs/bloc.export.dart';
import 'package:notesapp/models/task.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;

import '../../../config/routes/routes.dart';
import '../../../models/drawing_point.dart';
import '../../../utils/resources/gaps_manager.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../drawing_room_page/drawing_room_screen.dart';
import '../../widgets/bottom_sheet_page/info_add_box_page.dart';
import '../../widgets/bottom_sheet_page/info_more_vert_page.dart';
import '../../widgets/bottom_sheet_page/info_notification_add_page.dart';
import '../../widgets/dialog_box_notification.dart';
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
  late TextEditingController titleController;
  late TextEditingController contentController;

  // update editing note
  late bool timeOrLocation;
  late DateTime now;
  String date = '';
  String formattedDate = '';
  String location = '';
  String formattedEditedTime = "";
  late Map<IconData, Map<String, DateTime>> notificationList;
  late Map<IconData, Map<String, DateTime>> notification;
  late List<String> labelTask;
  late Map<String, bool> checkList = {};
  late DateTime editedTime = DateTime.now();

  // Image
  late List<File>? selectedImage = widget.task.selectedImage;

  // Record
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isRecording = false;
  bool isPlaying = false;
  late String? recordingPath = widget.task.recordingPath;

  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  // Paint
  late List<DrawingPoint>? drawingPoint = widget.task.drawingPoint;

  // Check box
  final TextEditingController checkBoxController = TextEditingController();
  late bool checkBox = widget.task.checkBoxList!.isNotEmpty ? true : false;
  late Map<String, bool>? checkBoxList = widget.task.checkBoxList;

  @override
  void initState() {
    super.initState();
    formattedEditedTime = widget.task.editedTime ?? "";
    labelTask = widget.task.labelsList;
    widget.task.labelsList.forEach((label) {
      checkList[label] = true;
    });
    notificationList = widget.task.notifications;
    notification = widget.task.notifications;
    if (widget.task.notifications.isNotEmpty) {
      timeOrLocation = (widget.task.notifications.keys.first == Icons.schedule)
          ? false
          : true;
      now = widget.task.notifications.values.first.values.first;
      date =
          '${StringsManger.day} ${now.day} ${StringsManger.month} ${now.month}';
      formattedDate = DateFormat('HH:mm').format(now);
      location = widget.task.notifications.values.first.keys.first;
    }
    titleController = TextEditingController(text: title);
    contentController = TextEditingController(text: content);

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  String formatTime(int second) {
    return '${(Duration(seconds: second))}'.split('.')[0].padLeft(8, '0');
  }

  void onDeletePainting() {
    setState(() {
      drawingPoint?.clear();
    });
  }

  void onRecord() {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (_) => StatefulBuilder(builder: (context, dialogState) {
              return Center(
                child: GestureDetector(
                  onTap: () async {
                    if (isRecording) {
                      String? filePath = await audioRecorder.stop();
                      await audioPlayer.setSourceUrl(filePath!);

                      final audioDuration = await audioPlayer.getDuration();
                      dialogState(() {
                        isRecording = false;
                      });
                      setState(() {
                        recordingPath = filePath;
                        if (audioDuration != null) {
                          duration = Duration(seconds: audioDuration.inSeconds);
                          position = Duration.zero;
                        }
                        onEditedTime();
                        Navigator.pop(context);
                      });
                    } else {
                      if (await audioRecorder.hasPermission()) {
                        final Directory appDocumentsDir =
                            await getApplicationDocumentsDirectory();
                        final String filePath =
                            p.join(appDocumentsDir.path, 'recording.wav');
                        await audioRecorder.start(const RecordConfig(),
                            path: filePath);
                        dialogState(() {
                          isRecording = true;
                        });
                        setState(() {
                          recordingPath = "";
                        });
                      }
                    }
                  },
                  child: Container(
                    width: SizesManager.w100, // Width of the circle
                    height: SizesManager.h120, // Height of the circle
                    decoration: BoxDecoration(
                      color: isRecording ? Colors.red : Colors.white,
                      // Background color of the circle
                      shape: BoxShape.circle, // Make the container circular
                    ),
                    child: Icon(
                      isRecording ? Icons.stop : Icons.mic,
                      color: isRecording ? Colors.white : Colors.black,
                      // Color of the icon
                      size: SizesManager.s50, // Size of the icon
                    ),
                  ),
                ),
              );
            }));
  }

  void onCheckBox() {
    setState(() {
      checkBox = !checkBox;
      Navigator.pop(context);
    });
  }

  void onEditedTime() {
    setState(() {
      editedTime = DateTime.now();
      formattedEditedTime = DateFormat("HH:mm").format(editedTime);
    });
  }

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

  void onDelete() {
    setState(() {
      onEditedTime();
      notificationList.clear();
    });
  }

  void onSave(DateTime updateTime, String locations, bool timeOrLocation) {
    onEditedTime();
    setState(() {
      IconData icon;
      !timeOrLocation
          ? {
              icon = Icons.schedule,
              now = updateTime,
              date =
                  '${StringsManger.day} ${now.day} ${StringsManger.month} ${now.month}',
              formattedDate = DateFormat('HH:mm').format(now),
            }
          : {
              icon = (location == StringsManger.private_home)
                  ? Icons.home
                  : Icons.work,
              location = locations
            };
      notificationList = {
        icon: {location: updateTime}
      };
    });
  }

  void onTap() {
    setState(() {
      pinNote = !pinNote!;
    });
  }

  Future<void> onPaint() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => DrawingRoomScreen(
              drawingPoint: drawingPoint!, onDeletePainting: onDeletePainting)),
    );

    if (result != null) {
      onEditedTime();
      setState(() {
        drawingPoint = result;
      });
    }
  }

  Future pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {
      selectedImage!.add(File(returnedImage.path));
    });
  }

  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      selectedImage!.add(File(returnedImage.path));
    });
  }

  Future<void> onLabel() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => ChooseLabelScreen(checkList: checkList)),
    );

    if (result != null && result is Map<String, bool>) {
      onEditedTime();
      setState(() {
        checkList = result;
        formattedEditedTime = DateFormat("HH:mm").format(editedTime);
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
      onEditedTime();
      setState(() {
        if (result.values.first.keys.first == StringsManger.date_and_time) {
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
        }
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
                                            onPressed: () => {
                                              Navigator.pop(context),
                                              Navigator.pop(context)
                                            },
                                          )
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
                              editedTime: formattedEditedTime,
                              labelsList: labelTask,
                              notifications: notificationList,
                              selectedImage: selectedImage,
                              recordingPath: recordingPath,
                              drawingPoint: drawingPoint,
                              checkBoxList: checkBoxList);
                          setState(() {
                            audioRecorder.dispose();
                            audioPlayer.dispose();
                          });
                          context.read<TasksBloc>().add(
                              PinTask(oldTask: widget.task, newTask: task));
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
                              isPin: pinNote,
                              isStore: widget.task.isStore,
                              editedTime: formattedEditedTime,
                              labelsList: labelTask,
                              notifications: notificationList,
                              checkBoxList: checkBoxList,
                              drawingPoint: drawingPoint,
                              recordingPath: recordingPath,
                              selectedImage: selectedImage);
                          if (!widget.task.isStore!) {
                            context
                                .read<TasksBloc>()
                                .add(StoreTask(task: task));
                          }
                          setState(() {
                            audioRecorder.dispose();
                            audioPlayer.dispose();
                          });
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
                    onChanged: (_) {
                      onEditedTime();
                    },
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
                    onChanged: (_) {
                      onEditedTime();
                    },
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
                  if (checkBox)
                    Column(
                      children: [
                        Column(
                          children: checkBoxList!.entries
                              .where((entry) =>
                                  !entry.value) // Filter for true values
                              .map((entry) => Row(
                                    children: [
                                      GapsManager.w32,
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              checkBoxList![entry.key] =
                                                  true; // Set value to true
                                            });
                                          },
                                          child: const Icon(
                                              Icons.check_box_outline_blank)),
                                      GapsManager.w10,
                                      Expanded(
                                        child: Text(
                                          entry.key,
                                          style: TextStyle(
                                              fontSize: SizesManager.s20),
                                        ),
                                      ),
                                      GapsManager.w10,
                                      IconButton(
                                        icon: const Icon(Icons.cancel_outlined),
                                        onPressed: () {
                                          setState(() {
                                            checkBoxList!.remove(entry.key);
                                          });
                                        },
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.drag_indicator),
                            GapsManager.w10,
                            const Icon(Icons.check_box_outline_blank),
                            GapsManager.w10,
                            Expanded(
                                child: TextField(
                              style: TextStyle(fontSize: SizesManager.s20),
                              controller: checkBoxController,
                            )),
                            GapsManager.w10,
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    checkBoxList![checkBoxController.text] =
                                        false;
                                    checkBoxController.clear();
                                  });
                                },
                                child: const Icon(Icons.done)),
                            GapsManager.w10,
                          ],
                        ),
                        GapsManager.h10,
                        Column(
                          children: checkBoxList!.entries
                              .where((entry) =>
                                  entry.value) // Filter for true values
                              .map((entry) => Row(
                                    children: [
                                      GapsManager.w32,
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              checkBoxList![entry.key] = false;
                                            });
                                          },
                                          child: const Icon(Icons.check_box)),
                                      GapsManager.w10,
                                      Expanded(
                                        child: Text(
                                          entry.key,
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontSize: SizesManager.s20,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                      GapsManager.w10,
                                      IconButton(
                                        icon: const Icon(Icons.cancel_outlined),
                                        onPressed: () {
                                          setState(() {
                                            checkBoxList!.remove(entry.key);
                                          });
                                        },
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  GapsManager.h10,
                  if (checkList.isNotEmpty)
                    GestureDetector(
                      onTap: () => onLabel(),
                      child: Wrap(
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
                    ),
                  GapsManager.h10,
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
                    ),
                  GapsManager.h10,
                  if (drawingPoint!.isNotEmpty)
                    GestureDetector(
                      onTap: onPaint, // Open the drawing screen again
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Chip(
                          labelStyle: TextStyle(fontSize: SizesManager.s15),
                          color: WidgetStateProperty.all(Colors.grey.shade200),
                          avatar: Icon(
                            Icons.image_outlined,
                            size: SizesManager.s20,
                          ),
                          label: const Text(StringsManger.painting),
                        ),
                      ),
                    ),
                  GapsManager.h20,
                  if (selectedImage!.isNotEmpty)
                    SizedBox(
                      height: SizesManager.h260,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: SizesManager.crossAxis1,
                        ),
                        itemCount: selectedImage!.length,
                        itemBuilder: (context, index) => Image.file(
                          selectedImage![index],
                          height: SizesManager.h260,
                          width: SizesManager.w150,
                        ),
                        shrinkWrap: true,
                      ),
                    ),
                  GapsManager.h20,
                  if (recordingPath!.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(right: SizesManager.m10),
                      color: Colors.grey.shade400,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GapsManager.w10,
                          InkWell(
                            onTap: () async {
                              if (isPlaying) {
                                audioPlayer.pause();
                              } else {
                                var urlSource =
                                    DeviceFileSource(recordingPath!);
                                audioPlayer.play(urlSource);
                              }
                            },
                            child: isPlaying
                                ? const Icon(Icons.pause)
                                : const Icon(Icons.play_circle_outline),
                          ),
                          Expanded(
                            child: Slider(
                              min: 0,
                              max: duration.inSeconds.toDouble(),
                              value: position.inSeconds.toDouble(),
                              onChanged: (value) {
                                final position =
                                    Duration(seconds: value.toInt());
                                audioPlayer.seek(position);
                                audioPlayer.resume();
                              },
                            ),
                          ),
                          Text(formatTime((duration - position).inSeconds)),
                          GapsManager.w10,
                          InkWell(
                              onTap: () {
                                setState(() {
                                  recordingPath = null;
                                });
                              },
                              child: const Icon(Icons.delete_outline)),
                          GapsManager.w10,
                        ],
                      ),
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
          var editedTask = Task(
              title: titleController.text,
              content: contentController.text,
              isPin: pinNote,
              isChoose: false,
              isStore: widget.task.isStore,
              editedTime: formattedEditedTime,
              labelsList: labelTask,
              notifications: notificationList,
              checkBoxList: checkBoxList,
              drawingPoint: drawingPoint,
              recordingPath: recordingPath,
              selectedImage: selectedImage);
          context
              .read<TasksBloc>()
              .add(EditTask(oldTask: widget.task, newTask: editedTask));
          if (!pinNote!) {
            context.read<TasksBloc>().add(RemovePinTask(task: widget.task));
          } else {
            context.read<TasksBloc>().add(RestorePinTask(task: widget.task));
          }
          context.read<TasksBloc>().add(AddLabelTask(task: editedTask));
          Navigator.pop(context);
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
                          builder: (ctx) => InfoAddBoxPage(
                              onGallery: pickImageFromGallery,
                              onCamera: pickImageFromCamera,
                              onCheckBox: onCheckBox,
                              onRecord: onRecord,
                              onPaint: onPaint));
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
                    formattedEditedTime.isNotEmpty
                        ? (notification.isNotEmpty)
                            ? (editedTime.day ==
                                        notification
                                            .values.first.values.first.day &&
                                    editedTime.month ==
                                        notification
                                            .values.first.values.first.month)
                                ? "${StringsManger.update_home} $formattedEditedTime"
                                : "${StringsManger.update_home} ${StringsManger.day} ${notification.values.first.values.first.day} ${StringsManger.month} ${notification.values.first.values.first.month}"
                            : "${StringsManger.update_home} $formattedEditedTime"
                        : "",
                    style: TextStyle(fontSize: SizesManager.s12),
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
            ),
          ],
        ),
      ),
    );
  }
}