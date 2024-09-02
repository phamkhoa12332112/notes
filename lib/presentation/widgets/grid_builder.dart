import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/models/task.dart';
import 'package:notesapp/presentation/pages/edit_note_page/edit_note_screen.dart';
import 'package:notesapp/utils/resources/sizes_manager.dart';
import 'package:notesapp/utils/resources/strings_manager.dart';

import '../../blocs/bloc_task/tasks_bloc.dart';

class GridBuilder extends StatefulWidget {
  const GridBuilder(
      {super.key,
      required this.tasksList,
      required this.isSelectionMode,
      required this.onLongPress,
      required this.onTap,
      this.physic});

  final List<Task> tasksList;
  final bool isSelectionMode;
  final Function? onLongPress;
  final Function? onTap;
  final ScrollPhysics? physic;

  @override
  GridBuilderState createState() => GridBuilderState();
}

class GridBuilderState extends State<GridBuilder> {
  List<Color?> availableColor = [];

  void _removeOrDeleteTask(BuildContext ctx, Task task) {
    task.isDelete!
        ? ctx.read<TasksBloc>().add(DeleteTask(task: task))
        : ctx.read<TasksBloc>().add(RemoveTask(task: task));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    availableColor = [
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).brightness == Brightness.dark
          ? Colors.red[300]
          : Colors.red,
      Theme.of(context).brightness == Brightness.dark
          ? Colors.deepOrange[300]
          : Colors.deepOrange,
      Theme.of(context).brightness == Brightness.dark
          ? Colors.amber[300]
          : Colors.amber,
      Theme.of(context).brightness == Brightness.dark
          ? Colors.yellow[300]
          : Colors.yellow,
      Theme.of(context).brightness == Brightness.dark
          ? Colors.blue[300]
          : Colors.blue,
      Theme.of(context).brightness == Brightness.dark
          ? Colors.cyan[300]
          : Colors.cyan,
      Theme.of(context).brightness == Brightness.dark
          ? Colors.green[300]
          : Colors.green,
      Theme.of(context).brightness == Brightness.dark
          ? Colors.lightGreenAccent[400]
          : Colors.lightGreenAccent,
      Theme.of(context).brightness == Brightness.dark
          ? Colors.brown[300]
          : Colors.brown,
      Theme.of(context).brightness == Brightness.dark
          ? Colors.deepPurple[300]
          : Colors.deepPurple,
      Theme.of(context).brightness == Brightness.dark
          ? Colors.pink[300]
          : Colors.pink,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: widget.physic,
        // Disable scrolling
        shrinkWrap: true,
        itemCount: widget.tasksList.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (_, index) {
          var task = widget.tasksList[index];
          var deltaJson = jsonDecode(task.content);
          StringBuffer normalText = StringBuffer();
          for (var operation in deltaJson) {
            normalText.write(operation['insert']);
          }
          return GestureDetector(
            onTap: () => widget.isSelectionMode
                ? Future.delayed(Duration.zero, () async {
                    widget.onTap!(task);
                  })
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditNoteScreen(task: task))),
            onDoubleTap: () {
              _removeOrDeleteTask(context, task);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Container(
                  height: task.isPin ? SizesManager.h35 : SizesManager.h30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SizesManager.r2)),
                  child: Row(
                    children: [
                      Expanded(
                        child: task.isPin
                            ? const Text(
                                StringsManger.delete_pin_snack_bar,
                              )
                            : const Text(
                                StringsManger.delete_no_pin_snack_bar,
                              ),
                      ),
                    ],
                  ),
                ),
              ));
            },
            onLongPress: () => Future.delayed(Duration.zero, () async {
              widget.onLongPress!();
            }),
            child: widget.isSelectionMode
                ? GridTile(
                    child: Container(
                        decoration: BoxDecoration(
                            color:
                                availableColor[widget.tasksList[index].color],
                            border: Border.all(
                                color:
                                    task.isChoose ? Colors.green : Colors.grey,
                                width: task.isChoose
                                    ? SizesManager.w5
                                    : SizesManager.w1),
                            borderRadius: BorderRadiusDirectional.all(
                                Radius.circular(SizesManager.r20))),
                        margin: EdgeInsets.all(SizesManager.m20),
                        padding: EdgeInsets.all(SizesManager.p10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  text: task.title,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.color,
                                      fontSize: SizesManager.s30)),
                            ),
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  text: normalText.toString(),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.color,
                                      fontSize: SizesManager.s20)),
                            ),
                            if (widget
                                .tasksList[index].notifications.isNotEmpty)
                              Wrap(spacing: SizesManager.w5, children: [
                                Chip(
                                    padding: EdgeInsets.all(SizesManager.p8),
                                    avatar: Icon(widget.tasksList[index]
                                        .notifications.keys.first),
                                    label: widget.tasksList[index].notifications
                                                .keys.first ==
                                            Icons.schedule
                                        ? Text(
                                            '${StringsManger.day} ${widget.tasksList[index].notifications.values.first.values.first.day} ${StringsManger.month} ${widget.tasksList[index].notifications.values.first.values.first.month}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: SizesManager.s15),
                                          )
                                        : Text(
                                            widget
                                                .tasksList[index]
                                                .notifications
                                                .values
                                                .first
                                                .keys
                                                .first,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: SizesManager.s15),
                                          ))
                              ]),
                          ],
                        )))
                : GridTile(
                    child: Container(
                        decoration: BoxDecoration(
                            color:
                                availableColor[widget.tasksList[index].color],
                            border: Border.all(
                                color: Colors.grey, width: SizesManager.w1),
                            borderRadius: BorderRadiusDirectional.all(
                                Radius.circular(SizesManager.r20))),
                        margin: EdgeInsets.all(SizesManager.m20),
                        padding: EdgeInsets.all(SizesManager.p10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  text: task.title,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.color,
                                      fontSize: SizesManager.s30)),
                            ),
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  text: normalText.toString(),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.color,
                                      fontSize: SizesManager.s20)),
                            ),
                            if (widget
                                .tasksList[index].notifications.isNotEmpty)
                              Wrap(spacing: SizesManager.w5, children: [
                                Chip(
                                    padding: EdgeInsets.all(SizesManager.p8),
                                    avatar: Icon(widget.tasksList[index]
                                        .notifications.keys.first),
                                    label: widget.tasksList[index].notifications
                                                .keys.first ==
                                            Icons.schedule
                                        ? Text(
                                            '${StringsManger.day} ${widget.tasksList[index].notifications.values.first.values.first.day} ${StringsManger.month} ${widget.tasksList[index].notifications.values.first.values.first.month}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: SizesManager.s15),
                                          )
                                        : Text(
                                            widget
                                                .tasksList[index]
                                                .notifications
                                                .values
                                                .first
                                                .keys
                                                .first,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: SizesManager.s15),
                                          ))
                              ]),
                          ],
                        ))),
          );
        });
  }
}