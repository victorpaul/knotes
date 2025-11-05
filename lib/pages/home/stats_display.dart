import 'package:flutter/material.dart';
import '../../models/user_notes.dart';

class StatsDisplay extends StatelessWidget {
  final UserNotes userNotes;
  final ValueNotifier<int> updateNotifier;

  const StatsDisplay({
    super.key,
    required this.userNotes,
    required this.updateNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: updateNotifier,
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Kotes'),
            Text(
              userNotes.toString(),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        );
      },
    );
  }
}
