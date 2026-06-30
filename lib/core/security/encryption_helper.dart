import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class EncryptionHelper {
  static const _secureStorage = FlutterSecureStorage();
  static const _keyName = 'hive_encryption_key';

  static Future<HiveAesCipher> getEncryptionCipher() async {
    String? base64Key = await _secureStorage.read(key: _keyName);
    List<int> encryptionKey;

    if (base64Key == null) {
      // Generate a new secure key
      encryptionKey = Hive.generateSecureKey();
      // Store base64 encoded
      await _secureStorage.write(
        key: _keyName,
        value: base64Encode(encryptionKey),
      );
    } else {
      encryptionKey = base64Decode(base64Key);
    }

    return HiveAesCipher(encryptionKey);
  }
}
