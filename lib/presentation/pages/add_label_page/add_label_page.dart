import 'package:flutter/material.dart';
import 'package:notesapp/presentation/widgets/text_field_widget.dart';

import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';

class AddLabelScreen extends StatelessWidget {
  const AddLabelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(StringsManger.title_label),
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(SizesManager.h1),
              child: Container(
                color: Colors.grey,
                height: SizesManager.h1,
              )),
        ),
        body: const SafeArea(
          child: Column(
            children: [
              TextFieldWidget(
                  borderRadius: 0,
                  hintText: StringsManger.add_lable,
                  contentPadding: SizesManager.p12,
                  suffixIcon: Icon(Icons.done),
                  prefixIcon: Icon(Icons.close)),
              Padding(
                padding: EdgeInsets.all(SizesManager.p12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.label_outlined),
                    Text(
                      StringsManger.title,
                      style: TextStyle(fontSize: SizesManager.s15),
                    ),
                    Icon(Icons.edit)
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
