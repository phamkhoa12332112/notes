import 'package:flutter/material.dart';
import 'package:notesapp/blocs/bloc.export.dart';
import 'package:notesapp/models/task.dart';
import 'package:notesapp/presentation/pages/edit_note_page/edit_note_screen.dart';
import 'package:notesapp/utils/resources/sizes_manager.dart';

class GridBuilder extends StatefulWidget {
  const GridBuilder({
    super.key,
    required this.tasksList,
    required this.isSelectionMode,
    required this.onLongPress,
    required this.onTap,
  });

  final List<Task> tasksList;
  final bool isSelectionMode;
  final Function? onLongPress;
  final Function? onTap;

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
        physics: const NeverScrollableScrollPhysics(), // Disable scrolling
        shrinkWrap: true,
        itemCount: widget.tasksList.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (_, index) {
          var task = widget.tasksList[index];
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
                                  text: task.content,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: SizesManager.s20)),
                            ),
                          ],
                        )))
                : GridTile(
                    child: Container(
                        decoration: BoxDecoration(
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
                                  text: task.content,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: SizesManager.s20)),
                            ),
                          ],
                        ))),
          );
        });
  }
}
