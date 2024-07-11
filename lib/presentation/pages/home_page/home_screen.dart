import 'package:flutter/material.dart';
import 'package:notesapp/presentation/widgets/text_field_widget.dart';

import '../../../config/routes/routes.dart';
import '../../../utils/resources/assets_manager.dart';
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
            children: [
              IconButton(
                  icon: const Icon(Icons.view_stream_outlined),
                  onPressed: () {}),
              IconButton(icon: const Icon(Icons.people), onPressed: () {}),
            ],
          ),
        ),
      )),
      body: const SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage(ImageAssets.light)),
              Text(StringsManger.hintText_home),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: SizesManager.m10,
        height: SizesManager.h60,
        child: Container(
          margin: const EdgeInsets.only(right: SizesManager.m100),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  style: TextStyle(fontSize: SizesManager.s20),
                  StringsManger.app_name),
              Text(
                  style: TextStyle(fontSize: SizesManager.s15),
                  StringsManger.update_home)
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
