import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart' as crypto;
import 'dart:convert';

class CryptoApp {
  static const _keyLength = 32;
  static const _ivLength = 16;

  Future<crypto.Encrypted?> encryptFile(
    String password,
    Uint8List bytes,
  ) async {
    try {
      final key = await _deriveKey(password);
      final iv = _generateIv();
      Uint8List paddedBytes;

      final encrypter = crypto.Encrypter(
        crypto.AES(key, mode: crypto.AESMode.cbc),
      );

      paddedBytes = _applyPKCS7Padding(bytes);

      final content = encrypter.encryptBytes(paddedBytes, iv: iv);

      var ivAndCipherText = Uint8List.fromList(
        [...iv.bytes, ...content.bytes],
      );
      return crypto.Encrypted(ivAndCipherText);
    } catch (e) {
      return null;
    }
  }

  Future<Uint8List?> decrypt(
    String password,
    Uint8List bytes,
  ) async {
    try {
      final key = await _deriveKey(password);
      Uint8List bytesIv = bytes.sublist(0, _ivLength);

      crypto.IV iv = crypto.IV(Uint8List.fromList(bytesIv));

      Uint8List cipherBytes = bytes.sublist(_ivLength);

      final encrypter = crypto.Encrypter(
        crypto.AES(key, mode: crypto.AESMode.cbc),
      );
      List<int> content = encrypter.decryptBytes(
        crypto.Encrypted(cipherBytes),
        iv: iv,
      );
      return removePKCS7Padding(Uint8List.fromList(content));
    } catch (e) {
      return null;
    }
  }

  Uint8List encodeExtencion(String fileExt) {
    var b = encodeVariableLength(fileExt.length) + utf8.encode(fileExt);
    return Uint8List.fromList(b);
  }

  Uint8List _applyPKCS7Padding(Uint8List input) {
    const blockSize = 16;
    final padding = blockSize - input.length % blockSize;
    final paddedBytes =
        Uint8List.fromList([...input, ...List.filled(padding, padding)]);
    return paddedBytes;
  }

  Uint8List removePKCS7Padding(Uint8List input) {
    final lastByte = input[input.length - 1];

    // Verifica se o último byte é negativo
    if (lastByte < 0) {
      // Retorna lista vazia em caso de preenchimento inválido
      return Uint8List.fromList([]);
    }

    final paddingLength = lastByte & 0xFF;

    // Verifica se o tamanho do preenchimento está dentro da faixa válida
    if (paddingLength > 0 && paddingLength <= input.length) {
      // Verifica se todos os bytes de preenchimento são iguais ao tamanho do preenchimento
      for (int i = input.length - paddingLength; i < input.length; i++) {
        if (input[i] != paddingLength) {
          // Retorna lista vazia em caso de preenchimento inválido
          return Uint8List.fromList([]);
        }
      }

      // Remove o preenchimento
      return input.sublist(0, input.length - paddingLength);
    } else {
      // Retorna lista vazia em caso de tamanho de preenchimento inválido
      return Uint8List.fromList([]);
    }
  }

  static Future<crypto.Key> _deriveKey(String password) async {
    var nonce = await deriveNonceFromPassword(password);
    var keyDerivator = await Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: 100000,
      bits: _keyLength * 8,
    ).deriveKeyFromPassword(password: password, nonce: nonce);

    final keyBytes = await keyDerivator.extractBytes();
    return crypto.Key(Uint8List.fromList(keyBytes));
  }

  static crypto.IV _generateIv() {
    return crypto.IV.fromSecureRandom(_ivLength);
  }

  List<int> encodeVariableLength(int length) {
    List<int> result = [];
    do {
      int byte = length % 128;
      length ~/= 128;
      if (length > 0) {
        byte |= 0x80;
      }
      result.add(byte);
    } while (length > 0);
    return result;
  }

  static Future<Uint8List> deriveNonceFromPassword(String password) async {
    final sha256 = Sha256();
    final hash = await sha256.hash(utf8.encode(password));
    return Uint8List.fromList(hash.bytes.sublist(0, _ivLength));
  }

  Future<crypto.Encrypted?> encryptText(
      String password, Uint8List bytes) async {
    try {
      final key = await _deriveKey(password);
      final iv = _generateIv();
      Uint8List paddedBytes;

      final encrypter = crypto.Encrypter(
        crypto.AES(key, mode: crypto.AESMode.cbc),
      );

      paddedBytes = _applyPKCS7Padding(bytes);

      final content = encrypter.encryptBytes(paddedBytes, iv: iv);

      Uint8List ivAndCipherText = Uint8List.fromList(
        [...iv.bytes, ...content.bytes],
      );
      return crypto.Encrypted.fromBase64(
        base64.encode(ivAndCipherText),
      );
    } catch (e) {
      return null;
    }
  }
}
