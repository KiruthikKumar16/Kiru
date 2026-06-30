import 'dart:io';
import 'dart:ui' as ui;

class ExifHelper {
  /// Strips EXIF metadata from the given file by decoding and re-encoding it.
  /// Returns a new File with the stripped image data.
  static Future<File> stripExif(File originalFile) async {
    final bytes = await originalFile.readAsBytes();
    
    // Decode the image bytes into raw pixels
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    // Convert raw pixels back to PNG bytes (which completely discards EXIF headers)
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception('Failed to strip EXIF: Could not encode image');
    }

    final strippedBytes = byteData.buffer.asUint8List();

    // Save to a temporary file
    final tempDir = Directory.systemTemp;
    final String newPath = '${tempDir.path}/stripped_${DateTime.now().millisecondsSinceEpoch}.png';
    final strippedFile = File(newPath);
    await strippedFile.writeAsBytes(strippedBytes);

    return strippedFile;
  }
}
