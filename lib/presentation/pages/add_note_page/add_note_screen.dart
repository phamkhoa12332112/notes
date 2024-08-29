import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:notesapp/models/task.dart';
import 'package:notesapp/presentation/widgets/dialog_box_notification.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;

import '../../../blocs/bloc_task/tasks_bloc.dart';
import '../../../config/routes/routes.dart';
import '../../../models/drawing_point.dart';
import '../../../utils/resources/gaps_manager.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../drawing_room_page/drawing_room_screen.dart';
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
  final QuillController quillController = QuillController.basic();
  final FocusNode focusNode = FocusNode();
  late bool pinNote = false;
  late String title;
  late String content;
  late List<String> labelTask = [];
  late bool timeOrLocation;
  bool isFormating = false;
  late Map<IconData, Map<String, DateTime>> notificationList = {};

  // Color background
  Color? colorBackground;
  var availableColor = [
    Colors.white,
    Colors.red,
    Colors.deepOrange,
    Colors.amber,
    Colors.yellow,
    Colors.blue,
    Colors.cyan,
    Colors.green,
    Colors.lightGreenAccent,
    Colors.brown,
    Colors.deepPurple,
    Colors.pink,
  ];

  // update editing note
  late Map<String, bool> checkList = {};
  late DateTime editedTime = DateTime.now();
  final DateTime checkEdit = DateTime.now();
  String formattedEditedTime = "";
  late DateTime now = DateTime.now();
  String date = '';
  String formattedDate = '';
  String location = '';
  String durationNotification = StringsManger.no_duration;

  // Image
  List<File> selectedImage = [];

  // CheckBox
  final TextEditingController checkBoxController = TextEditingController();
  bool checkBox = false;
  Map<String, bool> checkBoxList = {};

  // Record
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isRecording = false;
  bool isPlaying = false;
  String? recordingPath;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  // Paint
  List<DrawingPoint> drawingPoint = [];

  @override
  void initState() {
    super.initState();

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

    quillController.addListener(() {
      onEditedTime();
    });
  }

  @override
  void dispose() {
    quillController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  String formatTime(int second) {
    return '${(Duration(seconds: second))}'.split('.')[0].padLeft(8, '0');
  }

  void onFormating() {
    setState(() {
      isFormating = !isFormating;
    });
  }

  void onDeletePainting() {
    setState(() {
      drawingPoint.clear();
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
                          recordingPath = null;
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

  void onTap() {
    setState(() {
      pinNote = !pinNote;
    });
  }

  void onDeleteNotification() {
    setState(() {
      onEditedTime();
      notificationList.clear();
    });
  }

  void onDeleteNote() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.homeScreen,
      (route) => route.isFirst,
    );
  }

  void onDuplicateNote() {
    var task = Task(
        title: titleController.text,
        content: jsonEncode(quillController.document.toDelta().toJson()),
        isChoose: false,
        isPin: pinNote,
        editedTime: formattedEditedTime,
        labelsList: labelTask,
        notifications: notificationList,
        duration: durationNotification,
        checkBoxList: checkBoxList,
        drawingPoint: drawingPoint,
        recordingPath: recordingPath,
        selectedImage: selectedImage);
    if (pinNote) {
      context.read<TasksBloc>().add(PinTask(oldTask: task, newTask: task));
    } else {
      context.read<TasksBloc>().add(DuplicateNote(task: task));
    }
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesName.homeScreen,
      (route) => route.isFirst,
    );
  }

  void onSave(DateTime updateTime, String locations, bool timeOrLocation,
      String? duration) {
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
              durationNotification = duration!
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

  void setColorBackground() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      context: context,
      builder: (context) => SizedBox(
        height: SizesManager.h60,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: availableColor.length,
          itemBuilder: (context, index) => Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    colorBackground = availableColor[index];
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  width: SizesManager.w70,
                  height: SizesManager.h120,
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorBackground == availableColor[index]
                          ? Colors.blue
                          : Colors.black,
                      width: SizesManager.w1,
                    ),
                    color: availableColor[index],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              if (colorBackground == availableColor[index])
                Icon(
                  Icons.done,
                  color: Colors.blue,
                  size: SizesManager.s30,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void onAddBox() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        context: context,
        builder: (ctx) => InfoAddBoxPage(
            onCamera: pickImageFromCamera,
            onGallery: pickImageFromGallery,
            onCheckBox: onCheckBox,
            onRecord: onRecord,
            onPaint: onPaint));
  }

  void onMoreVert() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        context: context,
        builder: (ctx) => InfoMoreVertPage(
              onLabel: onLabel,
              onDelete: onDeleteNote,
              onDuplicate: onDuplicateNote,
            ));
  }

  Widget onFormatText() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: QuillToolbar.simple(
                controller: quillController,
                configurations: const QuillSimpleToolbarConfigurations(
                    showAlignmentButtons: false,
                    showBackgroundColorButton: false,
                    showCenterAlignment: false,
                    showClipboardCopy: false,
                    showClipboardCut: false,
                    showClipboardPaste: false,
                    showCodeBlock: false,
                    showDirection: false,
                    showDividers: false,
                    showIndent: false,
                    showInlineCode: false,
                    showJustifyAlignment: false,
                    showLeftAlignment: false,
                    showLineHeightButton: false,
                    showLink: false,
                    showListBullets: false,
                    showListCheck: false,
                    showListNumbers: false,
                    showQuote: false,
                    showRedo: false,
                    showRightAlignment: false,
                    showSearchButton: false,
                    showSmallButton: false,
                    showStrikeThrough: false,
                    showSubscript: false,
                    showSuperscript: false,
                    showUndo: false)),
          ),
        ),
        GapsManager.w10,
        VerticalDivider(
          endIndent: SizesManager.w1,
          width: SizesManager.w1,
          thickness: SizesManager.w1,
        ),
        GapsManager.w10,
        Padding(
          padding: EdgeInsets.only(top: SizesManager.p5),
          child: InkWell(
              onTap: () {
                onFormating();
              },
              child: const Icon(Icons.cancel_outlined)),
        )
      ],
    );
  }

  //----------------------------------------------------

