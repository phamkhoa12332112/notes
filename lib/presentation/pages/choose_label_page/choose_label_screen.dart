import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/utils/resources/sizes_manager.dart';
import 'package:notesapp/utils/resources/strings_manager.dart';

import '../../../blocs/bloc_task/tasks_bloc.dart';


class ChooseLabelScreen extends StatefulWidget {
  ChooseLabelScreen({super.key, required this.checkList});

  late Map<String, bool> checkList;

  @override
  State<ChooseLabelScreen> createState() => _ChooseLabelScreenState();
}

class _ChooseLabelScreenState extends State<ChooseLabelScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(builder: (context, state) {
      if (widget.checkList.isEmpty) {
        for (var key in state.labelListTasks.keys) {
          widget.checkList[key] = false;
        }
      }
      return Scaffold(
        appBar: AppBar(
            title: TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                  border: InputBorder.none, hintText: StringsManger.find_label),
            ),
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context, widget.checkList);
                },
                child: const Icon(Icons.arrow_back))),
        body: widget.checkList.isEmpty
            ? Container()
            : ListView.builder(
                padding: EdgeInsets.all(SizesManager.p15),
                shrinkWrap: true,
                itemCount: state.labelListTasks.keys.length,
                itemBuilder: (context, index) {
                  String key = state.labelListTasks.keys.elementAt(index);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.label_outline),
                      Text(
                        key,
                        style: TextStyle(fontSize: SizesManager.s15),
                      ),
                      Checkbox(
                          value: widget.checkList.containsKey(key)
                              ? widget.checkList[key]
                              : false,
                          onChanged: (newBool) {
                            setState(() {
                              widget.checkList[key] = newBool!;
                            });
                          })
                    ],
                  );
                }),
      );
    });
  }
}