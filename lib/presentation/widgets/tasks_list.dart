import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/task.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key, required this.taskList});

  final List<Task> taskList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        var task = taskList[index];
        return  ListTile(
          title: Text(task.title),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(task.content)],
          ),
        );
      },
    );
  }
}
