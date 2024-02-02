import 'dart:io';

import 'package:encriptar/service/alert.dart';
import 'package:encriptar/service/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DecryptFile extends StatefulWidget {
  const DecryptFile({super.key});

  @override
  State<DecryptFile> createState() => _DecryptFileState();
}

class _DecryptFileState extends State<DecryptFile> {
  final Rx<File?> file = Rx<File?>(null);
  RxString texto = ''.obs;
  TextEditingController senha = TextEditingController();
  getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file.value = File(result.files.single.path!);
      file.refresh();
    } else {
      // User canceled the picker
    }
  }

  copy() {
    Clipboard.setData(ClipboardData(text: texto.value));
    Alert().snackBar('texto_copiado', 'texto_copiado');
  }

  getNameFile(String path) {
    File file = File(path);
    String fileName = file.uri.pathSegments.last;

    return fileName;
  }

  descriptar() async {
    if (file.value == null) {
      Alert().show('Arquivo vazio', 'arquivo_vazio_info');
      return;
    }
    if (senha.text == '') {
      Alert().show('senha_vazia', 'senha_vazia_info');
      return;
    }

    Alert().loading();
    await Future.delayed(const Duration(microseconds: 500));
    var text = await file.value!.readAsString();

    String? info = await CryptoAes().aes128Decode(text, senha.text);
    Get.back();
    if (info != null) {
      texto.value = info;
      texto.refresh();
    } else {
      Alert().show(
        'erro_descriptografar',
        'erro_descriptografar_info',
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
                              file.value == null
                                  ? 'selecionar_arquivo'.tr
                                  : getNameFile(file.value!.path),
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
            if (texto.value == '') ...[
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
                          hintText: 'digite_senha'.tr,
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
                  onPressed: descriptar,
                  child: Text('descriptografar'.tr),
                ),
              ),
            ],
            if (texto.value != '') ...[
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
                            child: Text(texto.value),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: copy,
                          child: Text('copiar'.tr),
                        ),
                      ),
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
