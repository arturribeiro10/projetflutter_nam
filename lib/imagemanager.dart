import 'dart:convert';
import 'dart:typed_data';

class ImageManager{
  static String? bytesToBase64(Uint8List? bytes) {
    if (bytes == null) {
      return null;
    }
    return base64Encode(bytes);
  }

  static Uint8List? base64ToBytes(String base64) {
    if (base64.isEmpty) {
      return null;
    }
    return base64Decode(base64);
  }
}