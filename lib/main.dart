import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notesapp/blocs/bloc_theme/theme_bloc.dart';
import 'package:notesapp/utils/resources/routes_manager.dart';
import 'package:notesapp/utils/theme/theme.dart';
import 'package:path_provider/path_provider.dart';

import 'blocs/bloc_notification/timing_bloc.dart';
import 'blocs/bloc_task/tasks_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRoutes _appRouter = AppRoutes();

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => TasksBloc()),
                  BlocProvider(create: (context) => ThemeBloc()),
                  BlocProvider(create: (context) => TimingBloc())
                ],
                child: BlocBuilder<ThemeBloc, ThemeMode>(
                  builder: (context, themeState) {
                    return MaterialApp(
                      themeMode: themeState,
                      theme: TAppTheme.lightTheme,
                      darkTheme: TAppTheme.darkTheme,
                      debugShowCheckedModeBanner: false,
                      onGenerateRoute: _appRouter.onGenerateRoute,
                    );
                  },
                )));
  }
}