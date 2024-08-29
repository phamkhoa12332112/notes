import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/bloc_task/tasks_bloc.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';

class AddLabelScreen extends StatefulWidget {
  const AddLabelScreen({super.key});

  @override
  State<AddLabelScreen> createState() => _AddLabelScreenState();
}

class _AddLabelScreenState extends State<AddLabelScreen> {
  TextEditingController labelController = TextEditingController();
  bool isDone = false;

  void onTap() {
    setState(() {
      isDone = !isDone;
      if (isDone) labelController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(builder: (context, state) {
      return Scaffold(
          appBar: AppBar(
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back)),
            title: const Text(StringsManger.title_label),
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(SizesManager.h1),
                child: Container(
                  color: Colors.grey.shade200,
                  height: SizesManager.h1,
                )),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                      autofocus: true,
                      controller: labelController,
                      decoration: isDone
                          ? InputDecoration(
                              prefixIcon: InkWell(
                                  onTap: onTap,
                                  child: !isDone
                                      ? const Icon(Icons.close)
                                      : const Icon(Icons.add)),
                              contentPadding: EdgeInsets.all(SizesManager.p12),
                              hintText: StringsManger.add_lable,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(SizesManager.r0)),
                            )
                          : InputDecoration(
                              suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      context.read<TasksBloc>().add(
                                          AddLabelList(
                                              label: labelController.text));
                                      labelController.clear();
                                    });
                                  },
                                  child: const Icon(Icons.done)),
                              prefixIcon: InkWell(
                                  onTap: onTap,
                                  child: !isDone
                                      ? const Icon(Icons.close)
                                      : const Icon(Icons.add)),
                              contentPadding: EdgeInsets.all(SizesManager.p12),
                              hintText: StringsManger.add_lable,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(SizesManager.r0)))),
                  Padding(
                      padding: EdgeInsets.all(SizesManager.p12),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.labelListTasks.keys.length,
                        itemBuilder: (context, index) {
                          String key =
                              state.labelListTasks.keys.elementAt(index);
                          return Padding(
                            padding: EdgeInsets.only(
                                top: SizesManager.p10,
                                bottom: SizesManager.p10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                isDone
                                    ? InkWell(
                                        onTap: () {
                                          context
                                              .read<TasksBloc>()
                                              .add(RemoveLabel(label: key));
                                        },
                                        child: const Icon(Icons.delete_outline))
                                    : const Icon(Icons.label_outlined),
                                Text(
                                  key,
                                  style: TextStyle(fontSize: SizesManager.s15),
                                ),
                                InkWell(
                                    onTap: onTap,
                                    child: isDone
                                        ? const Icon(Icons.done)
                                        : const Icon(Icons.edit))
                              ],
                            ),
                          );
                        },
                      ))
                ],
              ),
            ),
          ));
    });
  }
}