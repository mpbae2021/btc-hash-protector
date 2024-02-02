import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart' as crypto;
import 'dart:convert';

class CryptoAes {
  static const _keyLength = 32;
  static const _ivLength = 16;

  Future<crypto.Encrypted?> aes128Encode(String texto, String senha) async {
    try {
      final key = await _deriveKey(senha);
      final iv = _generateIv();

      final encrypter = crypto.Encrypter(
        crypto.AES(key, mode: crypto.AESMode.cbc),
      );

      // Adicione o IV ao início do texto cifrado
      final encrypted = encrypter.encrypt(texto, iv: iv);
      final ivAndCipherText =
          Uint8List.fromList([...iv.bytes, ...encrypted.bytes]);

      // Converta o texto cifrado de volta para o formato Encrypted
      final result =
          crypto.Encrypted.fromBase64(base64.encode(ivAndCipherText));

      return result;
    } catch (e) {
      return null;
    }
  }

  Future<String?> aes128Decode(String encodedText, String senha) async {
    try {
      final key = await _deriveKey(senha);
      final ivAndCipherText = base64.decode(encodedText);

      final iv = crypto.IV(ivAndCipherText.sublist(0, _ivLength));
      final cipherText = ivAndCipherText.sublist(_ivLength);

      final encrypter = crypto.Encrypter(
        crypto.AES(key, mode: crypto.AESMode.cbc),
      );

      return encrypter.decrypt64(base64.encode(cipherText), iv: iv);
    } catch (e) {
      return null;
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

  static Future<Uint8List> deriveNonceFromPassword(String password) async {
    final sha256 = Sha256();
    final hash = await sha256.hash(utf8.encode(password));
    return Uint8List.fromList(hash.bytes.sublist(0, _ivLength));
  }
}
