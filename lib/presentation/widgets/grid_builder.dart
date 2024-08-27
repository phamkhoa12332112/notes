import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notesapp/blocs/bloc.export.dart';
import 'package:notesapp/models/task.dart';
import 'package:notesapp/presentation/pages/edit_note_page/edit_note_screen.dart';
import 'package:notesapp/utils/resources/sizes_manager.dart';
import 'package:notesapp/utils/resources/strings_manager.dart';

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
  void _removeOrDeleteTask(BuildContext ctx, Task task) {
    task.isDelete!
        ? ctx.read<TasksBloc>().add(DeleteTask(task: task))
        : ctx.read<TasksBloc>().add(RemoveTask(task: task));
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
            onDoubleTap: () => _removeOrDeleteTask(context, task),
            onLongPress: () => Future.delayed(Duration.zero, () async {
              widget.onLongPress!();
            }),
            child: widget.isSelectionMode
                ? GridTile(
                    child: Container(
                        decoration: BoxDecoration(
                            color: widget.tasksList[index].color,
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
                                      color: Colors.black,
                                      fontSize: SizesManager.s30)),
                            ),
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  text: normalText.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
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
                            color: widget.tasksList[index].color,
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
                                      color: Colors.black,
                                      fontSize: SizesManager.s30)),
                            ),
                            RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  text: normalText.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
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