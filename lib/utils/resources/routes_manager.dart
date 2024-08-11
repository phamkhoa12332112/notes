import 'package:flutter/material.dart';
import 'package:notesapp/presentation/pages/choose_label_page/choose_label_screen.dart';

import '../../config/routes/routes.dart';
import '../../presentation/pages/add_label_page/add_label_page.dart';
import '../../presentation/pages/add_note_page/add_note_screen.dart';
import '../../presentation/pages/delete_page/delete_screen.dart';
import '../../presentation/pages/help_page/help_screen.dart';
import '../../presentation/pages/home_page/home_screen.dart';
import '../../presentation/pages/notification_page/notification_screen.dart';
import '../../presentation/pages/save_page/save_screen.dart';
import '../../presentation/pages/setting_page/setting_screen.dart';

class AppRoutes {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RoutesName.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
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
      case RoutesName.chooseLabelScreen:
        return MaterialPageRoute(
            builder: (_) => ChooseLabelScreen(
                  checkList: const {},
                ));
      default:
        return null;
    }
  }
}