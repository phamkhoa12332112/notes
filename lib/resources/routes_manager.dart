import 'package:flutter/material.dart';

import '../presentation/add_label/add_label_screen.dart';
import '../presentation/add_note/add_note_screen.dart';
import '../presentation/delete/delete_screen.dart';
import '../presentation/help/help_screen.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/notification/notification_screen.dart';
import '../presentation/save/save_screen.dart';
import '../presentation/setting/setting_screen.dart';
import '../routes/routes.dart';

class AppRoutes {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RoutesName.homeScreen:
        return MaterialPageRoute(
            builder: (_) => const HomeScreen());
      case RoutesName.addNoteScreen:
        return MaterialPageRoute(builder: (_) => const AddNoteScreen());
      case RoutesName.notificationScreen:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case RoutesName.labelScreen:
        return MaterialPageRoute(builder: (_) => const AddLabelScreen());
      case RoutesName.saveScreen:
        return MaterialPageRoute(builder: (_) => const SaveScreen());
      case RoutesName.deleteScreen:
        return MaterialPageRoute(builder: (_) => const DeleteScreen());
      case RoutesName.settingScreen:
        return MaterialPageRoute(builder: (_) => const SettingScreen());
      case RoutesName.helpScreen:
        return MaterialPageRoute(builder: (_) => const HelpScreen());
      default:
        return null;
    }
  }
}