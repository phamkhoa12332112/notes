import 'package:flutter/material.dart';
import 'package:notesapp/blocs/bloc.export.dart';
import 'package:notesapp/models/task.dart';
import 'package:notesapp/presentation/widgets/tasks_list.dart';

import '../../../config/routes/routes.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../widgets/grid_builder.dart';
import '../../widgets/text_field_widget.dart';
import '../menu_page/sidebar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(builder: (context, state) {
      List<Task> tasksList = state.allTasks;
      return Scaffold(
        drawer: const Sidebar(),
        appBar: AppBar(
            title: TextFieldWidget(
          borderRadius: 0,
          hintText: StringsManger.searchText_home,
          contentPadding: SizesManager.p12,
          suffixIcon: SizedBox(
            width: SizesManager.w100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                IconButton(icon: const Icon(Icons.people), onPressed: () {}),
              ],
            ),
          ),
        )),
        body: SafeArea(
            child: tasksList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.emoji_objects_outlined,
                            color: Colors.orangeAccent,
                            size: SizesManager.w150),
                        Text(
                          StringsManger.hintText_home,
                          style: TextStyle(fontSize: SizesManager.s15),
                        ),
                      ],
                    ),
                  )
                : isGridView
                    ? GridBuilder(selectedList: tasksList)
                    : TasksList(taskList: tasksList)),
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
                    StringsManger.total_notes)
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
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
