import 'dart:convert';
import 'folder.dart';

class UserNotes {
  final List<Folder> folders;

  UserNotes({
    required this.folders,
  });

  /// Returns the total number of characters across all notes
  int getTotalCharacters() {
    int total = 0;
    for (var folder in folders) {
      for (var note in folder.notes) {
        total += note.length;
      }
    }
    return total;
  }

  /// Returns the total size in bytes of all notes
  int getTotalBytes() {
    int total = 0;
    for (var folder in folders) {
      for (var note in folder.notes) {
        total += utf8.encode(note).length;
      }
    }
    return total;
  }

  /// Returns the total size in megabytes of all notes
  double getTotalMegabytes() {
    return getTotalBytes() / (1024 * 1024);
  }

  @override
  String toString() {
    final chars = getTotalCharacters();
    final mb = getTotalMegabytes();
    return 'Total: $chars characters, ${mb.toStringAsFixed(2)} MB';
  }

  /// Convert UserNotes to JSON
  Map<String, dynamic> toJson() {
    return {
      'folders': folders.map((folder) => folder.toJson()).toList(),
    };
  }

  /// Create UserNotes from JSON
  factory UserNotes.fromJson(Map<String, dynamic> json) {
    return UserNotes(
      folders: (json['folders'] as List)
          .map((folderJson) => Folder.fromJson(folderJson))
          .toList(),
    );
  }
}
