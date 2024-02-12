import 'dart:io';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';

class ModelInfo {
  File? file;
  File? saveFile;
  String? ext;
  Uint8List? decrypted;
  Encrypted? encrypted;
  bool? text;
  bool? bytes;

  ModelInfo({
    this.file,
    this.saveFile,
    this.ext,
    this.encrypted,
    this.decrypted,
    this.text,
    this.bytes,
  });

  factory ModelInfo.fromJson(Map<String, dynamic> json) {
    return ModelInfo(
      file: json['file'],
      saveFile: json['savefile'],
      ext: json['ext'],
      encrypted: json['encrypted'],
      decrypted: json['decrypted'],
      text: json['text'],
      bytes: json['bytes'],
    );
  }
}
