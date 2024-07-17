import 'package:flutter/material.dart';
import 'package:notesapp/presentation/widgets/text_field_widget.dart';

import '../../../config/routes/routes.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';
import '../menu_page/sidebar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
          title: TextFieldWidget(
        borderRadius: 0,
        hintText: StringsManger.searchText_home,
        contentPadding: SizesManager.p12,
        suffixIcon: SizedBox(
          width: SizesManager.w100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  icon: const Icon(Icons.view_stream_outlined),
                  onPressed: () {}),
              IconButton(icon: const Icon(Icons.people), onPressed: () {}),
            ],
          ),
        ),
      )),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.emoji_objects_outlined,
                  color: Colors.orangeAccent, size: SizesManager.s70),
              const Text(StringsManger.hintText_home),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: SizesManager.m10,
        height: SizesManager.h60,
        child: Container(
          margin: EdgeInsets.only(right: SizesManager.m100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  style: TextStyle(fontSize: SizesManager.s10),
                  StringsManger.app_name),
              Text(
                  style: TextStyle(fontSize: SizesManager.s8),
                  StringsManger.total_notes)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, RoutesName.addNoteScreen);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
