import 'package:app/service/alert.dart';
import 'package:app/service/openlinkd.dart';
import 'package:app/service/translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:bip39/bip39.dart' as bip39;

class PhrasePage extends StatefulWidget {
  const PhrasePage({super.key});

  @override
  State<PhrasePage> createState() => _PhrasePageState();
}

class _PhrasePageState extends State<PhrasePage> {
  RxString mnemonic = ''.obs;
  int selectedStrength = 128; // padrão para 12 palavras

  generateMnemonic() {
    mnemonic.value = bip39.generateMnemonic(strength: selectedStrength);
    mnemonic.refresh();
  }

  List get array => mnemonic.value.split(' ');
  copy() {
    Clipboard.setData(ClipboardData(text: mnemonic.value));
    Alert().snackBar('copied_text', 'copied_text_info');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'generate_keyword_btc'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'choose_number'.tr,
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: selectedStrength,
                        items: [
                          DropdownMenuItem<int>(
                            value: 128,
                            child: Text('12words'.tr),
                          ),
                          DropdownMenuItem<int>(
                            value: 256,
                            child: Text('24words'.tr),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedStrength = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: generateMnemonic,
                  child: Text('generate_words'.tr),
                ),
                const SizedBox(height: 20),
                if (mnemonic.value != '') ...[
                  Card(
                    child: InkWell(
                      onTap: copy,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            GridView.count(
                                physics: const ScrollPhysics(),
                                crossAxisCount: 4,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 4),
                                shrinkWrap: true,
                                children: List.generate(
                                  array.length,
                                  (index) {
                                    return Card(
                                      child: Center(
                                        child: Text(
                                          array[index],
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: copy,
                      child: Text('copy'.tr),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
