import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/presentation/widgets/text_field_widget.dart';

import '../../../blocs/bloc_task/tasks_bloc.dart';
import '../../../config/routes/routes.dart';
import '../../../models/task.dart';
import '../../../utils/resources/gaps_manager.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../widgets/grid_builder.dart';
import '../../widgets/tasks_list.dart';
import '../menu_page/sidebar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isSearch = false;
  bool isGridView = false;
  bool _isSelectionMode = false;
  late List<Task> selectedList = [];

  void onDrawer() {
    setState(() {
      for (var task in selectedList) {
        task.isChoose = false;
      }
      selectedList.clear();
    });
  }

  void onLongPress() {
    _isSelectionMode = !_isSelectionMode;
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      for (var task in selectedList) {
        task.isChoose = false;
      }
      selectedList.clear();
    });
  }

  void onCancel() {
    setState(() {
      _isSelectionMode = false;
      for (var task in selectedList) {
        task.isChoose = false;
      }
      selectedList.clear();
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
      List<Task> tasksList =
          state.allTasks.where((e) => e.notifications.isNotEmpty).toList();
      List<Task> pinList =
          state.pinTasks.where((e) => e.notifications.isNotEmpty).toList();
      List<Task> searchList =
          state.searchTasks.where((e) => e.notifications.isNotEmpty).toList();
      return Scaffold(
        drawer: Sidebar(
          onTap: onDrawer,
        ),
        appBar: !_isSelectionMode
            ? AppBar(
                title: Row(
                  children: [
                    isSearch
                        ? Expanded(
                            flex: SizesManager.l2,
                            child: TextFieldWidget(
                              controller: _searchController,
                              onChanged: (query) {
                                context
                                    .read<TasksBloc>()
                                    .add(SearchTasks(query: query));
                              },
                              borderRadius: SizesManager.r0,
                              hintText: StringsManger.searchText_home,
                              contentPadding: SizesManager.p12,
                            ),
                          )
                        : Title(
                            color: Colors.black,
                            child: const Text(StringsManger.remind)),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                setState(() {
                                  isSearch = !isSearch;
                                  _searchController.clear();
                                });
                              },
                              child: isSearch
                                  ? const Icon(Icons.cancel_outlined)
                                  : const Icon(Icons.search)),
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
                        ],
                      ),
                    )
                  ],
                ),
              )
            : AppBar(
                title: Text(
                    "${selectedList.length} ${StringsManger.selected_item}"),
                actions: [
                  InkWell(
                    onTap: () {
                      for (var task in selectedList) {
                        if (task.isChoose) {
                          context.read<TasksBloc>().add(RemoveTask(task: task));
                        }
                      }
                      setState(() {
                        selectedList.clear;
                        _isSelectionMode = !_isSelectionMode;
                      });
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
                                  StringsManger.delete_no_pin_snack_bar,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
                    },
                    child: const Icon(Icons.delete),
                  ),
                  GapsManager.w20,
                  InkWell(
                    onTap: () {
                      setState(() {
                        for (int index = 0; index < tasksList.length; index++) {
                          tasksList[index].isChoose =
                              tasksList[index].isChoose ? false : true;
                          tasksList[index].isChoose
                              ? selectedList.add(tasksList[index])
                              : selectedList.remove(tasksList[index]);
                        }
                      });
                    },
                    child: const Icon(Icons.select_all_outlined),
                  ),
                  GapsManager.w20,
                  InkWell(
                    onTap: onCancel,
                    child: const Icon(Icons.cancel),
                  )
                ],
              ),
        body: (tasksList.isNotEmpty || pinList.isNotEmpty)
            ? pinList.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                top: SizesManager.p20, left: SizesManager.p20),
                            child: const Text(StringsManger.pinned)),
                        isGridView
                            ? GridBuilder(
                                tasksList: searchList
                                    .where((task) => task.isPin)
                                    .toList(),
                                isSelectionMode: _isSelectionMode,
                                onTap: onTap,
                                onLongPress: onLongPress,
                                physic: const NeverScrollableScrollPhysics(),
                              )
                            : TasksList(
                                taskList: searchList
                                    .where((task) => task.isPin)
                                    .toList(),
                                isSelectionMode: _isSelectionMode,
                                onLongPress: onLongPress,
                                onTap: onTap,
                                physic: const NeverScrollableScrollPhysics(),
                              ),
                        Padding(
                            padding: EdgeInsets.only(
                                top: SizesManager.p20, left: SizesManager.p20),
                            child: const Text(StringsManger.others)),
                        isGridView
                            ? GridBuilder(
                                tasksList: searchList
                                    .where((task) => !task.isPin)
                                    .toList(),
                                isSelectionMode: _isSelectionMode,
                                onTap: onTap,
                                onLongPress: onLongPress,
                                physic: const NeverScrollableScrollPhysics(),
                              )
                            : TasksList(
                                taskList: searchList
                                    .where((task) => !task.isPin)
                                    .toList(),
                                isSelectionMode: _isSelectionMode,
                                onLongPress: onLongPress,
                                onTap: onTap,
                                physic: const NeverScrollableScrollPhysics(),
                              ),
                      ],
                    ),
                  )
                : isGridView
                    ? GridBuilder(
                        tasksList:
                            searchList.where((task) => !task.isPin).toList(),
                        isSelectionMode: _isSelectionMode,
                        onTap: onTap,
                        onLongPress: onLongPress,
                        physic: const AlwaysScrollableScrollPhysics(),
                      )
                    : TasksList(
                        taskList:
                            searchList.where((task) => !task.isPin).toList(),
                        isSelectionMode: _isSelectionMode,
                        onLongPress: onLongPress,
                        onTap: onTap,
                        physic: const AlwaysScrollableScrollPhysics(),
                      )
            : SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.notifications_none_outlined,
                          color: Colors.orange, size: SizesManager.w150),
                      Text(
                        StringsManger.hintText_home,
                        style: TextStyle(fontSize: SizesManager.s15),
                      ),
                    ],
                  ),
                ),
              ),
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
                    "${StringsManger.total_notes_1} ${searchList.length} ${StringsManger.total_notes_2}")
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            onDrawer();
            Navigator.pushNamed(context, RoutesName.addNoteScreen);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
    });
  }
}