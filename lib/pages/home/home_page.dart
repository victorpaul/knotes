import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/folder.dart';
import '../../models/user_notes.dart';
import '../../theme/text_styles.dart';
import '../../service_locator.dart';
import '../../services/storage_service.dart';
import 'stats_display.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? selectedFolderIndex;
  int? selectedNoteIndex;

  // Sample data
  late UserNotes userNotes;

  // Text editing controller
  final TextEditingController _noteController = TextEditingController();

  // Stats update notifier
  final ValueNotifier<int> _statsUpdateNotifier = ValueNotifier<int>(0);

  // Debounce timer for saving
  Timer? _saveDebounceTimer;
  static const _saveDebounceDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _loadUserNotes();
  }

  /// Load user notes from storage or initialize with sample data
  void _loadUserNotes() {
    final storage = getIt<StorageService>();
    final loadedNotes = storage.getUserNotes('user_notes');

    if (loadedNotes != null) {
      // Load from storage
      userNotes = loadedNotes;
      debugPrint('Loaded notes from storage');
    } else {
      // Initialize with sample data
      userNotes = UserNotes(
        folders: [
          Folder(
            name: 'Personal',
            notes: [
              'First personal note',
              'Shopping list:\n- Milk\n- Eggs\n- Bread',
              'Meeting notes from today',
            ],
          ),
          Folder(
            name:
                'Work Work Work Work Work Work Work Work Work Work Work Work Work',
            notes: ['Project ideas', 'Team meeting notes'],
          ),
          Folder(
            name: 'IdeasIdeasIdeasIdeasIdeasIdeasIdeasIdeasIdeasIdeasIdeas',
            notes: [
              'App concept: A notes app like macOS Notes',
              'Long note test ' +
                  ('This is a repeated line to test scrolling ' * 1000),
            ],
          ),
        ],
      );
      debugPrint('Initialized with sample data');
      // Save sample data to storage
      _saveUserNotes();
    }
  }

  @override
  void dispose() {
    _saveDebounceTimer?.cancel();
    _noteController.dispose();
    _statsUpdateNotifier.dispose();
    super.dispose();
  }

  /// Save user notes to storage
  Future<void> _saveUserNotes() async {
    final storage = getIt<StorageService>();
    await storage.saveUserNotes('user_notes', userNotes);
    debugPrint('Notes saved successfully');
  }

  /// Debounced save - cancels previous timer and starts a new one
  void _debouncedSave() {
    _saveDebounceTimer?.cancel();
    _saveDebounceTimer = Timer(_saveDebounceDuration, () {
      _saveUserNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StatsDisplay(
          userNotes: userNotes,
          updateNotifier: _statsUpdateNotifier,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.go('/'),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Row(
        children: [
          // Left column - Folders list
          _buildFoldersColumn(),
          // Middle column - Notes list
          _buildNotesColumn(),
          // Right column - Note content
          _buildNoteContentColumn(),
        ],
      ),
    );
  }

  Widget _buildFoldersColumn() {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: ListView.builder(
        itemCount: userNotes.folders.length,
        itemBuilder: (context, index) {
          final folder = userNotes.folders[index];
          final isSelected = selectedFolderIndex == index;

          return ListTile(
            selected: isSelected,
            title: Text(folder.name),
            onTap: () {
              setState(() {
                selectedFolderIndex = index;
                selectedNoteIndex = null; // Reset note selection
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildNotesColumn() {
    if (selectedFolderIndex == null) {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
          ),
          child: const Center(child: Text('Select a folder')),
        ),
      );
    }

    final notes = userNotes.folders[selectedFolderIndex!].notes;

    return Container(
      width: 250,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: notes.isEmpty
          ? const Center(child: Text('No notes'))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                final isSelected = selectedNoteIndex == index;
                final preview = note.split('\n').first; // First line as preview

                return ListTile(
                  selected: isSelected,
                  title: Text(
                    preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body1,
                  ),
                  onTap: () {
                    setState(() {
                      selectedNoteIndex = index;
                      _noteController.text = note;
                    });
                  },
                );
              },
            ),
    );
  }

  Widget _buildNoteContentColumn() {
    if (selectedFolderIndex == null || selectedNoteIndex == null) {
      return const Expanded(child: Center(child: Text('Select a note')));
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _noteController,
          maxLines: null,
          expands: true,
          textAlignVertical: TextAlignVertical.top,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          style: AppTextStyles.body1,
          onChanged: (value) {
            userNotes.folders[selectedFolderIndex!].notes[selectedNoteIndex!] =
                value;
            _statsUpdateNotifier.value++;
            _debouncedSave();
          },
        ),
      ),
    );
  }
}
