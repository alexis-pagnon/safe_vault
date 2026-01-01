
class Note {
  final int? id_note;
  final String title;
  final String content;
  final int date;

  Note({
    this.id_note,
    required this.title,
    required this.content,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_note': id_note,
      'title': title,
      'content': content,
      'date': date,
    };
  }

  Note.fromMap(Map<String, dynamic> data)
      : id_note = data["id_note"],
        title = data["title"],
        content = data["content"],
        date = data["date"];

  @override
  String toString() {
    return 'Note{id_note: $id_note, title: $title, content: $content, date: $date}';
  }
}