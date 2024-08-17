import 'package:flutter/material.dart';
import 'package:notesapp/presentation/widgets/grid_builder.dart';

import '../../../blocs/bloc.export.dart';
import '../../../models/task.dart';
import '../../../utils/resources/gaps_manager.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../widgets/tasks_list.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen({super.key});

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  late List<Task> selectedList = [];
  bool _isSelectionMode = false;
  bool isGridView = true;

  void onTap(Task task) {
    if (_isSelectionMode) {
      setState(() {
        task.isChoose = !task.isChoose;
        task.isChoose ? selectedList.add(task) : selectedList.remove(task);
      });
    }
  }

  void onLongPress() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(builder: (context, state) {
      List<Task> storeList = state.storeTasks;
      return Scaffold(
          appBar: AppBar(
              title: !_isSelectionMode
                  ? Row(
                      children: [
                        Title(
                            color: Colors.black,
                            child: const Text(StringsManger.save)),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.search),
                              GapsManager.w20,
                              if (isGridView)
                                IconButton(
                                    icon:
                                        const Icon(Icons.view_agenda_outlined),
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
                                    icon:
                                        const Icon(Icons.view_agenda_outlined),
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
                                      child:
                                          const Text(StringsManger.delete_bin),
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
                                      child:
                                          const Text(StringsManger.deny_store),
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
                                      child:
                                          const Text(StringsManger.select_all),
                                      onTap: () {
                                        setState(() {
                                          for (int index = 0;
                                              index < storeList.length;
                                              index++) {
                                            storeList[index].isChoose =
                                                storeList[index].isChoose
                                                    ? false
                                                    : true;
                                            storeList[index].isChoose
                                                ? selectedList
                                                    .add(storeList[index])
                                                : selectedList
                                                    .remove(storeList[index]);
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
              child: storeList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.save_alt_outlined,
                              color: Colors.orangeAccent,
                              size: SizesManager.w150),
                          Text(
                            StringsManger.save_text,
                            style: TextStyle(fontSize: SizesManager.s15),
                          ),
                        ],
                      ),
                    )
                  : isGridView
                      ? GridBuilder(
                          tasksList: storeList,
                          isSelectionMode: _isSelectionMode,
                          physic: const AlwaysScrollableScrollPhysics(),
                          onLongPress: onLongPress,
                          onTap: onTap)
                      : TasksList(
                          physic: const AlwaysScrollableScrollPhysics(),
                          taskList: storeList,
                          isSelectionMode: _isSelectionMode,
                          onTap: onTap,
                          onLongPress: onLongPress,
                        )));
    });
  }
}