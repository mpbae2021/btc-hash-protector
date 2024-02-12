import 'dart:convert';
import 'dart:io';

import 'package:app/model/index.dart';
import 'package:app/service/alert.dart';
import 'package:app/service/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class DecryptFile extends StatefulWidget {
  const DecryptFile({super.key});

  @override
  State<DecryptFile> createState() => _DecryptFileState();
}

class _DecryptFileState extends State<DecryptFile> {
  Rx<ModelInfo> modelInfo = ModelInfo().obs;

  ModelInfo get model => modelInfo.value;

  TextEditingController senha = TextEditingController();

  getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      modelInfo.value.file = File(result.files.single.path!);
      modelInfo.refresh();
    } else {
      // User canceled the picker
    }
  }

  copy() {
    Clipboard.setData(ClipboardData(text: model.encrypted!.base64));
    Alert().snackBar('copied_text', 'copied_text_info');
  }

  getNameFile(String path) {
    File file = File(path);
    String fileName = file.uri.pathSegments.last;

    return fileName;
  }

  decryptFile() async {
    if (model.file == null) {
      Alert().show('empty_file', 'empty_file_info');
      return;
    }
    if (senha.text == '') {
      Alert().show('empty_password', 'empty_password_info');
      return;
    }

    Alert().loading();
    await Future.delayed(const Duration(microseconds: 500));
    Uint8List content;

    try {
      Uint8List bytes = modelInfo.value.file!.readAsBytesSync();
      modelInfo.value.bytes = true;

      int extLength = bytes[0];
      String ext = utf8.decode(bytes.sublist(1, extLength + 1));

      modelInfo.value.ext = ext;
      content = bytes.sublist(extLength + 1);
    } catch (e) {
      String hash = modelInfo.value.file!.readAsStringSync();
      content = base64Decode(hash);
    }

    modelInfo.value.decrypted = await CryptoApp().decrypt(
      senha.text,
      content,
    );

    Get.back();

    if (model.decrypted == null) {
      Alert().show(
        'error_decrypt',
        'error_decrypt_info',
      );
    } else {
      saveFile();
    }
  }

  share() async {
    await Share.shareXFiles(
      [XFile(model.saveFile!.path)],
      text: getNameFile(model.file!.path),
    );
  }

  saveFile() async {
    try {
      var ext = model.ext!.trim();

      var nameFile = '${DateTime.now().millisecondsSinceEpoch}.$ext';

      final directory = await getApplicationDocumentsDirectory();

      var file = File('${directory.path}/$nameFile');

      file.writeAsBytesSync(model.decrypted!);

      modelInfo.value.saveFile = file;
      modelInfo.refresh();
    } catch (e) {
      Alert().show(
        'save_text',
        'save_text_info',
      );
    }
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
                child: InkWell(
                  onTap: getFile,
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
                          const Icon(Icons.file_open_sharp),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Text(
                              model.file == null
                                  ? 'select_file'.tr
                                  : getNameFile(model.file!.path),
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
            if (model.decrypted == null) ...[
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
                        controller: senha,
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
                child: ElevatedButton(
                  onPressed: decryptFile,
                  child: Text('decrypt'.tr),
                ),
              ),
            ],
            if (model.decrypted != null) ...[
              Card(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      if (model.ext != null) ...[
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
                      ],
                      if (model.ext == null) ...[
                        InkWell(
                          onTap: copy,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(utf8.decode(model.decrypted!)),
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
            ],
          ],
        ),
      ),
    );
  }
}
