import 'package:encriptar/service/openlinkd.dart';
import 'package:encriptar/service/translate.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  var array = [
    "proposito",
    'feito_flutter',
    "funcionalidades",
    "internet",
    "open_source",
    "responsabilidades",
    "perda_senha",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'about'.tr,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: array.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          bottom: 4,
                          right: 8,
                        ),
                        child: Row(
                          children: [
                            Text((index + 1).toString()),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    array[index].toString().tr,
                                    style: const TextStyle(
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    ('${array[index]}_info').tr,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
