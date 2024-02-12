import 'package:app/encrypt/file.dart';
import 'package:app/encrypt/text.dart';
import 'package:app/service/openlinkd.dart';
import 'package:app/service/translate.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EncryptPage extends StatefulWidget {
  const EncryptPage({super.key});

  @override
  State<EncryptPage> createState() => _EncryptPagePageState();
}

class _EncryptPagePageState extends State<EncryptPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => OpenLink().github(),
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
            children: <Widget>[EncryptText(), EncryptFile()],
          )),
    );
  }
}
