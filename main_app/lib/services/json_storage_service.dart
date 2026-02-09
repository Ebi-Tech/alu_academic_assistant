import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class JsonStorageService {
  static final JsonStorageService _instance = JsonStorageService._internal();
  factory JsonStorageService() => _instance;
  JsonStorageService._internal();

  // Get the app's documents directory
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Get a file reference
  Future<File> _getLocalFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  // Save data to JSON file
  Future<void> saveToFile(String fileName, List<Map<String, dynamic>> data) async {
    try {
      final file = await _getLocalFile(fileName);
      final jsonString = jsonEncode(data);
      await file.writeAsString(jsonString);
      print('✅ Saved ${data.length} items to $fileName');
    } catch (e) {
      print('❌ Error saving to $fileName: $e');
    }
  }

  // Load data from JSON file
  Future<List<Map<String, dynamic>>> loadFromFile(String fileName) async {
    try {
      final file = await _getLocalFile(fileName);
      
      // Check if file exists
      if (await file.exists()) {
        final contents = await file.readAsString();
        
        // Check if file is not empty
        if (contents.trim().isNotEmpty) {
          final List<dynamic> jsonList = jsonDecode(contents);
          return jsonList.cast<Map<String, dynamic>>();
        }
      }
    } catch (e) {
      print('❌ Error loading from $fileName: $e');
    }
    
    // Return empty list if file doesn't exist or is empty
    return [];
  }

  // Check if file exists (for debugging)
  Future<bool> fileExists(String fileName) async {
    final file = await _getLocalFile(fileName);
    return await file.exists();
  }

  // Delete file (optional, for cleanup)
  Future<void> deleteFile(String fileName) async {
    try {
      final file = await _getLocalFile(fileName);
      if (await file.exists()) {
        await file.delete();
        print('🗑️ Deleted $fileName');
      }
    } catch (e) {
      print('❌ Error deleting $fileName: $e');
    }
  }

  // List all files (for debugging)
  Future<List<String>> listFiles() async {
    try {
      final path = await _localPath;
      final directory = Directory(path);
      final files = await directory.list().toList();
      return files.whereType<File>().map((file) => file.path.split('/').last).toList();
    } catch (e) {
      print('❌ Error listing files: $e');
      return [];
    }
  }
}
