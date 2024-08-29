import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notesapp/utils/resources/strings_manager.dart';

import '../../blocs/bloc_task/tasks_bloc.dart';
import '../../models/task.dart';
import '../../utils/resources/sizes_manager.dart';
import '../pages/edit_note_page/edit_note_screen.dart';

class TasksList extends StatefulWidget {
  const TasksList(
      {super.key,
      required this.taskList,
      required this.onLongPress,
      required this.isSelectionMode,
      required this.onTap,
      required this.physic});

  final List<Task> taskList;
  final bool isSelectionMode;
  final Function? onLongPress;
  final Function? onTap;
  final ScrollPhysics? physic;

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  void _removeOrDeleteTask(BuildContext ctx, Task task) {
    task.isDelete!
        ? ctx.read<TasksBloc>().add(DeleteTask(task: task))
        : ctx.read<TasksBloc>().add(RemoveTask(task: task));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: widget.physic,
      shrinkWrap: true,
      itemCount: widget.taskList.length,
      itemBuilder: (context, index) {
        var task = widget.taskList[index];
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
          onLongPress: () => Future.delayed(Duration.zero, () async {
            widget.onLongPress!();
          }),
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: widget.taskList[index].color,
                border: Border.all(
                    color: task.isChoose ? Colors.green : Colors.grey,
                    width: task.isChoose ? SizesManager.w5 : SizesManager.w1),
                borderRadius: BorderRadius.circular(SizesManager.r20)),
            margin: EdgeInsets.all(SizesManager.m20),
            child: !widget.isSelectionMode
                ? Slidable(
                    key: const ValueKey(0),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                            onPressed: (_) =>
                                _removeOrDeleteTask(context, task),
                            borderRadius:
                                BorderRadius.circular(SizesManager.r20),
                            padding: EdgeInsets.all(SizesManager.p10),
                            backgroundColor: Colors.red,
                            icon: Icons.delete_outline,
                            label: StringsManger.delete)
                      ],
                    ),
                    child: ListTile(
                      title: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            text: task.title,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.color,
                                fontSize: SizesManager.s25)),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          if (widget.taskList[index].notifications.isNotEmpty)
                            Wrap(spacing: SizesManager.w5, children: [
                              Chip(
                                  padding: EdgeInsets.all(SizesManager.p8),
                                  avatar: Icon(widget.taskList[index]
                                      .notifications.keys.first),
                                  label: widget.taskList[index].notifications
                                              .keys.first ==
                                          Icons.schedule
                                      ? Text(
                                          '${StringsManger.day} ${widget.taskList[index].notifications.values.first.values.first.day} ${StringsManger.month} ${widget.taskList[index].notifications.values.first.values.first.month}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: SizesManager.s15),
                                        )
                                      : Text(
                                          widget.taskList[index].notifications
                                              .values.first.keys.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: SizesManager.s15),
                                        ))
                            ]),
                        ],
                      ),
                    ),
                  )
                : ListTile(
                    title: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text: task.title,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.titleLarge?.color,
                              fontSize: SizesManager.s25)),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        if (widget.taskList[index].notifications.isNotEmpty)
                          Wrap(spacing: SizesManager.w5, children: [
                            Chip(
                                padding: EdgeInsets.all(SizesManager.p8),
                                avatar: Icon(widget
                                    .taskList[index].notifications.keys.first),
                                label: widget.taskList[index].notifications.keys
                                            .first ==
                                        Icons.schedule
                                    ? Text(
                                        '${StringsManger.day} ${widget.taskList[index].notifications.values.first.values.first.day} ${StringsManger.month} ${widget.taskList[index].notifications.values.first.values.first.month}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: SizesManager.s15),
                                      )
                                    : Text(
                                        widget.taskList[index].notifications
                                            .values.first.keys.first,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: SizesManager.s15),
                                      ))
                          ]),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}