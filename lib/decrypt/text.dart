import 'dart:io';

import 'package:encriptar/service/alert.dart';
import 'package:encriptar/service/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DecryptText extends StatefulWidget {
  const DecryptText({super.key});

  @override
  State<DecryptText> createState() => _DecryptTextState();
}

class _DecryptTextState extends State<DecryptText> {
  TextEditingController hash = TextEditingController();
  TextEditingController senha = TextEditingController();

  RxString texto = ''.obs;
  final Rx<File?> file = Rx<File?>(null);

  void descriptar() async {
    if (hash.text == '') {
      Alert().show('hash_vazia', 'hash_vazia_info');
      return;
    }
    if (senha.text == '') {
      Alert().show('senha_vazia', 'senha_vazia_info');
      return;
    }

    Alert().loading();
    await Future.delayed(const Duration(microseconds: 500));

    String? info = await CryptoAes().aes128Decode(hash.text, senha.text);
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

  copy() {
    Clipboard.setData(ClipboardData(text: texto.value));
    Alert().snackBar('texto_copiado', 'texto_copiado_info');
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
                      controller: hash,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'digite_hash'.tr,
                        border: InputBorder.none,
                      ),
                      onChanged: (e) => {
                        if (texto.value != '')
                          {
                            texto.value = '',
                            texto.refresh(),
                          }
                      },
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
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: descriptar,
                    child: Text('descriptografar'.tr),
                  ),
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
