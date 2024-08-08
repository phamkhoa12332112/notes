import 'package:flutter/material.dart';
import 'package:notesapp/utils/resources/gaps_manager.dart';
import '../../../blocs/bloc.export.dart';
import '../../../config/routes/routes.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import 'list_title.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

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
                style: TextStyle(fontSize: SizesManager.s10),
                StringsManger.app_name),
            const ContentSidebar(
              text: StringsManger.noted,
              icon: Icon(Icons.light),
              routes: RoutesName.homeScreen,
            ),
            const ContentSidebar(
              text: StringsManger.remind,
              icon: Icon(Icons.conveyor_belt),
              routes: RoutesName.notificationScreen,
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
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: SizesManager.p12,
                                  bottom: SizesManager.p14),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.label_outlined),
                                  GapsManager.w10,
                                  Text(
                                    key,
                                    style:
                                        TextStyle(fontSize: SizesManager.s15),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const ContentSidebar(
                        text: StringsManger.add_lable,
                        icon: Icon(Icons.add),
                        routes: RoutesName.labelScreen,
                      ),
                      Divider(height: SizesManager.w1)
                    ],
                  )
                : const ContentSidebar(
                    text: StringsManger.add_lable,
                    icon: Icon(Icons.add),
                    routes: RoutesName.labelScreen,
                  ),
            const ContentSidebar(
              text: StringsManger.save,
              icon: Icon(Icons.save),
              routes: RoutesName.saveScreen,
            ),
            const ContentSidebar(
              text: StringsManger.delete,
              icon: Icon(Icons.delete),
              routes: RoutesName.deleteScreen,
            ),
            const ContentSidebar(
              text: StringsManger.setting,
              icon: Icon(Icons.settings),
              routes: RoutesName.settingScreen,
            ),
            const ContentSidebar(
              text: StringsManger.help,
              icon: Icon(Icons.help),
              routes: RoutesName.helpScreen,
            )
          ],
        ),
      );
    });
  }
}