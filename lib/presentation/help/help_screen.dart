import 'package:flutter/material.dart';

import '../../resources/gaps_manager.dart';
import '../../resources/sizes_manager.dart';
import '../../resources/strings_manager.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
            padding: const EdgeInsets.only(
                left: SizesManager.s18, right: SizesManager.s18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  StringsManger.help_title,
                  style: TextStyle(
                      fontSize: SizesManager.s15, fontWeight: FontWeight.w500),
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
                    const Text(StringsManger.help_1)
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
                    const Text(StringsManger.help_2)
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
                    const Text(StringsManger.help_3)
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
                    const SizedBox(
                      width: SizesManager.w300,
                      child: Text(
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
                    const Text(StringsManger.help_5)
                  ],
                ),
                GapsManager.h20,
                const TextField(
                    decoration: InputDecoration(
                        hintText: StringsManger.searchHelp,
                        filled: true,
                        fillColor: Color(0xff99CCFF),
                        contentPadding: EdgeInsets.all(SizesManager.p12),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(SizesManager.r20))
                        ),
                        prefixIcon: Icon(Icons.search),
                        prefixIconColor: Colors.black)
                ),
                GapsManager.h10,
                const Divider(height: SizesManager.h1),
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
                    const Text(StringsManger.help_6)
                  ],
                ),
                GapsManager.h10,
                const Divider(height: SizesManager.h1),
              ],
            ),
          ),
        ));
  }
}