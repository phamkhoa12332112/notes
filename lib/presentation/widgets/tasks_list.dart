import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notesapp/blocs/bloc.export.dart';
import 'package:notesapp/utils/resources/strings_manager.dart';

import '../../models/task.dart';
import '../../utils/resources/sizes_manager.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key, required this.taskList});

  final List<Task> taskList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        var task = taskList[index];
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(SizesManager.r20)),
          margin: EdgeInsets.all(SizesManager.m20),
          child: Slidable(
            key: const ValueKey(0),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                    onPressed: (_) {
                      context.read<TasksBloc>().add(DeleteTask(task: task));
                    },
                    borderRadius: BorderRadius.circular(SizesManager.r20),
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
                    style: TextStyle(color: Colors.black ,fontSize: SizesManager.s25)),
              ),
              subtitle: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    text: task.title,
                    style: TextStyle(color: Colors.black ,fontSize: SizesManager.s20)),
              ),
            ),
          ),
        );
      },
    );
  }
}
