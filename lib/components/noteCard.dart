import 'package:authentication_test/auth/auth_view_model.dart';
import 'package:authentication_test/note_management/note_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class NoteCard extends StatelessWidget {
  final String title;
  final String content;
  final Future<void> Function() onDelete;
   final Future<void> Function() onUpdate;


  const NoteCard({
    super.key,
    required this.title,
    required this.content, required this.onDelete, required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
  
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
                  onPressed: () async{
                    // Edit note functionality
                    await onUpdate();
                  },
                ),
                IconButton(
                  icon:
                      const Icon(Icons.delete, color: Colors.white70, size: 20),
                  onPressed: () async{
                    // Delete note functionality
                   await onDelete();
                   
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
