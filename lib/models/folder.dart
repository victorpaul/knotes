class Folder {
  final String name;
  final List<String> notes;

  Folder({
    required this.name,
    required this.notes,
  });

  /// Convert Folder to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'notes': notes,
    };
  }

  /// Create Folder from JSON
  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      name: json['name'] as String,
      notes: List<String>.from(json['notes'] as List),
    );
  }
}
