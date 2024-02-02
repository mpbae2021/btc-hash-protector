import 'dart:io';

import 'package:encriptar/service/alert.dart';
import 'package:encriptar/service/crypto.dart';
import 'package:encrypt/encrypt.dart';
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
  final Rx<File?> file = Rx<File?>(null);
  RxString hash = ''.obs;
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
    Clipboard.setData(ClipboardData(text: hash.value));
    Alert().snackBar('hash_copiada', 'hash_copiada_info');
  }

  getNameFile(String path) {
    File file = File(path);
    String fileName = file.uri.pathSegments.last;

    return fileName;
  }

  saveFile() async {
    try {
      var nameFile = '${DateTime.now().millisecondsSinceEpoch}.aes';

      // Obtenha o diretório de documentos do aplicativo
      final directory = await getApplicationDocumentsDirectory();

      // Crie um arquivo no diretório de documentos com o nome "texto.txt"
      file.value = File('${directory.path}/$nameFile');

      // Escreva o texto no arquivo
      await file.value!.writeAsString(hash.value);

      file.refresh();

      hash.refresh();
    } catch (e) {
      Alert().show('salvar_texto', 'salvar_texto_info');
    }
  }

  encriptarFile() async {
    if (file.value == null) {
      Alert().show('arquivo_vazio', 'arquivo_vazio_info');
      return;
    }
    if (senha.text == '') {
      Alert().show('senha_vazia', 'senha_vazia_info');
      return;
    }

    Alert().loading();
    await Future.delayed(const Duration(microseconds: 500));
    var text = await file.value!.readAsString();

    Encrypted? info = await CryptoAes().aes128Encode(text, senha.text);
    Get.back();
    if (info != null) {
      hash.value = info.base64;
      hash.refresh();
    } else {
      Alert().show(
        'erro_criptografar',
        'erro_criptografar_info',
      );
    }
  }

  share() async {
    await Share.shareXFiles(
      [XFile(file.value!.path)],
      text: getNameFile(file.value!.path),
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
            if (hash.value == '') ...[
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
                  onPressed: encriptarFile,
                  child: Text('criptografar'.tr),
                ),
              ),
            ],
            if (hash.value != '') ...[
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
                            child: Text(hash.value),
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
                      if (file.value == null) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: saveFile,
                              child: Text('armazenar_em_arquivo'.tr),
                            ),
                          ),
                        ),
                      ],
                      if (file.value != null) ...[
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
                                          getNameFile(file.value!.path),
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
