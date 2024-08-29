import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/utils/resources/gaps_manager.dart';
import '../../../blocs/bloc_task/tasks_bloc.dart';
import '../../../config/routes/routes.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../label_notes_page/label_notes_screen.dart';
import 'list_title.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key, required this.onTap});

  final Function onTap;

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(builder: (context, state) {
      return Drawer(
        child: ListView(
          children: [
            Text(
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: SizesManager.s20),
                StringsManger.app_name),
            GapsManager.h10,
            ContentSidebar(
              text: StringsManger.noted,
              icon: const Icon(Icons.light),
              routes: RoutesName.homeScreen,
              onTap: widget.onTap,
            ),
            ContentSidebar(
              text: StringsManger.remind,
              icon: const Icon(Icons.conveyor_belt),
              routes: RoutesName.notificationScreen,
              onTap: widget.onTap,
            ),
            state.labelListTasks.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(height: SizesManager.w1),
                      Padding(
                        padding: EdgeInsets.only(
                            top: SizesManager.p10, left: SizesManager.p15),
                        child: const Text(StringsManger.label,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: SizesManager.p18, right: SizesManager.p18),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.labelListTasks.keys.length,
                          itemBuilder: (context, index) {
                            var key =
                                state.labelListTasks.keys.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                widget.onTap();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LabelNote(label: key),
                                    ));
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: SizesManager.p12,
                                      bottom: SizesManager.p14),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.label_outlined),
                                      GapsManager.w10,
                                      Expanded(
                                        child: Text(
                                          key,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      ContentSidebar(
                        text: StringsManger.add_lable,
                        icon: const Icon(Icons.add),
                        routes: RoutesName.labelScreen,
                        onTap: widget.onTap,
                      ),
                      Divider(height: SizesManager.w1)
                    ],
                  )
                : ContentSidebar(
                    text: StringsManger.add_lable,
                    icon: const Icon(Icons.add),
                    routes: RoutesName.labelScreen,
                    onTap: widget.onTap,
                  ),
            ContentSidebar(
              text: StringsManger.save,
              icon: const Icon(Icons.save),
              routes: RoutesName.saveScreen,
              onTap: widget.onTap,
            ),
            ContentSidebar(
              text: StringsManger.delete,
              icon: const Icon(Icons.delete),
              routes: RoutesName.deleteScreen,
              onTap: widget.onTap,
            ),
            ContentSidebar(
              text: StringsManger.setting,
              icon: const Icon(Icons.settings),
              routes: RoutesName.settingScreen,
              onTap: widget.onTap,
            ),
            ContentSidebar(
              text: StringsManger.help,
              icon: const Icon(Icons.help),
              onTap: widget.onTap,
              routes: RoutesName.helpScreen,
            )
          ],
        ),
      );
    });
  }
}