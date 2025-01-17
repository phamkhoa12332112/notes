import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/bloc_task/tasks_bloc.dart';
import '../../../models/task.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../widgets/grid_builder.dart';

class DeleteScreen extends StatefulWidget {
  const DeleteScreen({super.key});

  @override
  State<DeleteScreen> createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
  late List<Task> selectedList = [];
  final bool _isSelectionMode = true;

  void onTap(Task task) {
    setState(() {
      task.isChoose = !task.isChoose;
      task.isChoose ? selectedList.add(task) : selectedList.remove(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(builder: (context, state) {
      List<Task> deleteList = state.deleteTasks;
      return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Title(
                    color: Colors.black,
                    child: const Text(StringsManger.delete)),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        child: const Text(StringsManger.delete_bin),
                        onTap: () {
                          for (var task in selectedList) {
                            if (task.isChoose) {
                              context
                                  .read<TasksBloc>()
                                  .add(DeleteTask(task: task));
                            }
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Container(
                              height: SizesManager.h30,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(SizesManager.r2)),
                              child: const Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      StringsManger.remove_snack_bar,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                        }),
                    PopupMenuItem(
                        child: const Text(StringsManger.restore),
                        onTap: () {
                          for (var task in selectedList) {
                            if (task.isChoose) {
                              context
                                  .read<TasksBloc>()
                                  .add(RestoreTask(task: task));
                            }
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Container(
                              height: SizesManager.h30,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(SizesManager.r2)),
                              child: const Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      StringsManger.restore_snack_bar,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                        }),
                    PopupMenuItem(
                        child: const Text(StringsManger.select_all),
                        onTap: () {
                          setState(() {
                            for (int index = 0;
                                index < deleteList.length;
                                index++) {
                              deleteList[index].isChoose =
                                  deleteList[index].isChoose ? false : true;
                              deleteList[index].isChoose
                                  ? selectedList.add(deleteList[index])
                                  : selectedList.remove(deleteList[index]);
                            }
                          });
                        }),
                  ],
                )
              ],
            ),
          ),
          body: SafeArea(
              child: deleteList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.delete_outline,
                              color: Colors.orangeAccent,
                              size: SizesManager.w150),
                          Text(
                            StringsManger.delete_text,
                            style: TextStyle(fontSize: SizesManager.s15),
                          ),
                        ],
                      ),
                    )
                  : GridBuilder(
                      tasksList: deleteList,
                      isSelectionMode: _isSelectionMode,
                      onLongPress: null,
                      onTap: onTap,
                    )));
    });
  }
}