import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

import 'package:app/model/index.dart';
import 'package:app/service/alert.dart';
import 'package:app/service/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class EncryptFile extends StatefulWidget {
  const EncryptFile({super.key});

  @override
  State<EncryptFile> createState() => _EncryptFileState();
}

class _EncryptFileState extends State<EncryptFile> {
  TextEditingController password = TextEditingController();

  Rx<ModelInfo> modelInfo = ModelInfo().obs;

  ModelInfo get model => modelInfo.value;

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
    Alert().snackBar('hash_copied', 'hash_copied_info');
  }

  getNameFile(String path) {
    File file = File(path);
    String fileName = file.uri.pathSegments.last;

    return fileName;
  }

  saveFile() async {
    try {
      var nameFile = '${DateTime.now().millisecondsSinceEpoch}.aes';

      final directory = await getApplicationDocumentsDirectory();

      var file = File('${directory.path}/$nameFile');

      final encodedExtension = CryptoApp().encodeExtencion(model.ext!);

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

  encryptFile() async {
    if (model.file == null) {
      Alert().show('empty_file', 'empty_file_info');
      return;
    }
    if (password.text == '') {
      Alert().show('empty_password', 'empty_password_info');
      return;
    }

    Alert().loading();

    await Future.delayed(const Duration(microseconds: 1000));

    try {
      var ext = path.extension(model.file!.path).split('.')[1];
      Uint8List bytes = model.file!.readAsBytesSync();
      modelInfo.value.ext = ext.trim();
      modelInfo.value.encrypted = await CryptoApp().encryptFile(
        password.text,
        bytes,
      );
    } catch (e) {
      String text = model.file!.readAsStringSync();
      List<int> bytes = utf8.encode(text);
      Uint8List uint8list = Uint8List.fromList(bytes);
      modelInfo.value.encrypted = await CryptoApp().encryptText(
        password.text,
        uint8list,
      );
    }
    saveFile();

    Get.back();
    if (model.encrypted == null) {
      Alert().show(
        'error_encrypt',
        'error_encrypt_info',
      );
    }
  }

  share() async {
    //return saveFile();
    await Share.shareXFiles(
      [XFile(model.saveFile!.path)],
      text: getNameFile(model.file!.path),
    );
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
                                  : getNameFile(
                                      model.file!.path,
                                    ),
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
                child: ElevatedButton(
                  onPressed: encryptFile,
                  child: Text('encrypt'.tr),
                ),
              ),
            ],
            if (model.encrypted != null) ...[
              Card(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
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
