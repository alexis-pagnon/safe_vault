
class Note {
  final int? id_note;
  final String title;
  final String content;
  final int date;
  final bool isTemporary;

  Note({
    this.id_note,
    required this.title,
    required this.content,
    required this.date,
    required this.isTemporary,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_note': id_note,
      'title': title,
      'content': content,
      'date': date,
      'is_temporary': isTemporary ? 1 : 0,
    };
  }

  Note.fromMap(Map<String, dynamic> data)
      : id_note = data["id_note"],
        title = data["title"],
        content = data["content"],
        date = data["date"],
        isTemporary = data["is_temporary"] == 1 ? true : false;

  @override
  String toString() {
    return 'Note{id_note: $id_note, title: $title, content: $content, date: $date, isTemporary: $isTemporary}';
  }
}