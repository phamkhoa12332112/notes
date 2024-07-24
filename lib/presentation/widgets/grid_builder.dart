import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/models/task.dart';
import 'package:notesapp/utils/resources/sizes_manager.dart';

import '../../blocs/bloc/tasks_bloc.dart';

class GridBuilder extends StatefulWidget {
  const GridBuilder({
    super.key,
    required this.selectedList,
  });

  final List<Task> selectedList;

  @override
  GridBuilderState createState() => GridBuilderState();
}

class GridBuilderState extends State<GridBuilder> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: widget.selectedList.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (_, int index) {
          var task = widget.selectedList[index];
          return GestureDetector(
            onLongPress: () {
              context.read<TasksBloc>().add(DeleteTask(task: task));
            },
            child: GridTile(
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
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
                              style: TextStyle(fontSize: SizesManager.s30)),
                        ),
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              text: task.content,
                              style: TextStyle(fontSize: SizesManager.s20)),
                        ),
                      ],
                    ))),
          );
        });
  }
}