import 'package:flutter/material.dart';
import '../../resources/sizes_manager.dart';
import '../../resources/strings_manager.dart';
import '../../routes/routes.dart';
import 'list_title.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const Text(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: SizesManager.s20),
              StringsManger.app_name),
          ContentSidebar(
            text: StringsManger.noted,
            icon: const Icon(Icons.light),
            routes: RoutesName.homeScreen,
          ),
          ContentSidebar(
            text: StringsManger.remind,
            icon: const Icon(Icons.conveyor_belt),
            routes: RoutesName.notificationScreen,
          ),
          ContentSidebar(
            text: StringsManger.add_lable,
            icon: const Icon(Icons.add),
            routes: RoutesName.labelScreen,
          ),
          ContentSidebar(
            text: StringsManger.save,
            icon: const Icon(Icons.save),
            routes: RoutesName.saveScreen,
          ),
          ContentSidebar(
            text: StringsManger.delete,
            icon: const Icon(Icons.delete),
            routes: RoutesName.deleteScreen,
          ),
          ContentSidebar(
            text: StringsManger.setting,
            icon: const Icon(Icons.settings),
            routes: RoutesName.settingScreen,
          ),
          ContentSidebar(
            text: StringsManger.help,
            icon: const Icon(Icons.help),
            routes: RoutesName.helpScreen,
          )
        ],
      ),
    );
  }
}