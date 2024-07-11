import 'package:flutter/material.dart';

import '../../resources/assets_manager.dart';
import '../../resources/sizes_manager.dart';
import '../../resources/strings_manager.dart';
import '../../routes/routes.dart';
import '../menu/sidebar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
              hintText: StringsManger.searchText_home,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(SizesManager.p12),
              border: const OutlineInputBorder(),
              suffixIcon: SizedBox(
                width: SizesManager.w100,
                child: Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.view_stream_outlined),
                        onPressed: () {
                        }
                    ),
                    IconButton(
                        icon: const Icon(Icons.people),
                        onPressed: () {
                        }
                    ),
                  ],
                ),
              )
          ),
        ),
      ),
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
                  style: TextStyle(
                      fontSize: SizesManager.s20
                  ),
                  StringsManger.app_name
              ),
              Text(
                  style: TextStyle(
                      fontSize: SizesManager.s15
                  ),
                  StringsManger.update_home
              )
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