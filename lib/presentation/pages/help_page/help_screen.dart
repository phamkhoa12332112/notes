import 'package:flutter/material.dart';
import 'package:notesapp/presentation/widgets/text_field_widget.dart';

import '../../../utils/resources/gaps_manager.dart';
import '../../../utils/resources/sizes_manager.dart';
import '../../../utils/resources/strings_manager.dart';

class HelpScreen extends StatelessWidget {
  HelpScreen({super.key});
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Stack(children: [
            Title(
                color: Colors.black,
                child: const Text(StringsManger.help_screen)),
            const Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.more_vert),
            )
          ]),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(SizesManager.p18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  StringsManger.help_title,
                  style: TextStyle(
                      fontSize: SizesManager.s25, fontWeight: FontWeight.w500),
                ),
                GapsManager.h20,
                Row(
                  children: [
                    Container(
                        width: SizesManager.w30,
                        height: SizesManager.h30,
                        decoration: const BoxDecoration(
                          color: Color(0xff99CCFF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.article_outlined,
                          color: Colors.blue,
                        )),
                    GapsManager.w20,
                    Text(
                      StringsManger.help_1,
                      style: TextStyle(fontSize: SizesManager.s15),
                    )
                  ],
                ),
                GapsManager.h20,
                Row(
                  children: [
                    Container(
                        width: SizesManager.w30,
                        height: SizesManager.h30,
                        decoration: const BoxDecoration(
                          color: Color(0xff99CCFF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.article_outlined,
                          color: Colors.blue,
                        )),
                    GapsManager.w20,
                    Text(
                      StringsManger.help_2,
                      style: TextStyle(fontSize: SizesManager.s15),
                    )
                  ],
                ),
                GapsManager.h20,
                Row(
                  children: [
                    Container(
                        width: SizesManager.w30,
                        height: SizesManager.h30,
                        decoration: const BoxDecoration(
                          color: Color(0xff99CCFF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.article_outlined,
                          color: Colors.blue,
                        )),
                    GapsManager.w20,
                    Text(
                      StringsManger.help_3,
                      style: TextStyle(fontSize: SizesManager.s15),
                    )
                  ],
                ),
                GapsManager.h20,
                Row(
                  children: [
                    Container(
                        width: SizesManager.w30,
                        height: SizesManager.h30,
                        decoration: const BoxDecoration(
                          color: Color(0xff99CCFF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.article_outlined,
                          color: Colors.blue,
                        )),
                    GapsManager.w20,
                    SizedBox(
                      width: SizesManager.w200,
                      child: Text(
                        style: TextStyle(fontSize: SizesManager.s15),
                        StringsManger.help_4,
                        maxLines: SizesManager.l2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                GapsManager.h20,
                Row(
                  children: [
                    Container(
                        width: SizesManager.w30,
                        height: SizesManager.h30,
                        decoration: const BoxDecoration(
                          color: Color(0xff99CCFF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.article_outlined,
                          color: Colors.blue,
                        )),
                    GapsManager.w20,
                    Text(
                      StringsManger.help_5,
                      style: TextStyle(fontSize: SizesManager.s15),
                    )
                  ],
                ),
                GapsManager.h20,
                TextFieldWidget(
                    hintText: StringsManger.searchHelp,
                    filled: true,
                    fillColor: const Color(0xff99CCFF),
                    contentPadding: SizesManager.p12,
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: Colors.black,
                    borderRadius: SizesManager.r20, controller: _controller,),
                GapsManager.h10,
                Divider(height: SizesManager.h1),
                GapsManager.h10,
                Row(
                  children: [
                    Container(
                        width: SizesManager.w30,
                        height: SizesManager.h30,
                        decoration: const BoxDecoration(
                          color: Color(0xff99CCFF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.article_outlined,
                          color: Colors.blue,
                        )),
                    GapsManager.w20,
                    Text(
                      StringsManger.help_6,
                      style: TextStyle(fontSize: SizesManager.s15),
                    )
                  ],
                ),
                GapsManager.h10,
                Divider(height: SizesManager.h1),
              ],
            ),
          ),
        ));
  }
}