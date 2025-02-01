class Note {
  String? id; // Firestore document ID
  String userId; // User ID of the note owner
  String title;
  String content;
  DateTime timestamp;

  Note({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  // Convert a Note to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
    //  'userId': userId,
      'title': title,
      'content': content,
      'timestamp': timestamp,
    };
  }

  // Create a Note from a Firestore document
  factory Note.fromMap(String id, Map<String, dynamic> data) {
    return Note(
      id: id,
      userId: data['userId'],
      title: data['title'],
      content: data['content'],
      timestamp: data['timestamp'].toDate(),
    );
  }
}