// get path from camera
  Future pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {
      selectedImage.add(File(returnedImage.path));
    });
  }

  // get path from gallery
  Future pickImageFromGallery() async {
    final List<XFile> selectedXFileImages =
        await ImagePicker().pickMultiImage();
    if (selectedXFileImages.isEmpty) return;
    setState(() {
      selectedImage.addAll(
          selectedXFileImages.map((xFile) => File(xFile.path)).toList());
    });
  }

  // get value of LabelScreen
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
      });
    }
  }

  // get value of DrawingScreen
  Future<void> onPaint() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => DrawingRoomScreen(
              drawingPoint: drawingPoint, onDeletePainting: onDeletePainting)),
    );

    if (result != null) {
      onEditedTime();
      setState(() {
        drawingPoint = result;
      });
    }
  }

  // get value of NotificationScreen
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
                    onDelete: onDeleteNotification,
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
      backgroundColor:
          colorBackground ?? Theme.of(context).scaffoldBackgroundColor,
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
                              content: jsonEncode(
                                  quillController.document.toDelta().toJson()),
                              isChoose: false,
                              duration: durationNotification,
                              color: colorBackground,
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
                          context
                              .read<TasksBloc>()
                              .add(StoreTask(oldTask: task, newTask: task));
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
                    style: TextStyle(fontSize: SizesManager.s35),
                    controller: titleController,
                    decoration: InputDecoration(
                        suffixIcon: checkBox
                            ? PopupMenuButton(
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                          onTap: () {
                                            onCheckBox();
                                          },
                                          child: const Text(
                                              StringsManger.disappearCheckBox))
                                    ])
                            : null,
                        border: InputBorder.none,
                        hintText: StringsManger.title,
                        hintStyle: TextStyle(
                            color: Colors.grey, fontSize: SizesManager.s30)),
                  ),
                  Stack(
                    children: [
                      QuillEditor.basic(
                        controller: quillController,
                        focusNode: focusNode,
                        configurations: QuillEditorConfigurations(
                          customStyles: DefaultStyles(
                            paragraph: DefaultTextBlockStyle(
                                TextStyle(
                                  color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color ??
                                      Colors.black,
                                  fontSize: SizesManager.s25,
                                ),
                                const HorizontalSpacing(0, 0),
                                const VerticalSpacing(0, 0),
                                const VerticalSpacing(0, 0),
                                const BoxDecoration()),
                          ),
                        ),
                      ),
                      if (quillController.document.isEmpty())
                        GestureDetector(
                          onTap: () {
                            FocusScope.of(context).requestFocus(focusNode);
                          },
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              StringsManger.noted,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: SizesManager.s20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (checkBox == true)
                    Column(
                      children: [
                        Column(
                          children: checkBoxList.entries
                              .where((entry) =>
                                  !entry.value) // Filter for true values
                              .map((entry) => Row(
                                    children: [
                                      GapsManager.w32,
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              checkBoxList[entry.key] =
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
                                            checkBoxList.remove(entry.key);
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
                                    checkBoxList[checkBoxController.text] =
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
                          children: checkBoxList.entries
                              .where((entry) =>
                                  entry.value) // Filter for true values
                              .map((entry) => Row(
                                    children: [
                                      GapsManager.w32,
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              checkBoxList[entry.key] = false;
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
                                            checkBoxList.remove(entry.key);
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
                    Wrap(spacing: SizesManager.w5, children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (_) => DialogBoxNotification(
                                    now: now,
                                    timeOrLocation: timeOrLocation,
                                    resultLocation: location,
                                    onDelete: onDeleteNotification,
                                    duration: durationNotification,
                                    onSave: onSave,
                                    onTapTime: onTapTime,
                                    onTapLocation: onTapLocation,
                                  ));
                        },
                        child: Chip(
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
                                  )),
                      )
                    ]),
                  GapsManager.h10,
                  if (drawingPoint.isNotEmpty)
                    GestureDetector(
                      onTap: onPaint,
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
                  if (selectedImage.isNotEmpty)
                    SizedBox(
                      height: SizesManager.h260,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: SizesManager.crossAxis1,
                        ),
                        itemCount: selectedImage.length,
                        itemBuilder: (context, index) =>
                            Stack(fit: StackFit.passthrough, children: [
                          Image.file(
                            selectedImage[index],
                            height: SizesManager.h260,
                            width: SizesManager.w150,
                          ),
                          Align(
                            alignment: AlignmentDirectional.bottomCenter,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedImage.remove(selectedImage[index]);
                                });
                              },
                              child: Icon(
                                  size: SizesManager.s25,
                                  color: Colors.black45,
                                  Icons.cancel_outlined),
                            ),
                          ),
                        ]),
                        shrinkWrap: true,
                      ),
                    ),
                  GapsManager.h20,
                  if (recordingPath != null)
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
        onPressed: () {
          labelTask = checkList.entries
              .where((entry) => entry.value)
              .map((entry) => entry.key.toString())
              .toList();
          var task = Task(
              title: titleController.text,
              content: jsonEncode(quillController.document.toDelta().toJson()),
              isChoose: false,
              isPin: pinNote,
              color: colorBackground,
              editedTime: formattedEditedTime,
              duration: durationNotification,
              labelsList: labelTask,
              notifications: notificationList,
              checkBoxList: checkBoxList,
              drawingPoint: drawingPoint,
              recordingPath: recordingPath,
              selectedImage: selectedImage);
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
        height: SizesManager.h70,
        child: isFormating
            ? onFormatText()
            : Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            onAddBox();
                          },
                          icon: const Icon(Icons.add_box_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            setColorBackground();
                          },
                          icon: const Icon(Icons.palette_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            onFormating();
                          },
                          icon: const Icon(Icons.text_format_outlined),
                        ),
                        Text(
                          formattedEditedTime.isNotEmpty
                              ? "${StringsManger.update_home} $formattedEditedTime"
                              : "",
                          style: TextStyle(fontSize: SizesManager.s12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      onMoreVert();
                    },
                    icon: const Icon(Icons.more_vert),
                  )
                ],
              ),
      ),
    );
  }
}