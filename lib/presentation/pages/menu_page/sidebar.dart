import 'package:flutter/material.dart';
import '../../../config/routes/routes.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import 'list_title.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
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
          const ContentSidebar(
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
  }
}