import 'dart:convert';
import 'dart:io';

import 'package:app/model/index.dart';
import 'package:app/service/alert.dart';
import 'package:app/service/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class EncryptText extends StatefulWidget {
  const EncryptText({super.key});

  @override
  State<EncryptText> createState() => _EncryptTextState();
}

class _EncryptTextState extends State<EncryptText> {
  TextEditingController text = TextEditingController();
  TextEditingController password = TextEditingController();

  Rx<ModelInfo> modelInfo = ModelInfo().obs;

  ModelInfo get model => modelInfo.value;

  void encrypt() async {
    if (text.text == '') {
      Alert().show('empty_text', 'empty_text_info');
      return;
    }
    if (password.text == '') {
      Alert().show('empty_password', 'empty_password_info');
      return;
    }

    Alert().loading();
    await Future.delayed(const Duration(microseconds: 500));

    try {
      List<int> bytes = utf8.encode(text.text);
      Uint8List uint8list = Uint8List.fromList(bytes);

      modelInfo.value.encrypted = await CryptoApp().encryptText(
        password.text,
        uint8list,
      );
      modelInfo.value.text = true;
      // ignore: empty_catches
    } catch (e) {}
    modelInfo.refresh();

    Get.back();
    if (modelInfo.value.encrypted == null) {
      Alert().show(
        'error_encrypt',
        'error_encrypt_info',
      );
    }
  }

  copy() {
    Clipboard.setData(ClipboardData(text: model.encrypted!.base64));
    Alert().snackBar('hash_copied', 'hash_copied_info');
  }

  saveFile() async {
    try {
      var nameFile = '${DateTime.now().millisecondsSinceEpoch}.aes';

      // Obtenha o diretório de documentos do aplicativo
      final directory = await getApplicationDocumentsDirectory();

      // Crie um arquivo no diretório de documentos com o nome "texto.txt"
      var file = File('${directory.path}/$nameFile');

      // Escreva o texto no arquivo

      final encodedExtension = CryptoApp().encodeExtencion('txt');

      Uint8List bytesToWrite = Uint8List.fromList([
        ...encodedExtension,
        ...model.encrypted!.bytes,
      ]);
      file.writeAsBytesSync(bytesToWrite);

      modelInfo.value.saveFile = file;
      modelInfo.refresh();
    } catch (e) {
      Alert().show(
        'save_text',
        'save_text_info',
      );
    }
  }

  share() async {
    await Share.shareXFiles(
      [XFile(model.saveFile!.path)],
      text: getNameFile(model.saveFile!.path),
    );
  }

  getNameFile(String path) {
    File file = File(path);
    String fileName = file.uri.pathSegments.last;

    return fileName;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: text,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'enter_text'.tr,
                        border: InputBorder.none,
                      ),
                      onChanged: (e) => {
                        if (model.encrypted != null)
                          {
                            modelInfo.value = ModelInfo(),
                            modelInfo.refresh(),
                          }
                      },
                    ),
                  ),
                ),
              ),
            ),
            if (model.encrypted == null) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 0,
                      bottom: 0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: password,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'enter_password'.tr,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: encrypt,
                    child: Text('encrypt'.tr),
                  ),
                ),
              ),
            ],
            if (model.encrypted != null) ...[
              Card(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: copy,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              model.encrypted!.base64,
                              maxLines: 5,
                              overflow: TextOverflow.fade,
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
                      if (model.saveFile == null) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: saveFile,
                              child: Text('store_in_file'.tr),
                            ),
                          ),
                        ),
                      ],
                      if (model.saveFile != null) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: InkWell(
                              onTap: share,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: Colors.blue),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.file_download_outlined,
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Expanded(
                                        child: Text(
                                          getNameFile(model.saveFile!.path),
                                          maxLines: 1,
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
