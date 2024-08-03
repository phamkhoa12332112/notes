import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notesapp/blocs/bloc.export.dart';
import 'package:notesapp/utils/resources/strings_manager.dart';

import '../../models/task.dart';
import '../../utils/resources/sizes_manager.dart';
import '../pages/edit_note_page/edit_note_screen.dart';

class TasksList extends StatefulWidget {
  const TasksList(
      {super.key,
      required this.taskList,
      required this.onLongPress,
      required this.isSelectionMode,
      required this.onTap});

  final List<Task> taskList;
  final bool isSelectionMode;
  final Function? onLongPress;
  final Function? onTap;

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
      shrinkWrap: true,
      itemCount: widget.taskList.length,
      itemBuilder: (context, index) {
        var task = widget.taskList[index];
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
                                color: Colors.black,
                                fontSize: SizesManager.s25)),
                      ),
                      subtitle: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            text: task.content,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: SizesManager.s20)),
                      ),
                    ),
                  )
                : ListTile(
                    title: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text: task.title,
                          style: TextStyle(
                              color: Colors.black, fontSize: SizesManager.s25)),
                    ),
                    subtitle: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text: task.content,
                          style: TextStyle(
                              color: Colors.black, fontSize: SizesManager.s20)),
                    ),
                  ),
          ),
        );
      },
    );
  }
}