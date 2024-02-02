import 'package:encriptar/decrypt/file.dart';
import 'package:encriptar/decrypt/text.dart';
import 'package:encriptar/service/openlinkd.dart';
import 'package:encriptar/service/translate.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DecryptPage extends StatefulWidget {
  const DecryptPage({super.key});

  @override
  State<DecryptPage> createState() => _DecryptPageState();
}

class _DecryptPageState extends State<DecryptPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => OpenLink().url(),
              icon: const Icon(
                FontAwesomeIcons.github,
              ),
            ),
            centerTitle: true,
            title: SizedBox(
              width: 60,
              height: 60,
              child: Image.asset(
                'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png',
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => TranslateApp().showLangs(),
                icon: const Icon(Icons.language_outlined),
              )
            ],
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.keyboard_alt_outlined),
                ),
                Tab(
                  icon: Icon(Icons.file_open_sharp),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: <Widget>[DecryptText(), DecryptFile()],
          )),
    );
  }
}
