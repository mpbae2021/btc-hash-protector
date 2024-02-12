import 'dart:convert';
import 'dart:io';

import 'package:app/service/alert.dart';
import 'package:app/service/crypto.dart';
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
  TextEditingController password = TextEditingController();

  RxString texto = ''.obs;
  final Rx<File?> file = Rx<File?>(null);

  void decrypt() async {
    if (hash.text == '') {
      Alert().show('empty_hash', 'empty_hash_info');
      return;
    }
    if (password.text == '') {
      Alert().show('empty_password', 'empty_password_info');
      return;
    }

    Alert().loading();
    await Future.delayed(const Duration(microseconds: 500));

    Uint8List? info = await CryptoApp().decrypt(
      password.text,
      base64Decode(hash.text),
    );
    Get.back();
    if (info != null) {
      texto.value = utf8.decode(info);
      texto.refresh();
    } else {
      Alert().show(
        'error_decrypt',
        'error_decrypt_info',
      );
    }
  }

  copy() {
    Clipboard.setData(ClipboardData(text: texto.value));
    Alert().snackBar('copied_text', 'copied_text_info');
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
                        hintText: 'enter_hash'.tr,
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
                    onPressed: decrypt,
                    child: Text('decrypt'.tr),
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
                          child: Text('copy'.tr),
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
