import 'package:flutter/material.dart';

import '../../../blocs/bloc.export.dart';
import '../../../models/task.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../../widgets/grid_builder.dart';

class DeleteScreen extends StatefulWidget {
  const DeleteScreen({super.key});

  @override
  State<DeleteScreen> createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(builder: (context, state) {
      List<Task> deleteList = state.deleteTasks;
      return Scaffold(
          appBar: AppBar(
            title: Stack(
              children: [
                Title(
                    color: Colors.black,
                    child: const Text(StringsManger.delete)),
                const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.more_vert))
              ],
            ),
          ),
          body: SafeArea(
              child: deleteList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.delete_outline,
                              color: Colors.orangeAccent,
                              size: SizesManager.w150),
                          Text(
                            StringsManger.delete_text,
                            style: TextStyle(fontSize: SizesManager.s15),
                          ),
                        ],
                      ),
                    )
                  : GridBuilder(
                      tasksList: deleteList,
                      isSelectionMode: false,
                      onLongPress: null,
                      onTap: null,
                    )));
    });
  }
}