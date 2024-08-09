import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../blocs/bloc.export.dart';
import '../../../config/routes/routes.dart';
import '../../../models/task.dart';
import '../../../utils/resources/gaps_manager.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../widgets/dialog_box.dart';
import '../../widgets/grid_builder.dart';
import '../../widgets/tasks_list.dart';
import '../menu_page/sidebar.dart';

class LabelNote extends StatefulWidget {
  const LabelNote({super.key, required this.label});

  final String label;

  @override
  State<LabelNote> createState() => _LabelNote();
}

class _LabelNote extends State<LabelNote> {
  bool isGridView = false;
  bool _isSelectionMode = false;
  late List<Task> selectedList = [];

  void onLongPress() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
    });
  }

  void onTap(Task task) {
    if (_isSelectionMode) {
      setState(() {
        task.isChoose = !task.isChoose;
        task.isChoose ? selectedList.add(task) : selectedList.remove(task);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(builder: (context, state) {
      Map<String, List<Task>> labelListTasks = state.labelListTasks;
      if (!labelListTasks.containsKey(widget.label) ||
          labelListTasks[widget.label] == null) {
        return Scaffold(
          appBar: AppBar(title: const Text("Label Deleted")),
          body: const Center(child: Text("The label has been deleted.")),
        );
      }

      return Scaffold(
        drawer: const Sidebar(),
        appBar: AppBar(
            title: !_isSelectionMode
                ? Row(
                    children: [
                      Title(color: Colors.black, child: Text(widget.label)),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.search),
                            GapsManager.w20,
                            if (isGridView)
                              IconButton(
                                  icon: const Icon(Icons.view_agenda_outlined),
                                  onPressed: () {
                                    setState(() {
                                      isGridView = false;
                                    });
                                  })
                            else
                              IconButton(
                                  icon: const Icon(Icons.grid_view_outlined),
                                  onPressed: () {
                                    setState(() {
                                      isGridView = true;
                                    });
                                  }),
                            PopupMenuButton(
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                          child: const Text(
                                              StringsManger.change_name_label),
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (_) => DialogBox(
                                                    label: widget.label));
                                          }),
                                      PopupMenuItem(
                                          child: const Text(
                                              StringsManger.delete_label),
                                          onTap: () {
                                            Future.delayed(Duration.zero,
                                                () async {
                                              Navigator.pushNamed(context,
                                                  RoutesName.homeScreen);
                                            });
                                            context.read<TasksBloc>().add(
                                                RemoveLabel(
                                                    label: widget.label));
                                          }),
                                    ]),
                          ],
                        ),
                      )
                    ],
                  )
                : Row(
                    children: [
                      Title(
                          color: Colors.black,
                          child: Text(
                              "${StringsManger.total_notes_1} ${selectedList.length} ${StringsManger.total_notes_2}")),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.search),
                            GapsManager.w10,
                            if (isGridView)
                              IconButton(
                                  icon: const Icon(Icons.view_agenda_outlined),
                                  onPressed: () {
                                    setState(() {
                                      isGridView = false;
                                    });
                                  })
                            else
                              IconButton(
                                  icon: const Icon(Icons.grid_view_outlined),
                                  onPressed: () {
                                    setState(() {
                                      isGridView = true;
                                    });
                                  }),
                            PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    child: const Text(StringsManger.delete_bin),
                                    onTap: () {
                                      for (var task in selectedList) {
                                        if (task.isChoose) {
                                          context
                                              .read<TasksBloc>()
                                              .add(RemoveTask(task: task));
                                        }
                                      }
                                      setState(() {
                                        selectedList.clear;
                                        _isSelectionMode = !_isSelectionMode;
                                      });
                                    }),
                                PopupMenuItem(
                                    child: const Text(StringsManger.deny_store),
                                    onTap: () {
                                      for (var task in selectedList) {
                                        if (task.isChoose) {
                                          context
                                              .read<TasksBloc>()
                                              .add(UnStoreTask(task: task));
                                        }
                                      }
                                      setState(() {
                                        selectedList.clear;
                                        _isSelectionMode = !_isSelectionMode;
                                      });
                                    }),
                                PopupMenuItem(
                                    child: const Text(StringsManger.select_all),
                                    onTap: () {
                                      setState(() {
                                        for (int index = 0;
                                            index <
                                                labelListTasks[widget.label]!
                                                    .length;
                                            index++) {
                                          labelListTasks[widget.label]![index]
                                              .isChoose = labelListTasks[
                                                      widget.label]![index]
                                                  .isChoose
                                              ? false
                                              : true;
                                          labelListTasks[widget.label]![index]
                                                  .isChoose
                                              ? selectedList.add(labelListTasks[
                                                  widget.label]![index])
                                              : selectedList.remove(
                                                  labelListTasks[widget.label]![
                                                      index]);
                                        }
                                      });
                                    }),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  )),
        body: SafeArea(
            child: (labelListTasks[widget.label]!.isEmpty)
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.label_outline,
                            color: Colors.orange, size: SizesManager.w150),
                        Text(
                          StringsManger.label_content,
                          style: TextStyle(fontSize: SizesManager.s15),
                        ),
                      ],
                    ),
                  )
                : isGridView
                    ? GridBuilder(
                        tasksList: labelListTasks[widget.label]!.toList(),
                        isSelectionMode: _isSelectionMode,
                        onTap: onTap,
                        onLongPress: onLongPress,
                      )
                    : TasksList(
                        taskList: labelListTasks[widget.label]!.toList(),
                        isSelectionMode: _isSelectionMode,
                        onLongPress: onLongPress,
                        onTap: onTap,
                      )),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: SizesManager.m10,
          height: SizesManager.h60,
          child: Container(
            margin: EdgeInsets.only(right: SizesManager.m100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    style: TextStyle(fontSize: SizesManager.s20),
                    StringsManger.app_name),
                Text(
                    style: TextStyle(fontSize: SizesManager.s15),
                    "${StringsManger.total_notes_1} ${labelListTasks[widget.label]!.length} ${StringsManger.total_notes_2}")
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey.shade300,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, RoutesName.addNoteScreen);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
    });
  }
}